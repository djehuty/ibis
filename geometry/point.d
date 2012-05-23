module geometry.point;

import geometry.rectangle;
import geometry.point;
import geometry.line;

final class Point {
public:
  this() {
    this(0, 0);
  }

  this(double x, double y) {
    _x = x;
    _y = y;
  }

  double x() {
    return _x;
  }

  double y() {
    return _y;
  }

private:
  double _x;
  double _y;
}
