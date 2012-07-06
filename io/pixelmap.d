module io.pixelmap;

import io.stream;
import io.buffer;

import drawing.color;

import binding.c;

final class Pixelmap {
public:
  enum Type {
    B8G8R8,
    B8G8R8A8,

    R8G8B8,
    R8G8B8A8,

    R16G16B16,
    R16G16B16A16,

    B16G16R16,
    B16G16R16A16,
  }

private:
  Type _type;
  Buffer _buffer;

  ulong _x;
  ulong _y;

  ulong _width;
  ulong _height;

  void _advance() {
    _x++;
    
    if (_x >= _width) {
      _x = 0;
     
      if (_y < _height) {
        _y++;
      }
    }
  }

public:

  this(ulong width, ulong height, Type type) {
    _type = type;
    _buffer = new Buffer(width * height * bytesPerPixel(), 0);

    _x = 0;
    _y = 0;

    _width  = width;
    _height = height;
  }

  // Properties //

  Type type() {
    return _type;
  }

  Stream input() {
    return _buffer.input;
  }

  Stream output() {
    return _buffer.output;
  }
  
  Stream stream() {
    return _buffer.stream;
  }

  ulong width() {
    return _width;
  }

  ulong height() {
    return _height;
  }

  ulong x() {
    return _x;
  }

  ulong y() {
    return _y;
  }

  ulong bitsPerPixel() {
    switch (_type) {
      case Type.R8G8B8A8:
      case Type.B8G8R8A8:
        return 32;

      case Type.R8G8B8:
      case Type.B8G8R8:
        return 24;

      case Type.R16G16B16:
      case Type.B16G16R16:
        return 48;

      case Type.R16G16B16A16:
      case Type.B16G16R16A16:
        return 64;

      default:
        break;
    }

    return 0;
  }

  ulong bytesPerPixel() {
    return bitsPerPixel / 8;
  }

  void writeRGBA(double red, double green, double blue, double alpha) {
    write(new Color(Color.Space.RGBA, red, green, blue, alpha));
  }
  
  void writeHSLA(double hue, double saturation, double luminance, double alpha) {
    write(new Color(Color.Space.HSLA, hue, saturation, luminance, alpha));
  }

  void writeRGBA(uint color) {
    switch (_type) {
      case Type.R8G8B8A8:
        ubyte[] clr = (cast(ubyte*)&color)[0..4];
        _buffer.write(clr);
        _advance();
        break;

      case Type.R8G8B8:
        ubyte[] clr = (cast(ubyte*)&color)[0..3];
        _buffer.write(clr);
        _advance();
        break;

      default:
        double red   = cast(double)((color >>  0) & 0xff) / cast(double)0xff;
        double green = cast(double)((color >>  8) & 0xff) / cast(double)0xff;
        double blue  = cast(double)((color >> 16) & 0xff) / cast(double)0xff;
        double alpha = cast(double)((color >> 24) & 0xff) / cast(double)0xff;

        writeRGBA(red, green, blue, alpha);
    }
  }

  void writeBGRA(uint color) {
    switch (_type) {
      case Type.B8G8R8A8:
        ubyte[] clr = (cast(ubyte*)&color)[0..4];
        _buffer.write(clr);
        _advance();
        break;

      case Type.B8G8R8:
        ubyte[] clr = (cast(ubyte*)&color)[0..3];
        _buffer.write(clr);
        _advance();
        break;

      default:
        double red   = cast(double)((color >>  0) & 0xff) / cast(double)0xff;
        double green = cast(double)((color >>  8) & 0xff) / cast(double)0xff;
        double blue  = cast(double)((color >> 16) & 0xff) / cast(double)0xff;
        double alpha = cast(double)((color >> 24) & 0xff) / cast(double)0xff;

        writeRGBA(red, green, blue, alpha);
    }
  }

  void write(Color color) {
    switch (_type) {
      default:
      case Type.R8G8B8A8:
        ubyte r, g, b, a;
        r = cast(ubyte)(color.red   * 0xff);
        g = cast(ubyte)(color.green * 0xff);
        b = cast(ubyte)(color.blue  * 0xff);
        a = cast(ubyte)(color.alpha * 0xff);

        _buffer.write([r, g, b, a]);
        _advance();
        break;

      case Type.R8G8B8:
        ubyte r, g, b;
        r = cast(ubyte)(color.red   * 0xff);
        g = cast(ubyte)(color.green * 0xff);
        b = cast(ubyte)(color.blue  * 0xff);

        _buffer.write([r, g, b]);
        _advance();
        break;

      case Type.B8G8R8A8:
        ubyte r, g, b, a;
        r = cast(ubyte)(color.red   * 0xff);
        g = cast(ubyte)(color.green * 0xff);
        b = cast(ubyte)(color.blue  * 0xff);
        a = cast(ubyte)(color.alpha * 0xff);

        _buffer.write([b, g, r, a]);
        _advance();
        break;

      case Type.B8G8R8:
        ubyte r, g, b;
        r = cast(ubyte)(color.red   * 0xff);
        g = cast(ubyte)(color.green * 0xff);
        b = cast(ubyte)(color.blue  * 0xff);

        _buffer.write([b, g, r]);
        _advance();
        break;

      case Type.R16G16B16A16:
        ushort r, g, b, a;
        r = cast(ushort)(color.red   * 0xffff);
        g = cast(ushort)(color.green * 0xffff);
        b = cast(ushort)(color.blue  * 0xffff);
        a = cast(ushort)(color.alpha * 0xffff);

        _buffer.write(cast(ubyte[])[r, g, b, a]);
        _advance();
        break;

      case Type.R16G16B16:
        ushort r, g, b;
        r = cast(ushort)(color.red   * 0xffff);
        g = cast(ushort)(color.green * 0xffff);
        b = cast(ushort)(color.blue  * 0xffff);

        _buffer.write(cast(ubyte[])[r, g, b]);
        _advance();
        break;
    }
  }

  Color read(long x, long y) {
    return read((_width * y) + x);
  }

  Color read(long index) {
    _buffer.seek(-_buffer.position);
    _buffer.seek(index * bytesPerPixel());

    auto bytes = _buffer.read(4);

    uint red   = bytes[0];
    uint green = bytes[1];
    uint blue  = bytes[2];
    uint alpha = bytes[3];

    double redf   = cast(double)red   / cast(double)0xff;
    double greenf = cast(double)green / cast(double)0xff;
    double bluef  = cast(double)blue  / cast(double)0xff;
    double alphaf = cast(double)alpha / cast(double)0xff;

    return new Color(redf, greenf, bluef, alphaf);
  }

  void seek(long x, long y) {
    reposition(_x + x, _y + y);
  }

  void reposition(ulong x, ulong y) {
    if (x >= _width) {
      x = _width - 1;
    }

    if (y >= _height) {
      y = _height - 1;
    }

    _x = x;
    _y = y;

    long position = ((_y * _width) + _x) * bytesPerPixel();
    _buffer.seek(-_buffer.position);
    _buffer.seek(position);
  }
}
