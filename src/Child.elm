module Child exposing (..)


import Html
import Html exposing (Html, button, li, p, text)
import Html.Events exposing (onClick)


type Msg
  = NoOp
  | Delete


type alias Model =
  { id : Int
  , name : String
  , isDeleted : Bool
  }


model : Int -> String -> Model
model id name =
  { id = id
  , name = name
  , isDeleted = False
  }


view : Model -> Html Msg
view model =
  li
    []
    [ p
        []
        [ text ("Name: " ++ model.name) ]
    , p
        []
        [ text ("Id: " ++ (toString model.id)) ]
    , button
        [ (onClick Delete) ]
        [ text "Delete" ]
    ]


update : Msg -> Model -> Model
update msg model =
  case msg of
    NoOp ->
      model

    Delete ->
      let
        newModel =
          { model | isDeleted = True }

      in
        newModel
