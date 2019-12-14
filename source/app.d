import std.algorithm, std.array, std.stdio, std.string, std.format, std.file, std.path, std.conv;
import kasm.lexer, kasm.parser, kasm.stringasm;

void main(string[] args) {
  if (args.length == 1) {
    throw new Error("Invalid Arguments");
  }
  args = args[1 .. $];

  if (!exists(args[0])) {
    throw new Error("No such a file - %s".format(args[0]));
  }

  string src_file = args[0];
  string data = readText(src_file);
  auto tokens = lex(data);
  auto code = parse(tokens);
  auto asm_result = StringAssembler.assemble(code);

  writeln("assembled codes: ");
  string dst_file = "%s.memb".format(baseName(src_file, ".kasm"));
  File dst = File(dst_file, "w");
  foreach (line; asm_result) {
    writeln(line);
    dst.writeln(line);
  }

  writeln("[Assembled codes are saved as ", dst_file, "]");

}
