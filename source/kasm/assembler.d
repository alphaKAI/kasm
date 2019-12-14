module kasm.assembler;
import kasm.opcode;

interface Assembler(T) {
  static void emit_integer_or_shift(ref T[] code, ubyte op, bool immf, ubyte rd, ubyte rs,
      ushort imm);
  static void emit_logic(ref T[] code, ubyte op, ubyte rd, ubyte rs);
  static void emit_set_l_h(ref T[] code, ubyte op, ubyte rd);
  static void emit_zero_arg(ref T[] code, ubyte op);
  static void emit_jump(ref T[] code, ubyte op, bool immf, ubyte cc, ubyte rs, ushort imm);

  static T[] assemble(Opcode[] code);
  static T[] assemble_file(string src_file);
}

class AssemblerException : Exception {
  this(string msg) {
    super(msg);
  }
}
