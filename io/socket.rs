#[crate_id="io-socket#1.0"];
#[feature(globs)];
extern mod io_stream  = "io-stream";
extern mod io_console = "io-console";

extern mod text_format = "text-format";

#[cfg(target_os = "linux")]
mod os {
  // TODO: 32 bit
  pub type size_t    = u64;
  pub type ssize_t   = i64;
  pub type socklen_t = u32;
  pub type c_long    = i64;
  pub type c_ulong   = u64;
  pub type time_t    = i32;

  pub static NFDBITS:i32 = 64;

  pub struct timeval {
    tv_sec:  c_long,
    tv_usec: c_long,
  }

  pub struct sockaddr {
    sa_family: u16,
    sa_data:   [u8,..14],
  }

  pub struct fd_set {
    fds_bits: [c_long,..(1024/NFDBITS)],
  }

  pub struct addrinfo {
    ai_flags:     i32,        /* AI_PASSIVE, AI_CANONNAME */
    ai_family:    i32,        /* PF_xxx */
    ai_socktype:  i32,        /* SOCK_xxx */
    ai_protocol:  i32,        /* IPPROTO_xxx for IPv4 and IPv6 */
    ai_addrlen:   socklen_t,     /* length of ai_addr */
    ai_addr:      *sockaddr,  /* binary address */
    ai_canonname: *char,      /* canonical name for host */
    ai_next:      *addrinfo,  /* next structure in linked list */
  }

  pub enum AddressFamily {
    AF_MAX = 34,
    AF_APPLETALK = 5,
    AF_INET6 = 10,
    AF_FILE = 1,
    AF_ROSE = 11,
    AF_NETROM = 6,
    AF_ATMPVC = 8,
    AF_WANPIPE = 25,
    AF_UNSPEC = 0,
    AF_BRIDGE = 7,
    AF_X25 = 9,
    AF_BLUETOOTH = 31,
    AF_ROUTE = 16,
    AF_SECURITY = 14,
    AF_RXRPC = 33,
    AF_AX25 = 3,
    AF_KEY = 15,
    AF_IUCV = 32,
    AF_ECONET = 19,
    AF_INET = 2,
    AF_ATMSVC = 20,
    AF_PPPOX = 24,
    AF_PACKET = 17,
    AF_IRDA = 23,
    AF_NETBEUI = 13,
    AF_SNA = 22,
    AF_ASH = 18,
    AF_DECnet = 12,
    AF_IPX = 4,
  }

  pub enum SocketType {
    SOCK_RAW       = 3,
    SOCK_RDM       = 4,
    SOCK_SEQPACKET = 5,
    SOCK_PACKET    = 10,
    SOCK_DGRAM     = 2,
    SOCK_STREAM    = 1,
  }

  pub enum Protocol {
    IPPROTO_IP = 0,
    IPPROTO_ROUTING = 43,
    IPPROTO_EGP = 8,
    IPPROTO_PIM = 103,
    IPPROTO_ENCAP = 98,
    IPPROTO_ESP = 50,
    IPPROTO_PUP = 12,
    IPPROTO_IDP = 22,
    IPPROTO_IPIP = 4,
    IPPROTO_TCP = 6,
    IPPROTO_IPV6 = 41,
    IPPROTO_SCTP = 132,
    IPPROTO_AH = 51,
    IPPROTO_MTP = 92,
    IPPROTO_TP = 29,
    IPPROTO_UDP = 17,
    IPPROTO_RAW = 255,
    IPPROTO_ICMP = 1,
    IPPROTO_GGP = 3,
    IPPROTO_FRAGMENT = 44,
    IPPROTO_GRE = 47,
    IPPROTO_DSTOPTS = 60,
    IPPROTO_NONE = 59,
    IPPROTO_RSVP = 46,
    IPPROTO_IGMP = 2,
    IPPROTO_ICMPV6 = 58,
    IPPROTO_COMP = 108,
  }

  /*pub enum RecvOptions {
    MSG_PEEK     = 0x2,
    MSG_DONTWAIT = 0x40,
  }*/

  pub enum FileControlCommands {
    F_GETFL = 6,
    F_SETFL = 7,
  }

  pub enum FileControlOptions {
    O_NONBLOCK = 128,
  }

  pub enum IoControl {
    FIONREAD = 0x541b,
  }

/*
  pub enum SocketLevel {
    SOL_SOCKET = 1,
  }

  pub enum SocketOptions {
    SO_ERROR = 4,
  }
  */

  #[nolink]
  extern {
    //pub fn gai_strerror(ecode: i32) -> *u8;
    //pub fn gethostname(name: *u8, namelen: i32) -> i32;
    //pub fn getnameinfo(sa: *sockaddr, salen: socklen_t, node: *u8, nodelen: socklen_t, service: *u8, servicelen: socklen_t, flags: i32) -> i32;
    pub fn ioctl(d: i32, request: c_ulong, ...) -> i32;
    pub fn fcntl(fd: i32, cmd: i32, ...) -> i32;
    //pub fn getsockopt(sockfd: i32, level: i32, optname: i32, optval: *i32, optlen: *socklen_t) -> i32;
    pub fn getaddrinfo(nodename: *u8, servname: *u8, hints: *addrinfo, res: **addrinfo) -> i32;
    pub fn freeaddrinfo(ai: *addrinfo);
    pub fn socket(af: i32, socket_type: i32, protocol: i32) -> i32;
    pub fn connect(s: i32, name: *sockaddr, namelen: socklen_t) -> i32;
    pub fn shutdown(s: i32, how: i32) -> i32;
    pub fn close(fd: i32) -> i32;
    pub fn recv(s: i32, buf: *mut u8, len: size_t, flags: i32) -> ssize_t;
    pub fn send(s: i32, buf: *u8, len: size_t, flags: i32) -> ssize_t;
    pub fn select(nfds: i32, readfds: *mut fd_set, writefds: *mut fd_set,
                  errorfds: *mut fd_set, timeout: *timeval) -> i32;
  }
}

pub mod io {
  pub mod socket {
    use std::vec;
    //use io_stream::io::stream::{Read, Write, ReadWrite, Executable, ReadExecutable, WriteExecutable, ReadWriteExecutable};

    pub struct Socket {
      descriptor: u64,
      connected:  bool,
    }

    pub enum Connection {
      Connected(~Socket),
      Error(u64)
    }

    pub fn connect(hostname: &str, port: u16) -> ~Connection {
      let ai = ::os::addrinfo {
        ai_flags:     0,
        ai_family:    ::os::AF_UNSPEC   as i32,
        ai_socktype:  ::os::SOCK_STREAM as i32,
        ai_protocol:  ::os::IPPROTO_TCP as i32,
        ai_addrlen:   0,
        ai_addr:      0 as *::os::sockaddr,
        ai_canonname: 0 as *char,
        ai_next:      0 as *::os::addrinfo,
      };

      let ai_result_ptr: *::os::addrinfo = 0 as *::os::addrinfo;

      let port_string = ::text_format::text::format::integer(port as i64, 10) + "\0";

      let error = unsafe {
        ::os::getaddrinfo(hostname.as_ptr(), port_string.as_ptr(), &ai as *::os::addrinfo, &ai_result_ptr as **::os::addrinfo)
      };

      if error != 0 {
        // Error connecting
        unsafe { ::os::freeaddrinfo(ai_result_ptr) };
        return ~Error(0);
      }

      let ai_result = unsafe { *ai_result_ptr };

      let fd = unsafe {
        ::os::socket(ai_result.ai_family, ai_result.ai_socktype, ai_result.ai_protocol)
      };

      if fd == -1 {
        unsafe { ::os::freeaddrinfo(ai_result_ptr) };
        ~Error(0)
      }
      else {
        unsafe {
          let mut flags = ::os::fcntl(fd, ::os::F_GETFL as i32);
          flags |= ::os::O_NONBLOCK as i32;
          ::os::fcntl(fd, ::os::F_SETFL as i32, flags);
        }

        let socket = ~Socket {
          descriptor: fd as u64,
          connected:  true,
        };

        let result = unsafe {
          ::os::connect(fd, ai_result.ai_addr, ai_result.ai_addrlen as ::os::socklen_t)
        };

        unsafe { ::os::freeaddrinfo(ai_result_ptr) };

        if result == -1 {
          unsafe { ::os::close(fd); }
          ~Error(0)
        }
        else {
          ~Connected(socket)
        }
      }
    }

    impl Drop for Socket {
      fn drop(&mut self) {
        unsafe {
          ::os::shutdown(self.descriptor as i32, 2);
          ::os::close(self.descriptor as i32);
        }
      }
    }

    impl ::io_stream::io::stream::Readable for Socket {
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

      fn seekTo(&mut self, _: u64) {
      }

      fn seek(&mut self, _: i64) {
      }

      fn length(&self) -> u64 {
        0
      }

      fn available(&self) -> u64 {
        0
      }

      fn position(&self) -> u64 {
        0
      }

      fn seekable(&self) -> bool {
        self.seekable()
      }

      fn persistent(&self) -> bool {
        self.persistent()
      }
    }

    impl ::io_stream::io::stream::Writable for Socket {
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
        self.append(data.read(amount));
      }

      fn appendFromStream(&mut self, data: &mut ::io_stream::io::stream::Streamable, amount: u64) {
        self.append(data.read(amount));
      }

      fn seekTo(&mut self, _: u64) {
      }

      fn seek(&mut self, _: i64) {
      }

      fn length(&self) -> u64 {
        0
      }

      fn available(&self) -> u64 {
        0
      }

      fn position(&self) -> u64 {
        0
      }

      fn seekable(&self) -> bool {
        self.seekable()
      }

      fn persistent(&self) -> bool {
        self.persistent()
      }
    }

    impl Socket {
      pub fn connected(&self) -> bool {
        self.connected
      }

      pub fn stream(&self) -> ~::io_stream::io::stream::Streamable {
        ~Socket {
          descriptor: self.descriptor,
          connected:  self.connected
        } as ~::io_stream::io::stream::Streamable
      }

      pub fn reader(&self) -> ~::io_stream::io::stream::Readable {
        ~Socket {
          descriptor: self.descriptor,
          connected:  self.connected
        } as ~::io_stream::io::stream::Readable
      }

      pub fn writer(&self) -> ~::io_stream::io::stream::Writable {
        ~Socket {
          descriptor: self.descriptor,
          connected:  self.connected
        } as ~::io_stream::io::stream::Writable
      }

      pub fn readInto(&mut self, buffer: &mut [u8]) -> bool {
        let buf_p = buffer.as_mut_ptr();
        let buf_len = buffer.len();
        self.readIntoPtr(buf_p, buf_len as u64)
      }

      pub fn readIntoPtr(&mut self, buf_p: *mut u8, amount: u64) -> bool {
        if amount == 0 {
          // Check for disconnect using select and timeout of 0
          let mut set = ::os::fd_set {
            fds_bits: [0,..(1024/::os::NFDBITS)]
          };

          let tval = ::os::timeval {
            tv_sec:  0,
            tv_usec: 0,
          };

          set.fds_bits[(self.descriptor as i32) / ::os::NFDBITS] |= (1 << ((self.descriptor as i32) % ::os::NFDBITS));

          let selected =
            unsafe {
              ::os::select(self.descriptor as i32 + 1,
                           &mut set as *mut ::os::fd_set,
                           0 as *mut ::os::fd_set,
                           0 as *mut ::os::fd_set,
                           &tval as *::os::timeval)
            };

          if selected > 0 {
            // Descriptors found!
            if self.available() == 0 {
              self.connected = false
            }
          }

          return true;
        }

        let amount_read =
          unsafe {
            ::os::recv(self.descriptor as i32, buf_p, amount as ::os::size_t, 0)
          };

        if amount_read == 0 {
          // Connection closed
          self.connected = false;
        }

        true
      }

      pub fn read(&mut self, amount: u64) -> ~[u8] {
        let mut vector = vec::with_capacity(amount as uint);
        unsafe { vector.set_len(amount as uint); }
        self.readInto(vector);
        vector
      }

      pub fn readAll(&mut self) -> ~[u8] {
        let amount = self.available();

        if amount == 0 {
          // Check for disconnect using select and timeout of 0
          let mut set = ::os::fd_set {
            fds_bits: [0,..(1024/::os::NFDBITS)]
          };

          let tval = ::os::timeval {
            tv_sec:  0,
            tv_usec: 0,
          };

          set.fds_bits[(self.descriptor as i32) / ::os::NFDBITS] |= (1 << ((self.descriptor as i32) % ::os::NFDBITS));

          let selected =
            unsafe {
              ::os::select(self.descriptor as i32 + 1,
                           &mut set as *mut ::os::fd_set,
                           0 as *mut ::os::fd_set,
                           0 as *mut ::os::fd_set,
                           &tval as *::os::timeval)
            };

          if selected > 0 {
            // Descriptors found!
            if self.available() == 0 {
              self.connected = false
            }
          }

          ~[]
        }
        else {
          self.read(amount)
        }
      }

      pub fn seekTo(&mut self, _: u64) {
      }

      pub fn seek(&mut self, _: i64) {
      }

      pub fn length(&self) -> u64 {
        0
      }

      pub fn available(&self) -> u64 {
        unsafe {
          let bytes_available:i32 = 0;
          ::os::ioctl(self.descriptor as i32, ::os::FIONREAD as ::os::c_ulong, &bytes_available);
          bytes_available as u64
        }
      }

      pub fn position(&self) -> u64 {
        0
      }

      pub fn write(&mut self, data: &[u8]) {
        let vbuf = data.as_ptr();
        let len = data.len();
        self.writeFromPtr(vbuf, len as u64);
      }

      pub fn writeFromPtr(&mut self, buf_p: *u8, amount: u64) {
        // TODO: non-blocking
        unsafe {
          ::os::send(self.descriptor as i32, buf_p, amount as ::os::size_t, 0);
        }
      }

      pub fn append(&mut self, data: &[u8]) {
        self.write(data);
      }

      pub fn appendFromPtr(&mut self, buf_p: *u8, amount: u64) {
        self.writeFromPtr(buf_p, amount);
      }

      pub fn seekable(&self) -> bool {
        false
      }

      pub fn persistent(&self) -> bool {
        false
      }
    }

    impl ::io_stream::io::stream::Streamable for Socket {
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

      fn seekTo(&mut self, _: u64) {
      }

      fn seek(&mut self, _: i64) {
      }

      fn length(&self) -> u64 {
        0
      }

      fn available(&self) -> u64 {
        0
      }

      fn position(&self) -> u64 {
        0
      }

      fn write(&mut self, data: &[u8]) {
        self.write(data)
      }

      fn writeFromReader(&mut self, data: &mut ::io_stream::io::stream::Readable, amount: u64) {
        self.write(data.read(amount));
      }

      fn writeFromStream(&mut self, data: &mut ::io_stream::io::stream::Streamable, amount: u64) {
        self.write(data.read(amount));
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
        self.append(data.read(amount));
      }

      fn appendFromStream(&mut self, data: &mut ::io_stream::io::stream::Streamable, amount: u64) {
        self.append(data.read(amount));
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
