module Main exposing (..)

import Html.App as App
import Time exposing (Time, second)
import Platform.Sub exposing (none)
import Html exposing (text, Html)


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


view : Model -> Html msg
view model =
    text "Hello World!"



-- main


main : Program Never
main =
    App.program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
