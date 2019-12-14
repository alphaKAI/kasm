module kasm.stringasm;
import kasm.assembler;
import kasm.opcode;
import kasm.register;

import std.string;
import std.stdio;
import std.file;
import std.conv;

class StringAssembler : Assembler!(string) {
  static void emit_integer_or_shift(ref string[] code, ubyte op, bool immf,
      ubyte rd, ubyte rs, ushort imm) {
    code ~= "%07b%1b%04b%04b%016b".format(op, immf, rd, rs, imm);
  }

  static void emit_logic(ref string[] code, ubyte op, ubyte rd, ubyte rs) {
    code ~= "%07b%1b%04b%04b%016b".format(op, 0, rd, rs, 0);
  }

  static void emit_set_l_h(ref string[] code, ubyte op, ubyte rd) {
    code ~= "%07b%1b%04b%04b%016b".format(op, 0, rd, 0, 0);
  }

  static void emit_load(ref string[] code, ubyte op, ubyte rd, ubyte rs, ushort imm) {
    code ~= "%07b%1b%04b%04b%016b".format(op, 1, rd, rs, imm);
  }

  static void emit_store(ref string[] code, ubyte op, ubyte rd, ubyte rs, ushort imm) {
    code ~= "%07b%1b%04b%04b%016b".format(op, 1, rs, rd, imm);
  }

  static void emit_zero_arg(ref string[] code, ubyte op) {
    code ~= "%07b%1b%04b%04b%016b".format(op, 0, 0, 0, 0);
  }

  static void emit_jump(ref string[] code, ubyte op, bool immf, ubyte cc, ubyte rs, ushort imm) {
    code ~= "%07b%1b%04b%04b%016b".format(op, immf, cc, rs, imm);
  }

  static string[] assemble(Opcode[] code) {
    string[] ret;

    void emitImmMode(T)(Opcode op) {
      auto t = op.to!T;
      Register dst = t.dst;
      short imm = t.imm;
      emit_integer_or_shift(ret, opcode_symbol_to_byte(op.sym), true, reg_to_bytes(dst), 0, imm);
    }

    void emitRegMode(T)(Opcode op) {
      auto t = op.to!T;
      ubyte dst = t.dst.reg_to_bytes;
      ubyte src = t.src.reg_to_bytes;
      emit_integer_or_shift(ret, opcode_symbol_to_byte(op.sym), false, dst, src, 0);
    }

    void emitLogic(T)(Opcode op) {
      auto t = op.to!T;
      ubyte dst = t.dst.reg_to_bytes;
      ubyte src = t.src.reg_to_bytes;
      emit_logic(ret, opcode_symbol_to_byte(op.sym), dst, src);
    }

    void emitLH(T)(Opcode op) {
      auto t = op.to!T;
      ubyte dst = t.dst.reg_to_bytes;
      short imm = t.imm;
      emit_integer_or_shift(ret, opcode_symbol_to_byte(op.sym), false, dst, 0, imm);
    }

    void emitJumpI(T)(Opcode op) {
      auto t = op.to!T;
      short imm = t.value;
      emit_jump(ret, opcode_symbol_to_byte(op.sym), true, t.cc, 0, imm);
    }

    void emitJumpR(T)(Opcode op) {
      auto t = op.to!T;
      ubyte src = t.src.reg_to_bytes;
      emit_jump(ret, opcode_symbol_to_byte(op.sym), false, t.cc, src, 0);
    }

    void emitLoad(Opcode op) {
      auto t = op.to!Load;
      ubyte dst = t.dst.reg_to_bytes;
      ubyte src = t.src.reg_to_bytes;
      short imm = t.imm;

      emit_load(ret, opcode_symbol_to_byte(op.sym), dst, src, imm);
    }

    void emitStore(Opcode op) {
      auto t = op.to!Store;
      ubyte dst = t.dst.reg_to_bytes;
      ubyte src = t.src.reg_to_bytes;
      short imm = t.imm;

      emit_store(ret, opcode_symbol_to_byte(op.sym), dst, src, imm);
    }

    foreach (op; code) {
      final switch (op.sym) {
      case OpcodeSymbol.addi: {
          emitImmMode!(AddI)(op);
          break;
        }
      case OpcodeSymbol.subi: {
          emitImmMode!(SubI)(op);
          break;
        }
      case OpcodeSymbol.muli: {
          emitImmMode!(MulI)(op);
          break;
        }
      case OpcodeSymbol.divi: {
          emitImmMode!(DivI)(op);
          break;
        }
      case OpcodeSymbol.cmpi: {
          emitImmMode!(CmpI)(op);
          break;
        }
      case OpcodeSymbol.absi: {
          emitImmMode!(AbsI)(op);
          break;
        }
      case OpcodeSymbol.adci: {
          emitImmMode!(AdcI)(op);
          break;
        }
      case OpcodeSymbol.sbci: {
          emitImmMode!(SbcI)(op);
          break;
        }
      case OpcodeSymbol.shli: {
          emitImmMode!(ShlI)(op);
          break;
        }
      case OpcodeSymbol.shri: {
          emitImmMode!(ShrI)(op);
          break;
        }
      case OpcodeSymbol.ashi: {
          emitImmMode!(AshI)(op);
          break;
        }
      case OpcodeSymbol.roli: {
          emitImmMode!(RolI)(op);
          break;
        }
      case OpcodeSymbol.rori: {
          emitImmMode!(RorI)(op);
          break;
        }
      case OpcodeSymbol.addr: {
          emitRegMode!(AddR)(op);
          break;
        }
      case OpcodeSymbol.subr: {
          emitRegMode!(SubR)(op);
          break;
        }
      case OpcodeSymbol.mulr: {
          emitRegMode!(MulR)(op);
          break;
        }
      case OpcodeSymbol.divr: {
          emitRegMode!(DivR)(op);
          break;
        }
      case OpcodeSymbol.cmpr: {
          emitRegMode!(CmpR)(op);
          break;
        }
      case OpcodeSymbol.absr: {
          emitRegMode!(AbsR)(op);
          break;
        }
      case OpcodeSymbol.adcr: {
          emitRegMode!(AdcR)(op);
          break;
        }
      case OpcodeSymbol.sbcr: {
          emitRegMode!(SbcR)(op);
          break;
        }
      case OpcodeSymbol.shlr: {
          emitRegMode!(ShlR)(op);
          break;
        }
      case OpcodeSymbol.shrr: {
          emitRegMode!(ShrR)(op);
          break;
        }
      case OpcodeSymbol.ashr: {
          emitRegMode!(AshR)(op);
          break;
        }
      case OpcodeSymbol.rolr: {
          emitRegMode!(RolR)(op);
          break;
        }
      case OpcodeSymbol.rorr: {
          emitRegMode!(RorR)(op);
          break;
        }
      case OpcodeSymbol.and: {
          emitLogic!(And)(op);
          break;
        }
      case OpcodeSymbol.or: {
          emitLogic!(Or)(op);
          break;
        }
      case OpcodeSymbol.not: {
          emitLogic!(Not)(op);
          break;
        }
      case OpcodeSymbol.xor: {
          emitLogic!(Xor)(op);
          break;
        }
      case OpcodeSymbol.setl: {
          emitLH!(Setl)(op);
          break;
        }
      case OpcodeSymbol.seth: {
          emitLH!(Seth)(op);
          break;
        }
      case OpcodeSymbol.load: {
          emitLoad(op);
          break;
        }
      case OpcodeSymbol.store: {
          emitStore(op);
          break;
        }
      case OpcodeSymbol.jmpi: {
          emitJumpI!(JmpI)(op);
          break;
        }
      case OpcodeSymbol.jmpr: {
          emitJumpR!(JmpR)(op);
          break;
        }
      case OpcodeSymbol.jzi: {
          emitJumpI!(JzI)(op);
          break;
        }
      case OpcodeSymbol.jzr: {
          emitJumpR!(JzR)(op);
          break;
        }
      case OpcodeSymbol.jpi: {
          emitJumpI!(JpI)(op);
          break;
        }
      case OpcodeSymbol.jpr: {
          emitJumpR!(JpR)(op);
          break;
        }
      case OpcodeSymbol.jni: {
          emitJumpI!(JnI)(op);
          break;
        }
      case OpcodeSymbol.jnr: {
          emitJumpR!(JnR)(op);
          break;
        }
      case OpcodeSymbol.jci: {
          emitJumpI!(JcI)(op);
          break;
        }
      case OpcodeSymbol.jcr: {
          emitJumpR!(JcR)(op);
          break;
        }
      case OpcodeSymbol.joi: {
          emitJumpI!(JoI)(op);
          break;
        }
      case OpcodeSymbol.jor: {
          emitJumpR!(JoR)(op);
          break;
        }
      case OpcodeSymbol.jmpai: {
          emitJumpI!(JmpaI)(op);
          break;
        }
      case OpcodeSymbol.jmpar: {
          emitJumpR!(JmpaR)(op);
          break;
        }
      case OpcodeSymbol.jazi: {
          emitJumpI!(JazI)(op);
          break;
        }
      case OpcodeSymbol.jazr: {
          emitJumpR!(JazR)(op);
          break;
        }
      case OpcodeSymbol.japi: {
          emitJumpI!(JapI)(op);
          break;
        }
      case OpcodeSymbol.japr: {
          emitJumpR!(JapR)(op);
          break;
        }
      case OpcodeSymbol.jani: {
          emitJumpI!(JanI)(op);
          break;
        }
      case OpcodeSymbol.janr: {
          emitJumpR!(JanR)(op);
          break;
        }
      case OpcodeSymbol.jaci: {
          emitJumpI!(JacI)(op);
          break;
        }
      case OpcodeSymbol.jacr: {
          emitJumpR!(JacR)(op);
          break;
        }
      case OpcodeSymbol.jaoi: {
          emitJumpI!(JaoI)(op);
          break;
        }
      case OpcodeSymbol.jaor: {
          emitJumpR!(JaoR)(op);
          break;
        }
      case OpcodeSymbol.nop:
      case OpcodeSymbol.hlt:
        emit_zero_arg(ret,
            opcode_symbol_to_byte(op.sym));
      }
    }

    return ret;
  }

  static string[] assemble_file(string src_file) {
    import kasm.parser : parse_file;

    auto code = parse_file(src_file);
    auto asm_result = assemble(code);
    return asm_result;
  }
}
