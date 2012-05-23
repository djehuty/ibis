module geometry.line;

import geometry.rectangle;
import geometry.circle;
import geometry.point;

import math.sqrt;

final class Line {
public:
  this(Point a, Point b) {
    _points = [a, b];
  }

  this(Point[2] points) {
    _points = points.dup;
  }

  this() {
    this(new Point(0, 0), new Point(0, 0));
  }

  Point start() {
    return _points[0];
  }

  Point end() {
    return _points[1];
  }

  Point[] points() {
    return _points.dup;
  }

  double magnitude() {
    double magnitudeX = _points[1].x - _points[0].x;
    double magnitudeY = _points[1].y - _points[0].y;

    double magnitude = magnitudeX * magnitudeX + magnitudeY * magnitudeY;
    magnitude = sqrt(magnitude);

    return magnitude;
  }

  bool intercepts(Point b) {
    return false;
  }

private:
  Point[] _points;
}
