pub struct Digest {
  data: ~[u32]
}

impl Digest {
  pub fn to_string(&self) -> ~str {
    self.data.foldl(~"", { |a, e|
      a + fmt!("%8.8x", *e as uint)
    })
  }
}
