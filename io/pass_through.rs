#[crate_id="io-pass_through#1.0"];
extern mod io_stream = "io-stream";

pub mod io {
  pub mod pass_through {
    use std::rc::Rc;
    use std::vec;

    pub enum Streams {
      Reader(~::io_stream::io::stream::Readable),
      Writer(~::io_stream::io::stream::Writable),
      Stream(~::io_stream::io::stream::Streamable),
      None
    }

    pub struct PassThrough {
      data: Streams,
      length: u64,
      position: u64,

      regionIndex: u64,

      starts: ~[u64],
      lengths: ~[u64],
      positions: ~[u64],
    }

    pub fn create() -> ~PassThrough {
      ~PassThrough {
        data: None,
        length: 0,
        position: 0,

        regionIndex: 0,

        starts: ~[],
        lengths: ~[],
        positions: ~[],
      }
    }

    pub fn createWithStream(stream: ~::io_stream::io::stream::Streamable) -> ~PassThrough {
      ~PassThrough {
        data: Stream(stream),
        length: 0,
        position: 0,

        regionIndex: 0,

        starts: ~[],
        lengths: ~[],
        positions: ~[],
      }
    }

    pub fn createWithWriter(stream: ~::io_stream::io::stream::Writable) -> ~PassThrough {
      ~PassThrough {
        data: Writer(stream),
        length: 0,
        position: 0,

        regionIndex: 0,

        starts: ~[],
        lengths: ~[],
        positions: ~[],
      }
    }

    pub fn createWithReader(stream: ~::io_stream::io::stream::Readable) -> ~PassThrough {
      ~PassThrough {
        data: Reader(stream),
        length: 0,
        position: 0,

        regionIndex: 0,

        starts: ~[],
        lengths: ~[],
        positions: ~[],
      }
    }

    impl PassThrough {
      pub fn reader<'a>(&'a mut self) -> &'a mut ::io_stream::io::stream::Readable {
        self as &'a mut ::io_stream::io::stream::Readable
      }

      pub fn writer<'a>(&'a mut self) -> &'a mut ::io_stream::io::stream::Writable {
        self as &'a mut ::io_stream::io::stream::Writable
      }

      pub fn stream<'a>(&'a mut self) -> &'a mut ::io_stream::io::stream::Streamable {
        self as &'a mut ::io_stream::io::stream::Streamable
      }

      pub fn imm_reader<'a>(&'a self) -> &'a ::io_stream::io::stream::Readable {
        self as &'a ::io_stream::io::stream::Readable
      }

      pub fn imm_writer<'a>(&'a self) -> &'a ::io_stream::io::stream::Writable {
        self as &'a ::io_stream::io::stream::Writable
      }

      pub fn imm_stream<'a>(&'a self) -> &'a ::io_stream::io::stream::Streamable {
        self as &'a ::io_stream::io::stream::Streamable
      }

      fn regionLength(&self) -> u64 {
        if self.regionIndex >= self.lengths.len() as u64 {
          0
        }
        else {
          self.lengths[self.regionIndex]
        }
      }

      fn regionPosition(&self) -> u64 {
        if self.regionIndex >= self.positions.len() as u64 {
          0
        }
        else {
          self.position - self.positions[self.regionIndex]
        }
      }

      fn regionAvailable(&self) -> u64 {
        self.regionLength() - self.regionPosition()
      }

      pub fn useRegion(&mut self, start: u64, length: u64) {
        self.starts.push(start);
        self.lengths.push(length);
        self.positions.push(self.length);
        self.length += length;
      }

      pub fn readInto<'a>(&'a mut self, buffer: &mut [u8]) -> bool {
        let buf_p = buffer.as_mut_ptr();
        let amount = buffer.len();
        self.readIntoPtr(buf_p, amount as u64)
      }

      pub fn readIntoPtr<'a>(&'a mut self, buf_p: *mut u8, amount: u64) -> bool {
        if amount > self.available() {
          return false;
        }

        match self.data {
          Stream(_) |
          Reader(_) => {
            let mut ptr      = buf_p;
            let mut to_read  = amount;
            let mut num_read = 0;

            while (to_read > 0) {
              let old_pos =
                match self.data {
                  Stream(ref s) => s.position(),
                  Reader(ref s) => s.position(),
                  _ => 0
                };
              let regionPosition  = self.regionPosition();
              let regionAvailable = self.regionAvailable();

              match self.data {
                Stream(ref mut s) =>
                  s.seekTo(self.starts[self.regionIndex] + regionPosition),
                Reader(ref mut s) =>
                  s.seekTo(self.starts[self.regionIndex] + regionPosition),
                Writer(ref mut s) =>
                  s.seekTo(self.starts[self.regionIndex] + regionPosition),
                _ => {}
              };

              if to_read >= regionAvailable {
                // Grab all within the region
                match self.data {
                  Stream(ref mut s) => s.readIntoPtr(ptr, regionAvailable),
                  Reader(ref mut s) => s.readIntoPtr(ptr, regionAvailable),
                  _ => false
                };

                num_read += regionAvailable;
                to_read  -= regionAvailable;
                ptr       = ((ptr as u64) + regionAvailable) as *mut u8;

                self.position += regionAvailable;

                self.regionIndex += 1;
              }
              else {
                match self.data {
                  Stream(ref mut s) => s.readIntoPtr(ptr, amount),
                  Reader(ref mut s) => s.readIntoPtr(ptr, amount),
                  _ => false
                };

                self.position += amount;
                to_read = 0;
              }

              self.seekTo(old_pos);
            }

            true
          },
          _ => false
        }
      }

      pub fn read<'a>(&'a mut self, amount: u64) -> ~[u8] {
        // slice, if we can
        if amount <= self.regionAvailable() {
          let old_pos =
            match self.data {
              Stream(ref s) => s.position(),
              Reader(ref s) => s.position(),
              _ => 0
            };
          let regionPosition = self.regionPosition();

          match self.data {
            Stream(ref mut s) => s.seekTo(self.starts[self.regionIndex] + regionPosition),
            Reader(ref mut s) => s.seekTo(self.starts[self.regionIndex] + regionPosition),
            _ => {}
          };

          let ret =
            match self.data {
              Stream(ref mut s) => s.read(amount),
              Reader(ref mut s) => s.read(amount),
              _ => ~[]
            };

          match self.data {
            Stream(ref mut s) => s.seekTo(old_pos),
            Reader(ref mut s) => s.seekTo(old_pos),
            _ => {}
          };

          ret
        }
        else {
          let mut ret:~[u8] = vec::with_capacity(amount as uint);
          unsafe {
            ret.set_len(amount as uint);
          }
          self.readInto(ret);
          ret
        }
      }

      pub fn write<'a>(&'a mut self, buffer: &[u8]) {
      }

      pub fn writeFromPtr(&mut self, buf_p: *u8, amount: u64) {
      }

      pub fn writeFromReader<'a>(&'a mut self, data: &mut ::io_stream::io::stream::Readable, amount: u64) {
      }

      pub fn writeFromStream<'a>(&'a mut self, data: &mut ::io_stream::io::stream::Streamable, amount: u64) {
      }

      pub fn append<'a>(&'a mut self, buffer: &[u8]) {
      }

      pub fn appendFromPtr<'a>(&'a mut self, buf_p: *u8, amount: u64) {
      }

      pub fn appendFromReader<'a>(&'a mut self, data: &mut ::io_stream::io::stream::Readable, amount: u64) {
      }

      pub fn appendFromStream<'a>(&'a mut self, data: &mut ::io_stream::io::stream::Streamable, amount: u64) {
      }

      pub fn seekTo<'a>(&'a mut self, position: u64) {
        if position > self.length {
          self.position = self.length;
          self.regionIndex = self.lengths.len() as u64;
          return;
        }

        let mut to_skip = position;
        self.position = 0;
        self.regionIndex = 0;

        while (to_skip > 0) {
          if to_skip >= self.regionAvailable() {
            to_skip -= self.regionAvailable();
            self.position += self.regionAvailable();
            self.regionIndex += 1;
          }
          else {
            self.position += to_skip;
            to_skip = 0;
          }
        }
      }

      pub fn seek<'a>(&'a mut self, amount: i64) {
        self.seekTo((self.position as i64 + amount) as u64);
      }

      pub fn length<'a>(&'a self) -> u64 {
        self.length
      }

      pub fn available<'a>(&'a self) -> u64 {
        self.length - self.position
      }

      pub fn position<'a>(&'a self) -> u64 {
        self.position
      }

      pub fn persistent(&self) -> bool {
        false
      }
    }

    impl ::io_stream::io::stream::Readable for PassThrough {
      fn readInto<'a>(&'a mut self, buffer: &mut [u8]) -> bool {
        self.readInto(buffer)
      }

      fn readIntoPtr<'a>(&'a mut self, buf_p: *mut u8, amount: u64) -> bool {
        self.readIntoPtr(buf_p, amount)
      }

      fn read<'a>(&'a mut self, amount: u64) -> ~[u8] {
        self.read(amount)
      }

      fn seekTo<'a>(&'a mut self, position: u64) {
        self.seekTo(position)
      }

      fn seek<'a>(&'a mut self, amount: i64) {
        self.seek(amount)
      }

      fn length<'a>(&'a self) -> u64 {
        self.length()
      }

      fn available<'a>(&'a self) -> u64 {
        self.available()
      }

      fn position<'a>(&'a self) -> u64 {
        self.position()
      }

      fn seekable(&self) -> bool {
        true
      }

      fn persistent(&self) -> bool {
        false
      }
    }

    impl ::io_stream::io::stream::Writable for PassThrough {
      fn write<'a>(&'a mut self, buffer: &[u8]) {
        self.write(buffer)
      }

      fn writeFromPtr(&mut self, buf_p: *u8, amount: u64) {
        self.writeFromPtr(buf_p, amount);
      }

      fn writeFromReader<'a>(&'a mut self, data: &mut ::io_stream::io::stream::Readable, amount: u64) {
        self.writeFromReader(data, amount)
      }

      fn writeFromStream<'a>(&'a mut self, data: &mut ::io_stream::io::stream::Streamable, amount: u64) {
        self.writeFromStream(data, amount)
      }

      fn append<'a>(&'a mut self, buffer: &[u8]) {
        self.append(buffer)
      }

      fn appendFromPtr<'a>(&'a mut self, buf_p: *u8, amount: u64) {
        self.appendFromPtr(buf_p, amount)
      }

      fn appendFromReader<'a>(&'a mut self, data: &mut ::io_stream::io::stream::Readable, amount: u64) {
        self.appendFromReader(data, amount)
      }

      fn appendFromStream<'a>(&'a mut self, data: &mut ::io_stream::io::stream::Streamable, amount: u64) {
        self.appendFromStream(data, amount)
      }

      fn seekTo<'a>(&'a mut self, position: u64) {
        self.seekTo(position)
      }

      fn seek<'a>(&'a mut self, amount: i64) {
        self.seek(amount)
      }

      fn length<'a>(&'a self) -> u64 {
        self.length()
      }

      fn available<'a>(&'a self) -> u64 {
        self.available()
      }

      fn position<'a>(&'a self) -> u64 {
        self.position()
      }

      fn seekable(&self) -> bool {
        true
      }

      fn persistent(&self) -> bool {
        false
      }
    }

    impl ::io_stream::io::stream::Streamable for PassThrough {
      fn readInto<'a>(&'a mut self, buffer: &mut [u8]) -> bool {
        self.readInto(buffer)
      }

      fn readIntoPtr<'a>(&'a mut self, buf_p: *mut u8, amount: u64) -> bool {
        self.readIntoPtr(buf_p, amount)
      }

      fn read<'a>(&'a mut self, amount: u64) -> ~[u8] {
        self.read(amount)
      }

      fn write<'a>(&'a mut self, buffer: &[u8]) {
        self.write(buffer)
      }

      fn writeFromPtr(&mut self, buf_p: *u8, amount: u64) {
        self.writeFromPtr(buf_p, amount);
      }

      fn writeFromReader<'a>(&'a mut self, data: &mut ::io_stream::io::stream::Readable, amount: u64) {
        self.writeFromReader(data, amount)
      }

      fn writeFromStream<'a>(&'a mut self, data: &mut ::io_stream::io::stream::Streamable, amount: u64) {
        self.writeFromStream(data, amount)
      }

      fn append<'a>(&'a mut self, buffer: &[u8]) {
        self.append(buffer)
      }

      fn appendFromPtr<'a>(&'a mut self, buf_p: *u8, amount: u64) {
        self.appendFromPtr(buf_p, amount)
      }

      fn appendFromReader<'a>(&'a mut self, data: &mut ::io_stream::io::stream::Readable, amount: u64) {
        self.appendFromReader(data, amount)
      }

      fn appendFromStream<'a>(&'a mut self, data: &mut ::io_stream::io::stream::Streamable, amount: u64) {
        self.appendFromStream(data, amount)
      }

      fn seekTo<'a>(&'a mut self, position: u64) {
        self.seekTo(position)
      }

      fn seek<'a>(&'a mut self, amount: i64) {
        self.seek(amount)
      }

      fn length<'a>(&'a self) -> u64 {
        self.length()
      }

      fn available<'a>(&'a self) -> u64 {
        self.available()
      }

      fn position<'a>(&'a self) -> u64 {
        self.position()
      }

      fn seekable(&self) -> bool {
        true
      }

      fn persistent(&self) -> bool {
        false
      }
    }
  }
}
