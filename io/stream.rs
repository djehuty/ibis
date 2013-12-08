#[link(name = "io-stream", vers = "1.0", package_id = "io-stream")];

pub trait Readable {
  fn readInto(&self, buffer: &mut [u8]) -> bool;
  fn read(&self, amount: u64) -> ~[u8];

  fn seek(&self, amount: i64);
  fn length(&self) -> u64;
  fn available(&self) -> u64;
  fn position(&self) -> u64;
}

pub trait Writable {
  fn write(&self, data: &[u8]);
  fn append(&self, data: &[u8]);

  fn seek(&self, amount: i64);
  fn length(&self) -> u64;
  fn available(&self) -> u64;
  fn position(&self) -> u64;
}

pub trait Streamable {
  fn readInto(&self, buffer: &mut [u8]) -> bool;
  fn read(&self, amount: u64) -> ~[u8];
  fn write(&self, data: &[u8]);
  fn append(&self, data: &[u8]);

  fn seek(&self, amount: i64);
  fn length(&self) -> u64;
  fn available(&self) -> u64;
  fn position(&self) -> u64;
}

pub enum Access {
  Read = 1,
  Write = 2,
  ReadWrite = 3,
  Executable = 4,
  ReadExecutable = 5,
  WriteExecutable = 6,
  ReadWriteExecutable = 7
}

pub enum Result {
  Reader(~Readable),
  Writer(~Writable),
  Stream(~Streamable),
  Error(u64)
}
