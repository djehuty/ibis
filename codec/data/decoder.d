module codec.data.decoder;

import io.stream;

final class DataDecoder {
public:
  enum State {
    Invalid,
    Insufficient,
    StreamRequired,
    Accepted,
    Complete
  }

private:
  State    delegate(Stream) _decodeFunc;
  bool     delegate()       _canDecodeFunc;
  char[]   delegate()       _descriptionFunc;
  char[][] delegate()       _tagsFunc;

public:  
  this(DataDecoder.State delegate(Stream) decodeFunc,
       char[]            delegate()       descriptionFunc,
       char[][]          delegate()       tagsFunc) {

    _decodeFunc      = decodeFunc;
    _descriptionFunc = descriptionFunc;
    _tagsFunc        = tagsFunc;
  }

  State decode(Stream output) {
    return _decodeFunc(output);
  }

  bool canDecode() {
    return _canDecodeFunc();
  }

  char[] description() {
    return _descriptionFunc();
  }

  char[][] tags() {
    return _tagsFunc();
  }
}
