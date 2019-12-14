import std.algorithm, std.array, std.stdio, std.string, std.format, std.file, std.path, std.conv;
import kasm.lexer, kasm.parser, kasm.assembler, kasm.stringemitter;

void main(string[] args) {
  if (args.length == 1) {
    throw new Error("Invalid Arguments");
  }
  args = args[1 .. $];

  foreach (src_file; args) {
    if (!exists(src_file)) {
      throw new Error("No such a file - %s".format(args[0]));
    }

    string data = readText(src_file);
    auto tokens = lex(data);
    auto code = parse(tokens);
    auto asm_result = Assembler!(string, StringEmitter).assemble(code);

    writefln("assembly code[%s]:", src_file);
    writeln(data);

    writeln("assembled codes: ");
    string dst_file = "%s.memb".format(baseName(src_file, ".kasm"));
    File dst = File(dst_file, "w");
    foreach (line; asm_result) {
      writeln(line);
      dst.writeln(line);
    }

    writeln("[Assembled codes are saved as ", dst_file, "]");
  }
}
