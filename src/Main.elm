module Main exposing (..)

import Time exposing (Time, second)
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

    text "Hello World!"
