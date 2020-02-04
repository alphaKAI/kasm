module kasm.lexer;
import kasm.token;
import kasm.opcode, kasm.register;
import std.string;
import std.algorithm, std.array;
import std.regex, std.conv;
import std.typecons;
import std.file;

enum commentRegex = ctRegex!";.*$";
enum commaRegex = ctRegex!",";
enum labelRegex = ctRegex!r"\w(\w|\d)*";

Nullable!(OpcodeToken) tryParseOpcodeToken(string s) {
  switch (s) with (OpcodeSymbol) {
  case addi:
  case subi:
  case muli:
  case divi:
  case cmpi:
  case absi:
  case adci:
  case sbci:
  case shli:
  case shri:
  case ashi:
  case roli:
  case rori:
  case addr:
  case subr:
  case mulr:
  case divr:
  case cmpr:
  case absr:
  case adcr:
  case sbcr:
  case shlr:
  case shrr:
  case ashr:
  case rolr:
  case rorr:
  case and:
  case or:
  case not:
  case xor:
  case setl:
  case seth:
  case load:
  case store:
  case jmpi:
  case jmpr:
  case jzi:
  case jzr:
  case jpi:
  case jpr:
  case jni:
  case jnr:
  case jci:
  case jcr:
  case joi:
  case jor:
  case jmpai:
  case jmpar:
  case jazi:
  case jazr:
  case japi:
  case japr:
  case jani:
  case janr:
  case jaci:
  case jacr:
  case jaoi:
  case jaor:
  case nop:
  case hlt:
    return nullable(new OpcodeToken(cast(OpcodeSymbol) s));
  default:
    return typeof(return).init;
  }
}

Nullable!(RegisterToken) tryParseRegisterToken(string s) {
  switch (s) with (Register) {
  case r0:
  case r1:
  case r2:
  case r3:
  case r4:
  case r5:
  case r6:
  case r7:
  case r8:
  case r9:
  case r10:
  case r11:
  case r12:
  case r13:
  case r14:
  case r15:
    return nullable(new RegisterToken(cast(Register) s));
  default:
    return typeof(return).init;
  }
}

Nullable!(ImmediateToken) tryParseImmediateToken(string s) {
  try {
    short value = s.to!short;
    return nullable(new ImmediateToken(value));
  } catch (ConvException e) {
    return typeof(return).init;
  }
}

Nullable!(LabelToken) tryParseLabelToken(string s) {
  if (s.strip.match(labelRegex)) {
    import std.stdio;

    if (s.length >= 2 && s[$ - 1] == ':') {
      return nullable(new LabelToken(s[0 .. $ - 1]));
    } else {
      return nullable(new LabelToken(s));
    }
  } else {
    return typeof(return).init;
  }
}

Nullable!(JumpWithLabelToken) tryParseJumpWithLabelToken(string s) {
  switch (s) with (JumpWithLabelKind) {
  case jmp:
  case jz:
  case jp:
  case jn:
  case jc:
  case jo:
    return nullable(new JumpWithLabelToken(cast(JumpWithLabelKind) s));
  default:
    return typeof(return).init;
  }
}

class LexerException : Exception {
  this(string msg) {
    super(msg);
  }
}

Token[] lex(string input) {
  Token[] tokens;
  string[] inputs = input.split("\n")
    .map!((string line) => line.strip.replaceAll(commentRegex, " ").replaceAll(commaRegex, " "))
    .array
    .filter!((string line) => line.length > 0)
    .array;

  string[] simplified = inputs.join(" ").split(" ");

  foreach (elem; simplified) {
    if (elem.length == 0) {
      continue;
    }
    elem = elem.chomp.strip;

    auto maybeOpcode = tryParseOpcodeToken(elem);
    if (!maybeOpcode.isNull) {
      tokens ~= maybeOpcode.get;
      continue;
    }
    auto maybeRegister = tryParseRegisterToken(elem);
    if (!maybeRegister.isNull) {
      tokens ~= maybeRegister.get;
      continue;
    }
    auto maybeImmediate = tryParseImmediateToken(elem);
    if (!maybeImmediate.isNull) {
      tokens ~= maybeImmediate.get;
      continue;
    }
    auto maybeJumpWithLabel = tryParseJumpWithLabelToken(elem);
    if (!maybeJumpWithLabel.isNull) {
      tokens ~= maybeJumpWithLabel.get;
      continue;
    }
    auto maybeLabel = tryParseLabelToken(elem);
    if (!maybeLabel.isNull) {
      tokens ~= maybeLabel.get;
      continue;
    }

    throw new LexerException(" Unknown token given - \"%s\"".format(elem));
  }

  return tokens;
}

Token[] lex_file(string file_name) {
  return readText(file_name).lex;
}
