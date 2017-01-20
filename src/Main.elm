module Main exposing (..)

import Time exposing (Time, second)
import Platform.Sub exposing (none)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


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
    Model 0 False False


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )



-- update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        IncreaseSeconds seconds ->
            let
                newSeconds =
                    model.secondsToCountDown + seconds

                secondsToCountDown =
                    if newSeconds > 0 then
                        newSeconds
                    else
                        0
            in
                ( { model
                    | secondsToCountDown = secondsToCountDown
                    , atZero = False
                  }
                , Cmd.none
                )

        ToggleTimer ->
            let
                countdownRunning =
                    if model.secondsToCountDown > 0 then
                        not model.countdownRunning
                    else
                        model.countdownRunning
            in
                ( { model | countdownRunning = countdownRunning }, Cmd.none )

        TimerTick now ->
            let
                newSeconds =
                    model.secondsToCountDown - 1

                atZero =
                    newSeconds == 0

                countdownRunning =
                    not atZero
            in
                ( { model
                    | secondsToCountDown = newSeconds
                    , atZero = atZero
                    , countdownRunning = countdownRunning
                  }
                , Cmd.none
                )

        ResetTimer ->
            ( initialModel, Cmd.none )



-- subscription


subscriptions : Model -> Sub Msg
subscriptions model =
    if not model.atZero && model.countdownRunning then
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


timerButton : String -> String -> Msg -> Html Msg
timerButton title cssClass command =
    button
        [ class <| "btn h6 " ++ cssClass
        , onClick <| command
        ]
        [ text title ]


view : Model -> Html Msg
view model =
    let
        minutes =
            model.secondsToCountDown // 60

        seconds =
            model.secondsToCountDown % 60

        elapsedTime =
            (formatTimeComponent minutes) ++ ":" ++ (formatTimeComponent seconds)

        mainCssClass =
            if model.atZero then
                "timer-ended"
            else
                ""

        buttonCssClass =
            if model.atZero then
                "bg-white black"
            else
                "bg-black white"

        startStopButtonText =
            if model.countdownRunning && not model.atZero then
                "Stop"
            else
                "Start"
    in
        div [ class <| " " ++ mainCssClass ]
            [ div []
                [ h1 [ class "center" ] [ text elapsedTime ]
                ]
            , div [ class "" ]
                [ timerButton "-30 s" buttonCssClass (IncreaseSeconds -30)
                , timerButton "+30 s" buttonCssClass (IncreaseSeconds 30)
                , timerButton "Reset" buttonCssClass ResetTimer
                , timerButton startStopButtonText buttonCssClass ToggleTimer
                ]
            ]



-- main


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
