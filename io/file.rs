#[link(name = "file", vers = "1.0")];

use std::vec;
use std::libc;

mod io {
  extern mod stream;
  extern mod console;
}

struct File {
  descriptor: u64
}

pub fn create(filename: &str, access: io::stream::Access) -> ~io::stream::Result {
  let fd = unsafe {
    do filename.to_c_str().with_ref |pathbuf| {
      do "w+b".to_c_str().with_ref |modebuf| {
        libc::fopen(pathbuf, modebuf)
      }
    }
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

    do filename.to_c_str().with_ref |pathbuf| {
      do access_str.to_c_str().with_ref |modebuf| {
        libc::fopen(pathbuf, modebuf)
      }
    }
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
  pub fn drop(&self) {
    unsafe { libc::fclose(self.descriptor as *libc::FILE); };
  }
}

impl io::stream::Readable for File {
  // TODO: Errorable Option Type should be returned
  pub fn readInto(&self, buffer: &mut [u8]) -> bool {
    unsafe {
      do buffer.as_mut_buf() |buf_p, buf_len| {
        let count = libc::fread(buf_p as *mut libc::c_void,
                                1u as libc::size_t,
                                buf_len as libc::size_t,
                                self.descriptor as *libc::FILE);

        count == (buf_len as u64)
      }
    }
  }

  pub fn read(&self, amount: u64) -> ~[u8] {
    let mut vector = vec::with_capacity(amount as uint);
    unsafe { vec::raw::set_len(&mut vector, amount as uint); }
    (self as &io::stream::Readable).readInto(vector);
    vector
  }

  pub fn seek(&self, amount: i64) {
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
    (self as &io::stream::Readable).length() - (self as &io::stream::Readable).position()
  }

  pub fn position(&self) -> u64 {
    unsafe {
      libc::ftell(self.descriptor as *libc::FILE) as u64
    }
  }
}

impl io::stream::Writable for File {
  pub fn write(&self, data: &[u8]) {
    unsafe {
      do data.as_imm_buf() |vbuf, len| {
        let nout = libc::fwrite(vbuf as *libc::c_void,
                                1,
                                len as libc::size_t,
                                self.descriptor as *libc::FILE);
        if nout != len as libc::size_t {
          // Error
        }
      }
    }
  }

  pub fn append(&self, data: &[u8]) {
    let typed = self as &io::stream::Writable;
    let available = typed.available() as i64;
    typed.seek(available);
    typed.write(data);

    let back = available + data.len() as i64;
    typed.seek(-back);
  }

  pub fn seek(&self, amount: i64) {
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
    (self as &io::stream::Writable).length() - (self as &io::stream::Writable).position()
  }

  pub fn position(&self) -> u64 {
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
  pub fn readInto(&self, buffer: &mut [u8]) -> bool {
    unsafe {
      do buffer.as_mut_buf() |buf_p, buf_len| {
        let count = libc::fread(buf_p as *mut libc::c_void,
                                1u as libc::size_t,
                                buf_len as libc::size_t,
                                self.descriptor as *libc::FILE);

        count == (buf_len as u64)
      }
    }
  }

  pub fn read(&self, amount: u64) -> ~[u8] {
    let mut vector = vec::with_capacity(amount as uint);
    unsafe { vec::raw::set_len(&mut vector, amount as uint); }
    self.readInto(vector);
    vector
  }

  pub fn seek(&self, amount: i64) {
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

  pub fn write(&self, data: &[u8]) {
    unsafe {
      do data.as_imm_buf() |vbuf, len| {
        let nout = libc::fwrite(vbuf as *libc::c_void,
                                1,
                                len as libc::size_t,
                                self.descriptor as *libc::FILE);
        if nout != len as libc::size_t {
          // Error
        }
      }
    }
  }

  pub fn append(&self, data: &[u8]) {
    let available = self.available() as i64;
    self.seek(available);
    self.write(data);

    let back = available + data.len() as i64;
    self.seek(-back);
  }
}

impl io::stream::Streamable for File {
  // TODO: Errorable Option Type should be returned
  pub fn readInto(&self, buffer: &mut [u8]) -> bool {
    unsafe {
      do buffer.as_mut_buf() |buf_p, buf_len| {
        let count = libc::fread(buf_p as *mut libc::c_void,
                                1u as libc::size_t,
                                buf_len as libc::size_t,
                                self.descriptor as *libc::FILE);

        count == (buf_len as u64)
      }
    }
  }

  pub fn read(&self, amount: u64) -> ~[u8] {
    let mut vector = vec::with_capacity(amount as uint);
    unsafe { vec::raw::set_len(&mut vector, amount as uint); }
    (self as &io::stream::Streamable).readInto(vector);
    vector
  }

  pub fn seek(&self, amount: i64) {
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
    (self as &io::stream::Streamable).length() - (self as &io::stream::Readable).position()
  }

  pub fn position(&self) -> u64 {
    unsafe {
      libc::ftell(self.descriptor as *libc::FILE) as u64
    }
  }

  pub fn write(&self, data: &[u8]) {
    unsafe {
      do data.as_imm_buf() |vbuf, len| {
        let nout = libc::fwrite(vbuf as *libc::c_void,
                                1,
                                len as libc::size_t,
                                self.descriptor as *libc::FILE);
        if nout != len as libc::size_t {
          // Error
        }
      }
    }
  }

  pub fn append(&self, data: &[u8]) {
    let typed = self as &io::stream::Streamable;
    let available = typed.available() as i64;
    typed.seek(available);
    typed.write(data);

    let back = available + data.len() as i64;
    typed.seek(-back);
  }
}
