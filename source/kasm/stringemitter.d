module kasm.stringemitter;
import kasm.assembler;
import kasm.opcode;
import kasm.register;

import std.format;

class StringEmitter : AssemblerEmitter!(string) {
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
}
