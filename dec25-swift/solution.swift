
import Foundation



let args = CommandLine.arguments
let fname = args.count > 1 ? args[1] : "input.txt"

let content = try String(contentsOfFile: fname, encoding: String.Encoding.ascii)
let lines = content.components(separatedBy:"\n")

print(lines)
