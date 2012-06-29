module hash.sha256;

import io.stream;

import system.architecture;
import system.cpu;

import hash.digest;

final class Sha256 {
private:
  Stream _stream;

	static uint k[64] = [
		0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
		0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
		0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
		0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
		0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
		0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
		0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
		0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
	];

	static Digest _hash(ubyte[] message) {
    auto cpu = Architecture.currentCpu;

		//Initialize variables:
		uint h0 = 0x6a09e667;
		uint h1 = 0xbb67ae85;
		uint h2 = 0x3c6ef372;
		uint h3 = 0xa54ff53a;
		uint h4 = 0x510e527f;
		uint h5 = 0x9b05688c;
		uint h6 = 0x1f83d9ab;
		uint h7 = 0x5be0cd19;

		//Pre-processing
		//append the bit '1' to the message
		//append k bits '0', where k is the minimum number ? 0 such that the resulting message
		  //  length (in bits) is congruent to 448 (mod 512)
		//append length of message (before pre-processing), in bits, as 64-bit big-endian integer

		int padBytes;
		uint bufferLen = message.length + 9;

		// minimum increase of 9, after that the message must be padded
		if ((bufferLen % 64)) {
			padBytes = 64 - (cast(int)bufferLen % 64);
			if (padBytes < 0) {
				padBytes += 64;
			}
			bufferLen += padBytes;
		}

		ubyte[] buffer = new ubyte[bufferLen];
		buffer[0..message.length] = message[0..$];
		buffer[message.length] = 0x80;

		*(cast(ulong*)&buffer[$-8]) = cpu.fromBigEndian64(message.length * 8);

		uint* bufferPtr = cast(uint*)&buffer[0];
		uint* bufferEnd = bufferPtr + (buffer.length / 8);

		uint[64] words;

		uint s0;
		uint s1;
		uint t1;
		uint t2;
		uint ch;
		uint maj;

		uint a,b,c,d,e,f,g,h;

		//Process the message in successive 512-bit chunks:
		while (bufferPtr < bufferEnd) {
			//Extend the sixteen 32-bit words into sixty-four 32-bit words:
			int i;
			for (; i < 16; i++) {
				words[i] = cpu.fromBigEndian32(bufferPtr[i]);
			}
			for (i=0; i < 48; i++) {
				s0 = ((words[i+1] >>> 7) | (words[i+1] << 25)) ^ ((words[i+1] >>> 18) | (words[i+1] << 14)) ^ ((words[i+1] >>> 3));
				s1 = ((words[i+14] >>> 17) | (words[i+14] << 15)) ^ ((words[i+14] >>> 19) | (words[i+14] << 13)) ^ ((words[i+14] >>> 10));
				words[i+16] = words[i] + s0 + words[i+9] + s1;
		    }

		    //Initialize hash value for this chunk:
			a = h0;	b = h1;	c = h2;	d = h3;
			e = h4;	f = h5;	g = h6;	h = h7;

		    for (i=0; i<64; i++) {
				s0 = ((a >>> 2) | (a << 30)) ^ ((a >>> 13) | (a << 19)) ^ ((a >>> 22) | (a << 10));
				maj = (a & b) ^ (a & c) ^ (b & c);
				t2 = s0 + maj;
		        s1 = ((e >>> 6) | (e << 26)) ^ ((e >>> 11) | (e << 21)) ^ ((e >>> 25) | (e << 7));
		        ch = (e & f) ^ ((~e) & g);
		        t1 = h + s1 + ch + k[i] + words[i];

		        h = g;
		        g = f;
		        f = e;
		        e = d + t1;
		        d = c;
		        c = b;
		        b = a;
		        a = t1 + t2;
		    }

		    //Add this chunk's hash to result so far:
		    h0 += a; h1 += b; h2 += c; h3 += d;
			h4 += e; h5 += f; h6 += g; h7 += h;

		    bufferPtr += 16;
		}

		//Produce the final hash value (big-endian):
		//digest = hash = h0 append h1 append h2 append h3 append h4
		return new Digest([h0,h1,h2,h3,h4,h5,h6,h7]);
	}

public:
  this(Stream input) {
    _stream = input;
  }

  Digest digest() {
    return digest(_stream.available);
  }

  Digest digest(ulong bytes) {
    return _hash(_stream.read(bytes));
  }

  static Digest digest(ubyte[] bytes) {
    return _hash(bytes);
  }

  static Digest digest(char[] string) {
    return _hash(cast(ubyte[])string);
  }
}
