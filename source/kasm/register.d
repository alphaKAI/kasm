module kasm.register;

enum Register {
  r0 = "r0",
  r1 = "r1",
  r2 = "r2",
  r3 = "r3",
  r4 = "r4",
  r5 = "r5",
  r6 = "r6",
  r7 = "r7",
  r8 = "r8",
  r9 = "r9",
  r10 = "r10",
  r11 = "r11",
  r12 = "r12",
  r13 = "r13",
  r14 = "r14",
  r15 = "r15",
}

ubyte reg_to_byte(Register reg) {
  final switch (reg) with (Register) {
  case r0:
    return 0;
  case r1:
    return 1;
  case r2:
    return 2;
  case r3:
    return 3;
  case r4:
    return 4;
  case r5:
    return 5;
  case r6:
    return 6;
  case r7:
    return 7;
  case r8:
    return 8;
  case r9:
    return 9;
  case r10:
    return 10;
  case r11:
    return 11;
  case r12:
    return 12;
  case r13:
    return 13;
  case r14:
    return 14;
  case r15:
    return 15;
  }
}
