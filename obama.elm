import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode exposing (Decoder)

main =
  Html.program
    { init = init ""
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL


type alias Model =
    String


init : String -> (Model, Cmd Msg)
init topic =
  ( ""
  , Cmd.none
  )



-- UPDATE


type Msg = FetchContent | ContentReceived

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    FetchContent ->
        (model, Http.send ContentReceived contentRequest)
    ContentReceived response -> -- process response
        (response, Cmd.none)



-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ h2 [] [text "Obama || Markov"]
    , button [ onClick FetchContent ] [ text "Next Quote" ]
    , div [] [text model.quote]
    ]


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


-- HTTP


--getNextQuote : Cmd Msg
--getNextQuote =
--  let
--    addr =
--      "talk-to-obama.herokuapp.com/chat?size=tweet"
--  in
--    Http.send NewQuote (Http.get addr decodeQuoteUrl)


--decodeQuoteUrl : Decode.Decoder String
--decodeQuoteUrl =
--  Decode.at ["content"] Decode.string


contentRequest : Http.Request String
contentRequest =
  Http.get "talk-to-obama.herokuapp.com/chat?size=tweet" contentDecoder





--contentDecoder : Json.Decode.field "content" Json.Decode.string
--contentDecoder =

contentDecoder : Decoder String
contentDecoder =
  Decoder.at ["content"] Decoder.string
