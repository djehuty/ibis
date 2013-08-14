#[link(name = "rectangle", vers = "1.0")];

use geometry::point::*;
use geometry::line::*;

mod geometry {
  extern mod point;
  extern mod line;
}

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
