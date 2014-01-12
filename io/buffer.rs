#[crate_id="io-buffer#1.0"];
extern mod io_console = "io-console";
extern mod io_stream = "io-stream";

pub mod io {
  pub mod buffer {
    use std::ptr;
    use std::vec;

    pub struct Buffer {
      data:     ~[u8],
      length:   u64,
      position: u64,
    }

    pub fn create() -> ~Buffer {
      ~Buffer {
        data: ~[],
        length: 0,
        position: 0
      }
    }

    pub fn with_length(length: u64) -> ~Buffer {
      let mut ret = ~Buffer {
        data: ~[],
        length: 0,
        position: 0
      };

      ret.resize(length);
      ret.length = length;

      ret
    }

    pub fn with_capacity(capacity: u64) -> ~Buffer {
      let mut ret = ~Buffer {
        data: ~[],
        length: 0,
        position: 0
      };

      ret.resize(capacity);

      ret
    }

    impl Buffer {
      pub fn owned_reader(~self) -> ~::io_stream::io::stream::Readable {
        self as ~::io_stream::io::stream::Readable
      }

      pub fn owned_writer(~self) -> ~::io_stream::io::stream::Writable {
        self as ~::io_stream::io::stream::Writable
      }

      pub fn owned_stream(~self) -> ~::io_stream::io::stream::Streamable {
        self as ~::io_stream::io::stream::Streamable
      }

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

      // Deletes data before current position
      pub fn flush(&mut self) {
      }

      // Claims any unused memory (moves data, sets capacity to length)
      pub fn reclaim(&mut self) {
        if self.data.len() as u64 == self.length {
          return
        }

        self.resize(self.length);
      }

      // Sets length to 0.
      pub fn clean(&mut self) {
        self.position = 0;
        self.length = 0;
      }

      pub fn resize(&mut self, capacity: u64) {
        let mut new_data:~[u8] = vec::with_capacity(capacity as uint);
        unsafe {
          new_data.set_len(capacity as uint);
        }

        let amount =
          if capacity > self.length {
            self.length
          }
          else {
            capacity
          };
        let buf_p = new_data.as_mut_ptr();
        let data_p = self.data.as_mut_ptr();
        unsafe {
          ptr::copy_memory(buf_p, data_p, amount as uint);
        }
        self.data = new_data;
      }

      pub fn readInto(&mut self, buffer: &mut [u8]) -> bool {
        let buf_p = buffer.as_mut_ptr();
        let amount = buffer.len();
        self.readIntoPtr(buf_p, amount as u64)
      }

      pub fn readIntoPtr(&mut self, buf_p: *mut u8, amount: u64) -> bool {
        if (self.available() < amount) {
          return false;
        }

        let data_p = self.data.slice_from(self.position as uint).as_ptr();
        unsafe {
          ptr::copy_memory(buf_p, data_p, amount as uint);
        }

        self.position += amount;
        true
      }

      pub fn read(&mut self, amount: u64) -> ~[u8] {
        let ret = self.data.slice(self.position as uint, (self.position + amount) as uint);

        self.position += amount;

        ret.to_owned()
      }

      pub fn write(&mut self, buffer: &[u8]) {
        self.writeFromPtr(&buffer[0] as *u8, buffer.len() as u64);
      }

      pub fn writeFromPtr(&mut self, buf_p: *u8, amount: u64) {
        if (self.position + amount) > self.data.len() as u64 {
          self.resize(self.position + amount);
        }
        unsafe {
          let data_p = self.data.mut_slice_from(self.position as uint).as_mut_ptr();
          ptr::copy_memory(data_p, buf_p, amount as uint);
        }

        self.position += amount;
        if self.position > self.length {
          self.length = self.position;
        }
      }

      pub fn writeFromReader(&mut self, data: &mut ::io_stream::io::stream::Readable, amount: u64) {
        self.write(data.read(amount));
      }

      pub fn writeFromStream(&mut self, data: &mut ::io_stream::io::stream::Streamable, amount: u64) {
        self.write(data.read(amount));
      }

      pub fn append(&mut self, buffer: &[u8]) {
        self.appendFromPtr(&buffer[0] as *u8, buffer.len() as u64);
      }

      pub fn appendFromPtr(&mut self, buf_p: *u8, amount: u64) {
        if (self.length + amount) > self.data.len() as u64 {
          self.resize(self.length + amount);
        }
        unsafe {
          let data_p = self.data.mut_slice_from(self.length as uint).as_mut_ptr();
          ptr::copy_memory(data_p, buf_p, amount as uint);
        }

        self.length += amount as u64;
      }

      pub fn appendFromReader(&mut self, data: &mut ::io_stream::io::stream::Readable, amount: u64) {
        if (self.length + amount) > self.data.len() as u64 {
          self.resize(self.length + amount);
        }
        let data_p = self.data.mut_slice_from(self.length as uint).as_mut_ptr();
        data.readIntoPtr(data_p, amount);

        self.length += amount as u64;
      }

      pub fn appendFromStream(&mut self, data: &mut ::io_stream::io::stream::Streamable, amount: u64) {
        if (self.length + amount) > self.data.len() as u64 {
          self.resize(self.length + amount);
        }
        let data_p = self.data.mut_slice_from(self.length as uint).as_mut_ptr();
        data.readIntoPtr(data_p, amount);

        self.length += amount as u64;
      }

      pub fn seekTo(&mut self, position: u64) {
        if position > self.length {
          self.position = self.length;
        }
        else {
          self.position = position;
        }
      }

      pub fn seek(&mut self, amount: i64) {
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

      pub fn length(&self) -> u64 {
        self.length
      }

      pub fn available(&self) -> u64 {
        self.length - self.position
      }

      pub fn position(&self) -> u64 {
        self.position
      }

      pub fn seekable(&self) -> bool {
        true
      }

      pub fn persistent(&self) -> bool {
        false
      }
    }

    impl ::io_stream::io::stream::Readable for Buffer {
      fn readInto(&mut self, buffer: &mut [u8]) -> bool {
        self.readInto(buffer)
      }

      fn readIntoPtr(&mut self, buf_p: *mut u8, amount: u64) -> bool {
        self.readIntoPtr(buf_p, amount)
      }

      fn read(&mut self, amount: u64) -> ~[u8] {
        self.read(amount)
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
        true
      }

      fn persistent(&self) -> bool {
        false
      }
    }

    impl ::io_stream::io::stream::Writable for Buffer {
      fn write(&mut self, buffer: &[u8]) {
        self.write(buffer)
      }

      fn writeFromPtr(&mut self, buf_p: *u8, amount: u64) {
        self.writeFromPtr(buf_p, amount)
      }

      fn writeFromReader(&mut self, data: &mut ::io_stream::io::stream::Readable, amount: u64) {
        self.writeFromReader(data, amount)
      }

      fn writeFromStream(&mut self, data: &mut ::io_stream::io::stream::Streamable, amount: u64) {
        self.writeFromStream(data, amount)
      }

      fn append(&mut self, buffer: &[u8]) {
        self.append(buffer)
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
        true
      }

      fn persistent(&self) -> bool {
        false
      }
    }

    impl ::io_stream::io::stream::Streamable for Buffer {
      fn readInto(&mut self, buffer: &mut [u8]) -> bool {
        self.readInto(buffer)
      }

      fn readIntoPtr(&mut self, buf_p: *mut u8, amount: u64) -> bool {
        self.readIntoPtr(buf_p, amount)
      }

      fn read(&mut self, amount: u64) -> ~[u8] {
        self.read(amount)
      }

      fn write(&mut self, buffer: &[u8]) {
        self.write(buffer)
      }

      fn writeFromPtr(&mut self, buf_p: *u8, amount: u64) {
        self.writeFromPtr(buf_p, amount)
      }

      fn writeFromReader(&mut self, data: &mut ::io_stream::io::stream::Readable, amount: u64) {
        self.writeFromReader(data, amount)
      }

      fn writeFromStream(&mut self, data: &mut ::io_stream::io::stream::Streamable, amount: u64) {
        self.writeFromStream(data, amount)
      }

      fn append(&mut self, buffer: &[u8]) {
        self.append(buffer)
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
        true
      }

      fn persistent(&self) -> bool {
        false
      }
    }
  }
}
