#[link(name = "io-file", vers = "1.0", package_id = "io-file")];

use std::vec;
use std::libc;

#[path = ".libs/io"]
mod io {
  extern mod stream  = "io-stream";
  extern mod console = "io-console";
}

struct File {
  descriptor: u64
}

pub fn create(filename: &str, access: io::stream::Access) -> ~io::stream::Result {
  let fd = unsafe {
    filename.to_c_str().with_ref(|pathbuf| {
      "w+b".to_c_str().with_ref(|modebuf| {
        libc::fopen(pathbuf, modebuf)
      })
    })
  } as u64;

  let file = ~File {
    descriptor: fd
  };

  if fd == -1 {
    ~io::stream::Error(0)
  }
  else {
    match access {
      io::stream::Read => ~io::stream::Reader(file as ~io::stream::Readable),
      io::stream::Write => ~io::stream::Writer(file as ~io::stream::Writable),
      io::stream::ReadWrite => ~io::stream::Stream(file as ~io::stream::Streamable),
      io::stream::Executable => ~io::stream::Reader(file as ~io::stream::Readable),
      io::stream::ReadExecutable => ~io::stream::Reader(file as ~io::stream::Readable),
      io::stream::WriteExecutable => ~io::stream::Writer(file as ~io::stream::Writable),
      io::stream::ReadWriteExecutable => ~io::stream::Stream(file as ~io::stream::Streamable)
    }
  }
}

pub fn open(filename: &str, access: io::stream::Access) -> ~io::stream::Result {
  let fd = unsafe {
    let access_str = match(access) {
      io::stream::Read => "rb",
      io::stream::Write => "wb",
      io::stream::ReadWrite => "r+b",
      io::stream::Executable => "rb",
      io::stream::ReadExecutable => "rb",
      io::stream::WriteExecutable => "wb",
      io::stream::ReadWriteExecutable => "r+b"
    };

    filename.to_c_str().with_ref(|pathbuf| {
      access_str.to_c_str().with_ref(|modebuf| {
        libc::fopen(pathbuf, modebuf)
      })
    })
  } as u64;

  let file = ~File {
    descriptor: fd
  };

  if fd == 0 {
    ~io::stream::Error(0)
  }
  else {
    match access {
      io::stream::Read => ~io::stream::Reader(file as ~io::stream::Readable),
      io::stream::Write => ~io::stream::Writer(file as ~io::stream::Writable),
      io::stream::ReadWrite => ~io::stream::Stream(file as ~io::stream::Streamable),
      io::stream::Executable => ~io::stream::Reader(file as ~io::stream::Readable),
      io::stream::ReadExecutable => ~io::stream::Reader(file as ~io::stream::Readable),
      io::stream::WriteExecutable => ~io::stream::Writer(file as ~io::stream::Writable),
      io::stream::ReadWriteExecutable => ~io::stream::Stream(file as ~io::stream::Streamable)
    }
  }
}

impl Drop for File {
  fn drop(&mut self) {
    unsafe {
      libc::fclose(self.descriptor as *libc::FILE);
    }
  }
}

impl io::stream::Readable for File {
  // TODO: Errorable Option Type should be returned
  fn readInto(&mut self, buffer: &mut [u8]) -> bool {
    buffer.as_mut_buf(|buf_p, buf_len| {
      self.readIntoPtr(buf_p, buf_len as u64)
    })
  }

  fn readIntoPtr(&mut self, buf_p: *mut u8, amount: u64) -> bool {
    unsafe {
      let count = libc::fread(buf_p as *mut libc::c_void,
                              1u as libc::size_t,
                              amount as libc::size_t,
                              self.descriptor as *libc::FILE);

      count == amount
    }
  }

  fn read(&mut self, amount: u64) -> ~[u8] {
    let mut vector = vec::with_capacity(amount as uint);
    unsafe { vec::raw::set_len(&mut vector, amount as uint); }
    (self as &mut io::stream::Readable).readInto(vector);
    vector
  }

  fn seek(&mut self, amount: i64) {
    unsafe {
      libc::fseek(self.descriptor as *libc::FILE,
                  amount as libc::c_long,
                  1 /* SEEK_CUR */);
    }
  }

  fn length(&self) -> u64 {
    let tell =
      unsafe {
        libc::ftell(self.descriptor as *libc::FILE)
      };

    let ret =
      unsafe {
        libc::fseek(self.descriptor as *libc::FILE,
                    0,
                    2 /* SEEK_END */);
        libc::ftell(self.descriptor as *libc::FILE) as u64
      };

    unsafe {
      libc::fseek(self.descriptor as *libc::FILE,
                  tell,
                  0 /* SEEK_SET */);
    }

    ret as u64
  }

  fn available(&self) -> u64 {
    (self as &io::stream::Readable).length() - (self as &io::stream::Readable).position()
  }

  fn position(&self) -> u64 {
    unsafe {
      libc::ftell(self.descriptor as *libc::FILE) as u64
    }
  }
}

impl io::stream::Writable for File {
  fn write(&mut self, data: &[u8]) {
    data.as_imm_buf(|vbuf, len| {
      self.writeFromPtr(vbuf, len as u64);
    });
  }

  fn writeFromPtr(&mut self, buf_p: *u8, amount: u64) {
    unsafe {
      let nout = libc::fwrite(buf_p as *libc::c_void,
                              1,
                              amount as libc::size_t,
                              self.descriptor as *libc::FILE);
      if nout != amount as libc::size_t {
        // Error
      }
    }
  }

  fn append(&mut self, data: &[u8]) {
    let typed = self as &mut io::stream::Writable;
    let available = typed.available() as i64;
    typed.seek(available);
    typed.write(data);

    let back = available + data.len() as i64;
    typed.seek(-back);
  }

  fn seek(&mut self, amount: i64) {
    unsafe {
      libc::fseek(self.descriptor as *libc::FILE,
                  amount as libc::c_long,
                  1 /* SEEK_CUR */);
    }
  }

  fn length(&self) -> u64 {
    let tell =
      unsafe {
        libc::ftell(self.descriptor as *libc::FILE)
      };

    let ret =
      unsafe {
        libc::fseek(self.descriptor as *libc::FILE,
                    0,
                    2 /* SEEK_END */);
        libc::ftell(self.descriptor as *libc::FILE) as u64
      };

    unsafe {
      libc::fseek(self.descriptor as *libc::FILE,
                  tell,
                  0 /* SEEK_SET */);
    }

    ret as u64
  }

  fn available(&self) -> u64 {
    (self as &io::stream::Writable).length() - (self as &io::stream::Writable).position()
  }

  fn position(&self) -> u64 {
    unsafe {
      libc::ftell(self.descriptor as *libc::FILE) as u64
    }
  }
}

impl File {
  pub fn stream(&self) -> ~io::stream::Streamable {
    ~File {
      descriptor: self.descriptor
    } as ~io::stream::Streamable
  }

  pub fn reader(&self) -> ~io::stream::Readable {
    ~File {
      descriptor: self.descriptor
    } as ~io::stream::Readable
  }

  pub fn writer(&self) -> ~io::stream::Writable {
    ~File {
      descriptor: self.descriptor
    } as ~io::stream::Writable
  }

  // TODO: Errorable Option Type should be returned
  pub fn readInto(&mut self, buffer: &mut [u8]) -> bool {
    buffer.as_mut_buf(|buf_p, buf_len| {
      self.readIntoPtr(buf_p, buf_len as u64)
    })
  }

  pub fn readIntoPtr(&mut self, buf_p: *mut u8, amount: u64) -> bool {
    unsafe {
      let count = libc::fread(buf_p as *mut libc::c_void,
                              1u as libc::size_t,
                              amount as libc::size_t,
                              self.descriptor as *libc::FILE);

      count == amount
    }
  }

  pub fn read(&mut self, amount: u64) -> ~[u8] {
    let mut vector = vec::with_capacity(amount as uint);
    unsafe { vec::raw::set_len(&mut vector, amount as uint); }
    self.readInto(vector);
    vector
  }

  pub fn seek(&mut self, amount: i64) {
    unsafe {
      libc::fseek(self.descriptor as *libc::FILE,
                  amount as libc::c_long,
                  1 /* SEEK_CUR */);
    }
  }

  pub fn length(&self) -> u64 {
    let tell =
      unsafe {
        libc::ftell(self.descriptor as *libc::FILE)
      };

    let ret =
      unsafe {
        libc::fseek(self.descriptor as *libc::FILE,
                    0,
                    2 /* SEEK_END */);
        libc::ftell(self.descriptor as *libc::FILE) as u64
      };

    unsafe {
      libc::fseek(self.descriptor as *libc::FILE,
                  tell,
                  0 /* SEEK_SET */);
    }

    ret as u64
  }

  pub fn available(&self) -> u64 {
    self.length() - (self as &io::stream::Readable).position()
  }

  pub fn position(&self) -> u64 {
    unsafe {
      libc::ftell(self.descriptor as *libc::FILE) as u64
    }
  }

  pub fn write(&mut self, data: &[u8]) {
    data.as_imm_buf(|vbuf, len| {
      self.writeFromPtr(vbuf, len as u64);
    });
  }

  pub fn writeFromPtr(&mut self, buf_p: *u8, amount: u64) {
    unsafe {
      let nout = libc::fwrite(buf_p as *libc::c_void,
                              1,
                              amount as libc::size_t,
                              self.descriptor as *libc::FILE);
      if nout != amount as libc::size_t {
        // Error
      }
    }
  }

  pub fn append(&mut self, data: &[u8]) {
    let available = self.available() as i64;
    self.seek(available);
    self.write(data);

    let back = available + data.len() as i64;
    self.seek(-back);
  }
}

impl io::stream::Streamable for File {
  // TODO: Errorable Option Type should be returned
  fn readInto(&mut self, buffer: &mut [u8]) -> bool {
    buffer.as_mut_buf(|buf_p, buf_len| {
      self.readIntoPtr(buf_p, buf_len as u64)
    })
  }

  fn readIntoPtr(&mut self, buf_p: *mut u8, amount: u64) -> bool {
    unsafe {
      let count = libc::fread(buf_p as *mut libc::c_void,
                              1u as libc::size_t,
                              amount as libc::size_t,
                              self.descriptor as *libc::FILE);

      count == amount
    }
  }

  fn read(&mut self, amount: u64) -> ~[u8] {
    let mut vector = vec::with_capacity(amount as uint);
    unsafe { vec::raw::set_len(&mut vector, amount as uint); }
    (self as &mut io::stream::Streamable).readInto(vector);
    vector
  }

  fn seek(&mut self, amount: i64) {
    unsafe {
      libc::fseek(self.descriptor as *libc::FILE,
                  amount as libc::c_long,
                  1 /* SEEK_CUR */);
    }
  }

  fn length(&self) -> u64 {
    let tell =
      unsafe {
        libc::ftell(self.descriptor as *libc::FILE)
      };

    let ret =
      unsafe {
        libc::fseek(self.descriptor as *libc::FILE,
                    0,
                    2 /* SEEK_END */);
        libc::ftell(self.descriptor as *libc::FILE) as u64
      };

    unsafe {
      libc::fseek(self.descriptor as *libc::FILE,
                  tell,
                  0 /* SEEK_SET */);
    }

    ret as u64
  }

  fn available(&self) -> u64 {
    (self as &io::stream::Streamable).length() - (self as &io::stream::Readable).position()
  }

  fn position(&self) -> u64 {
    unsafe {
      libc::ftell(self.descriptor as *libc::FILE) as u64
    }
  }

  fn write(&mut self, data: &[u8]) {
    data.as_imm_buf(|vbuf, len| {
      self.writeFromPtr(vbuf, len as u64);
    });
  }

  fn writeFromPtr(&mut self, buf_p: *u8, amount: u64) {
    unsafe {
      let nout = libc::fwrite(buf_p as *libc::c_void,
                              1,
                              amount as libc::size_t,
                              self.descriptor as *libc::FILE);
      if nout != amount as libc::size_t {
        // Error
      }
    }
  }

  fn append(&mut self, data: &[u8]) {
    let typed = self as &mut io::stream::Streamable;
    let available = typed.available() as i64;
    typed.seek(available);
    typed.write(data);

    let back = available + data.len() as i64;
    typed.seek(-back);
  }
}
