import 'dart:io';

final NUM_REGISTERS = 4;

enum OpType { CPY, INC, DEC, JNZ }
enum ArgType { CONSTANT, REGISTER, NONE }

class Argument {
  final ArgType type;
  final int value;

  Argument(this.type, {this.value: 0});
}

class Operation {
  final OpType type;
  final Argument arg1, arg2;

  Operation(this.type, this.arg1, this.arg2);
}

Argument parseArg(String str) {
  if (str == null) return new Argument(ArgType.NONE);

  final int c0 = "a".codeUnitAt(0);
  int c = str.codeUnitAt(0);
  if (c >= c0 && c < c0 + NUM_REGISTERS) {
    return new Argument(ArgType.REGISTER, value: c - c0);
  } else {
    return new Argument(ArgType.CONSTANT, value: int.parse(str));
  }
}

OpType parseOpType(String str) {
  String str1 = "." + str.toLowerCase();
  for (OpType t in OpType.values) {
    String t1 = t.toString().toLowerCase();
    if (t1.contains(str1)) return t;
  }
  return null;
}

Operation parseOp(String str) {
  var parts = str.split(" ");
  var arg1 = parseArg(parts[1]);
  var arg2 = parseArg(parts.length > 2 ? parts[2] : null);
  return new Operation(parseOpType(parts[0]), arg1, arg2);
}

List<int> eval(List<Operation> ops) {
  var reg = new List.filled(NUM_REGISTERS, 0);
  int ip = 0;
  while (ip < ops.length) {
    var op = ops[ip];
    switch (op.type) {
      case OpType.INC:
        reg[op.arg1.value]++;
        ip++;
        break;
      case OpType.DEC:
        reg[op.arg1.value]--;
        ip++;
        break;
      case OpType.JNZ:
        if (reg[op.arg1.value] != 0) {
          ip += op.arg2.value;
        } else {
          ip++;
        }
        break;
      case OpType.CPY:
        var val;
        if (op.arg1.type == ArgType.CONSTANT) {
          val = op.arg1.value;
        } else {
          val = reg[op.arg1.value];
        }
        reg[op.arg2.value] = val;
        ip++;
        break;
    }
  }
  return reg;
}

main(List<String> args) {
  String file = "test.txt";
  if (args.length > 0) file = args[0];

  List<String> lines = (new File(file)).readAsLinesSync();
  var ops = lines.map(parseOp).toList();
  var res1 = eval(ops);
  print("Value in register a: ${res1[0]}");

  ops.insert(0, parseOp("cpy 1 c"));
  var res2 = eval(ops);
  print("Value in register a (c starts at 1): ${res2[0]}");
}
