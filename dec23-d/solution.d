import std.stdio, std.traits, std.string;
import std.array, std.algorithm, std.conv;

const int NUM_REGISTERS = 4;

enum OpCode {
  CPY, INC, DEC, JNZ, TGL, ERR
}

struct Argument {
  int   value;    //  register index if register  
  bool  register;
}

struct Operation {
  OpCode  code;
  Argument arg1, arg2;
}

Argument parseArg(const ref string str) {
  bool register = false;
  int val = 0;
  char c = str[0];
  if (c >= 'a' && c < 'a' + NUM_REGISTERS) {
    val = c - 'a';
    register = true;
  } else {
    val = to!int(str);
  }
  return Argument(val, register);
}

Operation parseOp(char[] str) {
  string[] parts = split(to!string(str), " ");
  if (parts.length < 2 || parts.length > 3) {
    return Operation(OpCode.ERR);
  }
  string opStr = toLower(parts[0]);

  OpCode code = OpCode.ERR;
  foreach (c; [EnumMembers!OpCode]) {
    if (toLower(to!string(c)) == opStr) code = c;
  }

  Argument arg1, arg2;
  arg1 = parseArg(parts[1]);
  if (parts.length > 2) arg2 = parseArg(parts[2]);
  return Operation(code, arg1, arg2);
}

void toggleOp(ref Operation op) {
  if (op.code == OpCode.INC) {
    op.code = OpCode.DEC;
  } else if (op.code == OpCode.DEC || op.code == OpCode.TGL) {
    op.code = OpCode.INC;
  } else if (op.code == OpCode.JNZ) {
    op.code = OpCode.CPY;
  } else {
    op.code = OpCode.JNZ;
  }
}

void eval(Operation[] initOps, int[] registers) {
  auto ops = initOps.dup;
  int ip = 0;

  auto arg = delegate (ref Argument arg) => 
    arg.register ? &registers[arg.value] : &arg.value;
    
  while (ip >= 0 && ip < ops.length) {
    auto op = ops[ip];
    switch (op.code) {
      case OpCode.CPY:
        if (op.arg2.register) {
          *arg(op.arg2) = *arg(op.arg1);
        }
      break;
      case OpCode.INC:
        if (op.arg1.register) {
          *arg(op.arg1) += 1;
        }
      break;
      case OpCode.DEC:
        if (op.arg1.register) {
          *arg(op.arg1) -= 1;
        }
      break;
      case OpCode.JNZ:
        if (*arg(op.arg1) != 0) {
          ip += *arg(op.arg2) - 1;
        }
      break;
      case OpCode.TGL:
        int ipt = *arg(op.arg1) + ip;
        if (ipt >= 0 && ipt < ops.length) {
          toggleOp(ops[ipt]);
        }
      break;
      default: break;
    }
    ip++;
  }
}

void main(string[] args) {
  string fname = args.length > 1 ? args[1] : "input.txt";
  int initVal = args.length > 2 ? to!int(args[2]) : 7;

  auto file = File(fname);
  auto ops = array(file.byLine().map!parseOp);

  int[NUM_REGISTERS] reg;
  reg[0] = initVal;

  eval(ops, reg);

  writefln("Value in register a: %d", reg[0]);
}