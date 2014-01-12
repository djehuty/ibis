#[crate_id="keyboard-key#1.0"];

pub mod keyboard {
  pub mod key {
    pub struct Key {
      code: u32,

      leftAlt: bool,
      rightAlt: bool,
      leftControl: bool,
      rightControl: bool,
      leftShift: bool,
      rightShift: bool,
      capsLock: bool
    }

    impl Key {
      pub fn alt(&self) -> bool {
        self.leftAlt | self.rightAlt
      }

      pub fn shift(&self) -> bool {
        self.leftShift | self.rightShift
      }

      pub fn control(&self) -> bool {
        self.leftControl | self.rightControl
      }
    }
  }
}
