/*
 * sqrt.d
 *
 * This module implements the square root function.
 *
 */

module math.sqrt;

double sqrt(double x) {
  if (x == 0.0) {
    return 0.0;
  }

  double y, z, temp;

  temp = x;
  uint* ptr = (cast(uint*)&temp) + 1;

  // Use an estimate for 1 / sqrt(x)
  *ptr = (0xbfcdd90a - *ptr) >> 1;

  y = temp;

  // Newton Approximation
  z = x * 0.5; // 1/2

  // 5 iterations are enough for 64 bits
  y = (1.5 * y) - (y*y) * (y*z);
  y = (1.5 * y) - (y*y) * (y*z);
  y = (1.5 * y) - (y*y) * (y*z);
  y = (1.5 * y) - (y*y) * (y*z);
  y = (1.5 * y) - (y*y) * (y*z);

  // Return the result
  return x * y;
}
