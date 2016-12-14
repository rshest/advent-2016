import Html exposing (..)
import Task exposing (..)
import Http exposing (..)
import String exposing (..)
import Regex exposing (..)


-- boilerplate, to load inputs and show data
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
main: Program Never String Msg
main =
    Html.program
      { init = ("Wait...", lines inputFile)
      , update = update
      , view = view
      , subscriptions = \_ -> Sub.none
      }


-- solution itself
type Target 
  = Bot Int 
  | Output Int


type Operation 
  = Init (Int, Target)
  | Give (Target, Target, Target)  
  | Error


type alias OpList = List Operation
type alias Node = (Target, Maybe Int, Maybe Int)
type alias Network = List Node


parseOp: String -> Operation
parseOp str =
  let
    patInit = regex "value (\\d+) .+ (\\d+)"
    patGive = regex "(bot|output) (\\d+) .+ (bot|output) (\\d+) .+ (bot|output) (\\d+)"
    
    getMatch ps idx = ps 
      |> List.map .submatches |> List.concat
      |> List.map (Maybe.withDefault "0")
      |> List.drop idx |> List.head |> Maybe.withDefault "0"
    
    getInt ps idx = getMatch ps idx
      |> String.toInt |> Result.withDefault 0
    
    getTarget ps tIdx nIdx = 
      if getMatch ps tIdx == "bot" then Bot (getInt ps nIdx)
      else Output (getInt ps nIdx)
  in
    if Regex.contains patGive str then
      let p = Regex.find All patGive str
      in Give (getTarget p 0 1, getTarget p 2 3, getTarget p 4 5)
    else if Regex.contains patInit str then
      let p = Regex.find All patInit str
      in Init (getInt p 0, Bot (getInt p 1))
    else Error


--  yes, I have to write it myself as well, can you imagine? 
getDistinct : List a -> List a 
getDistinct lst = 
  case lst of
    x::xs -> x::(xs |> List.filter (\el -> el /= x) |> getDistinct)
    [] -> []


initNetwork : OpList -> Network
initNetwork ops = ops
  |> List.map (\op -> case op of
      Init (_, id) -> [id]
      Give (id, t1, t2) -> [id, t1, t2]
      Error -> [])
  |> List.concat
  |> getDistinct
  |> List.map (\t -> (t, Nothing, Nothing))


getValues : Network -> Target -> (Maybe Int, Maybe Int)
getValues network nodeId = 
  case network of
    (id, v1, v2)::ns ->
      if id == nodeId then (v1, v2) else getValues ns nodeId
    _ -> (Nothing, Nothing)


getOutput : Node -> Maybe (Int, Int)
getOutput node = case node of
  (Output id, Just val, _) -> Just (id, val)
  _ -> Nothing


setValue : Maybe Int -> Node -> Maybe Node 
setValue val node =
  case node of
  (id, Nothing, Nothing) -> Just (id, val, Nothing)
  (id, val1, Nothing) -> Just (id, val1, val)
  _ -> Just node


attemptApplyToNode : Network -> Operation -> Node -> (Maybe Node)
attemptApplyToNode network op node = 
  case (op, node) of
    (Init (val, id), (nid, _, _)) -> 
      if id == nid then setValue (Just val) node else Nothing
    (Give (sourceId, id1, id2), (id, v1, v2)) ->
      let 
        (bv1, bv2) = getValues network sourceId
      in 
      if bv1 == Nothing || bv2 == Nothing then Nothing
      else if id1 == id then setValue (Maybe.map2 min bv1 bv2) node
      else if id2 == id then setValue (Maybe.map2 max bv1 bv2) node
      else Nothing
    _ -> Nothing


attemptApply : Operation -> Network -> (Maybe Network)
attemptApply op network = 
  let 
    network1 = network |> List.map (attemptApplyToNode network op) 
    canNotApply = network1 |> List.filterMap identity |> List.isEmpty
    mergeEl = \x y -> case (x, y) of
      (x, Just y) -> y
      (x, _) -> x
  in
    if canNotApply then Nothing 
    else Just (List.map2 mergeEl network network1)


evaluateNetwork : List Operation -> Network -> (List Operation, Network)
evaluateNetwork ops network =
  let 
    foldfn = \op (ops1, network1) ->
      case attemptApply op network1 of
        Just n1 -> (ops1, n1) 
        Nothing -> (op::ops1, network1)
    (restOps, network1) = ops |> List.foldl foldfn ([], network)
  in
  case restOps of
    [] -> ([], network1)
    _ -> evaluateNetwork restOps network1


cond1 : Node -> Maybe Int
cond1 node = case node of
  (Bot x, Just 61, Just 17) -> Just x 
  _ -> Nothing


cond2 : Network -> Int
cond2 network =
  network
  |> List.filterMap getOutput
  |> List.sortBy (\(id, _) -> id)
  |> List.take 3
  |> List.map (\(_, val) -> val)
  |> List.product


solve : String -> String
solve str = 
  let
    ops = String.split "\n" str 
      |> List.map parseOp |> List.filter (\op -> op /= Error)
    (ops1, network) = evaluateNetwork ops (initNetwork ops)
    answer1 = network |> List.filterMap cond1 |> List.head |> Maybe.withDefault -1
    answer2 = cond2 network
  in 
    "Part 1 (the bot serving outputs 61 and 17): " ++ (toString answer1) ++ 
    "----- Part 2 (product of the first three outputs): " ++ (toString answer2)