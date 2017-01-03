
import Foundation

let NUM_REGISTERS: Int = 4

enum Arg {
  case Value(Int)
  case Register(Int)
}

enum Op {
  case Cpy(Arg, Arg)
  case Inc(Arg)
  case Dec(Arg)
  case Jnz(Arg, Arg)
  case Out(Arg)
  case Err(String)
}

func parseArg(str: String) -> Arg {
  let ca = Int(UInt8(ascii:"a"))
  let s = str.unicodeScalars
  let c = Int(s[s.startIndex].value)
  if c >= ca && c < ca + NUM_REGISTERS {
    return Arg.Register(c - ca)
  } else {
    return Arg.Value(Int(str)!)
  }
}

func parseOp(str: String) -> Op {
  let parts = str.components(separatedBy:" ")
  let arg1 = parseArg(str:parts[1])
  switch parts[0] {
    case "cpy": return .Cpy(arg1, parseArg(str:parts[2]))
    case "inc": return .Inc(arg1)
    case "dec": return .Dec(arg1)
    case "jnz": return .Jnz(arg1, parseArg(str:parts[2]))
    case "out": return .Out(arg1)
    default:    return .Err("Invalid operation:" + parts[0])
  }
}

func isProducingClockSignal(ops: [Op], a: Int, 
  maxLen: Int = 100, maxSteps: Int = 1000000) -> Bool
{
  var reg: [Int] = Array(repeating: 0, count: NUM_REGISTERS)
  reg[0] = a

  var nip = 0
  var ip = 0
  var len = 0
  var curSig = 0

  let getArg = { (arg: Arg) -> Int in
    switch arg {
      case .Value(let val): return val
      case .Register(let idx): return reg[idx]
    }
  }

  let setArg = {(arg: Arg, val: Int) in
    switch arg {
      case .Value(_): print("Error: trying to assign to constant")
      case .Register(let idx): reg[idx] = val
    }
  }

  while ip >= 0 && ip < ops.count {
    let op = ops[ip]
    switch op {
      case .Cpy(let arg1, let arg2): setArg(arg2, getArg(arg1))
      case .Inc(let arg1): setArg(arg1, getArg(arg1) + 1)
      case .Dec(let arg1): setArg(arg1, getArg(arg1) - 1)
      case .Jnz(let arg1, let arg2):
        if getArg(arg1) != 0 {
          ip += getArg(arg2) - 1
        }
      case .Out(let arg1):
        let val = getArg(arg1)
        if val != curSig {
          return false
        }
        curSig = 1 - curSig
        len += 1
        if len >= maxLen {
          return true
        }
      default: print("Error operation.")
    }
    ip += 1
    nip += 1
    if nip >= maxSteps {
      return false
    }
  }
  return false
}

func findLowestSeed(ops: [Op]) -> Int {
  var a = 0
  while true {
    if isProducingClockSignal(ops:ops, a:a) {
      return a
    }
    a += 1
  }
}


let args = CommandLine.arguments
let fname = args.count > 1 ? args[1] : "input.txt"

let content = try String(contentsOfFile: fname, encoding: String.Encoding.ascii)
let lines = content.components(separatedBy:"\n")
let ops = lines.filter{ !$0.isEmpty }.map(parseOp)

let seed = findLowestSeed(ops:ops)
print("Lowest seed value: \(seed)")
