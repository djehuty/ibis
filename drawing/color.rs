#[feature(struct_variant)];
#[crate_id="drawing-color#1.0"];

pub mod drawing {
  pub mod color {
    use std::iter;

    pub enum Color {
      ColorRGBA { alpha: f64, red:f64, green:f64,      blue:f64 },
      ColorHSLA { alpha: f64, hue:f64, saturation:f64, luminance:f64 }
    }

    pub fn foo() -> Color {
      ColorHSLA { alpha: 1.0, hue: 1.0, saturation: 1.0, luminance: 1.0 }
    }

    impl Color {
      pub fn hsla(hue: f64, saturation: f64, luminance: f64, alpha: f64) -> Color {
        ColorHSLA { hue: hue, saturation: saturation,
                    luminance: luminance, alpha: alpha }
      }

      pub fn rgba(red: f64, green: f64, blue: f64, alpha: f64) -> Color {
        ColorRGBA { red: red, green: green, blue: blue, alpha: alpha }
      }

      pub fn hsla_to_rgba(h: f64, s: f64, l: f64, alpha: f64) -> Color {
        let q =
          if (l < 0.5) {
            l * (1.0 + s)
          }
          else {
            l + s - (l * s)
          };

        let p = (2.0 * l) - q;

        let mut ctmp = [h + (1.0/3.0), h, h - (1.0/3.0)];

        for i in iter::range_step(0, 3, 1) {
          if (ctmp[i] < 0.0) {
            ctmp[i] += 1.0;
          }
          else if (ctmp[i] > 1.0) {
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

        let red   = if (s == 0.0) { l } else { ctmp[0] };
        let green = if (s == 0.0) { l } else { ctmp[1] };
        let blue  = if (s == 0.0) { l } else { ctmp[2] };

        ColorRGBA { alpha: alpha,
                    red: red,
                    green: green,
                    blue: blue }
      }

      pub fn rgba_to_hsla(r: f64, g: f64, b: f64, alpha: f64) -> Color {
        let min;
        let max;
        let maxColor;

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

        let luminance = (max + min) * 0.5;

        let saturation =
          if (max == min) {
            0.0
          }
          else if (luminance < 0.5) {
            (max - min) / (max + min)
          }
          else {
            (max - min) / (2.0 - max - min)
          };

        let hue =
          if (max == min) {
            0.0
          }
          else if (maxColor == 0) {
            (g - b) / (max - min)
          }
          else if (maxColor == 1){
            2.0 + (b - r) / (max - min)
          }
          else {
            4.0 + (r - g) / (max - min)
          } / 6.0;

        ColorHSLA { alpha: alpha,
                    hue: hue,
                    saturation: saturation,
                    luminance: luminance }
      }

      pub fn to_hsla(&self) -> Color {
        match *self {
          ColorRGBA {alpha: a, red: r, green: g, blue: b}
            => Color::rgba_to_hsla(r, g, b, a),
          ColorHSLA { .. } => *self
        }
      }

      pub fn to_rgba(&self) -> Color {
        match *self {
          ColorRGBA { .. } => *self,
          ColorHSLA {alpha: a, hue: h, saturation: s, luminance: l}
            => Color::hsla_to_rgba(h, s, l, a)
        }
      }

      pub fn red(&self) -> f64 {
        match *self {
          ColorHSLA {alpha: a, hue: h, saturation: s, luminance: l}
            => Color::hsla_to_rgba(h, s, l, a).red(),
          ColorRGBA {red: r, .. } => r
        }
      }

      pub fn green(&self) -> f64 {
        match *self {
          ColorHSLA {alpha: a, hue: h, saturation: s, luminance: l}
            => Color::hsla_to_rgba(h, s, l, a).green(),
          ColorRGBA {green: g, .. } => g
        }
      }

      pub fn blue(&self) -> f64 {
        match *self {
          ColorHSLA {alpha: a, hue: h, saturation: s, luminance: l}
            => Color::hsla_to_rgba(h, s, l, a).blue(),
          ColorRGBA {blue: b, .. } => b
        }
      }

      pub fn hue(&self) -> f64 {
        match *self {
          ColorRGBA {alpha: a, red: r, green: g, blue: b}
            => Color::rgba_to_hsla(r, g, b, a).hue(),
          ColorHSLA {hue: h, .. } => h
        }
      }

      pub fn saturation(&self) -> f64 {
        match *self {
          ColorRGBA {alpha: a, red: r, green: g, blue: b}
            => Color::rgba_to_hsla(r, g, b, a).saturation(),
          ColorHSLA {saturation: s, .. } => s
        }
      }

      pub fn luminance(&self) -> f64 {
        match *self {
          ColorRGBA {alpha: a, red: r, green: g, blue: b}
            => Color::rgba_to_hsla(r, g, b, a).luminance(),
          ColorHSLA {luminance: l, .. } => l
        }
      }

      pub fn alpha(&self) -> f64 {
        match *self {
          ColorRGBA {alpha: a, .. } => a,
          ColorHSLA {alpha: a, .. } => a
        }
      }

      pub fn r8g8b8a8(&self) -> u32 {
        match *self {
          ColorRGBA { red: r, green: g, blue: b, alpha: a } =>
            (r * 0xff as f64) as u32 | ((g * 0xff as f64) as u32 << 8) | ((b * 0xff as f64) as u32 << 16) | ((a * 0xff as f64) as u32 << 24),
          ColorHSLA { .. } =>
            self.to_rgba().r8g8b8a8(),
        }
      }

      pub fn b8g8r8a8(&self) -> u32 {
        match *self {
          ColorRGBA { red: r, green: g, blue: b, alpha: a } =>
            (b * 0xff as f64) as u32 | ((g * 0xff as f64) as u32 << 8) | ((r * 0xff as f64) as u32 << 16) | ((a * 0xff as f64) as u32 << 24),
          ColorHSLA { .. } =>
            self.to_rgba().b8g8r8a8(),
        }
      }

      pub fn h8s8l8a8(&self) -> u32 {
        match *self {
          ColorRGBA { .. } =>
            self.to_hsla().h8s8l8a8(),
          ColorHSLA { hue: h, saturation: s, luminance: l, alpha: a } =>
            (h * 0xff as f64) as u32 | ((s * 0xff as f64) as u32 << 8) | ((l * 0xff as f64) as u32 << 16) | ((a * 0xff as f64) as u32 << 24),
        }
      }

      pub fn r8g8b8(&self) -> u32 {
        match *self {
          ColorRGBA { red: r, green: g, blue: b, .. } =>
            (r * 0xff as f64) as u32 | ((g * 0xff as f64) as u32 << 8) | ((b * 0xff as f64) as u32 << 16),
          ColorHSLA { .. } =>
            self.to_rgba().r8g8b8(),
        }
      }

      pub fn b8g8r8(&self) -> u32 {
        match *self {
          ColorRGBA { red: r, green: g, blue: b, .. } =>
            (b * 0xff as f64) as u32 | ((g * 0xff as f64) as u32 << 8) | ((r * 0xff as f64) as u32 << 16),
          ColorHSLA { .. } =>
            self.to_rgba().b8g8r8(),
        }
      }

      pub fn h8s8l8(&self) -> u32 {
        match *self {
          ColorRGBA { .. } =>
            self.to_hsla().h8s8l8a8(),
          ColorHSLA { hue: h, saturation: s, luminance: l, .. } =>
            (h * 0xff as f64) as u32 | ((s * 0xff as f64) as u32 << 8) | ((l * 0xff as f64) as u32 << 16),
        }
      }
    }
  }
}
