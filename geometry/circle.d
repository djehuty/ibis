module geometry.circle;

import geometry.rectangle;
import geometry.point;
import geometry.line;

import math.sqrt;
import math.abs;

final class Circle {
public:
  this() {
    this(0, 0, 1);
  }

  this(double x, double y, double radius) {
    _x = x;
    _y = y;
    _radius = radius;
  }

  double x() {
    return _x;
  }

  double y() {
    return _y;
  }

  double radius() {
    return _radius;
  }

  bool intersects(Rectangle rectangle) {
    bool intersects = false;
    Line l;

    double halfWidth  = rectangle.width / 2.0;
    double halfHeight = rectangle.height / 2.0;

    Point points[4];
    points[0] = new Point(rectangle.x - halfWidth, rectangle.y - halfHeight);
    points[1] = new Point(rectangle.x - halfWidth, rectangle.y + halfHeight);
    points[2] = new Point(rectangle.x + halfWidth, rectangle.y + halfHeight);
    points[3] = new Point(rectangle.x + halfWidth, rectangle.y - halfHeight);

    l = new Line(points[0], points[1]);
    intersects |= this.intersects(l);

    l = new Line(points[1], points[2]);
    intersects |= this.intersects(l);

    l = new Line(points[2], points[3]);
    intersects |= this.intersects(l);

    l = new Line(points[3], points[0]);
    intersects |= this.intersects(l);

    return intersects;
  }

  bool intersects(Circle circle) {
    Line l = new Line(new Point(_x, _y), new Point(circle._x, circle._y));
    return l.magnitude < (_radius + circle._radius);
  }

  bool intersects(Line line) {
    double x1, y1, x2, y2;
    auto points = line.points;
    x1 = points[0].x - _x;
    x2 = points[1].x - _x;
    y1 = points[0].y - _y;
    y2 = points[1].y - _y;

    double dx, dy;
    dx = x2 - x1;
    dy = y2 - y1;

    double magnitude = line.magnitude;

    double determinant;
    determinant = x1 * y2 - x2 * y1;

    double discriminant;
    discriminant = _radius * _radius * magnitude * magnitude - determinant * determinant;

    double sign_of_dy = 1.0;
    if (dy < 0.0) {
      sign_of_dy = -1.0;
    }

    if (discriminant == 0) {
      // Tangent, 1 intersection point
      double x = determinant * dy - sign_of_dy * dx * sqrt(discriminant);
      x /= magnitude*magnitude;
      double y = -determinant * dx - abs(dy) * sqrt(discriminant);
      y /= magnitude * magnitude;

      Line clipped = new Line(new Point(x, y), new Point(x2, y2));

      double clippedMagnitude = clipped.magnitude();

      clipped = new Line(new Point(x2, y2), new Point(x1, y1));

      double clippedMagnitude2 = clipped.magnitude();

      if (clippedMagnitude2 > clippedMagnitude) {
        clippedMagnitude = clippedMagnitude2;
      }

      if (clippedMagnitude < magnitude) {
        // We actually clipped something
        return true;
      }
    }
    else if (discriminant > 0) {
      // Secant, 2 intersection points
      double x = determinant * dy - sign_of_dy * dx * sqrt(discriminant);
      x /= magnitude*magnitude;
      double y = -determinant * dx - abs(dy) * sqrt(discriminant);
      y /= magnitude * magnitude;

      Line clipped = new Line(new Point(x, y), new Point(x2, y2));

      double clippedMagnitude = clipped.magnitude;

      if (clippedMagnitude < magnitude) {
        // We actually clipped something!
        return true;
      }

      clipped = new Line(new Point(x1, y1), new Point(x2, y2));

      x  = determinant * dy + sign_of_dy * dx * sqrt(discriminant);
      x /= magnitude*magnitude;
      y  = -determinant * dx + abs(dy) * sqrt(discriminant);
      y /= magnitude*magnitude;

      clipped = new Line(new Point(x1, y1), new Point(x, y));

      clippedMagnitude = clipped.magnitude;
      if (clippedMagnitude < magnitude) {
        // We actually clipped something
        return true;
      }
    }
    else {
      // No intersection
    }

    return false;
  }

  bool intersects(Point point) {
    double dx = point.x - _x;
    double dy = point.y - _y;

    double distance = sqrt(dx * dx + dy * dy);

    return distance == radius;
  }

  bool contains(Rectangle b) {
    return false;
  }

  bool contains(Circle b) {
    return false;
  }

  bool contains(Line b) {
    return false;
  }

  bool contains(Point b) {
    return false;
  }

  int clip(Line b, Point[2] points) {
    return 0;
  }

  int clip(Rectangle b, Point[4] points) {
    return 0;
  }

  int clip(Circle b, Point[4] points) {
    return 0;
  }

private:

  double _x;
  double _y;
  double _radius;
}
