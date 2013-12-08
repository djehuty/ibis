#[link(name = "hash-digest", vers = "1.0", package_id = "hash-digest")];

pub struct Digest {
  data: ~[u32]
}

impl Digest {
  pub fn to_string(&self) -> ~str {
    self.data.iter().fold(~"", { |a, &e|
      a + format!("{:8.8x}", e as uint)
    })
  }
}
