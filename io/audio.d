module io.audio;

import io.waveform;

import binding.c;

version(linux) {
  typedef void* snd_pcm_t;
  typedef void* snd_pcm_hw_params_t;
  typedef void* snd_pcm_sw_params_t;

  // snd_pcm_stream_t
  static const int SND_PCM_STREAM_PLAYBACK = 0;
  static const int SND_PCM_STREAM_CAPTURE  = 1;

  // snd_pcm_access
  static const int SND_PCM_ACCESS_MMAP_INTERLEAVED    = 0;
  static const int SND_PCM_ACCESS_MMAP_NONINTERLEAVED = 1;
  static const int SND_PCM_ACCESS_MMAP_COMPLEX        = 2;
  static const int SND_PCM_ACCESS_RW_INTERLEAVED      = 3;
  static const int SND_PCM_ACCESS_RW_NONINTERLEAVED   = 4;

  // snd_pcm_format_t
  static const int SND_PCM_FORMAT_UNKNOWN    = -1;
  static const int SND_PCM_FORMAT_S8         = 0;
  static const int SND_PCM_FORMAT_U8         = 1;
  static const int SND_PCM_FORMAT_S16_LE     = 2;
  static const int SND_PCM_FORMAT_S16_BE     = 3;
  static const int SND_PCM_FORMAT_U16_LE     = 4;
  static const int SND_PCM_FORMAT_U16_BE     = 5;
  static const int SND_PCM_FORMAT_S24_LE     = 6;
  static const int SND_PCM_FORMAT_S24_BE     = 7;
  static const int SND_PCM_FORMAT_U24_LE     = 8;
  static const int SND_PCM_FORMAT_U24_BE     = 9;
  static const int SND_PCM_FORMAT_S32_LE     = 10;
  static const int SND_PCM_FORMAT_S32_BE     = 11;
  static const int SND_PCM_FORMAT_U32_LE     = 12;
  static const int SND_PCM_FORMAT_U32_BE     = 13;
  static const int SND_PCM_FORMAT_FLOAT_LE   = 14;
  static const int SND_PCM_FORMAT_FLOAT_BE   = 15;
  static const int SND_PCM_FORMAT_FLOAT64_LE = 14;
  static const int SND_PCM_FORMAT_FLOAT64_BE = 15;

  extern(C) int   snd_pcm_open(snd_pcm_t** pcm, char* name,
                               int stream,      int mode);

  extern(C) char* snd_strerror(int errnum);

  extern(C) int   snd_pcm_hw_params_malloc(snd_pcm_hw_params_t* params);

  extern(C) int   snd_pcm_hw_params_free(snd_pcm_hw_params_t params);

  extern(C) int   snd_pcm_hw_params_any(snd_pcm_t* handle,
                                        snd_pcm_hw_params_t hw_params);

  extern(C) int   snd_pcm_hw_params_set_access(snd_pcm_t* handle,
                                               snd_pcm_hw_params_t hw_params,
                                               int access);

  extern(C) int   snd_pcm_hw_params_set_format(snd_pcm_t* handle,
                                               snd_pcm_hw_params_t hw_params,
                                               int format);

  extern(C) int   snd_pcm_hw_params_set_rate_near(snd_pcm_t* handle,
                                                  snd_pcm_hw_params_t hw_params,
                                                  int rate,
                                                  int direction);

  extern(C) int   snd_pcm_hw_params_set_channels(snd_pcm_t* handle,
                                                 snd_pcm_hw_params_t hw_params,
                                                 int channels);

  extern(C) int   snd_pcm_hw_params(snd_pcm_t* handle,
                                    snd_pcm_hw_params_t hw_params);

  extern(C) int   snd_pcm_prepare(snd_pcm_t* handle);

  extern(C) int   snd_pcm_writei(snd_pcm_t* handle, ubyte* buffer, long count);

  extern(C) int   snd_pcm_close(snd_pcm_t* handle);
}

final class Audio {
private:
  version(linux) {
    snd_pcm_t* _handle;
  }

public:
  this() {
  }
  
  bool open() {
    snd_pcm_hw_params_t hw_params;

    int error = snd_pcm_open(&_handle, "default", SND_PCM_STREAM_PLAYBACK, 0);
    if (error < 0) {
      printf("Cannot open audio device: %s\n", snd_strerror(error));
      return false;
    }

    error = snd_pcm_hw_params_malloc(&hw_params);
    if (error < 0) {
      printf("Cannot allocate hw params: %s\n", snd_strerror(error));
      return false;
    }

    error = snd_pcm_hw_params_any(_handle, hw_params);
    if (error < 0) {
      printf("Cannot initialize hw params: %s\n", snd_strerror(error));
      snd_pcm_hw_params_free(hw_params);
      return false;
    }

    error = snd_pcm_hw_params_set_access(_handle, hw_params, SND_PCM_ACCESS_RW_INTERLEAVED);
    if (error < 0) {
      printf("Cannot set hw params access: %s\n", snd_strerror(error));
      snd_pcm_hw_params_free(hw_params);
      return false;
    }
    
    error = snd_pcm_hw_params_set_format(_handle, hw_params, SND_PCM_FORMAT_S16_LE);
    if (error < 0) {
      printf("Cannot set hw params format: %s\n", snd_strerror(error));
      snd_pcm_hw_params_free(hw_params);
      return false;
    }
    
    error = snd_pcm_hw_params_set_rate_near(_handle, hw_params, 44100, 0);
    if (error < 0) {
      printf("Cannot set hw params rate: %s\n", snd_strerror(error));
      snd_pcm_hw_params_free(hw_params);
      return false;
    }
    
    error = snd_pcm_hw_params_set_channels(_handle, hw_params, 2);
    if (error < 0) {
      printf("Cannot set hw params channels: %s\n", snd_strerror(error));
      snd_pcm_hw_params_free(hw_params);
      return false;
    }
    
    error = snd_pcm_hw_params_set_channels(_handle, hw_params, 2);
    if (error < 0) {
      printf("Cannot set hw params channels: %s\n", snd_strerror(error));
      snd_pcm_hw_params_free(hw_params);
      return false;
    }

    error = snd_pcm_hw_params(_handle, hw_params);
    if (error < 0) {
      printf("Cannot set hw params: %s\n", snd_strerror(error));
      snd_pcm_hw_params_free(hw_params);
      return false;
    }

    snd_pcm_hw_params_free(hw_params);

    error = snd_pcm_prepare(_handle);
    if (error < 0) {
      printf("Could not prepare the device: %s\n", snd_strerror(error));
      return false;
    }

    return true;
  }

  void send(Waveform buffer) {
    ubyte[] bytes = buffer.read(128);

    int error = snd_pcm_writei(_handle, bytes.ptr, 128);
    if (error < 0) {
      printf("Error sending buffer data: %s\n", snd_strerror(error));
      return;
    }
  }

  void receive(Waveform buffer) {
  }

  void close() {
    snd_pcm_close(_handle);
    _handle = null;
  }
}
