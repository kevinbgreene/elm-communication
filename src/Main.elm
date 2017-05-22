module Main exposing (..)


import Html
import Child
import Html exposing (Html, div, h3, text, ul)


main : Program Flags Model Msg
main =
  Html.programWithFlags
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


type Msg
  = NoOp
  | UpdateChild Child.Model Child.Msg


type alias Model =
  { items : List Child.Model
  }


type alias RawUser =
  { id : Int
  , name : String
  }


type alias Flags =
  List RawUser


model : Flags -> Model
model flags =
  let
    createChild item =
      Child.model item.id item.name

  in
    { items = (List.map createChild flags)
    }


init : Flags -> (Model, Cmd Msg)
init flags =
  ((model flags), Cmd.none)


isDeleted : Child.Beacon -> Child.Model -> Bool
isDeleted beacon child =
  case beacon of
    Child.Deleted ->
      True

    _ ->
      False

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NoOp ->
      (model, Cmd.none)

    UpdateChild child msg ->
      let
        updateChild next =
          if child.id == next.id then
            let
              (newChild, beacon) =
                Child.update msg next

            in
              if isDeleted beacon newChild then
                Nothing

              else
                Just newChild

          else
            Just next

        newItems =
          List.filterMap updateChild model.items

        newModel =
          { model | items = newItems }

      in
        (newModel, Cmd.none)


view : Model -> Html Msg
view model =
  div
    []
    [ h3
        []
        [ text "Users:" ]
    , ul
        []
        (List.map (\item -> Html.map (UpdateChild item) (Child.view item)) model.items)
    ]


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
