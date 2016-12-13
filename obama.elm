import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode
import Css


styles =
    Css.asPairs >> Html.Attributes.style


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
    ( "hello"
    , Cmd.none
    )



-- UPDATE


type Msg = FetchContent | ContentReceived (Result Http.Error String)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        FetchContent ->
            (model, Http.send ContentReceived contentRequest)
        ContentReceived (Ok content) -> -- process response
            (content, Cmd.none)
        ContentReceived (Err _) ->
            ("error", Cmd.none)


-- VIEW


view : Model -> Html Msg
view model =
    div [ styles [Css.textAlign Css.center]]
        [ h2 
            [styles [ Css.width (Css.pct 50.0), Css.margin Css.auto]] 
            [text "Obama || Markov"]
        , button 
            [ styles [ Css.width (Css.pct 20.0), Css.margin Css.auto ]
                , onClick FetchContent ] 
            [ text "Next Quote" ]
        , div [] [text model]
        , div [] [
            text "This is a simple page written in Elm to pull data from the webservice at "
            , a [href "https://talk-to-obama.herokuapp.com/chat"] [ text "talk-to-obama.herokuapp.com/chat" ]
            , text " created from "
            , a [href "https://github.com/krrishd/talk-to-obama"] [ text "krrishd's talk-to-obama"]
            , text "."
            ]
        ]
        


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


-- HTTP


contentRequest : Http.Request String
contentRequest =
    Http.get "https://talk-to-obama.herokuapp.com/chat?size=tweet" contentDecoder


contentDecoder : Decode.Decoder String
contentDecoder =
    Decode.at ["content"] Decode.string
