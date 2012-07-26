module system.cpu;

import system.endian;

final class Cpu {
private:
  Endian _endian;

public:
  this(Endian endian) {
    _endian = endian;
  }

  ulong fromBigEndian64(ulong  value) {
    if (_endian == Endian.Little) {
      return  (value >> 56) |
             ((value >> 40) & 0xFF00) |
             ((value >> 24) & 0xFF0000) |
             ((value >>  8) & 0xFF000000) |
             ((value <<  8) & 0xFF00000000UL) |
             ((value << 24) & 0xFF0000000000UL) |
             ((value << 40) & 0xFF000000000000UL) |
             ((value << 56) & 0xFF00000000000000UL);
    }
    else {
      return value;
    }
  }

  uint fromBigEndian32(uint   value) {
    if (_endian == Endian.Little) {
      return  (value >> 24)             | ((value >>  8) & 0xFF00) |
             ((value <<  8) & 0xFF0000) | ((value << 24) & 0xFF000000);
    }
    else {
      return value;
    }
  }

  ushort fromBigEndian16(ushort value) {
    if (_endian == Endian.Little) {
      return cast(ushort)((cast(uint)value >> 8) | (cast(uint)value << 8));
    }
    else {
      return value;
    }
  }

  ulong fromLittleEndian64(ulong  value) {
    if (_endian == Endian.Big) {
      return  (value >> 56) |
             ((value >> 40) & 0xFF00) |
             ((value >> 24) & 0xFF0000) |
             ((value >>  8) & 0xFF000000) |
             ((value <<  8) & 0xFF00000000UL) |
             ((value << 24) & 0xFF0000000000UL) |
             ((value << 40) & 0xFF000000000000UL) |
             ((value << 56) & 0xFF00000000000000UL);
    }
    else {
      return value;
    }
  }

  uint fromLittleEndian32(uint   value) {
    if (_endian == Endian.Big) {
      return  (value >> 24)             | ((value >>  8) & 0xFF00) |
             ((value <<  8) & 0xFF0000) | ((value << 24) & 0xFF000000);
    }
    else {
      return value;
    }
  }

  ushort fromLittleEndian16(ushort value) {
    if (_endian == Endian.Big) {
      return cast(ushort)((cast(uint)value >> 8) | (cast(uint)value << 8));
    }
    else {
      return value;
    }
  }

  // It seems like these are calling the wrong functions,
  // but this is because toBigEndian is synonymous with
  // fromBigEndian when native endianess is little.
  
  // Vice versa for the to little endian functions.
  ulong toBigEndian64(ulong value) {
    if (_endian == Endian.Little) {
      return fromBigEndian64(value);
    }
    else {
      return value;
    }
  }

  uint toBigEndian32(uint value) {
    if (_endian == Endian.Little) {
      return fromBigEndian32(value);
    }
    else {
      return value;
    }
  }

  ushort toBigEndian16(ushort value) {
    if (_endian == Endian.Little) {
      return fromBigEndian16(value);
    }
    else {
      return value;
    }
  }

  ulong toLittleEndian64(ulong value) {
    if (_endian == Endian.Big) {
      return fromLittleEndian64(value);
    }
    else {
      return value;
    }
  }

  uint toLittleEndian32(uint value) {
    if (_endian == Endian.Big) {
      return fromLittleEndian32(value);
    }
    else {
      return value;
    }
  }

  ushort toLittleEndian16(ushort value) {
    if (_endian == Endian.Big) {
      return fromLittleEndian16(value);
    }
    else {
      return value;
    }
  }
}
