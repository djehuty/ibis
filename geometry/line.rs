#[crate_id="geometry-line#1.0"];
#[feature(globs)];

extern mod geometry_point = "geometry-point";

pub mod geometry {
  pub mod line {
    use geometry_point::geometry::point::*;

    pub struct Line {
      start: Point,
      end:   Point
    }

    impl Line {
      pub fn magnitude(&self) -> f32 {
        let x = self.start.x - self.end.x;
        let y = self.start.y - self.end.y;

        let ret = x * x + y * y;

        ret.sqrt()
      }

      pub fn intercepts(&self, point: Point) -> bool {
        let x1 = if (self.start.x < self.end.x) { self.start.x } else { self.end.x };
        let x2 = if (self.start.x > self.end.x) { self.start.x } else { self.end.x };
        let y1 = if (self.start.y < self.end.y) { self.start.y } else { self.end.y };
        let y2 = if (self.start.y > self.end.y) { self.start.y } else { self.end.y };

        if (x1 == x2) {
          (point.x == x1) && (point.y <= y2 && point.y >= y1)
        }
        else {
          ((point.x - x1) / (x2 - x1) == (point.y - y1) / (y2 - y1)) &&
          (point.x <= x2 && point.x >= x1)
        }
      }
    }
  }
}
