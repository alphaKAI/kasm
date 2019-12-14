module kasm.opcode;
import kasm.register;

enum OpcodeSymbol {
  addi = "addi",
  addr = "addr",
  subi = "subi",
  subr = "subr",
  muli = "muli",
  mulr = "mulr",
  divi = "divi",
  divr = "divr",
  cmpi = "cmpi",
  cmpr = "cmpr",
  absi = "absi",
  absr = "absr",
  adci = "adci",
  adcr = "adcr",
  sbci = "sbci",
  sbcr = "sbcr",
  shli = "shli",
  shlr = "shlr",
  shri = "shri",
  shrr = "shrr",
  ashi = "ashi",
  ashr = "ashr",
  roli = "roli",
  rolr = "rolr",
  rori = "rori",
  rorr = "rorr",

  and = "and",
  or = "or",
  not = "not",
  xor = "xor",

  setl = "setl",
  seth = "seth",
  load = "load",
  store = "store",

  jmpi = "jmpi",
  jmpr = "jmpr",

  jzi = "jzi",
  jzr = "jzr",

  jpi = "jpi",
  jpr = "jpr",

  jni = "jni",
  jnr = "jnr",

  jci = "jci",
  jcr = "jcr",

  joi = "joi",
  jor = "jor",

  jmpai = "jmpai",
  jmpar = "jmpar",

  jazi = "jazi",
  jazr = "jazr",

  japi = "japi",
  japr = "japr",

  jani = "jani",
  janr = "janr",

  jaci = "jaci",
  jacr = "jacr",

  jaoi = "jaoi",
  jaor = "jaor",

  nop = "nop",
  hlt = "hlt"
}

ubyte opcode_symbol_to_byte(OpcodeSymbol op) {
  final switch (op) with (OpcodeSymbol) {
  case addi:
  case addr:
    return 0b000_0000;
  case subi:
  case subr:
    return 0b000_0001;
  case muli:
  case mulr:
    return 0b000_0010;
  case divi:
  case divr:
    return 0b000_0011;
  case cmpi:
  case cmpr:
    return 0b000_0100;
  case absi:
  case absr:
    return 0b000_0101;
  case adci:
  case adcr:
    return 0b000_0110;
  case sbci:
  case sbcr:
    return 0b000_0111;
  case shli:
  case shlr:
    return 0b000_1000;
  case shri:
  case shrr:
    return 0b000_1001;
  case ashi:
  case ashr:
    return 0b000_1010;
  case roli:
  case rolr:
    return 0b000_1100;
  case rori:
  case rorr:
    return 0b000_1101;

  case and:
    return 0b001_0000;
  case or:
    return 0b001_0001;
  case not:
    return 0b001_0010;
  case xor:
    return 0b001_0011;

  case setl:
    return 0b001_0110;
  case seth:
    return 0b001_0111;

  case load:
    return 0b001_1000;
  case store:
    return 0b001_1001;

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
    return 0b001_1100;
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
    return 0b001_1101;

  case nop:
    return 0b001_1110;
  case hlt:
    return 0b001_1111;
  }
}

interface Opcode {
  OpcodeSymbol sym();
}

class AddI : Opcode {
  Register dst;
  short imm;

  this(Register dst, short imm) {
    this.dst = dst;
    this.imm = imm;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.addi;
  }
}

class AddR : Opcode {
  Register dst;
  Register src;

  this(Register dst, Register src) {
    this.dst = dst;
    this.src = src;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.addr;
  }
}

Opcode addi(Register dst, short imm) {
  return new AddI(dst, imm);
}

Opcode addr(Register dst, Register src) {
  return new AddR(dst, src);
}

class SubI : Opcode {
  Register dst;
  short imm;

  this(Register dst, short imm) {
    this.dst = dst;
    this.imm = imm;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.subi;
  }
}

class SubR : Opcode {
  Register dst;
  Register src;

  this(Register dst, Register src) {
    this.dst = dst;
    this.src = src;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.subr;
  }
}

Opcode subi(Register dst, short imm) {
  return new SubI(dst, imm);
}

Opcode subr(Register dst, Register src) {
  return new SubR(dst, src);
}

class MulI : Opcode {
  Register dst;
  short imm;

  this(Register dst, short imm) {
    this.dst = dst;
    this.imm = imm;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.muli;
  }
}

class MulR : Opcode {
  Register dst;
  Register src;

  this(Register dst, Register src) {
    this.dst = dst;
    this.src = src;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.mulr;
  }
}

Opcode muli(Register dst, short imm) {
  return new MulI(dst, imm);
}

Opcode mulr(Register dst, Register src) {
  return new MulR(dst, src);
}

class DivI : Opcode {
  Register dst;
  short imm;

  this(Register dst, short imm) {
    this.dst = dst;
    this.imm = imm;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.divi;
  }
}

class DivR : Opcode {
  Register dst;
  Register src;

  this(Register dst, Register src) {
    this.dst = dst;
    this.src = src;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.divr;
  }
}

Opcode divi(Register dst, short imm) {
  return new DivI(dst, imm);
}

Opcode divr(Register dst, Register src) {
  return new DivR(dst, src);
}

class CmpI : Opcode {
  Register dst;
  short imm;

  this(Register dst, short imm) {
    this.dst = dst;
    this.imm = imm;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.cmpi;
  }
}

class CmpR : Opcode {
  Register dst;
  Register src;

  this(Register dst, Register src) {
    this.dst = dst;
    this.src = src;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.cmpr;
  }
}

Opcode cmpi(Register dst, short imm) {
  return new CmpI(dst, imm);
}

Opcode cmpr(Register dst, Register src) {
  return new CmpR(dst, src);
}

class AbsI : Opcode {
  Register dst;
  short imm;

  this(Register dst, short imm) {
    this.dst = dst;
    this.imm = imm;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.absi;
  }
}

class AbsR : Opcode {
  Register dst;
  Register src;

  this(Register dst, Register src) {
    this.dst = dst;
    this.src = src;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.absr;
  }
}

Opcode absi(Register dst, short imm) {
  return new AbsI(dst, imm);
}

Opcode absr(Register dst, Register src) {
  return new AbsR(dst, src);
}

class AdcI : Opcode {
  Register dst;
  short imm;

  this(Register dst, short imm) {
    this.dst = dst;
    this.imm = imm;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.adci;
  }
}

class AdcR : Opcode {
  Register dst;
  Register src;

  this(Register dst, Register src) {
    this.dst = dst;
    this.src = src;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.adcr;
  }
}

Opcode adci(Register dst, short imm) {
  return new AdcI(dst, imm);
}

Opcode adcr(Register dst, Register src) {
  return new AdcR(dst, src);
}

class SbcI : Opcode {
  Register dst;
  short imm;

  this(Register dst, short imm) {
    this.dst = dst;
    this.imm = imm;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.sbci;
  }
}

class SbcR : Opcode {
  Register dst;
  Register src;

  this(Register dst, Register src) {
    this.dst = dst;
    this.src = src;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.sbcr;
  }
}

Opcode sbci(Register dst, short imm) {
  return new SbcI(dst, imm);
}

Opcode sbcr(Register dst, Register src) {
  return new SbcR(dst, src);
}

class ShlI : Opcode {
  Register dst;
  short imm;

  this(Register dst, short imm) {
    this.dst = dst;
    this.imm = imm;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.shli;
  }
}

class ShlR : Opcode {
  Register dst;
  Register src;

  this(Register dst, Register src) {
    this.dst = dst;
    this.src = src;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.shlr;
  }
}

Opcode shli(Register dst, short imm) {
  return new ShlI(dst, imm);
}

Opcode shlr(Register dst, Register src) {
  return new ShlR(dst, src);
}

class ShrI : Opcode {
  Register dst;
  short imm;

  this(Register dst, short imm) {
    this.dst = dst;
    this.imm = imm;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.shri;
  }
}

class ShrR : Opcode {
  Register dst;
  Register src;

  this(Register dst, Register src) {
    this.dst = dst;
    this.src = src;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.shrr;
  }
}

Opcode shri(Register dst, short imm) {
  return new ShrI(dst, imm);
}

Opcode shrr(Register dst, Register src) {
  return new ShrR(dst, src);
}

class AshI : Opcode {
  Register dst;
  short imm;

  this(Register dst, short imm) {
    this.dst = dst;
    this.imm = imm;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.ashi;
  }
}

class AshR : Opcode {
  Register dst;
  Register src;

  this(Register dst, Register src) {
    this.dst = dst;
    this.src = src;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.ashr;
  }
}

Opcode ashi(Register dst, short imm) {
  return new AshI(dst, imm);
}

Opcode ashr(Register dst, Register src) {
  return new AshR(dst, src);
}

class RolI : Opcode {
  Register dst;
  short imm;

  this(Register dst, short imm) {
    this.dst = dst;
    this.imm = imm;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.roli;
  }
}

class RolR : Opcode {
  Register dst;
  Register src;

  this(Register dst, Register src) {
    this.dst = dst;
    this.src = src;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.rolr;
  }
}

Opcode roli(Register dst, short imm) {
  return new RolI(dst, imm);
}

Opcode rolr(Register dst, Register src) {
  return new RolR(dst, src);
}

class RorI : Opcode {
  Register dst;
  short imm;

  this(Register dst, short imm) {
    this.dst = dst;
    this.imm = imm;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.rori;
  }
}

class RorR : Opcode {
  Register dst;
  Register src;

  this(Register dst, Register src) {
    this.dst = dst;
    this.src = src;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.rorr;
  }
}

Opcode rori(Register dst, short imm) {
  return new RorI(dst, imm);
}

Opcode rorr(Register dst, Register src) {
  return new RorR(dst, src);
}

class And : Opcode {
  Register dst;
  Register src;

  this(Register dst, Register src) {
    this.dst = dst;
    this.src = src;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.and;
  }
}

Opcode and(Register dst, Register src) {
  return new And(dst, src);
}

class Or : Opcode {
  Register dst;
  Register src;

  this(Register dst, Register src) {
    this.dst = dst;
    this.src = src;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.or;
  }
}

Opcode or(Register dst, Register src) {
  return new Or(dst, src);
}

class Not : Opcode {
  Register dst;
  Register src;

  this(Register dst, Register src) {
    this.dst = dst;
    this.src = src;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.not;
  }
}

Opcode not(Register dst, Register src) {
  return new Not(dst, src);
}

class Xor : Opcode {
  Register dst;
  Register src;

  this(Register dst, Register src) {
    this.dst = dst;
    this.src = src;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.xor;
  }
}

Opcode xor(Register dst, Register src) {
  return new Xor(dst, src);
}

class Setl : Opcode {
  Register dst;
  short imm;

  this(Register dst, short imm) {
    this.dst = dst;
    this.imm = imm;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.setl;
  }
}

Opcode setl(Register dst, short imm) {
  return new Setl(dst, imm);
}

class Seth : Opcode {
  Register dst;
  short imm;

  this(Register dst, short imm) {
    this.dst = dst;
    this.imm = imm;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.seth;
  }
}

Opcode seth(Register dst, short imm) {
  return new Seth(dst, imm);
}

class Load : Opcode {
  Register dst;
  Register src;
  short imm;

  this(Register dst, Register src, short imm) {
    this.dst = dst;
    this.src = src;
    this.imm = imm;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.load;
  }
}

Opcode load(Register dst, Register src, short imm) {
  return new Load(dst, src, imm);
}

class Store : Opcode {
  Register dst;
  short imm;
  Register src;

  this(Register dst, short imm, Register src) {
    this.dst = dst;
    this.imm = imm;
    this.src = src;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.store;
  }
}

Opcode store(Register dst, short imm, Register src) {
  return new Store(dst, imm, src);
}

class Nop : Opcode {
  this() {
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.nop;
  }
}

Opcode nop() {
  return new Nop;
}

class Hlt : Opcode {
  this() {
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.hlt;
  }
}

Opcode hlt() {
  return new Hlt;
}

enum CC : ubyte {
  always = 0b000,
  zero = 0b001,
  positive = 0b010,
  negative = 0b011,
  carry = 0b100,
  overflow = 0b101
}

interface JumpFamily : Opcode {
  CC cc();
}

class JmpI : JumpFamily {
  short value;

  this(short value) {
    this.value = value;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.jmpi;
  }

  CC cc() {
    return CC.always;
  }
}

class JmpR : JumpFamily {
  Register src;

  this(Register src) {
    this.src = src;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.jmpr;
  }

  CC cc() {
    return CC.always;
  }
}

Opcode jmpi(short value) {
  return new JmpI(value);
}

Opcode jmpr(Register src) {
  return new JmpR(src);
}

class JzI : JumpFamily {
  short value;

  this(short value) {
    this.value = value;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.jzi;
  }

  CC cc() {
    return CC.zero;
  }
}

class JzR : JumpFamily {
  Register src;

  this(Register src) {
    this.src = src;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.jzr;
  }

  CC cc() {
    return CC.zero;
  }
}

Opcode jzi(short value) {
  return new JzI(value);
}

Opcode jzr(Register src) {
  return new JzR(src);
}

class JpI : JumpFamily {
  short value;

  this(short value) {
    this.value = value;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.jpi;
  }

  CC cc() {
    return CC.positive;
  }
}

class JpR : JumpFamily {
  Register src;

  this(Register src) {
    this.src = src;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.jpr;
  }

  CC cc() {
    return CC.positive;
  }
}

Opcode jpi(short value) {
  return new JpI(value);
}

Opcode jpr(Register src) {
  return new JpR(src);
}

class JnI : JumpFamily {
  short value;

  this(short value) {
    this.value = value;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.jni;
  }

  CC cc() {
    return CC.negative;
  }
}

class JnR : JumpFamily {
  Register src;

  this(Register src) {
    this.src = src;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.jnr;
  }

  CC cc() {
    return CC.negative;
  }
}

Opcode jni(short value) {
  return new JnI(value);
}

Opcode jnr(Register src) {
  return new JnR(src);
}

class JcI : JumpFamily {
  short value;

  this(short value) {
    this.value = value;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.jci;
  }

  CC cc() {
    return CC.carry;
  }
}

class JcR : JumpFamily {
  Register src;

  this(Register src) {
    this.src = src;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.jcr;
  }

  CC cc() {
    return CC.carry;
  }
}

Opcode jci(short value) {
  return new JcI(value);
}

Opcode jcr(Register src) {
  return new JcR(src);
}

class JoI : JumpFamily {
  short value;

  this(short value) {
    this.value = value;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.joi;
  }

  CC cc() {
    return CC.overflow;
  }
}

class JoR : JumpFamily {
  Register src;

  this(Register src) {
    this.src = src;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.jor;
  }

  CC cc() {
    return CC.overflow;
  }
}

Opcode joi(short value) {
  return new JoI(value);
}

Opcode jor(Register src) {
  return new JoR(src);
}

class JmpaI : JumpFamily {
  short value;

  this(short value) {
    this.value = value;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.jmpai;
  }

  CC cc() {
    return CC.always;
  }
}

class JmpaR : JumpFamily {
  Register src;

  this(Register src) {
    this.src = src;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.jmpar;
  }

  CC cc() {
    return CC.always;
  }
}

Opcode jmpai(short value) {
  return new JmpaI(value);
}

Opcode jmpar(Register src) {
  return new JmpaR(src);
}

class JazI : JumpFamily {
  short value;

  this(short value) {
    this.value = value;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.jazi;
  }

  CC cc() {
    return CC.zero;
  }
}

class JazR : JumpFamily {
  Register src;

  this(Register src) {
    this.src = src;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.jazr;
  }

  CC cc() {
    return CC.zero;
  }
}

Opcode jazi(short value) {
  return new JazI(value);
}

Opcode jazr(Register src) {
  return new JazR(src);
}

class JapI : JumpFamily {
  short value;

  this(short value) {
    this.value = value;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.japi;
  }

  CC cc() {
    return CC.positive;
  }
}

class JapR : JumpFamily {
  Register src;

  this(Register src) {
    this.src = src;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.japr;
  }

  CC cc() {
    return CC.positive;
  }
}

Opcode japi(short value) {
  return new JapI(value);
}

Opcode japr(Register src) {
  return new JapR(src);
}

class JanI : JumpFamily {
  short value;

  this(short value) {
    this.value = value;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.jani;
  }

  CC cc() {
    return CC.negative;
  }
}

class JanR : JumpFamily {
  Register src;

  this(Register src) {
    this.src = src;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.janr;
  }

  CC cc() {
    return CC.negative;
  }
}

Opcode jani(short value) {
  return new JanI(value);
}

Opcode janr(Register src) {
  return new JanR(src);
}

class JacI : JumpFamily {
  short value;

  this(short value) {
    this.value = value;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.jaci;
  }

  CC cc() {
    return CC.carry;
  }
}

class JacR : JumpFamily {
  Register src;

  this(Register src) {
    this.src = src;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.jacr;
  }

  CC cc() {
    return CC.carry;
  }
}

Opcode jaci(short value) {
  return new JacI(value);
}

Opcode jacr(Register src) {
  return new JacR(src);
}

class JaoI : JumpFamily {
  short value;

  this(short value) {
    this.value = value;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.jaoi;
  }

  CC cc() {
    return CC.overflow;
  }
}

class JaoR : JumpFamily {
  Register src;

  this(Register src) {
    this.src = src;
  }

  OpcodeSymbol sym() {
    return OpcodeSymbol.jaor;
  }

  CC cc() {
    return CC.overflow;
  }
}

Opcode jaoi(short value) {
  return new JaoI(value);
}

Opcode jaor(Register src) {
  return new JaoR(src);
}
