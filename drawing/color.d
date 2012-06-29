module drawing.color;

final class Color {
private:
  double _a;

  double _r;
  double _g;
  double _b;
  bool   _rgbValid;

  double _h;
  double _s;
  double _l;
  bool   _hslValid;

  void _calculateFromRGB() {
    // find min and max values

    double min, max;
    double r,g,b;
    r = _r;
    g = _g;
    b = _b;

    uint maxColor;

    if (r <= g && r <= b) {
      min = r;
      if (g < b) {
        max = b;
        maxColor = 2;
      }
      else {
        max = g;
        maxColor = 1;
      }
    }
    else if (g <= b && g <= r) {
      min = g;
      if (r < b) {
        max = b;
        maxColor = 2;
      }
      else {
        max = r;
        maxColor = 0;
      }
    }
    else {
      min = b;
      if (r < g) {
        max = g;
        maxColor = 1;
      }
      else {
        max = r;
        maxColor = 0;
      }
    }

    // find luminance
    _l = (max + min) * 0.5;

    if (max == min) {
      _s = 0;
      _h = 0;
      _hslValid = true;
      return;
    }

    // find the saturation
    if (_l < 0.5) {
      _s = (max - min) / (max + min);
    }
    else {
      _s = (max - min) / (2.0 - max - min);
    }

    // find hue
    if (maxColor == 0) {
      _h = (g - b) / (max - min);
    }
    else if (maxColor == 1){
      _h = 2.0 + (b - r) / (max - min);
    }
    else {
      _h = 4.0 + (r - g) / (max - min);
    }
    _h /= 6.0;
    _hslValid = true;
  }

  void _calculateFromHSL() {
    if (_s == 0) {
      _r = _l;
      _g = _l;
      _b = _l;
      return;
    }

    double p;
    double q;
    if (_l < 0.5) {
      q = _l * (1.0 + _s);
    }
    else {
      q = _l + _s - (_l * _s);
    }

    p = (2.0 * _l) - q;

    double[3] ctmp;

    ctmp[0] = _h + (1.0/3.0);
    ctmp[1] = _h;
    ctmp[2] = _h - (1.0/3.0);

    for(size_t i = 0; i < 3; i++) {
      if (ctmp[i] < 0) {
        ctmp[i] += 1.0;
      }
      else if (ctmp[i] > 1) {
        ctmp[i] -= 1.0;
      }

      if (ctmp[i] < (1.0 / 6.0)) {
        ctmp[i] = p + ((q - p) * 6.0 * ctmp[i]);
      }
      else if (ctmp[i] < 0.5) {
        ctmp[i] = q;
      }
      else if (ctmp[i] < (2.0 / 3.0)) {
        ctmp[i] = p + (q - p) * ((2.0 / 3.0) - ctmp[i]) * 6.0;
      }
      else {
        ctmp[i] = p;
      }
    }

    _r = ctmp[0];
    _g = ctmp[1];
    _b = ctmp[2];
    _rgbValid = true;
  }

public:
  enum Style {
    RGBA,
    HSLA
  }

  this(double red, double green, double blue, double alpha) {
    _r = red;
    _g = green;
    _b = blue;
    _a = alpha;

    _rgbValid = true;
    _hslValid = false;
  }

  this(Color.Style, double a, double b, double c, double d) {
  }

  static Color Red() {
    return new Color(0.8, 0.3, 0.3, 1.0);
  }

  static Color Green() {
    return new Color(0.3, 0.8, 0.3, 1.0);
  }

  static Color Blue() {
    return new Color(0.3, 0.3, 0.8, 1.0);
  }

  static Color Yellow() {
    return new Color(0.8, 0.8, 0.3, 1.0);
  }

  static Color Magenta() {
    return new Color(0.8, 0.3, 0.8, 1.0);
  }

  static Color Cyan() {
    return new Color(0.3, 0.8, 0.3, 1.0);
  }

  static Color Gray() {
    return new Color(0.8, 0.8, 0.8, 1.0);
  }

  static Color White() {
    return new Color(1.0, 1.0, 1.0, 1.0);
  }

  static Color DarkRed() {
    return new Color(0.5, 0.0, 0.0, 1.0);
  }

  static Color DarkGreen() {
    return new Color(0.0, 0.5, 0.0, 1.0);
  }

  static Color DarkBlue() {
    return new Color(0.0, 0.0, 0.5, 1.0);
  }

  static Color DarkYellow() {
    return new Color(0.5, 0.5, 0.0, 1.0);
  }

  static Color DarkMagenta() {
    return new Color(0.5, 0.0, 0.5, 1.0);
  }

  static Color DarkCyan() {
    return new Color(0.0, 0.5, 0.5, 1.0);
  }

  static Color DarkGray() {
    return new Color(0.3, 0.3, 0.3, 1.0);
  }

  static Color DarkestGray() {
    return new Color(0.1, 0.1, 0.1, 1.0);
  }

  static Color LightestGray() {
    return new Color(0.9, 0.9, 0.9, 1.0);
  }

  static Color LightRed() {
    return new Color(1.0, 0.0, 0.0, 1.0);
  }

  static Color LightGreen() {
    return new Color(0.0, 1.0, 0.0, 1.0);
  }

  static Color LightBlue() {
    return new Color(0.0, 0.0, 1.0, 1.0);
  }

  static Color LightYellow() {
    return new Color(1.0, 1.0, 0.0, 1.0);
  }

  static Color LightMagenta() {
    return new Color(1.0, 0.0, 1.0, 1.0);
  }

  static Color LightCyan() {
    return new Color(0.0, 1.0, 1.0, 1.0);
  }

  static Color LightGray() {
    return new Color(0.7, 0.7, 0.7, 1.0);
  }

  static Color Black() {
    return new Color(0.0, 0.0, 0.0, 1.0);
  }

  // Properties //

  double red() {
    if (!_rgbValid) {
      _calculateFromHSL();
    }
    return _r;
  }

  double green() {
    if (!_rgbValid) {
      _calculateFromHSL();
    }
    return _g;
  }

  double blue() {
    if (!_rgbValid) {
      _calculateFromHSL();
    }
    return _b;
  }

  double hue() {
    if (!_hslValid) {
      _calculateFromRGB();
    }
    return _h;
  }

  double saturation() {
    if (!_hslValid) {
      _calculateFromRGB();
    }
    return _s;
  }

  double luminance() {
    if (!_hslValid) {
      _calculateFromRGB();
    }
    return _l;
  }
}
