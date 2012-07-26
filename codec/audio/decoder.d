module codec.audio.decoder;

import io.stream;
import io.waveform;

final class AudioDecoder {
public:
  enum State {
    Invalid,
    Insufficient,
    WaveformRequired,
    Accepted,
    Complete
  }

private:
  AudioDecoder.State delegate(Waveform) _decodeFunc;
  char[]             delegate()         _descriptionFunc;
  char[][]           delegate()         _tagsFunc;

public:
  this(AudioDecoder.State delegate(Waveform) decodeFunc,
       char[]             delegate()         descriptionFunc,
       char[][]           delegate()         tagsFunc) {
    _decodeFunc      = decodeFunc;
    _descriptionFunc = descriptionFunc;
    _tagsFunc        = tagsFunc;
  }

  // Properties //

  char[] description() {
    return _descriptionFunc();
  }

  char[][] tags() {
    return _tagsFunc();
  }

  // Methods //

  State decode(Waveform output) {
    return _decodeFunc(output);
  }
}
