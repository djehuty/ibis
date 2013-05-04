pub struct Stream {
  readInto:  ~fn(&[u8]) -> bool,
  read:      ~fn(u64)   -> &[u8],
  write:     ~fn(&[u8]),
  append:    ~fn(&[u8]),
  seek:      ~fn(i64),
  length:    ~fn() -> u64,
  available: ~fn() -> u64,
  position:  ~fn() -> u64
}
