#[link(name = "io-buffer", vers = "1.0", package_id = "io-buffer")];

use std::ptr;
use std::vec;

mod io {
  extern mod stream = "io-stream";
}

pub struct Buffer {
  data:     ~[u8],
  length:   u64,
  position: u64,
}

pub fn create(capacity: u64) -> ~Buffer {
  ~Buffer {
    data: vec::with_capacity(capacity as uint),
    length: 0,
    position: 0
  }
}

impl Buffer {
  pub fn reader<'a>(&'a mut self) -> &'a mut io::stream::Readable {
    self as &'a mut io::stream::Readable
  }

  pub fn writer<'a>(&'a mut self) -> &'a mut io::stream::Writable {
    self as &'a mut io::stream::Writable
  }

  pub fn stream<'a>(&'a mut self) -> &'a mut io::stream::Streamable {
    self as &'a mut io::stream::Streamable
  }

  pub fn imm_reader<'a>(&'a self) -> &'a io::stream::Readable {
    self as &'a io::stream::Readable
  }

  pub fn imm_writer<'a>(&'a self) -> &'a io::stream::Writable {
    self as &'a io::stream::Writable
  }

  pub fn imm_stream<'a>(&'a self) -> &'a io::stream::Streamable {
    self as &'a io::stream::Streamable
  }
}

impl io::stream::Readable for Buffer {
  fn readInto(&mut self, buffer: &mut [u8]) -> bool {
    buffer.as_mut_buf(|buf_p, amount| {
      self.readIntoPtr(buf_p, amount as u64)
    })
  }

  fn readIntoPtr(&mut self, buf_p: *mut u8, amount: u64) -> bool {
    if (self.available() < amount) {
      return false;
    }

    unsafe {
      ptr::copy_memory(buf_p, &self.data as *u8, amount as uint);
    }

    self.position += amount;
    true
  }

  fn read(&mut self, amount: u64) -> ~[u8] {
    let ret = self.data.slice(self.position as uint, amount as uint);

    self.position += amount;

    ret.to_owned()
  }

  fn seek(&mut self, amount: i64) {
    if (amount < 0) {
      self.position -= ((-amount) as u64);
    }
    else if (amount as u64 > self.position) {
      self.position = 0;
    }
    else {
      self.position += amount as u64;
    }
  }

  fn length(&self) -> u64 {
    self.length
  }

  fn available(&self) -> u64 {
    self.length - self.position
  }

  fn position(&self) -> u64 {
    self.position
  }
}

impl io::stream::Writable for Buffer {
  fn write(&mut self, buffer: &[u8]) {
    self.writeFromPtr(&buffer[0] as *u8, buffer.len() as u64);
  }

  fn writeFromPtr(&mut self, buf_p: *u8, amount: u64) {
    self.data.mut_slice_from(self.position as uint).as_mut_buf(|data_p, _| {
      unsafe {
        ptr::copy_memory(data_p, buf_p, amount as uint);
      }
    });

    self.position += amount;
  }

  fn append(&mut self, buffer: &[u8]) {
    self.data.mut_slice_from(self.length as uint).as_mut_buf(|data_p, _| {
      unsafe {
        ptr::copy_memory(data_p, &buffer[0] as *u8, buffer.len());
      }
    });

    self.position += buffer.len() as u64;
  }

  fn seek(&mut self, amount: i64) {
    if (amount < 0) {
      self.position -= ((-amount) as u64);
    }
    else if (amount as u64 > self.position) {
      self.position = 0;
    }
    else {
      self.position += amount as u64;
    }
  }

  fn length(&self) -> u64 {
    self.length
  }

  fn available(&self) -> u64 {
    self.length - self.position
  }

  fn position(&self) -> u64 {
    self.position
  }
}

impl io::stream::Streamable for Buffer {
  fn readInto(&mut self, buffer: &mut [u8]) -> bool {
    buffer.as_mut_buf(|buf_p, amount| {
      self.readIntoPtr(buf_p, amount as u64)
    })
  }

  fn readIntoPtr(&mut self, buf_p: *mut u8, amount: u64) -> bool {
    if (self.available() < amount) {
      return false;
    }

    unsafe {
      ptr::copy_memory(buf_p, &self.data as *u8, amount as uint);
    }

    self.position += amount;
    true
  }

  fn read(&mut self, amount: u64) -> ~[u8] {
    let ret = self.data.slice(self.position as uint, amount as uint);

    self.position += amount;

    ret.to_owned()
  }

  fn write(&mut self, buffer: &[u8]) {
    self.writeFromPtr(&buffer[0] as *u8, buffer.len() as u64);
  }

  fn writeFromPtr(&mut self, buf_p: *u8, amount: u64) {
    self.data.mut_slice_from(self.position as uint).as_mut_buf(|data_p, _| {
      unsafe {
        ptr::copy_memory(data_p, buf_p, amount as uint);
      }
    });

    self.position += amount;
  }

  fn append(&mut self, buffer: &[u8]) {
    self.data.mut_slice_from(self.length as uint).as_mut_buf(|data_p, _| {
      unsafe {
        ptr::copy_memory(data_p, &buffer[0] as *u8, buffer.len());
      }
    });

    self.position += buffer.len() as u64;
  }

  fn seek(&mut self, amount: i64) {
    if (amount < 0) {
      self.position -= ((-amount) as u64);
    }
    else if (amount as u64 > self.position) {
      self.position = 0;
    }
    else {
      self.position += amount as u64;
    }
  }

  fn length(&self) -> u64 {
    self.length
  }

  fn available(&self) -> u64 {
    self.length - self.position
  }

  fn position(&self) -> u64 {
    self.position
  }
}
