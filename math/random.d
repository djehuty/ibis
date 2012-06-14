module math.random;

// For now, we make this platform dependent!
// (Until we teach djehuty how to read time)

version(Windows) {
  pragma(lib, "winmm.lib");
  
  extern(C) uint timeGetTime();

  uint _getSeed() {
    return timeGetTime();
  }
}
else version(linux) {
  version(GNU) {
    import gcc.builtins;
    alias __builtin_Clong Clong_t;
    alias __builtin_Culong Culong_t;
  }
  else version(X86_64) {
    alias long Clong_t;
    alias ulong Culong_t;
  }
  else {
    alias int Clong_t;
    alias uint Culong_t;
  }

  extern(C) struct timeval {
    Clong_t tv_sec;
    Clong_t tv_usec;
  }

  extern(C) int gettimeofday(timeval*, void*);

  uint _getSeed() {
    timeval val;
    gettimeofday(&val, null);
    return (val.tv_sec * 1000000) + val.tv_usec;
  }
}
else {
  static assert(false, "I do not know how to compile the Random class.");
}

final class Random {
private:
  static const auto MODULUS = 2147483647;
  static const auto MULTIPLIER = 48271;
  static const auto CHECK = 399268537;
  static const auto A256 = 22925;
  static const auto DEFAULT = 123456789;

  uint _state = DEFAULT;

  void _mutateState() {
    const uint Q = MODULUS / MULTIPLIER;
    const uint R = MODULUS % MULTIPLIER;
    uint t;

    t = MULTIPLIER * (_state % Q) - R * (_state / Q);
    if (t > 0) {
      _state = t;
    }
    else {
      _state = t + MODULUS;
    }
  }

public:
  this() {
    _state = _getSeed();
  }

  this(uint seed) {
    _state = seed;
  }

  // Properties //

  uint seed() {
    return _state;
  }

  // Methods //

  uint next() {
    _mutateState();
    return _state;
  }

  uint next(uint max) {
    if (max == 0) {
      return 0;
    }

    return next() % max;
  }

  int next(int min, int max) {
    if (min >= max) {
      return min;
    }

    int ret = next(max - min);
    return ret + min;
  }

  ulong nextLong() {
    ulong high = next();
    high <<= 32;

    return high + next();
  }

  ulong nextLong(ulong max) {
    if (max == 0) {
      return 0;
    }

    return nextLong() % max;
  }

  long nextLong(long min, long max) {
    if (min >= max) {
      return min;
    }

    long ret = nextLong(max - min);
    return ret + min;
  }

  bool nextBoolean() {
    return (next() % 2) == 0;
  }

  float nextFloat() {
    float numerator   = cast(float)(next() >> (32-24));
    float denominator = cast(float)(1 << 24);

    return numerator / denominator;
  }

  double nextDouble() {
    long accumulator = cast(long)(next() >> (32-26)) << 27;
    accumulator += cast(long)(next() >> (32-27));

    double numerator   = cast(double)accumulator;
    double denominator = cast(double)(1L << 53);

    return numerator / denominator;
  }
}
