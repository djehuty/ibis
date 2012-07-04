module codec.image.decoder;

import io.stream;
import io.pixelmap;

final class ImageDecoder {
public:
  enum State {
    Invalid,
    Insufficient,
    PixelmapRequired,
    Accepted,
    FrameComplete,
    Complete
  }

private:
  State    delegate(Pixelmap) _decodeFunc;
  bool     delegate()         _canDecodeFunc;
  char[]   delegate()         _descriptionFunc;
  char[][] delegate()         _tagsFunc;
  ulong    delegate()         _widthFunc;
  ulong    delegate()         _heightFunc;

public:  
  this(ImageDecoder.State delegate(Pixelmap) decodeFunc,
       char[]             delegate()         descriptionFunc,
       char[][]           delegate()         tagsFunc,
       ulong              delegate()         widthFunc,
       ulong              delegate()         heightFunc) {

    _decodeFunc      = decodeFunc;
    _descriptionFunc = descriptionFunc;
    _tagsFunc        = tagsFunc;
    _widthFunc       = widthFunc;
    _heightFunc      = heightFunc;
  }

  State decode(Pixelmap image) {
    return _decodeFunc(image);
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

  ulong width() {
    return _widthFunc();
  }

  ulong height() {
    return _heightFunc();
  }
}
