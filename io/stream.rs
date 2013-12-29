#[link(name = "io-stream", vers = "1.0", package_id = "io-stream")];

pub trait Readable {
  fn readInto(&mut self, buffer: &mut [u8]) -> bool;
  fn readIntoPtr(&mut self, buf_p: *mut u8, amount: u64) -> bool;
  fn read(&mut self, amount: u64) -> ~[u8];

  fn seek(&mut self, amount: i64);
  fn length(&self) -> u64;
  fn available(&self) -> u64;
  fn position(&self) -> u64;
}

pub trait Writable {
  fn write(&mut self, data: &[u8]);
  fn writeFromPtr(&mut self, buf_p: *u8, amount: u64);
  fn append(&mut self, data: &[u8]);

  fn seek(&mut self, amount: i64);
  fn length(&self) -> u64;
  fn available(&self) -> u64;
  fn position(&self) -> u64;
}

pub trait Streamable {
  fn readInto(&mut self, buffer: &mut [u8]) -> bool;
  fn readIntoPtr(&mut self, buf_p: *mut u8, amount: u64) -> bool;
  fn read(&mut self, amount: u64) -> ~[u8];
  fn write(&mut self, data: &[u8]);
  fn writeFromPtr(&mut self, buf_p: *u8, amount: u64);
  fn append(&mut self, data: &[u8]);

  fn seek(&mut self, amount: i64);
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
