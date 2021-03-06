#[crate_id="geometry-rectangle#1.0"];
#[feature(globs)];

extern mod geometry_point = "geometry-point";
extern mod geometry_line  = "geometry-line";

pub mod geometry {
  pub mod rectangle {
    use geometry_point::geometry::point::*;
    use geometry_line::geometry::line::*;

    pub struct Rectangle {
      top_left: Point,
      bottom_right: Point
    }

    impl Rectangle {
      pub fn left_edge(&self) -> Line {
        Line { start: self.top_left,
                       end: Point { x: self.top_left.x,
                                           y: self.bottom_right.y } }
      }

      pub fn right_edge(&self) -> Line {
        Line { start: Point { x: self.bottom_right.x,
                                           y: self.top_left.y },
                       end: self.bottom_right }
      }

      pub fn bottom_edge(&self) -> Line {
        Line { start: Point { x: self.top_left.x,
                                           y: self.bottom_right.y },
                       end: self.bottom_right }
      }

      pub fn top_edge(&self) -> Line {
        Line { start: self.top_left,
                       end: Point { x: self.bottom_right.x,
                                           y: self.top_left.y } }
      }
    }
  }
}
