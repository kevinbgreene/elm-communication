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
  { users : List Child.Model
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
    createChild user =
      Child.model user.id user.name

  in
    { users = (List.map createChild flags)
    }


init : Flags -> (Model, Cmd Msg)
init flags =
  ((model flags), Cmd.none)


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
              newChild =
                Child.update msg next

              isNewlyDeleted =
                newChild.isDeleted == True && child.isDeleted == False

            in
              newChild

          else
            next

        notDeleted next =
          next.isDeleted == False

        updatedUsers =
          List.map updateChild model.users

        newUsers =
          List.filter notDeleted updatedUsers

        newModel =
          { model | users = newUsers }

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
        (List.map (\user -> Html.map (UpdateChild user) (Child.view user)) model.users)
    ]


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
