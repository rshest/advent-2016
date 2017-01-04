open System
open System.Collections.Generic
open System.Text.RegularExpressions

let parseTLS(str: string): string seq * string seq =
  str.Split [|'['|] 
  |> Seq.map (fun s -> s.Split [|']'|])
  |> Seq.map (function
    | [| xo |]     -> (Some xo, None)
    | [| xi; "" |] -> (None, Some xi)
    | [| xi; xo |] -> (Some xo, Some xi)
    | _            -> (None, None))
  |> List.ofSeq 
  |> List.unzip
  |> fun (a, b) -> Seq.choose id a, Seq.choose id b

let rec hasABBA(str: string): bool = 
  str.Length >= 4 &&
  ((str.[0] = str.[3] && str.[1] = str.[2] && str.[0] <> str.[1]) ||
   hasABBA str.[1..])

let supportsTLS(str: string): bool =
  let outer, inner = parseTLS str
  (Seq.exists hasABBA outer) && not (Seq.exists hasABBA inner)

let rec getABAs(str: string): string list =
  if (str.Length >= 3) then 
    let rest = getABAs str.[1..]
    if (str.[2] = str.[0] && str.[1] <> str.[0]) 
    then str.[0..2]::rest
    else rest
  else []

let toBAB(aba: string): string = 
  [|aba.[1]; aba.[0]; aba.[1]|] |> String.Concat
  
let supportsSSL(str: string): bool =  
  let outer, inner = parseTLS str
  let abas = 
    outer 
    |> Seq.collect getABAs
    |> Seq.map toBAB
    |> Seq.filter (fun bab -> 
      inner |> Seq.exists (fun (s:String) -> s.Contains bab))
  Seq.length abas > 0


// read input data
let argv = Environment.GetCommandLineArgs()
let fname = if argv.Length > 2 then argv.[2] else "input.txt"
let input = IO.File.ReadLines(fname)

let numWithTLS = input |> Seq.filter supportsTLS |> Seq.length 
printfn "Number of IPs supporting TLS: %d" numWithTLS

let numWithSSL = input |> Seq.filter supportsSSL |> Seq.length 
printfn "Number of IPs supporting SSL: %d" numWithSSL
