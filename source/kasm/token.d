module kasm.token;
import kasm.opcode;
import kasm.register;

enum TokenType {
  Opcode,
  Register,
  Immediate
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
