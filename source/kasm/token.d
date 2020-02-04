module kasm.token;
import kasm.opcode;
import kasm.register;

enum TokenType {
  Opcode,
  Register,
  Immediate,
  Label,
  JumpWithLabel
}

interface Token {
  TokenType type();
}

class OpcodeToken : Token {
  OpcodeSymbol sym;

  this(OpcodeSymbol sym) {
    this.sym = sym;
  }

  TokenType type() {
    return TokenType.Opcode;
  }
}

class RegisterToken : Token {
  Register reg;

  this(Register reg) {
    this.reg = reg;
  }

  TokenType type() {
    return TokenType.Register;
  }
}

class ImmediateToken : Token {
  short value;

  this(short value) {
    this.value = value;
  }

  TokenType type() {
    return TokenType.Immediate;
  }
}

class LabelToken : Token {
  string label;

  this(string label) {
    this.label = label;
  }

  TokenType type() {
    return TokenType.Label;
  }
}

enum JumpWithLabelKind {
  jmp = "jmp",
  jz = "jz",
  jp = "jp",
  jn = "jn",
  jc = "jc",
  jo = "jo"
}

class JumpWithLabelToken : Token {
  JumpWithLabelKind kind;

  this(JumpWithLabelKind kind) {
    this.kind = kind;
  }

  TokenType type() {
    return TokenType.JumpWithLabel;
  }
}
