module geometry.rectangle;

import geometry.circle;
import geometry.point;
import geometry.line;

final class Rectangle {
public:
  this() {
    this(0, 0, 1, 1);
  }

  this(double x, double y, double width, double height) {
    _x = x;
    _y = y;
    _width = width;
    _height = height;
  }

  double x() {
    return _x;
  }

  double y() {
    return _y;
  }

  double width() {
    return _width;
  }

  double height() {
    return _height;
  }

  bool intersects(Rectangle b) {
    bool doesNotIntersect = false;
    doesNotIntersect |= b._x > (_x + _width);
    doesNotIntersect |= x    > (b._x + b._width);
    doesNotIntersect |= b._y > (_y + _height);
    doesNotIntersect |= y    > (b._y + b._height);
    return !doesNotIntersect;
  }

  bool intersects(Circle b) {
    return false;
  }

  bool intersects(Line b) {
    return false;
  }

  bool contains(Point point) {
    double halfWidth  = _width  / 2.0;
    double halfHeight = _height / 2.0;

    bool containsPoint = true;
    containsPoint &= point.x >= x - halfWidth;
    containsPoint &= point.y >= y - halfHeight;
    containsPoint &= point.x <  x + halfWidth;
    containsPoint &= point.y <  y + halfHeight;
    return containsPoint;
  }

private:
  double _x;
  double _y;
  double _width;
  double _height;
}
