#[crate_id="codec-data-deflate-decoder#1.0"];
#[feature(globs)];

extern mod io_console      = "io-console";
extern mod io_stream       = "io-stream";

mod io {
  pub mod stream {
    pub use io_stream::io::stream::*;
  }
  pub mod console {
    pub use io_console::io::console::*;
  }
}

pub mod codec {
  pub mod data {
    pub mod deflate {
      pub mod decoder {
        enum State {
          Init,

          Accepted,
          Invalid,
          Required,

          ReadByte,

          ReadBits,
          ReadBit,

          ReadBitsRev,
          ReadBitRev,

          ReadBFinal,
          ReadBType,

          DeflateNoCompression,
          DeflateNoCompressionSkip,
          DeflateNoCompressionCopy,

          DeflateFixedCheckCode,
          DeflateFixedGetLength,
          DeflateFixedGetDistance,
          DeflateFixedGetDistanceEx,

          DeflateDynamicCompression,
          DeflateDynamicHDIST,
          DeflateDynamicHCLEN,
          DeflateDynamicGetCodeLen,
          DeflateDynamicDecodeLens,

          DeflateDynamicDecodeLen16,
          DeflateDynamicDecodeLen17,
          DeflateDynamicDecodeLen18,
          DeflateDynamicDecodeDist,
          DeflateDynamicBuildTree,
          DeflateDynamicDecoder,
          DeflateDynamicGetLength,
          DeflateDynamicGetDistance,
          DeflateDynamicGetDistEx,

          Complete,
        }

        struct HuffmanRange {
          base:  u16,
          minor: u16,
          major: u16,
        }

        struct HuffmanEntry {
          rangesCount: u16,
          ranges:      [HuffmanRange, ..144],
        }

        struct HuffmanTable {
          entries: [HuffmanEntry, ..16]
        }

        struct DeflateBlockInfo {
          isLastBlock: i32,
          blockType:   i32,
        }

        struct DeflateLengthEntry {
          extraBits: u8,
          base:      u16,
        }

        static DEFLATE_FIXED_HUFFMAN_TABLE:HuffmanTable =
          HuffmanTable {
            entries: [
              HuffmanEntry { // 1 bit
                rangesCount: 0,
                ranges: [
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                ]},
              HuffmanEntry { // 2 bits
                rangesCount: 0,
                ranges: [
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                ] },
              HuffmanEntry { // 3 bits
                rangesCount: 0,
                ranges: [
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                ] },
              HuffmanEntry { // 4 bits
                rangesCount: 0,
                ranges: [
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                ] },
              HuffmanEntry { // 5 bits
                rangesCount: 0,
                ranges: [
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                ] },
              HuffmanEntry { // 6 bits
                rangesCount: 0,
                ranges: [
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                ] },
              HuffmanEntry { // 7 bits
                rangesCount: 1,
                ranges: [
                  HuffmanRange { base: 256, minor: 0x00, major: 0x17 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                ] },
              HuffmanEntry { // 8 bits
                rangesCount: 2,
                ranges: [
                  HuffmanRange { base: 0,   minor: 0x30, major: 0xbf },
                  HuffmanRange { base: 280, minor: 0xc0, major: 0xc7 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                ] },
              HuffmanEntry { // 9 bits
                rangesCount: 1,
                ranges: [
                  HuffmanRange { base: 144, minor: 0x190, major: 0x1ff },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                ] },
              HuffmanEntry { // 10 bits
                rangesCount: 0,
                ranges: [
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                ] },
              HuffmanEntry { // 11 bits
                rangesCount: 0,
                ranges: [
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                ] },
              HuffmanEntry { // 12 bits
                rangesCount: 0,
                ranges: [
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                ] },
              HuffmanEntry { // 13 bits
                rangesCount: 0,
                ranges: [
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                ] },
              HuffmanEntry { // 14 bits
                rangesCount: 0,
                ranges: [
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                ] },
              HuffmanEntry { // 15 bits
                rangesCount: 0,
                ranges: [
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                ] },
              HuffmanEntry { // 16 bits
                rangesCount: 0,
                ranges: [
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                  HuffmanRange { base: 0, minor: 0x0, major: 0x0 },
                ] },
            ]
          };

        static DEFLATE_LENGTH_TABLE:[DeflateLengthEntry,..29] = [
          DeflateLengthEntry { extraBits: 0, base: 3},
          DeflateLengthEntry { extraBits: 0, base: 4},
          DeflateLengthEntry { extraBits: 0, base: 5},
          DeflateLengthEntry { extraBits: 0, base: 6},
          DeflateLengthEntry { extraBits: 0, base: 7},
          DeflateLengthEntry { extraBits: 0, base: 8},
          DeflateLengthEntry { extraBits: 0, base: 9},
          DeflateLengthEntry { extraBits: 0, base: 10 },
          DeflateLengthEntry { extraBits: 1, base: 11 },
          DeflateLengthEntry { extraBits: 1, base: 13 },
          DeflateLengthEntry { extraBits: 1, base: 15 },
          DeflateLengthEntry { extraBits: 1, base: 17 },
          DeflateLengthEntry { extraBits: 2, base: 19 },
          DeflateLengthEntry { extraBits: 2, base: 23 },
          DeflateLengthEntry { extraBits: 2, base: 27 },
          DeflateLengthEntry { extraBits: 2, base: 31 },
          DeflateLengthEntry { extraBits: 3, base: 35 },
          DeflateLengthEntry { extraBits: 3, base: 43 },
          DeflateLengthEntry { extraBits: 3, base: 51 },
          DeflateLengthEntry { extraBits: 3, base: 59 },
          DeflateLengthEntry { extraBits: 4, base: 67 },
          DeflateLengthEntry { extraBits: 4, base: 83 },
          DeflateLengthEntry { extraBits: 4, base: 99 },
          DeflateLengthEntry { extraBits: 4, base: 115 },
          DeflateLengthEntry { extraBits: 5, base: 131 },
          DeflateLengthEntry { extraBits: 5, base: 163 },
          DeflateLengthEntry { extraBits: 5, base: 195 },
          DeflateLengthEntry { extraBits: 5, base: 227 },
          DeflateLengthEntry { extraBits: 0, base: 258 },
        ];

        static GLOBAL_DEFLATE_DISTANCE_TABLE:[DeflateLengthEntry, ..30] = [
          DeflateLengthEntry { extraBits:  0, base: 1     },
          DeflateLengthEntry { extraBits:  0, base: 2     },
          DeflateLengthEntry { extraBits:  0, base: 3     },
          DeflateLengthEntry { extraBits:  0, base: 4     },
          DeflateLengthEntry { extraBits:  1, base: 5     },
          DeflateLengthEntry { extraBits:  1, base: 7     },
          DeflateLengthEntry { extraBits:  2, base: 9     },
          DeflateLengthEntry { extraBits:  2, base: 13    },
          DeflateLengthEntry { extraBits:  3, base: 17    },
          DeflateLengthEntry { extraBits:  3, base: 25    },
          DeflateLengthEntry { extraBits:  4, base: 33    },
          DeflateLengthEntry { extraBits:  4, base: 49    },
          DeflateLengthEntry { extraBits:  5, base: 65    },
          DeflateLengthEntry { extraBits:  5, base: 97    },
          DeflateLengthEntry { extraBits:  6, base: 129   },
          DeflateLengthEntry { extraBits:  6, base: 193   },
          DeflateLengthEntry { extraBits:  7, base: 257   },
          DeflateLengthEntry { extraBits:  7, base: 385   },
          DeflateLengthEntry { extraBits:  8, base: 513   },
          DeflateLengthEntry { extraBits:  8, base: 769   },
          DeflateLengthEntry { extraBits:  9, base: 1025  },
          DeflateLengthEntry { extraBits:  9, base: 1537  },
          DeflateLengthEntry { extraBits: 10, base: 2049  },
          DeflateLengthEntry { extraBits: 10, base: 3073  },
          DeflateLengthEntry { extraBits: 11, base: 4097  },
          DeflateLengthEntry { extraBits: 11, base: 6145  },
          DeflateLengthEntry { extraBits: 12, base: 8193  },
          DeflateLengthEntry { extraBits: 12, base: 12289 },
          DeflateLengthEntry { extraBits: 13, base: 16385 },
          DeflateLengthEntry { extraBits: 13, base: 24577 }
        ];

        // This is used to refer to the correct spot in the code lengths array.
        // For computing huffman tables for dynamic compression, code lengths occur
        //  in this order:
        //  16, 17, 18, 0, 8, 7, 9, 6, 10, 5, 11, 4, 12, 3, 13, 2, 14, 1, 15
        // This works under the assumption  that the later code lengths will be 0 and
        //  thus not necessary to include. Also, 16, 17, 18, 0 are thus not necessary
        //  (thus why HCLEN + 4 is the number of codes to retrieve)
        static DEFLATE_CODE_LENGTHS_REFERENCE:[u8, ..19] = [
          16, 17, 18, 0, 8, 7, 9, 6, 10, 5, 11, 4, 12, 3, 13, 2, 14, 1, 15
        ];

        pub struct Decoder {
          // Bit mask for getting the bit
          curMask: u8,
          curBit:  u8,
          curByte: u8,

          bitsLeft: u32,
          curValue: u32,
          curValueBit: u8,

          lastState: State,
          curCode: u16,

          // Block header
          curBlock: DeflateBlockInfo,

          // For Compression.Absent
          dataLength: u16,

          // For Huffman Compression

          // Current Huffman tables
          internalHuffmanTable: HuffmanTable,
          internalDistanceTable: HuffmanTable,

          // Regular Huffman Decoder
          curHuffmanBitLength: u32,
          curHuffmanTable: ~HuffmanTable,
          curHuffmanEntry: ~HuffmanEntry,

          // Distance Tree Decoder
          curDistanceEntry: ~HuffmanEntry,
          curDistanceBitLength: u32,

          // Track Length, Distance
          length: u16,
          distance: u16,

          // Counter
          counter: u32,
          counterMax: u32,

          // Dynamic Huffman Tree Building
          HLIT: u16,
          HDIST: u16,
          HCLEN: u16,

          // Holds the bit length of the code
          codeLengths: [u8, ..19],

          // Counts how many of each length have been found
          codeLengthCount: [u8, ..7],

          // The Huffman table for code lengths
          codeLengthTable: HuffmanTable,

          // The minimum code size for a code length code
          codeLengthCodeSize: u16,
          distanceCodeLengthCodeSize: u16,

          huffmanLengths: [u8, ..288],
          distanceLengths: [u8, ..32],
          huffmanLengthCounts: [u16, ..16],
          distanceLengthCounts: [u16, ..16],

          currentIsHuffman: bool,

          huffmanTable: [u16, ..578],
          distanceTable: [u16, ..68],

          huffmanNextCodes: [u16, ..16],

          treePosition: u16,

          state: State,
          nextState: State,
          currentState: State,
        }

        pub fn new() -> ~Decoder {
          ~Decoder {
            state: Init,
            nextState: Init,
            currentState: Init,

            curMask: 0,
            curBit:  0,
            curByte: 0,

            bitsLeft: 0,
            curValue: 0,
            curValueBit: 0,

            lastState: Init,
            curCode: 0,

            // Block header
            curBlock: DeflateBlockInfo {
              isLastBlock: 0,
              blockType: 0,
            },

            // For Compression.Absent
            dataLength: 0,

            // For Huffman Compression

            // Current Huffman tables
            internalHuffmanTable: HuffmanTable {
              entries: [
                HuffmanEntry { // 1 bit
                  rangesCount: 0,
                  ranges: [ HuffmanRange { base: 0, minor: 0x0, major: 0x0 }, ..144]
                }, ..16]
            },
            internalDistanceTable: HuffmanTable {
              entries: [
                HuffmanEntry { // 1 bit
                  rangesCount: 0,
                  ranges: [ HuffmanRange { base: 0, minor: 0x0, major: 0x0 }, ..144]
                }, ..16]
            },

            // Regular Huffman Decoder
            curHuffmanBitLength: 0,
            curHuffmanTable: ~DEFLATE_FIXED_HUFFMAN_TABLE,
            curHuffmanEntry: ~DEFLATE_FIXED_HUFFMAN_TABLE.entries[0],

            // Distance Tree Decoder
            curDistanceEntry: ~DEFLATE_FIXED_HUFFMAN_TABLE.entries[0],
            curDistanceBitLength: 0,

            // Track Length, Distance
            length: 0,
            distance: 0,

            // Counter
            counter: 0,
            counterMax: 0,

            // Dynamic Huffman Tree Building
            HLIT: 0,
            HDIST: 0,
            HCLEN: 0,

            // Holds the bit length of the code
            codeLengths: [0, ..19],

            // Counts how many of each length have been found
            codeLengthCount: [0, ..7],

            // The Huffman table for code lengths
            codeLengthTable: HuffmanTable {
              entries: [
                HuffmanEntry { // 1 bit
                  rangesCount: 0,
                  ranges: [ HuffmanRange { base: 0, minor: 0x0, major: 0x0 }, ..144]
                }, ..16]
            },

            // The minimum code size for a code length code
            codeLengthCodeSize: 0,
            distanceCodeLengthCodeSize: 0,

            huffmanLengths: [0, ..288],
            distanceLengths: [0, ..32],
            huffmanLengthCounts: [0, ..16],
            distanceLengthCounts: [0, ..16],

            currentIsHuffman: true,

            huffmanTable: [0, ..578],
            distanceTable: [0, ..68],

            huffmanNextCodes: [0, ..16],

            treePosition: 0,
          }
        }

        impl Decoder {
          pub fn decode(&mut self, input: &mut ::io::stream::Readable, stream: &mut ::io::stream::Streamable) {
            loop {
              //::io::console::println(format!("state: {}", self.state as u32));
              match self.state {
                Init => self.init(),

                Accepted => {},
                Invalid => {},
                Required => {},

                ReadByte => self.readByte(input),

                ReadBits => self.readBits(),
                ReadBit => self.readBit(),

                ReadBitsRev => self.readBitsRev(),
                ReadBitRev => self.readBitRev(),

                ReadBFinal => self.readBFinal(),
                ReadBType => self.readBType(),

                DeflateNoCompression => self.deflateNoCompression(input),
                DeflateNoCompressionSkip => self.deflateNoCompressionSkip(input),
                DeflateNoCompressionCopy => self.deflateNoCompressionCopy(input, stream),

                DeflateFixedCheckCode => self.deflateFixedCheckCode(stream),
                DeflateFixedGetLength => self.deflateFixedGetLength(),
                DeflateFixedGetDistance => self.deflateFixedGetDistance(stream),
                DeflateFixedGetDistanceEx => self.deflateFixedGetDistanceEx(stream),

                DeflateDynamicCompression => self.deflateDynamicCompression(),
                DeflateDynamicHDIST => self.deflateDynamicHDIST(),
                DeflateDynamicHCLEN => self.deflateDynamicHCLEN(),
                DeflateDynamicGetCodeLen => self.deflateDynamicGetCodeLen(),
                DeflateDynamicDecodeLens => self.deflateDynamicDecodeLens(),

                DeflateDynamicDecodeLen16 => self.deflateDynamicDecodeLen16(),
                DeflateDynamicDecodeLen17 => self.deflateDynamicDecodeLen17(),
                DeflateDynamicDecodeLen18 => self.deflateDynamicDecodeLen18(),
                DeflateDynamicDecodeDist => self.deflateDynamicDecodeDist(),
                DeflateDynamicBuildTree => self.deflateDynamicBuildTree(),
                DeflateDynamicDecoder => self.deflateDynamicDecoder(stream),
                DeflateDynamicGetLength => self.deflateDynamicGetLength(),
                DeflateDynamicGetDistance => self.deflateDynamicGetDistance(stream),
                DeflateDynamicGetDistEx => self.deflateDynamicGetDistEx(stream),

                Complete => {break;},
              }

              if (self.state as u32 == Invalid  as u32 ||
                  self.state as u32 == Required as u32 ||
                  self.state as u32 == Accepted as u32) {
                break;
              }
            }
          }

          fn init(&mut self) {
            self.codeLengthCodeSize = 1;
            self.distanceCodeLengthCodeSize = 1;

            self.curValue = 0;
            self.curValueBit = 0;

            self.lastState = ReadBFinal;

            self.state = ReadByte;
            self.nextState = ReadBit;
          }

          fn readByte(&mut self, input: &mut ::io::stream::Readable) {
            if input.available() == 0 {
              self.state = Required;
              self.currentState = ReadByte;
              return;
            }

            self.curByte = input.read(1)[0];

            self.curMask = 1; // 0b00000001
            self.curBit  = 0;

            self.state = self.nextState;
          }

          fn readBits(&mut self) {
            if self.curMask == 0 {
              self.state = ReadByte;
              self.nextState = ReadBits;
              return;
            }

            let masked = (self.curByte & self.curMask) as u32;
            if masked > 0 {
              if self.curBit > self.curValueBit {
                self.curValue |= (masked >> (self.curBit - self.curValueBit)) as u32;
              }
              else if self.curBit == self.curValueBit {
                self.curValue |= masked as u32;
              }
              else {
                self.curValue |= (masked << (self.curValueBit - self.curBit)) as u32;
              }
            }

            self.curMask <<= 1;

            self.bitsLeft    -= 1;
            self.curBit      += 1;
            self.curValueBit += 1;

            if self.bitsLeft == 0 {
              self.state = self.lastState;
            }
          }

          fn readBit(&mut self) {
            if self.curMask == 0 {
              self.state     = ReadByte;
              self.nextState = ReadBit;
              return;
            }

            let masked = self.curByte & self.curMask;
            if masked > 0 {
              if self.curBit > self.curValueBit {
                self.curValue |= (masked >> (self.curBit - self.curValueBit)) as u32;
              }
              else if self.curBit == self.curValueBit {
                self.curValue |= masked as u32;
              }
              else {
                self.curValue |= (masked << (self.curValueBit - self.curBit)) as u32;
              }
            }

            self.curMask <<= 1;

            self.curBit      += 1;
            self.curValueBit += 1;

            self.state = self.lastState;
          }

          fn readBitsRev(&mut self) {
            if self.curMask == 0 {
              self.state = ReadByte;
              self.nextState = ReadBitsRev;
              return;
            }

            self.curValue <<= 1;

            let masked = self.curByte & self.curMask;
            if masked > 0 {
              self.curValue += 1;
            }

            self.curMask <<= 1;

            self.bitsLeft    -= 1;
            self.curBit      += 1;

            if self.bitsLeft == 0 {
              self.state = self.lastState;
            }
          }

          fn readBitRev(&mut self) {
            if self.curMask == 0 {
              self.state = ReadByte;
              self.nextState = ReadBitRev;
              return;
            }

            self.curValue <<= 1;

            let masked = self.curByte & self.curMask;
            if masked > 0 {
              self.curValue += 1;
            }

            self.curMask <<= 1;

            self.bitsLeft    -= 1;
            self.curBit      += 1;

            self.state = self.lastState;
          }

          fn readBFinal(&mut self) {
            self.curBlock.isLastBlock = self.curValue as i32;

            self.state = ReadBits;
            self.lastState = ReadBType;

            self.curValue = 0;
            self.curValueBit = 0;
            self.bitsLeft = 2;
          }

          fn readBType(&mut self) {
            self.curBlock.blockType = self.curValue as i32;

            self.curValue = 0;
            self.curValueBit = 0;

            match self.curBlock.blockType {
              0 => { // No Compression
                self.state = DeflateNoCompression;
              },
              1 => { // Fixed Huffman
                self.curHuffmanTable = ~DEFLATE_FIXED_HUFFMAN_TABLE;

                self.curValue = 0;
                self.curValueBit = 0;
                self.curHuffmanBitLength = 6;
                self.curHuffmanEntry = ~self.curHuffmanTable.entries[6];

                self.bitsLeft = 7;

                self.state = ReadBitsRev;
                self.lastState = DeflateFixedCheckCode;
              },
              2 => { // Dynamic Huffman
                self.bitsLeft = 5;

                self.state = ReadBits;
                self.lastState = DeflateDynamicCompression;
              },
              _ => { // Unknown
                self.state = Invalid;
              }
            }
          }

          fn deflateNoCompression(&mut self, input: &mut ::io::stream::Readable) {
            if input.available() < 2 {
              self.currentState = self.state;
              self.state = Required;
              return;
            }

            input.readIntoPtr(&mut self.dataLength as *mut u16 as *mut u8, 2);
            // TODO:endianness
            self.state = DeflateNoCompressionSkip;
          }

          fn deflateNoCompressionSkip(&mut self, input: &mut ::io::stream::Readable) {
            if input.available() < 2 {
              self.currentState = self.state;
              self.state = Required;
              return;
            }

            input.seek(2);
            self.state = DeflateNoCompressionCopy;
          }

          fn deflateNoCompressionCopy(&mut self, input: &mut ::io::stream::Readable, output: &mut ::io::stream::Streamable) {
            if input.available() < self.dataLength as u64 {
              self.currentState = self.state;
              self.state = Required;
              return;
            }

            output.appendFromReader(input, self.dataLength as u64);

            if self.curBlock.isLastBlock > 0 {
              self.state = Complete;
              return;
            }

            // Read another block header
            self.curValue = 0;
            self.curValueBit = 0;
            self.lastState = ReadBFinal;

            self.state = ReadBit;
          }

          // Fixed Huffman Decoding

          // Determine if the code is within huffman tables
          // Otherwise, add a bit unless current bit is the 7th bit (the max)
          fn deflateFixedCheckCode(&mut self, output: &mut ::io::stream::Streamable) {
            for i in ::std::iter::range_step(0, self.curHuffmanEntry.rangesCount, 1) {
              let range = self.curHuffmanEntry.ranges[i];

              let code = self.curValue as u16;

              if code >= range.minor &&
                 code <= range.major {
                self.curCode  = code - range.minor;
                self.curCode += range.base;

                if self.curCode < 256 {
                  // Literal code, output
                  output.appendFromPtr(&self.curCode as *u16 as *u8, 1);

                  self.curValue = 0;
                  self.curValueBit = 0;
                  self.curHuffmanBitLength = 0;
                  self.curHuffmanEntry = ~self.curHuffmanTable.entries[
                    self.curHuffmanBitLength];

                  self.bitsLeft = 7;
                  self.state = ReadBitsRev;
                  self.lastState = DeflateFixedCheckCode;
                }
                else if self.curCode == 256 {
                  // End of block code

                  // Return to gathering blocks if this isn't the last one
                  if self.curBlock.isLastBlock > 0 {
                    self.state = Complete;
                    return;
                  }

                  self.curValue = 0;
                  self.curValueBit = 0;
                  self.lastState = ReadBFinal;

                  self.state = ReadBit;
                }
                else {
                  // Length Code

                  // Calculate the true length

                  self.length = DEFLATE_LENGTH_TABLE[self.curCode - 257].base;

                  self.curValue = 0;
                  self.curValueBit = 0;

                  if DEFLATE_LENGTH_TABLE[self.curCode - 257].extraBits > 0 {
                    self.state = ReadBits;
                    self.bitsLeft = DEFLATE_LENGTH_TABLE[self.curCode - 257].extraBits as u32;
                    self.lastState = DeflateFixedGetLength;
                  }
                  else {
                    // We have the length, find the distance

                    // In fixed huffman, the distance is a fixed 5 bit value plus any
                    // extra bits given in the table for distance codes
                    self.state = ReadBitsRev;
                    self.bitsLeft = 5;
                    self.lastState = DeflateFixedGetDistance;
                  }
                }

                break;
              }
            }

            if self.state as u32 == DeflateFixedCheckCode as u32 {
              // Huffman code not yet found, read another bit
              // Increment huffman entry counter
              self.curHuffmanBitLength += 1;
              self.curHuffmanEntry      = ~self.curHuffmanTable.entries[
                self.curHuffmanBitLength];

              self.state = ReadBitRev;

              if self.curHuffmanBitLength == 16 {
                // Huffman Maximum Code Length Exceeded
                self.state = Invalid;
                return;
              }
            }
          }

          fn deflateFixedGetLength(&mut self) {
            self.length += self.curValue as u16;

            // In fixed huffman, the distance is a fixed 5 bit value, plus any
            // extra bits given in the table for distance codes

            self.bitsLeft = 5;

            self.curValue = 0;
            self.curValueBit = 0;

            self.state = ReadBitsRev;
            self.lastState = DeflateFixedGetDistance;
          }

          fn deflateFixedGetDistance(&mut self, output: &mut ::io::stream::Streamable) {
            let distanceTable = &GLOBAL_DEFLATE_DISTANCE_TABLE[self.curValue];

            self.distance = distanceTable.base;

            if distanceTable.extraBits > 0 {
              self.state = ReadBits;

              self.bitsLeft = distanceTable.extraBits as u32;
              self.lastState = DeflateFixedGetDistanceEx;

              self.curValue = 0;
              self.curValueBit = 0;
            }
            else {
              // Distance requires no other input
              // Add to the data stream using interpret state
              // And then return to gather another code

              self.curValue = 0;
              self.curValueBit = 0;
              self.curHuffmanBitLength = 6;
              self.curHuffmanEntry = ~self.curHuffmanTable.entries[6];

              self.bitsLeft = 7;
              self.state = ReadBitsRev;
              self.lastState = DeflateFixedCheckCode;

              Decoder::duplicateFromEnd(output, self.distance as u64, self.length as u32);
            }
          }

          fn deflateFixedGetDistanceEx(&mut self, output: &mut ::io::stream::Streamable) {
            self.distance += self.curValue as u16;

            // Add to the data stream by using interpret state
            // And then return to gather another code

            self.curValue = 0;
            self.curValueBit = 0;
            self.curHuffmanBitLength = 6;
            self.curHuffmanEntry = ~self.curHuffmanTable.entries[6];

            self.bitsLeft = 7;
            self.state = ReadBitsRev;
            self.lastState = DeflateFixedCheckCode;

            Decoder::duplicateFromEnd(output, self.distance as u64, self.length as u32);
          }

          fn deflateDynamicCompression(&mut self) {
            self.HLIT = self.curValue as u16;

            for i in ::std::iter::range_step(0, 16, 1) {
              self.codeLengthTable.entries[i].rangesCount = 0;
            }

            for i in ::std::iter::range_step(0, 7, 1) {
              self.codeLengthCount[i] = 0;
            }

            for i in ::std::iter::range_step(0, 8, 1) {
              self.huffmanLengthCounts[i] = 0;
            }

            self.bitsLeft = 5;
            self.state = ReadBits;
            self.lastState = DeflateDynamicHDIST;
            self.curValue = 0;
            self.curValueBit = 0;
          }

          fn deflateDynamicHDIST(&mut self) {
            self.HDIST = self.curValue as u16;

            self.bitsLeft = 4;
            self.state = ReadBits;
            self.lastState = DeflateDynamicHCLEN;
            self.curValue = 0;
            self.curValueBit = 0;
          }

          fn deflateDynamicHCLEN(&mut self) {
            self.HCLEN = self.curValue as u16;

            self.counterMax = self.HCLEN as u32 + 4;
            self.counter = 0;

            self.bitsLeft = 3;
            self.state = ReadBits;

            self.lastState = DeflateDynamicGetCodeLen;

            self.curValue = 0;
            self.curValueBit = 0;
          }

          fn deflateDynamicGetCodeLen(&mut self) {
            self.codeLengths[DEFLATE_CODE_LENGTHS_REFERENCE[self.counter]]
              = self.curValue as u8;

            if self.curValue != 0 {
              self.codeLengthCount[self.curValue - 1] += 1;
            }

            self.huffmanLengthCounts[self.curValue] += 1;

            self.curValue = 0;
            self.curValueBit = 0;

            self.counter += 1;

            if self.counter != self.counterMax {
              // Read 3 more bits
              self.bitsLeft = 3;
              self.state = ReadBits;
            }
            else {
              for i in ::std::iter::range_step(self.counter, 19, 1) {
                self.codeLengths[DEFLATE_CODE_LENGTHS_REFERENCE[i]] = 0;
                self.huffmanLengthCounts[0] += 1;
              }

              for i in ::std::iter::range_step(0, 578, 1) {
                self.huffmanTable[i] = 0xffff;
              }

              // Build Code Length Tree

              self.huffmanNextCodes[0] = 0;

              for p in ::std::iter::range_step(1, 16, 1) {
                self.huffmanNextCodes[p]
                  = (self.huffmanNextCodes[p-1] + self.huffmanLengthCounts[p-1]) as u16 * 2;
              }

              let mut pos:u32 = 0;
              let mut filled:u32 = 0;

              for i in ::std::iter::range_step(0, 19, 1) {
                let cur_entry = self.huffmanNextCodes[self.codeLengths[i]];
                self.huffmanNextCodes[self.codeLengths[i]] += 1;

                for o in ::std::iter::range_step(0, self.codeLengths[i], 1) {
                  let bit = (cur_entry >> (self.codeLengths[i] - o - 1)) as u8 & 1;

                  let pos_exp = (2 * pos) + bit as u32;

                  if (o + 1) > (19 - 2) {
                    // Error: Tree is mishaped
                  }
                  else if self.huffmanTable[pos_exp] == 0xffff {
                    // Not in tree

                    // Is this the last bit?
                    if (o + 1) == self.codeLengths[i] {
                      self.huffmanTable[pos_exp] = i as u16;
                      pos = 0;
                    }
                    else {
                      filled += 1;

                      self.huffmanTable[pos_exp] = filled as u16 + 19;
                      pos = filled;
                    }
                  }
                  else {
                    // In tree
                    pos = self.huffmanTable[pos_exp] as u32 - 19;
                  }
                }
              }

              // Table is built
              // Decode code lengths

              self.counter = 0;
              self.counterMax = self.HLIT as u32 + 257;

              for i in ::std::iter::range_step(0, 16, 1) {
                self.huffmanLengthCounts[i] = 0;
                self.distanceLengthCounts[i] = 0;
              }

              self.lastState = DeflateDynamicDecodeLens;

              self.curHuffmanTable = ~self.codeLengthTable;
              self.curHuffmanEntry =
                ~self.codeLengthTable.entries[self.codeLengthCodeSize - 1];

              self.bitsLeft = self.codeLengthCodeSize as u32;
              self.curHuffmanBitLength = self.codeLengthCodeSize as u32;

              self.currentIsHuffman = true;

              self.state = DeflateDynamicDecodeLens;

              self.curValue = 0;
              self.curValueBit = 0;
              self.treePosition = 0;
            }
          }

          fn deflateDynamicDecodeLens(&mut self) {
            // Get bit

            if self.curMask == 0 {
              self.state = ReadByte;
              self.nextState = DeflateDynamicDecodeLens;
              return;
            }

            let masked = self.curByte & self.curMask;
            if masked > 0 {
              self.curValue = 1;
            }
            else {
              self.curValue = 0;
            }

            self.curMask <<= 1;
            self.curBit   += 1;

            // Check in the tree
            if self.treePosition >= 19 {
              // Corrupt data... out of position
              self.state = Invalid;
              return;
            }

            self.curCode = self.huffmanTable[
              (2 * self.treePosition) + self.curValue as u16];

            if self.curCode < 19 {
              self.treePosition = 0;
            }
            else {
              self.treePosition = self.curCode as u16 - 19;
            }

            if self.treePosition == 0 {
              // Interpret Code
              if self.curCode < 16 {
                // 0 .. 15 are literal lengths
                // Just insert into array

                if self.currentIsHuffman {
                  self.huffmanLengths[self.counter] = self.curCode as u8;
                  self.huffmanLengthCounts[self.curCode] += 1;
                }
                else {
                  self.distanceLengths[self.counter] = self.curCode as u8;
                  self.distanceLengthCounts[self.curCode] += 1;
                }
                self.counter += 1;

                if self.counter == self.counterMax {
                  // We have gotten the maximum codes we were supposed to find
                  // We have to now decode the distance array or the tree now

                  self.state = DeflateDynamicDecodeDist;
                  return;
                }

                // Read another code
                self.curValue = 0;
                self.curValueBit = 0;

                self.curHuffmanTable = ~self.codeLengthTable;
                self.curHuffmanEntry = ~self.codeLengthTable.entries[0];

                self.bitsLeft = 1;
                self.curHuffmanBitLength = 1;
              }
              else if self.curCode == 16 {
                // Copy previous length 3 - 6 times
                // Next two (2) bits determine length: (bits[2] + 3)

                self.curValue = 0;
                self.curValueBit = 0;

                self.bitsLeft = 2;
                self.state = ReadBits;
                self.lastState = DeflateDynamicDecodeLen16;
              }
              else if self.curCode == 17 {
                // Repeat code length of 0 for 3 - 10 times
                // Next three (3) bits determine length

                self.curValue = 0;
                self.curValueBit = 0;

                self.bitsLeft = 3;
                self.state = ReadBits;
                self.lastState = DeflateDynamicDecodeLen17;
              }
              else if self.curCode == 18 {
                // Repeat code length of 0 for 11 - 138 times
                // Next seven (7) bits determine length

                self.curValue = 0;
                self.curValueBit = 0;

                self.bitsLeft = 7;
                self.state = ReadBits;
                self.lastState = DeflateDynamicDecodeLen18;
              }
            }
          }

          fn deflateDynamicDecodeLen16(&mut self) {
            // Take last code and repeat 'curvalue' + 3 times
            self.curValue += 3;

            if self.counter != 0 {
              self.curCode =
                if self.currentIsHuffman {
                  self.huffmanLengths[self.counter - 1]
                }
                else {
                  self.distanceLengths[self.counter - 1]
                } as u16;
            }
            else {
              // Corrupt data, counter is 0?
              self.state = Invalid;
              return;
            }

            self.lastState = DeflateDynamicDecodeLens;

            self.curHuffmanTable = ~self.codeLengthTable;
            self.curHuffmanEntry = ~self.codeLengthTable.entries[0];

            self.bitsLeft = 1;
            self.curHuffmanBitLength = 1;

            self.state = DeflateDynamicDecodeLens;

            for _ in ::std::iter::range_step(0, self.curValue, 1) {
              if self.currentIsHuffman {
                self.huffmanLengths[self.counter] = self.curCode as u8;
                self.huffmanLengthCounts[self.curCode] += 1;
              }
              else {
                self.distanceLengths[self.counter] = self.curCode as u8;
                self.distanceLengthCounts[self.curCode] += 1;
              }

              self.counter += 1;

              if self.counter == self.counterMax {
                // We cannot repeat the value
                self.state = DeflateDynamicDecodeDist;
                break;
              }
            }

            self.curValue = 0;
            self.curValueBit = 0;
          }

          fn deflateDynamicDecodeLen17(&mut self) {
            self.curValue += 3;

            // Take 0 and repeat 'curvalue' times

            self.lastState = DeflateDynamicDecodeLens;

            self.curHuffmanTable = ~self.codeLengthTable;
            self.curHuffmanEntry = ~self.codeLengthTable.entries[0];

            self.bitsLeft = 1;
            self.curHuffmanBitLength = 1;

            self.state = DeflateDynamicDecodeLens;

            for _ in ::std::iter::range_step(0, self.curValue, 1) {
              if self.currentIsHuffman {
                self.huffmanLengths[self.counter] = 0;
                self.huffmanLengthCounts[0] += 1;
              }
              else {
                self.distanceLengths[self.counter] = 0;
                self.distanceLengthCounts[0] += 1;
              }

              self.counter += 1;

              if self.counter == self.counterMax {
                // We cannot repeat the value
                // Just stop

                self.state = DeflateDynamicDecodeDist;
                break;
              }
            }

            self.curValue = 0;
            self.curValueBit = 0;
          }

          fn deflateDynamicDecodeLen18(&mut self) {
            self.curValue += 8;
            self.deflateDynamicDecodeLen17();
          }

          fn deflateDynamicDecodeDist(&mut self) {
            if !self.currentIsHuffman {
              // Finish initializing the rest of the distance code length array

              // Write out the rest of the entries to 0
              for i in ::std::iter::range_step(self.counter, 32, 1) {
                self.distanceLengths[i] = 0;
                self.distanceLengthCounts[0] += 1;
              }

              self.state = DeflateDynamicBuildTree;
              return;
            }

            // Finish initializing the rest of the huffman code length array

            // Write out the rest of the entries to 0
            for i in ::std::iter::range_step(self.counter, 288, 1) {
              self.huffmanLengths[i] = 0;
              self.huffmanLengthCounts[0] += 1;
            }

            // Now initialize the length decoder to build the distance array
            self.counter = 0;
            self.counterMax = self.HDIST as u32 + 1;

            self.lastState = DeflateDynamicDecodeLens;

            self.curHuffmanTable = ~self.codeLengthTable;
            self.curHuffmanEntry = ~self.codeLengthTable.entries[
              self.codeLengthCodeSize - 1];

            self.bitsLeft = self.codeLengthCodeSize as u32;
            self.curHuffmanBitLength = self.codeLengthCodeSize as u32;

            self.currentIsHuffman = false;

            self.state = DeflateDynamicDecodeLens;

            self.curValue = 0;
            self.curValueBit = 0;
          }

          fn deflateDynamicBuildTree(&mut self) {
            for i in ::std::iter::range_step(0, 578, 1) {
              self.huffmanTable[i] = 0xffff;
            }

            for i in ::std::iter::range_step(0, 68, 1) {
              self.distanceTable[i] = 0xffff;
            }

            // Build Code Length Tree
            self.huffmanNextCodes[0] = 0;

            for p in ::std::iter::range_step(1, 16, 1) {
              self.huffmanNextCodes[p] =
                (self.huffmanNextCodes[p-1] + self.huffmanLengthCounts[p-1]) * 2;
            }

            let mut pos:u32 = 0;
            let mut filled:u32 = 0;

            for i in ::std::iter::range_step(0, 288, 1) {
              let cur_entry = self.huffmanNextCodes[self.huffmanLengths[i]];
              self.huffmanNextCodes[self.huffmanLengths[i]] += 1;

              // Go through every bit
              for o in ::std::iter::range_step(0, self.huffmanLengths[i], 1) {
                let bit:u8 = (cur_entry >> self.huffmanLengths[i] - o - 1) as u8 & 1;

                let pos_exp:u32 = (2 * pos) as u32 + bit as u32;

                if self.huffmanTable[pos_exp] == 0xffff {
                  // Is this the last bit?
                  if (o + 1) == self.huffmanLengths[i] {
                    // Output the code
                    self.huffmanTable[pos_exp] = i as u16;
                    pos = 0;
                  }
                  else {
                    filled += 1;

                    self.huffmanTable[pos_exp] = filled as u16 + 288;
                    pos = filled;
                  }
                }
                else {
                  pos = self.huffmanTable[pos_exp] as u32 - 288;
                }
              }
            }

            self.huffmanNextCodes[0] = 0;

            for p in ::std::iter::range_step(1, 16, 1) {
              self.huffmanNextCodes[p] =
                (self.huffmanNextCodes[p - 1] + self.distanceLengthCounts[p - 1]) * 2;
            }

            pos = 0;
            filled = 0;

            for i in ::std::iter::range_step(0, 32, 1) {
              let cur_entry = self.huffmanNextCodes[self.distanceLengths[i]];
              self.huffmanNextCodes[self.distanceLengths[i]] += 1;

              // Go through every bit
              for o in ::std::iter::range_step(0, self.distanceLengths[i], 1) {
                let bit:u8 = (cur_entry >> self.distanceLengths[i] - o - 1) as u8 & 1;

                let pos_exp:u32 = (2 * pos) as u32 + bit as u32;

                if (o + 1) > (32 - 2) {
                  // Error. Tree is mishaped.
                  self.state = Invalid;
                  return;
                }
                else if self.distanceTable[pos_exp] == 0xffff {
                  // Is this the last bit?
                  if (o + 1) == self.distanceLengths[i] {
                    // Output the code
                    self.distanceTable[pos_exp] = i as u16;
                    pos = 0;
                  }
                  else {
                    filled += 1;

                    self.distanceTable[pos_exp] = filled as u16 + 32;
                    pos = filled;
                  }
                }
                else {
                  pos = self.distanceTable[pos_exp] as u32 - 32;
                }
              }
            }

            // Build Code Length Tree
            // Decode
            // Init Huffman to minimum code length
            self.state = DeflateDynamicDecoder;
            self.treePosition = 0;
          }

          fn deflateDynamicDecoder(&mut self, output: &mut ::io::stream::Streamable) {
            // Get bit

            if self.curMask == 0 {
              self.state = ReadByte;
              self.nextState = DeflateDynamicDecoder;
              return;
            }

            let masked = self.curByte & self.curMask;
            if masked > 0 {
              self.curValue = 1;
            }
            else {
              self.curValue = 0;
            }

            self.curMask <<= 1;
            self.curBit   += 1;

            // Check in tree
            self.curCode = self.huffmanTable[
              (2 * self.treePosition) + self.curValue as u16];

            if self.curCode < 288 {
              self.treePosition = 0;
            }
            else {
              self.treePosition = self.curCode as u16 - 288;
            }

            if self.treePosition == 0 {
              // Interpret code

              if self.curCode < 256 {
                // Literal code

                // Append to output stream
                output.appendFromPtr(&self.curCode as *u16 as *u8, 1);

                // Return to gather another code
                self.curValue = 0;
                self.curValueBit = 0;
                self.curHuffmanBitLength = self.codeLengthCodeSize as u32 - 1;
                self.curHuffmanTable = ~self.internalHuffmanTable;
                self.curHuffmanEntry = ~self.internalHuffmanTable.entries[
                  self.curHuffmanBitLength];

                self.bitsLeft = self.codeLengthCodeSize as u32;
                self.state = DeflateDynamicDecoder;
                self.lastState = DeflateDynamicDecoder;
              }
              else if self.curCode == 256 {
                // End of block code

                // Return to gathering blocks if this is not the last one
                if self.curBlock.isLastBlock > 0 {
                  self.state = Complete;
                  return;
                }

                self.curValue = 0;
                self.curValueBit = 0;
                self.lastState = ReadBFinal;

                self.state = ReadBit;
              }
              else {
                // Length code

                // Calculate the true length
                let lengthTable = DEFLATE_LENGTH_TABLE[self.curCode - 257];
                self.length = lengthTable.base;

                self.curValue = 0;
                self.curValueBit = 0;

                if lengthTable.extraBits > 0 {
                  self.state = ReadBits;
                  self.bitsLeft = lengthTable.extraBits as u32;
                  self.lastState = DeflateDynamicGetLength;
                }
                else {
                  // We already have the length, find the distance
                  self.state = DeflateDynamicGetDistance;
                }
              }
            }
          }

          fn deflateDynamicGetLength(&mut self) {
            self.length += self.curValue as u16;

            self.state = DeflateDynamicGetDistance;

            self.curValue = 0;
            self.curValueBit = 0;
            self.bitsLeft = self.distanceCodeLengthCodeSize as u32;
            self.lastState = DeflateDynamicGetDistance;
          }

          fn deflateDynamicGetDistance(&mut self, output: &mut ::io::stream::Streamable) {
            // Get bit

            if self.curMask == 0 {
              self.state = ReadByte;
              self.nextState = DeflateDynamicGetDistance;
              return;
            }

            let masked = self.curByte & self.curMask;
            if masked > 0 {
              self.curValue = 1;
            }
            else {
              self.curValue = 0;
            }

            self.curMask <<= 1;
            self.curBit   += 1;

            // Check in tree
            self.curCode = self.distanceTable[
              (2 * self.treePosition) + self.curValue as u16];

            if self.curCode < 32 {
              self.treePosition = 0;
            }
            else {
              self.treePosition = self.curCode as u16 - 32;
            }

            if self.treePosition == 0 {
              // Interpret code

              let distanceTable = GLOBAL_DEFLATE_DISTANCE_TABLE[self.curCode];
              self.distance = distanceTable.base;

              if distanceTable.extraBits > 0 {
                self.state = ReadBits;

                self.bitsLeft = distanceTable.extraBits as u32;
                self.lastState = DeflateDynamicGetDistEx;

                self.curValue = 0;
                self.curValueBit = 0;
              }
              else {
                // The distance requires no other input
                // Add to the data stream
                // Return to get another code

                Decoder::duplicateFromEnd(output, self.distance as u64, self.length as u32);

                self.state = DeflateDynamicDecoder;
              }
            }
          }

          fn deflateDynamicGetDistEx(&mut self, output: &mut ::io::stream::Streamable) {
            self.distance += self.curValue as u16;

            self.curValue = 0;
            self.curValueBit = 0;

            self.bitsLeft = self.codeLengthCodeSize as u32;

            Decoder::duplicateFromEnd(output, self.distance as u64, self.length as u32);

            self.state = DeflateDynamicDecoder;
          }

          fn duplicateFromEnd(output: &mut ::io::stream::Streamable, distanceBehind: u64, amount: u32) -> bool {
            // Read immutable properties first before borrowing as mut
            let len = output.length();
            let pos = output.position();

            // Mutate output

            if amount == 0 {
              return false;
            }

            if distanceBehind > len {
              return false;
            }

            output.seekTo(len - distanceBehind);

            if (distanceBehind as u32) < amount {
              let bytes = output.read(distanceBehind);
              let mut toAppend = amount;

              while ((distanceBehind as u32) < toAppend) {
                output.append(bytes);
                toAppend -= distanceBehind as u32;
              }

              if toAppend > 0 {
                output.append(bytes.slice(0, toAppend as uint));
              }
            }
            else {
              let bytes = output.read(amount as u64);
              output.append(bytes);
            }

            output.seekTo(pos);

            true
          }
        }
      }
    }
  }
}
