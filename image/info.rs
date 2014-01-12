#[crate_id="image-info#1.0"];
#[feature(globs)];

extern mod io_pixelmap = "io-pixelmap";

mod io {
  pub mod pixelmap {
    pub use io_pixelmap::io::pixelmap::*;
  }
}

pub mod image {
  pub mod info {
    pub struct Info {
      width: u64,
      height: u64,
      colorDepth: ::io::pixelmap::ColorDepth,
      bitsPerPixel: u32,
    }
  }
}
