module io.waveform;

import io.stream;

import io.buffer;

final class Waveform {
private:
  uint _bitsPerSample;
  uint _averageBytesPerSecond;
  uint _channels;
  uint _samplesPerSecond;

  Buffer _buffer;

public:
  this(uint bitsPerSample,
       uint averageBytesPerSecond,
       uint channels,
       uint samplesPerSecond) {
    _bitsPerSample = bitsPerSample;
    _averageBytesPerSecond = averageBytesPerSecond;
    _channels = channels;
    _samplesPerSecond = samplesPerSecond;

    _buffer = new Buffer(0);
  }

  // Properties //

  uint bitsPerSample() {
    return _bitsPerSample;
  }

  uint averageBytesPerSecond() {
    return _averageBytesPerSecond;
  }

  uint channels() {
    return _channels;
  }

  uint samplesPerSecond() {
    return _samplesPerSecond;
  }

  /* This property describes the stream that can read from this buffer.
  */
  Stream input() {
    return _buffer.input;
  }

  /* This property describes the stream that can write to this buffer.
  */
  Stream output() {
    return _buffer.output;
  }

  /* This property describes the stream that has access to this buffer.
  */
  Stream stream() {
    return _buffer.stream;
  }

  // Methods //

  ubyte[] read(long amount) {
    return _buffer.read(amount);
  }
}
