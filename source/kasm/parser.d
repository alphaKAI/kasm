module kasm.parser;
import kasm.token;
import kasm.opcode;
import kasm.register;
import kasm.lexer;

import std.string;
import std.format;
import std.conv;
import std.typecons;

class ParserException : Exception {
  this(string msg) {
    super(msg);
  }
}

Nullable!Opcode tryParseImmMode(alias helper)(ref Token[] tokens, size_t i) {
  Register reg;
  short value;
  if ((i + 1 < tokens.length && tokens[i + 1].type == TokenType.Register)
      && (i + 2 < tokens.length && tokens[i + 2].type == TokenType.Immediate)) {
    reg = tokens[i + 1].to!(RegisterToken).reg;
    value = tokens[i + 2].to!(ImmediateToken).value;
    return nullable(helper(reg, value));
  } else {
    return typeof(return).init;
  }
}

Nullable!Opcode tryParseRegMode(alias helper)(ref Token[] tokens, size_t i) {
  Register dst;
  Register src;
  if ((i + 1 < tokens.length && tokens[i + 1].type == TokenType.Register)
      && (i + 2 < tokens.length && tokens[i + 2].type == TokenType.Register)) {
    dst = tokens[i + 1].to!(RegisterToken).reg;
    src = tokens[i + 2].to!(RegisterToken).reg;
    return nullable(helper(dst, src));
  } else {
    return typeof(return).init;
  }
}

Nullable!Opcode tryParseLoad(ref Token[] tokens, size_t i) {
  Register dst;
  Register src;
  short value;
  if ((i + 1 < tokens.length && tokens[i + 1].type == TokenType.Register)
      && (i + 2 < tokens.length && tokens[i + 2].type == TokenType.Register)
      && (i + 3 < tokens.length && tokens[i + 3].type == TokenType.Immediate)) {
    dst = tokens[i + 1].to!(RegisterToken).reg;
    src = tokens[i + 2].to!(RegisterToken).reg;
    value = tokens[i + 3].to!(ImmediateToken).value;
    return nullable(load(dst, src, value));
  } else {
    return typeof(return).init;
  }
}

Nullable!Opcode tryParseStore(ref Token[] tokens, size_t i) {
  Register dst;
  Register src;
  short value;
  if ((i + 1 < tokens.length && tokens[i + 1].type == TokenType.Register)
      && (i + 2 < tokens.length && tokens[i + 2].type == TokenType.Immediate)
      && (i + 3 < tokens.length && tokens[i + 3].type == TokenType.Register)) {
    dst = tokens[i + 1].to!(RegisterToken).reg;
    value = tokens[i + 2].to!(ImmediateToken).value;
    src = tokens[i + 3].to!(RegisterToken).reg;
    return nullable(store(dst, value, src));
  } else {
    return typeof(return).init;
  }
}

Nullable!Opcode tryParseJumpI(alias helper)(ref Token[] tokens, size_t i) {
  short value;
  if (i + 1 < tokens.length && tokens[i + 1].type == TokenType.Register) {
    value = tokens[i + 1].to!(ImmediateToken).value;
    return nullable(helper(value));
  } else {
    return typeof(return).init;
  }
}

Nullable!Opcode tryParseJumpR(alias helper)(ref Token[] tokens, size_t i) {
  Register src;
  if (i + 1 < tokens.length && tokens[i + 1].type == TokenType.Register) {
    src = tokens[i + 1].to!(RegisterToken).reg;
    return nullable(helper(src));
  } else {
    return typeof(return).init;
  }
}

class LabelOp : Opcode {
  string label;
  this(LabelToken lt) {
    this.label = lt.label;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.hlt; // dummy
  }
}

class JumpWithLabelOp : Opcode {
  JumpWithLabelKind kind;
  string label;
  this(JumpWithLabelToken jwlt, LabelToken lt) {
    this.kind = jwlt.kind;
    this.label = lt.label;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.hlt; // dummy
  }
}

Opcode[] resolveLabel(Opcode[] ops) {
  size_t[string] labelMap;
  Opcode[] ops2;
  size_t pc;

  // labelに対応するpcを計算する。また、命令中からLabelOpを除去する
  foreach (op; ops) {
    if ((cast(LabelOp) op) !is null) {
      LabelOp lop = cast(LabelOp) op;
      labelMap[lop.label] = pc;
    } else {
      ops2 ~= op;
      pc++;
    }
  }

  Opcode[] resolved;
  foreach (op; ops2) {
    if ((cast(JumpWithLabelOp) op) !is null) {
      JumpWithLabelOp jop = cast(JumpWithLabelOp) op;
      if (jop.label in labelMap) {
        size_t tpc = labelMap[jop.label];

        final switch (jop.kind) with (JumpWithLabelKind) {
        case jmp:
          resolved ~= new JmpaI(tpc.to!short);
          break;
        case jz:
          resolved ~= new JazI(tpc.to!short);
          break;
        case jp:
          resolved ~= new JapI(tpc.to!short);
          break;
        case jn:
          resolved ~= new JanI(tpc.to!short);
          break;
        case jc:
          resolved ~= new JacI(tpc.to!short);
          break;
        case jo:
          resolved ~= new JaoI(tpc.to!short);
          break;
        }
      } else {
        throw new ParserException("No such a label - %s".format(jop.label));
      }
    } else {
      resolved ~= op;
    }
  }

  return resolved;
}

Opcode[] parse(Token[] tokens) {
  Opcode[] parsed;

  void parseImm(alias helper, alias i)() {
    auto result = tryParseImmMode!(helper)(tokens, i);
    if (result.isNull) {
      throw new ParserException("Parse Error: imm expected");
    } else {
      parsed ~= result.get;
    }
    i += 3;
  }

  void parseReg(alias helper, alias i)() {
    auto result = tryParseRegMode!(helper)(tokens, i);
    if (result.isNull) {
      throw new ParserException("Parse Error: reg expected");
    } else {
      parsed ~= result.get;
    }
    i += 3;
  }

  void parseLoad(alias i)() {
    auto result = tryParseLoad(tokens, i);
    if (result.isNull) {
      throw new ParserException("Parse Error: load reg, reg, imm expected");
    } else {
      parsed ~= result.get;
    }
    i += 4;
  }

  void parseStore(alias i)() {
    auto result = tryParseStore(tokens, i);
    if (result.isNull) {
      throw new ParserException("Parse Error: store: store reg, imm, reg expected");
    } else {
      parsed ~= result.get;
    }
    i += 4;
  }

  void parseZeroArg(alias helper, alias i)() {
    parsed ~= helper();
    i += 1;
  }

  void parseJumpI(alias helper, alias i)() {
    auto result = tryParseJumpI!(helper)(tokens, i);
    if (result.isNull) {
      throw new ParserException("Parse Error<jmpI>: imm expected");
    } else {
      parsed ~= result.get;
    }
    i += 2;
  }

  void parseJumpR(alias helper, alias i)() {
    auto result = tryParseJumpR!(helper)(tokens, i);
    if (result.isNull) {
      throw new ParserException("Parse Error<jmpR>: reg expected");
    } else {
      parsed ~= result.get;
    }
    i += 2;
  }

  void parseLabel(alias i, alias token)() {
    parsed ~= new LabelOp(token.to!(LabelToken));
    i += 1;
  }

  void parseJumpWithLabel(alias i, alias token)() {
    parsed ~= new JumpWithLabelOp(token.to!(JumpWithLabelToken), tokens[i + 1].to!(LabelToken));
    i += 2;
  }

  for (size_t i; i < tokens.length;) {
    Token token = tokens[i];

    final switch (token.type) {
    case TokenType.Opcode: {
        const sym = token.to!OpcodeToken.sym;

        final switch (sym) {
        case OpcodeSymbol.addi: {
            parseImm!(addi, i);
            break;
          }
        case OpcodeSymbol.subi: {
            parseImm!(subi, i);
            break;
          }
        case OpcodeSymbol.muli: {
            parseImm!(muli, i);
            break;
          }
        case OpcodeSymbol.divi: {
            parseImm!(divi, i);
            break;
          }
        case OpcodeSymbol.cmpi: {
            parseImm!(cmpi, i);
            break;
          }
        case OpcodeSymbol.absi: {
            parseImm!(absi, i);
            break;
          }
        case OpcodeSymbol.adci: {
            parseImm!(adci, i);
            break;
          }
        case OpcodeSymbol.sbci: {
            parseImm!(sbci, i);
            break;
          }
        case OpcodeSymbol.shli: {
            parseImm!(shli, i);
            break;
          }
        case OpcodeSymbol.shri: {
            parseImm!(shri, i);
            break;
          }
        case OpcodeSymbol.ashi: {
            parseImm!(ashi, i);
            break;
          }
        case OpcodeSymbol.roli: {
            parseImm!(roli, i);
            break;
          }
        case OpcodeSymbol.rori: {
            parseImm!(rori, i);
            break;
          }
        case OpcodeSymbol.addr: {
            parseReg!(addr, i);
            break;
          }
        case OpcodeSymbol.subr: {
            parseReg!(subr, i);
            break;
          }
        case OpcodeSymbol.mulr: {
            parseReg!(mulr, i);
            break;
          }
        case OpcodeSymbol.divr: {
            parseReg!(divr, i);
            break;
          }
        case OpcodeSymbol.cmpr: {
            parseReg!(cmpr, i);
            break;
          }
        case OpcodeSymbol.absr: {
            parseReg!(absr, i);
            break;
          }
        case OpcodeSymbol.adcr: {
            parseReg!(adcr, i);
            break;
          }
        case OpcodeSymbol.sbcr: {
            parseReg!(sbcr, i);
            break;
          }
        case OpcodeSymbol.shlr: {
            parseReg!(shlr, i);
            break;
          }
        case OpcodeSymbol.shrr: {
            parseReg!(shrr, i);
            break;
          }
        case OpcodeSymbol.ashr: {
            parseReg!(ashr, i);
            break;
          }
        case OpcodeSymbol.rolr: {
            parseReg!(rolr, i);
            break;
          }
        case OpcodeSymbol.rorr: {
            parseReg!(rorr, i);
            break;
          }
        case OpcodeSymbol.and: {
            parseReg!(and, i);
            break;
          }
        case OpcodeSymbol.or: {
            parseReg!(or, i);
            break;
          }
        case OpcodeSymbol.not: {
            parseReg!(not, i);
            break;
          }
        case OpcodeSymbol.xor: {
            parseReg!(xor, i);
            break;
          }
        case OpcodeSymbol.setl: {
            parseImm!(setl, i);
            break;
          }
        case OpcodeSymbol.seth: {
            parseImm!(seth, i);
            break;
          }
        case OpcodeSymbol.load: {
            parseLoad!(i);
            break;
          }
        case OpcodeSymbol.store: {
            parseStore!(i);
            break;
          }
        case OpcodeSymbol.jmpi: {
            parseJumpI!(jmpi, i);
            break;
          }
        case OpcodeSymbol.jmpr: {
            parseJumpR!(jmpr, i);
            break;
          }
        case OpcodeSymbol.jzi: {
            parseJumpI!(jzi, i);
            break;
          }
        case OpcodeSymbol.jzr: {
            parseJumpR!(jzr, i);
            break;
          }
        case OpcodeSymbol.jpi: {
            parseJumpI!(jpi, i);
            break;
          }
        case OpcodeSymbol.jpr: {
            parseJumpR!(jpr, i);
            break;
          }
        case OpcodeSymbol.jni: {
            parseJumpI!(jni, i);
            break;
          }
        case OpcodeSymbol.jnr: {
            parseJumpR!(jnr, i);
            break;
          }
        case OpcodeSymbol.jci: {
            parseJumpI!(jci, i);
            break;
          }
        case OpcodeSymbol.jcr: {
            parseJumpR!(jcr, i);
            break;
          }
        case OpcodeSymbol.joi: {
            parseJumpI!(joi, i);
            break;
          }
        case OpcodeSymbol.jor: {
            parseJumpR!(jor, i);
            break;
          }
        case OpcodeSymbol.jmpai: {
            parseJumpI!(jmpai, i);
            break;
          }
        case OpcodeSymbol.jmpar: {
            parseJumpR!(jmpar, i);
            break;
          }
        case OpcodeSymbol.jazi: {
            parseJumpI!(jazi, i);
            break;
          }
        case OpcodeSymbol.jazr: {
            parseJumpR!(jazr, i);
            break;
          }
        case OpcodeSymbol.japi: {
            parseJumpI!(japi, i);
            break;
          }
        case OpcodeSymbol.japr: {
            parseJumpR!(japr, i);
            break;
          }
        case OpcodeSymbol.jani: {
            parseJumpI!(jani, i);
            break;
          }
        case OpcodeSymbol.janr: {
            parseJumpR!(janr, i);
            break;
          }
        case OpcodeSymbol.jaci: {
            parseJumpI!(jaci, i);
            break;
          }
        case OpcodeSymbol.jacr: {
            parseJumpR!(jacr, i);
            break;
          }
        case OpcodeSymbol.jaoi: {
            parseJumpI!(jaoi, i);
            break;
          }
        case OpcodeSymbol.jaor: {
            parseJumpR!(jaor, i);
            break;
          }
        case OpcodeSymbol.nop: {
            parseZeroArg!(nop, i)();
            break;
          }
        case OpcodeSymbol.hlt: {
            parseZeroArg!(hlt, i)();
            break;
          }
        }

        break;
      }
    case TokenType.Label: {
        parseLabel!(i, token)();
        break;
      }
    case TokenType.JumpWithLabel: {
        parseJumpWithLabel!(i, token)();
        break;
      }
    case TokenType.Register:
    case TokenType.Immediate: {
        throw new ParserException("Unexpected token given %s".format(token.type));
      }
    }
  }

  return resolveLabel(parsed);

  //return parsed;
}

Opcode[] parse_file(string file_name) {
  return file_name.lex_file.parse;
}
