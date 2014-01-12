#[crate_id="geometry-circle#1.0"];
#[feature(globs)];

extern mod geometry_point     = "geometry-point";
extern mod geometry_line      = "geometry-line";
extern mod geometry_rectangle = "geometry-rectangle";

pub mod geometry {
  pub mod circle {
    use geometry_point::geometry::point::*;
    use geometry_line::geometry::line::*;
    use geometry_rectangle::geometry::rectangle::*;

    pub struct Circle {
      center: Point,
      radius: f32
    }

    impl Circle {
      pub fn intersects_rectangle(&self, rectangle: Rectangle) -> bool {
        self.intersects_line(rectangle.left_edge())   |
        self.intersects_line(rectangle.right_edge())  |
        self.intersects_line(rectangle.bottom_edge()) |
        self.intersects_line(rectangle.top_edge())
      }

      pub fn intersects_circle(&self, circle: Circle) -> bool {
        let l = Line { start: self.center, end: circle.center };

        l.magnitude() < (self.radius + circle.radius)
      }

      pub fn intersects_line(&self, line: Line) -> bool {
        let p1 = Point { x: line.start.x - self.center.x,
                                          y: line.start.y - self.center.y };
        let p2 = Point { x: line.end.x   - self.center.x,
                                          y: line.end.y   - self.center.y };

        let delta = Point { x: p2.x - p1.x,
                                             y: p2.y - p1.y };

        let magnitude = line.magnitude();

        let determinant = p1.x * p2.y - p2.x * p1.y;

        let discriminant = self.radius * self.radius
                         * magnitude   * magnitude
                         - determinant * determinant;

        let sign_of_dy =
          if (delta.y < 0.0) { -1.0 }
          else               {  1.0 };

        if (discriminant == 0.0) {
          // Tangent, 1 intersection point
          let x = determinant * delta.y
                - sign_of_dy * delta.x
                * discriminant.sqrt()
                / magnitude * magnitude;

          let y = -determinant * delta.x
                - delta.y.abs()
                * discriminant.sqrt()
                / magnitude * magnitude;

          let clipped = Line {
            start: Point { x: x, y: y },
            end: p2
          };

          let clipped_2 = Line { start: p2, end: p1 };

          let clipped_magnitude =
            if (clipped.magnitude() > clipped_2.magnitude()) {
              clipped.magnitude()
            }
            else {
              clipped_2.magnitude()
            };

          if (clipped_magnitude < magnitude) {
            // We actually clipped something
            return true;
          }
        }
        else if (discriminant > 0.0) {
          // Secant, 2 intersection points
          let x = determinant * delta.y
                - sign_of_dy * delta.x
                * discriminant.sqrt()
                / magnitude * magnitude;

          let y = -determinant * delta.x
                - delta.y.abs()
                * discriminant.sqrt()
                / magnitude * magnitude;

          let clipped = Line {
            start: Point { x: x, y: y },
            end: p2
          };

          if (clipped.magnitude() < magnitude) {
            // We actually clipped something!
            return true;
          }

          let x = determinant * delta.y
                + sign_of_dy * delta.x
                * discriminant.sqrt()
                / magnitude * magnitude;

          let y = -determinant * delta.x
                + delta.y.abs()
                * discriminant.sqrt()
                / magnitude * magnitude;

          let clipped_2 = Line {
            start: p1,
            end: Point { x: x, y: y }
          };

          if (clipped_2.magnitude() < magnitude) {
            // We actually clipped something
            return true;
          }
        }
        else {
          // No intersection
        }

        false
      }

      pub fn intersects_point(&self, point: Point) -> bool {
        let line = Line { start: self.center, end: point };
        line.magnitude() == self.radius
      }
    }
  }
}
