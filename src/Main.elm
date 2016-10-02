module Main exposing (..)

import Html.App as App
import Time exposing (Time, second, inSeconds, inMinutes)
import Platform.Sub exposing (none)
import Html exposing (..)
import Html.Attributes exposing (..)


-- model


type alias Model =
    { secondsToCountDown : Int
    , countdownRunning : Bool
    , atZero : Bool
    }


type Msg
    = IncreaseSeconds Int
    | TimerTick Time
    | ToggleTimer
    | ResetTimer


initialModel : Model
initialModel =
    Model 180 False False


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )



-- update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        IncreaseSeconds seconds ->
            let
                newSecondsToCountDown =
                    model.secondsToCountDown + seconds
            in
                ( { model | secondsToCountDown = newSecondsToCountDown }, Cmd.none )

        ToggleTimer ->
            ( { model | countdownRunning = not model.countdownRunning }, Cmd.none )

        TimerTick now ->
            let
                newSeconds =
                    model.secondsToCountDown - 1

                atZero =
                    newSeconds == 0
            in
                ( { model | secondsToCountDown = newSeconds, atZero = atZero }, Cmd.none )

        ResetTimer ->
            ( initialModel, Cmd.none )



-- subscription


subscriptions : Model -> Sub Msg
subscriptions model =
    if model.countdownRunning then
        Time.every second TimerTick
    else
        Platform.Sub.none



-- view


formatTimeComponent : Int -> String
formatTimeComponent number =
    if number < 10 then
        "0" ++ toString number
    else
        toString number


view : Model -> Html msg
view model =
    let
        minutes =
            model.secondsToCountDown // 60

        seconds =
            model.secondsToCountDown % 60

        elapsedTime =
            (formatTimeComponent minutes) ++ ":" ++ (formatTimeComponent seconds)
    in
        div []
            [ text ("Time remaining: " ++ elapsedTime)
            ]



-- main


main : Program Never
main =
    App.program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
