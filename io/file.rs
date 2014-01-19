#[crate_id="io-file#1.0"];
extern mod io_stream  = "io-stream";
extern mod io_console = "io-console";

pub mod io {
  pub mod file {
    use std::vec;
    use std::libc;
    use io_stream::io::stream::{Read, Write, ReadWrite, Executable, ReadExecutable, WriteExecutable, ReadWriteExecutable};

    pub struct File {
      descriptor: u64
    }

    pub fn create(filename: &str, access: ::io_stream::io::stream::Access) -> ~::io_stream::io::stream::Result {
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
        ~::io_stream::io::stream::Error(0)
      }
      else {
        match access {
          Read => ~::io_stream::io::stream::Reader(file as ~::io_stream::io::stream::Readable),
          Write => ~::io_stream::io::stream::Writer(file as ~::io_stream::io::stream::Writable),
          ReadWrite => ~::io_stream::io::stream::Stream(file as ~::io_stream::io::stream::Streamable),
          Executable => ~::io_stream::io::stream::Reader(file as ~::io_stream::io::stream::Readable),
          ReadExecutable => ~::io_stream::io::stream::Reader(file as ~::io_stream::io::stream::Readable),
          WriteExecutable => ~::io_stream::io::stream::Writer(file as ~::io_stream::io::stream::Writable),
          ReadWriteExecutable => ~::io_stream::io::stream::Stream(file as ~::io_stream::io::stream::Streamable)
        }
      }
    }

    pub fn open(filename: &str, access: ::io_stream::io::stream::Access) -> ~::io_stream::io::stream::Result {
      let fd = unsafe {
        let access_str = match(access) {
          Read => "rb",
          Write => "wb",
          ReadWrite => "r+b",
          Executable => "rb",
          ReadExecutable => "rb",
          WriteExecutable => "wb",
          ReadWriteExecutable => "r+b"
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
        ~::io_stream::io::stream::Error(0)
      }
      else {
        match access {
          Read => ~::io_stream::io::stream::Reader(file as ~::io_stream::io::stream::Readable),
          Write => ~::io_stream::io::stream::Writer(file as ~::io_stream::io::stream::Writable),
          ReadWrite => ~::io_stream::io::stream::Stream(file as ~::io_stream::io::stream::Streamable),
          Executable => ~::io_stream::io::stream::Reader(file as ~::io_stream::io::stream::Readable),
          ReadExecutable => ~::io_stream::io::stream::Reader(file as ~::io_stream::io::stream::Readable),
          WriteExecutable => ~::io_stream::io::stream::Writer(file as ~::io_stream::io::stream::Writable),
          ReadWriteExecutable => ~::io_stream::io::stream::Stream(file as ~::io_stream::io::stream::Streamable)
        }
      }
    }

    impl File {
      pub fn stream(&self) -> ~::io_stream::io::stream::Streamable {
        ~File {
          descriptor: self.descriptor
        } as ~::io_stream::io::stream::Streamable
      }

      pub fn reader(&self) -> ~::io_stream::io::stream::Readable {
        ~File {
          descriptor: self.descriptor
        } as ~::io_stream::io::stream::Readable
      }

      pub fn writer(&self) -> ~::io_stream::io::stream::Writable {
        ~File {
          descriptor: self.descriptor
        } as ~::io_stream::io::stream::Writable
      }

      // TODO: Errorable Option Type should be returned
      pub fn readInto(&mut self, buffer: &mut [u8]) -> bool {
        let buf_p = buffer.as_mut_ptr();
        let buf_len = buffer.len();
        self.readIntoPtr(buf_p, buf_len as u64)
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
        unsafe { vector.set_len(amount as uint); }
        self.readInto(vector);
        vector
      }

      pub fn readAll(&mut self) -> ~[u8] {
        let amount = self.available();
        self.read(amount)
      }

      pub fn seekTo(&mut self, position: u64) {
        unsafe {
          libc::fseek(self.descriptor as *libc::FILE,
                      position as libc::c_long,
                      0 /* SEEK_SET */);
        }
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
        self.length() - (self as &::io_stream::io::stream::Readable).position()
      }

      pub fn position(&self) -> u64 {
        unsafe {
          libc::ftell(self.descriptor as *libc::FILE) as u64
        }
      }

      pub fn write(&mut self, data: &[u8]) {
        let vbuf = data.as_ptr();
        let len = data.len();
        self.writeFromPtr(vbuf, len as u64);
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

      pub fn seekable(&self) -> bool {
        true
      }

      pub fn persistent(&self) -> bool {
        true
      }
    }

    impl Drop for File {
      fn drop(&mut self) {
        unsafe {
          libc::fclose(self.descriptor as *libc::FILE);
        }
      }
    }

    impl ::io_stream::io::stream::Readable for File {
      fn readInto(&mut self, buffer: &mut [u8]) -> bool {
        self.readInto(buffer)
      }

      fn readIntoPtr(&mut self, buf_p: *mut u8, amount: u64) -> bool {
        self.readIntoPtr(buf_p, amount)
      }

      fn read(&mut self, amount: u64) -> ~[u8] {
        self.read(amount)
      }

      fn readAll(&mut self) -> ~[u8] {
        self.readAll()
      }

      fn seekTo(&mut self, position: u64) {
        self.seekTo(position)
      }

      fn seek(&mut self, amount: i64) {
        self.seek(amount)
      }

      fn length(&self) -> u64 {
        self.length()
      }

      fn available(&self) -> u64 {
        self.available()
      }

      fn position(&self) -> u64 {
        self.position()
      }

      fn seekable(&self) -> bool {
        self.seekable()
      }

      fn persistent(&self) -> bool {
        self.persistent()
      }
    }

    impl ::io_stream::io::stream::Writable for File {
      fn write(&mut self, data: &[u8]) {
        self.write(data)
      }

      fn writeFromPtr(&mut self, buf_p: *u8, amount: u64) {
        self.writeFromPtr(buf_p, amount)
      }

      fn writeFromReader(&mut self, data: &mut ::io_stream::io::stream::Readable, amount: u64) {
        self.write(data.read(amount));
      }

      fn writeFromStream(&mut self, data: &mut ::io_stream::io::stream::Streamable, amount: u64) {
        self.write(data.read(amount));
      }

      fn append(&mut self, data: &[u8]) {
        self.append(data)
      }

      fn appendFromPtr(&mut self, buf_p: *u8, amount: u64) {
        self.appendFromPtr(buf_p, amount)
      }

      fn appendFromReader(&mut self, data: &mut ::io_stream::io::stream::Readable, amount: u64) {
        self.appendFromReader(data, amount)
      }

      fn appendFromStream(&mut self, data: &mut ::io_stream::io::stream::Streamable, amount: u64) {
        self.appendFromStream(data, amount)
      }

      fn seekTo(&mut self, position: u64) {
        self.seekTo(position)
      }

      fn seek(&mut self, amount: i64) {
        self.seek(amount)
      }

      fn length(&self) -> u64 {
        self.length()
      }

      fn available(&self) -> u64 {
        self.available()
      }

      fn position(&self) -> u64 {
        self.position()
      }

      fn seekable(&self) -> bool {
        self.seekable()
      }

      fn persistent(&self) -> bool {
        self.persistent()
      }
    }

    impl ::io_stream::io::stream::Streamable for File {
      fn readInto(&mut self, buffer: &mut [u8]) -> bool {
        self.readInto(buffer)
      }

      fn readIntoPtr(&mut self, buf_p: *mut u8, amount: u64) -> bool {
        self.readIntoPtr(buf_p, amount)
      }

      fn read(&mut self, amount: u64) -> ~[u8] {
        self.read(amount)
      }

      fn readAll(&mut self) -> ~[u8] {
        self.readAll()
      }

      fn seekTo(&mut self, position: u64) {
        self.seekTo(position)
      }

      fn seek(&mut self, amount: i64) {
        self.seek(amount)
      }

      fn length(&self) -> u64 {
        self.length()
      }

      fn available(&self) -> u64 {
        self.available()
      }

      fn position(&self) -> u64 {
        self.position()
      }

      fn write(&mut self, data: &[u8]) {
        self.write(data)
      }

      fn writeFromReader(&mut self, data: &mut ::io_stream::io::stream::Readable, amount: u64) {
        self.writeFromReader(data, amount)
      }

      fn writeFromStream(&mut self, data: &mut ::io_stream::io::stream::Streamable, amount: u64) {
        self.writeFromStream(data, amount)
      }

      fn writeFromPtr(&mut self, buf_p: *u8, amount: u64) {
        self.writeFromPtr(buf_p, amount)
      }

      fn append(&mut self, data: &[u8]) {
        self.append(data)
      }

      fn appendFromPtr(&mut self, buf_p: *u8, amount: u64) {
        self.appendFromPtr(buf_p, amount)
      }

      fn appendFromReader(&mut self, data: &mut ::io_stream::io::stream::Readable, amount: u64) {
        self.appendFromReader(data, amount);
      }

      fn appendFromStream(&mut self, data: &mut ::io_stream::io::stream::Streamable, amount: u64) {
        self.appendFromStream(data, amount);
      }

      fn seekable(&self) -> bool {
        self.seekable()
      }

      fn persistent(&self) -> bool {
        self.persistent()
      }
    }
  }
}
