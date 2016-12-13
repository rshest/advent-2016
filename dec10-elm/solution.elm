import Html exposing (..)
import Task exposing (..)
import Http exposing (..)
import String exposing (..)
import Regex exposing (..)

-- solution itself
type Operation = Init (Int, Int) | Give (Int, Int, Int) | Error

parseOp: String -> Operation
parseOp str =
  let
    patInit = regex "value (\\d+) .+ (\\d+)"
    patGive = regex "bot (\\d+) .+ (\\d+) .+ (\\d+)"
    part ps idx = ps |> List.map .submatches |> List.concat
      |> List.map (Maybe.withDefault "0")
      |> List.drop idx |> List.head |> Maybe.withDefault "0"
      |> String.toInt |> Result.withDefault 0
  in
    if Regex.contains patGive str then
      let p = Regex.find All patGive str
      in Give (part p 0, part p 1, part p 2)
    else if Regex.contains patInit str then
      let p = Regex.find All patInit str
      in Init (part p 0, part p 1)
    else Error

solve: String -> String
solve str = String.split "\n" str
  |> List.map (parseOp >> toString)
  |> String.join "|" |> toString

-- boilerplate, to load inputs and show data
-- need to do the whole "elm app" sthing, just for that
inputFile: String
inputFile = "./input.txt"

type alias Model = String
type Msg = Fetched String | Failed String

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  (case msg of
    Fetched str -> str
    Failed err -> err
  , Cmd.none)

lines : String -> Cmd Msg
lines fname =
  Http.getString fname
  |> toTask
  |> Task.attempt (\res ->
    case res of
      Ok val -> Fetched val
      Err error -> Failed (toString error))

view : Model -> Html Msg
view str = solve str |> text

main =
    Html.program
      { init = ("", lines inputFile)
      , update = update
      , view = view
      , subscriptions = \_ -> Sub.none
      }