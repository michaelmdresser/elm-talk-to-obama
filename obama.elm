import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode

main =
  Html.program
    { init = init ""
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL


type alias Model =
  { quote : String }


init : String -> (Model, Cmd Msg)
init topic =
  ( Model ""
  , Cmd.none
  )



-- UPDATE


type Msg
  = NextQuote
  | NewQuote (Result Http.Error String)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NextQuote ->
      (model, getNextQuote)

    NewQuote (Ok newUrl) ->
      (Model model.quote, Cmd.none)

    NewQuote (Err _) ->
      (model, Cmd.none)



-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ h2 [] [text "Obama || Markov"]
    , button [ onClick NextQuote ] [ text "Next Quote" ]
    , br [] []
    , h3 [] [text model.quote]
    ]


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


-- HTTP


getNextQuote : Cmd Msg
getNextQuote =
  let
    url =
      "talk-to-obama.herokuapp.com/chat?size=tweet"
  in
    Http.send NewQuote (Http.get url decodeQuoteUrl)


decodeQuoteUrl : Decode.Decoder String
decodeQuoteUrl =
  Decode.at ["content"] Decode.string
