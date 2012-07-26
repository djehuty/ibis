module codec.audio.mp3.decoder;

import codec.audio.decoder;

double pow(double x, double y) {
  return 0.0;
}

double abs(double x) {
  return 0.0;
}

import math.trig;

import io.stream;
import io.waveform;

import codec.audio.mp3.huffman_tables;
import codec.audio.mp3.coefficients;

import chrono.time;

import system.architecture;
import system.cpu;

import binding.c;

final class Mp3Decoder {
private:
  typedef double ZeroDouble = 0.0;

  enum State {
    Init,

    Invalid,
    Required,
    Complete,

    BufferAudio,

    ReadHeader,

    AmbiguousSync,

    ReadCRC,
    ReadAudioData,
    ReadAudioDataPreamble,
    ReadAudioDataSingleChannel,
    ReadAudioDataScaleFactors,
    ReadAudioDataJointStereo,
  }

  State _state;
  State _currentState;

  align(1) struct Mp3HeaderInformation {
    uint id;
    uint layer;
    uint protectedBit;
    uint bitrateIndex;
    uint samplingFrequency;
    uint padding;
    uint privateBit;
    uint mode;
    uint modeExtension;
    uint copyright;
    uint original;
    uint emphasis;
  }

  Mp3HeaderInformation _header;
  uint _audioHeaderLength;

  align(1) struct Id3HeaderInformation {
    ubyte[3] signature;
    ubyte[2] ver;
    ubyte    flags;
    ubyte[4] len;
  }

  Id3HeaderInformation _id3;

  const uint _byteMasks[9][] = [
    [0x00, 0x00, 0x00, 0x00, 0x0, 0x0, 0x0, 0x0],    // 0 bit
    [0x80, 0x40, 0x20, 0x10, 0x8, 0x4, 0x2, 0x1],    // 1 bit
    [0xC0, 0x60, 0x30, 0x18, 0xC, 0x6, 0x3, 0x1],    // 2 bits
    [0xE0, 0x70, 0x38, 0x1C, 0xE, 0x7, 0x3, 0x1],    // 3 bits
    [0xF0, 0x78, 0x3C, 0x1E, 0xF, 0x7, 0x3, 0x1],    // 4 bits
    [0xF8, 0x7C, 0x3E, 0x1F, 0xF, 0x7, 0x3, 0x1],    // 5 bits
    [0xFC, 0x7E, 0x3F, 0x1F, 0xF, 0x7, 0x3, 0x1],    // 6 bits
    [0xFE, 0x7F, 0x3F, 0x1F, 0xF, 0x7, 0x3, 0x1],    // 7 bits
    [0xFF, 0x7F, 0x3F, 0x1F, 0xF, 0x7, 0x3, 0x1]    // 8 bits
  ];

  // Bitmasks

  const auto MPEG_SYNC_BITS            = 0xFFF00000;
  const auto MPEG_ID_BIT               = 0x00080000;
  const auto MPEG_LAYER                = 0x00060000;
  const auto MPEG_LAYER_SHIFT          = 17;
  const auto MPEG_PROTECTION_BIT       = 0x00010000;
  const auto MPEG_BITRATE_INDEX        = 0x0000F000;
  const auto MPEG_BITRATE_INDEX_SHIFT  = 12;
  const auto MPEG_SAMPLING_FREQ        = 0x00000C00;
  const auto MPEG_SAMPLING_FREQ_SHIFT  = 10;
  const auto MPEG_PADDING_BIT          = 0x00000200;
  const auto MPEG_PRIVATE_BIT          = 0x00000100;
  const auto MPEG_MODE                 = 0x000000C0;
  const auto MPEG_MODE_SHIFT           = 6;
  const auto MPEG_MODE_EXTENSION       = 0x00000030;
  const auto MPEG_MODE_EXTENSION_SHIFT = 4;
  const auto MPEG_COPYRIGHT            = 0x00000008;
  const auto MPEG_ORIGINAL             = 0x00000004;
  const auto MPEG_EMPHASIS             = 0x00000003;
  const auto MPEG_EMPHASIS_SHIFT       = 0;

  // Modes

  const auto MPEG_MODE_STEREO         = 0;
  const auto MPEG_MODE_JOINT_STEREO   = 1;
  const auto MPEG_MODE_DUAL_CHANNEL   = 2;
  const auto MPEG_MODE_SINGLE_CHANNEL = 3;

  // Static Huffman tables
  uint[][] _curTable;
  uint[]   _curValues;
  uint     _linbits;

  // layer 3 bit rates (MPEG-1)
  // the first entry is the 'free' bitrate
  const uint[] bitRates = [  0,  32,  40,  48,  56,  64, 80, 96,
                           112, 128, 160, 192, 224, 256, 320 ];

  // the final entry is reserved, but set to 1.0 due to being used in division
  const double[] _samplingFrequencies = [ 44.1, 48.0, 32.0, 1.0 ];

  // Scalefactor Band Indices
  const uint[23][3] sfindex_long = [
    // 44.1
    [  0,   4,   8,  12,  16,  20,  24,  30,  36,  44,  52,  62,
      74,  90, 110, 134, 162, 196, 238, 288, 342, 418, 576],

    // 48.0
    [  0,   4,   8,  12,  16,  20,  24,  30,  36,  42,  50,  60,
      72,  88, 106, 128, 156, 190, 230, 276, 330, 384, 576],

    // 32.0
    [  0,   4,   8,  12,  16,  20,  24,  30,  36,  44,  54,  66,
      82, 102, 126, 156, 194, 240, 296, 364, 448, 550, 576]
  ];

  const uint[14][3] sfindex_short = [
    // 44.1
    [0, 4, 8, 12, 16, 22, 30, 40, 52, 66,  84, 106, 136, 192],

    // 48.0
    [0, 4, 8, 12, 16, 22, 28, 38, 50, 64,  80, 100, 126, 192],

    // 32.0
    [0, 4, 8, 12, 16, 22, 30, 42, 58, 78, 104, 138, 180, 192]
  ];

  int[2] _bufOffset = [64, 64];
  ZeroDouble[2 * 512][2] BB;
  
  bool _accepted = false;

  const auto NUM_BLOCKS = 40;

  // subband limits
  const auto SBLIMIT = 32;
  const auto SSLIMIT = 18;

  // Decoded Huffman Data -- is(i) in the spec
  int[SSLIMIT][SBLIMIT] _codedData;

  // Requantized Data -- xr(i) in the spec
  double[SSLIMIT][SBLIMIT][2] _quantizedData;

  // Normalized Data -- lr(i) in the spec
  double[SSLIMIT][SBLIMIT][2] _normalizedData;

  // Reordered Data -- re(i) in the spec
  double[SSLIMIT][SBLIMIT] _reorderedData;

  // Anti-aliased Hybrid Synthesis Data -- hybridIn
  double[SSLIMIT][SBLIMIT] _hybridData;

  // Data for the Polysynth Phase -- hybridOut
  double[SSLIMIT][SBLIMIT][2] _polysynthData;

  // Current count table as a huffman table index
  uint _curCountTable;

  // ZeroDouble initializes to 0.0 instead of nil
  ZeroDouble[SSLIMIT][SBLIMIT][2] _previousBlock;

  // Header for the frame
  uint _mpegHeader;

  // Bit building
  uint _curByte;
  uint _curPos;

  uint _bufferLength;

  uint _channels;
  uint _samplingFrequency;
  uint _averageBytesPerSecond;
  uint _blockAlign;
  uint _bitsPerSample;

  ushort _crc;

  // Number of samples left to decode
  int _samplesLeft;

  // The buffer size and information
  uint _bufferSize;
  Time _bufferTime;

  ubyte[] _audioRef;
  uint    _audioRefLength;

  ubyte[]   _audioData;
  ubyte[32] _audioHeader;

  uint _frameStart;
  uint _frameEnd;

  uint _syncAmount;

  ulong _mainDataBegin;
  ulong _mainDataEnd;
  ulong _curDataPosition;

  // cb_limit -- Number of scalefactor bands for long blocks
  // (block_type != 2). This is a constant, 21, for Layer III
  // in all modes and at all sampling frequencies.
  static const uint cb_limit = 21;

  // cb_limit_short -- Number of scalefactor bands for long
  // blocks (block_type == 2). This is a constant, 12, for
  // Layer III in all modes and at all sampling frequencies.
  static const uint cb_limit_short = 12;

  // scfsi[scfsi_band] -- In Layer III, the scalefactor
  // selection information works similarly to Layers I and
  // II. The main difference is the use of variable
  // scfsi_band to apply scfsi to groups of scalefactors
  // instead of single scalefactors. scfsi controls the
  // use of scalefactors to the granules.
  uint[2][cb_limit] scfsi;

  // part2_3_length[gr] -- This value contains the number of
  // main_data bits used for scalefactors and Huffman code
  // data. Because the length of the side information is
  // always the same, this value can be used to calculate
  // the beginning of the main information for each granule
  // and the position of ancillary information (if used).

  uint[2][2] part2_3_length;
  
  // part2_length -- This value contains the number of
  // main_data bits used for scalefactors and Huffman code
  // data. Because the length of the side information is
  // always the same, this value can be used to calculate
  // the beginning of the main information for each granule
  // and the position of ancillary information (if used).

  uint part2_length;

  // big_values[gr] -- The spectral values of each granule
  // are coded with different Huffman code tables. The full
  // frequency range from zero to the Nyquist frequency is
  // divided into several regions, which then are coded using
  // different table. Partitioning is done according to the
  // maximum quantized values. This is done with the
  // assumption the values at higher frequencies are expected
  // to have lower amplitudes or don't need to be coded at all.
  // Starting at high frequencies, the pairs of quantized values
  // with absolute value not exceeding 1 (i.e. only 3 possible
  // quantization levels) are counted. This number is named
  // "count1". Again, an even number of values remains. Finally,
  // the number of pairs of values in the region of the spectrum
  // which extends down to zero is named "big_values". The
  // maximum absolute value in this range is constrained to 8191.
  
  // The figure shows the partitioning:
  // xxxxxxxxxxxxx------------------00000000000000000000000000000
  // |           |                 |                            |
  // 1      bigvalues*2    bigvalues*2+count1*4             iblen
  //
  // The values 000 are all zero
  // The values --- are -1, 0, or +1. Their number is a multiple of 4
  // The values xxx are not bound
  // iblen = 576

  uint[2][2] big_values;

  // global_gain[gr] -- The quantizer step size information is
  // transmitted in the side information variable global_gain.
  // It is logarithmically quantized. For the application of
  // global_gain, refer to the formula in 2.4.3.4 (ISO 11172-3)

  uint[2][2] global_gain;

  // scalefac_compress[gr] -- selects the number of bits used
  // for the transmission of the scalefactors according to the
  // following table:

  // if block_type is 0, 1, or 3:
  // slen1: length of scalefactors for scalefactor bands 0 to 10
  // slen2: length of scalefactors for scalefactor bands 11 to 20

  // if block_type is 2 and switch_point is 0:
  // slen1: length of scalefactors for scalefactor bands 0 to 5
  // slen2: length of scalefactors for scalefactor bands 6 to 11

  // if block_type is 2 and switch_point is 1:
  // slen1: length of scalefactors for scalefactor bands 0 to 7
  //    (long window scalefactor band) and 4 to 5 (short window
  //    scalefactor band)
  // slen2: length of scalefactors for scalefactor bands 6 to 11

  // scalefactor_compress slen1 slen2
  //                    0     0     0
  //                    1     0     1
  //                    2     0     2
  //                    3     0     3
  //                    4     3     0
  //                    5     1     1
  //                    6     1     2
  //                    7     1     3
  //                    8     2     1
  //                    9     2     2
  //                   10     2     3
  //                   11     3     1
  //                   12     3     2
  //                   13     3     3
  //                   14     4     2
  //                   15     4     3

  uint[2][2] scalefac_compress;
  
  uint[2][2] slen1;
  uint[2][2] slen2;

  const int[16] slen1_interpret = [0, 0, 0, 0, 3, 1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4];
  const int[16] slen2_interpret = [0, 1, 2, 3, 0, 1, 2, 3, 1, 2, 3, 1, 2, 3, 2, 3];

  // blocksplit_flag[gr] -- signals that the block uses an other
  // than normal (type 0) window. If blocksplit_flag is set,
  // several other variables are set by default:

  // region_address1 = 8 (in case of block_type == 1 or 3)
  // region_address1 = 9 (in case of block_type == 2)
  // region_address2 = 0 and the length of region 2 is zero

  // If it is not set, the value of block_type is zero

  uint[2][2] blocksplit_flag;

  // block_type[gr] -- indicates the window type for the actual
  // granule (see the description of filterbank)

  // type 0 - reserved
  // type 1 - start block
  // type 2 - 3 short windows
  // type 3 - end block

  uint[2][2] block_type;

  // switch_point[gr] -- signals the split point of short/long
  // transforms. The following table shows the number of the
  // scalefactor band above which window switching (i.e.
  // block_type different from 0) is used.

  // switch_point switch_point_l switch_point_s
  //                (num of sb)    (num of sb)
  // --------------------------------------------
  //       0             0              0
  //       1             8              3

  uint[2][2] switch_point;

  // switch_point_l -- Number of the scalefactor band (long
  // block scalefactor band) from which point on window
  // switching is used.

  uint[2][2] switch_point_l;

  // switch_point_s -- Number of the scalefactor band (short
  // block scalefactor band) from which point on window
  // switching is used.

  uint[2][2] switch_point_s;

  // table_select[region][gr] -- different Huffman code tables
  // are used depending on the maximum quantized value and the
  // local statistics of the signal. There are a total of 32
  // possible tables given in 3-Annex-B Table 3-B.7 (ISO 11172-3)

  uint[2][2][3] table_select;

  // subblock_gain[window][gr] -- indicates the gain offset
  // (quantization: factor 4) from the global gain for one
  // subblock. Used only with block type 2 (short windows).
  // The values of the subblock have to be divided by 4.

  uint[2][2][3] subblock_gain;

  // region_address1[gr] -- A further partitioning of the
  // spectrum is used to enhance the performance of the Huffman
  // coder. It is a subdivision of the region which is described
  // by big_values. The purpose of this subdivision is to get
  // better error robustness and better coding efficiency. Three
  // regions are used. Each region is coded using a different
  // Huffman code table depending on the maximum quantized value
  // and the local statistics.

  // The values region_address[1,2] are used to point to the
  // boundaries of the regions. The region boundaries are
  // aligned with the partitioning of the spectrum into critical
  // bands.

  // In the case of block_type == 2 (short blocks) the scalefactor
  // bands representing the different time slots are counted
  // separately. If switch_point == 0, the total amount of scalefactor
  // bands for the granule in this case is 12*3=36. If block_type == 2
  // and switch_point == 1, the amount of scalefactor bands is
  // 8+9*3=35. region_address1 counts the number of scalefactor bands
  // until the upper edge of the first region:

  // region_address1   upper_edge of region is upper edge
  //                      of scalefactor band number:
  //               0   0 (no first region)
  //               1   1
  //               2   2
  //             ...   ...
  //              15   15

  uint[2][2] region_address1;

  // region_address2[gr] -- counts the number of scalefactor bands
  // which are partially or totally in region 3. Again, if
  // block_type == 2, then the scalefactor bands representing
  // different time slots are counted separately.

  uint[2][2] region_address2;

  // preflag[gr] -- This is a shortcut for additional high
  // frequency amplification of the quantized values. If preflag
  // is set, the values of a table are added to the scalefactors
  // (see 3-Annex B, Table 3-B.6 ISO 11172-3). This is equivalent
  // to multiplication of the requantized scalefactors with table
  // values. preflag is never used if block_type == 2 (short blocks)

  uint[2][2] preflag;

  // scalefac_scale[gr] -- The scalefactors are logarithmically
  // quantized with a step size of 2 or sqrt(2) depending on
  // the value of scalefac_scale:

  // scalefac_scale = 0 ... stepsize = sqrt(2)
  // scalefac_scale = 1 ... stepsize = 2

  uint[2][2] scalefac_scale;

  // count1table_select[gr] -- This flag selects one of two
  // possible Huffman code tables for the region of
  // quadruples of quantized values with magnitude not
  // exceeding 1. (ref to ISO 11172-3)

  // count1table_select = 0 .. Table A of 3-Annex B.7
  // count1table_select = 1 .. Table B of 3-Annex B.7

  uint[2][2] count1table_select;
  
  // scalefac[cb][gr] -- The scalefactors are used to color
  // the quantization noise. If the quantization noise is
  // colored with the right shape, it is masked completely.
  // Unlike Layers I and II, the Layer III scalefactors say
  // nothing about the local maximum of the quantized signal.
  // In Layer III, the blocks stretch over several frequency
  // lines. These blocks are called scalefactor bands and are
  // selected to resemble critical bands as closely as possible.
  
  // The scalefac_compress table shows that scalefactors 0-10
  // have a range of 0 to 15 (maximum length 4 bits) and the
  // scalefactors 11-21 have a range of 0 to 7 (3 bits).

  // If intensity_stereo is enabled (modebit_extension) the
  // scalefactors of the "zero_part" of the difference (right)
  // channel are used as intensity_stereo positions
  
  // The subdivision of the spectrum into scalefactor bands is
  // fixed for every block length and sampling frequency and
  // stored in tables in the coder and decoder. (3-Annex 3-B.8)
  
  // The scalefactors are logarithmically quantized. The
  // quantization step is set with scalefac_scale.

  // scalefac[cb][window][gr] -- same as scalefac[cb][gr] but for
  // different windows when block_type == 2.

  struct ScaleFactor {
    uint[3][13] short_window;
    uint[23] long_window;
  }

  ScaleFactor[2][2] scalefac;

  bool _firstTime = true;

  Cpu   _cpu;

  void _init() {
    printf("init\n");
    _state = State.BufferAudio;
  }

  uint _readBits(uint bits) {
    // read a byte, read bits, whatever necessary to get the value
    uint curvalue;
    uint value = 0;

    uint mask;
    uint maskbits;

    int shift;
    if (_curByte >= _audioRefLength) {
      // We have consumed everything in our buffer
      return 5;
    }

    for (;;) {
      if (bits == 0) {
        return value;
      }

      if (bits > 8) {
        maskbits = 8;
      }
      else {
        maskbits = bits;
      }

      curvalue = (_audioRef[_curByte] & (_byteMasks[maskbits][_curPos]));

      shift = ((8 - cast(int)_curPos) - cast(int)bits);

      if (shift > 0) {
        curvalue >>= shift;
      }
      else if (shift < 0) {
        curvalue <<= -shift;
      }

      value |= curvalue;

      _curPos += maskbits;

      if (_curPos >= 8) {
        bits -= (8 - _curPos + maskbits);
        _curPos = 0;
        _curByte++;

        if (_curByte >= _audioRefLength) {
          // We have consumed everything in our buffer
          return value;
        }
      }
      else {
        break;
      }
    }
    return value;
  }

  // Select the table to use for decoding and reset state.
  void _initializeHuffman(uint region, uint gr, uint ch) {
    uint tableIndex = table_select[region][gr][ch];
    
    switch (tableIndex) {
      case 16:
        _linbits = 1;
        break;

      case 17:
        _linbits = 2;
        break;

      case 18:
        _linbits = 3;
        break;

      case 24:
      case 19:
        _linbits = 4;
        break;
        
      case 25:
        _linbits = 5;
        break;

      case 26:
      case 20:
        _linbits = 6;
        break;

      case 27:
        _linbits = 7;
        break;

      case 28:
      case 21:
        _linbits = 8;
        break;

      case 29:
        _linbits = 9;
        break;

      case 22:
        _linbits = 10;
        break;

      case 30:
        _linbits = 11;
        break;

      case 31:
      case 23:
        _linbits = 13;
        break;

      default:
        _linbits = 0;
        break;
    }

    if (tableIndex >= 24) {
      tableIndex = 17;
    }
    else if (tableIndex >= 16) {
      tableIndex = 16;
    }

    // XXX: This silliness is due to a compiler bug in DMD 1.046
    if (tableIndex == 17) {
      _curTable = huffmanTable24;
    }
    else {
      _curTable = huffmanTables[tableIndex];
    }
    _curValues = huffmanValues[tableIndex];
  }

  int[] _readCode() {
    uint code;
    uint bitlength;
    uint valoffset;

    for(;;) {
      code <<= 1;
      code |= _readBits(1);
      
      if (bitlength > _curTable.length) {
        break;
      }

      foreach(uint i, foo; _curTable[bitlength]) {
        if (foo == code) {
          // found code

          // get value offset
          valoffset += i;
          valoffset *= 2;

          int[] values = [_curValues[valoffset], _curValues[valoffset+1]];

          // read linbits (x)
          if (_linbits > 0 && values[0] == 15) {
            values[0] += _readBits(_linbits);
          }

          if (values[0] > 0) {
            if (_readBits(1) == 1) {
              values[0] = -values[0];
            }
          }

          if (_linbits > 0 && values[1] == 15) {
            values[1] += _readBits(_linbits);
          }

          if (values[1] > 0) {
            if (_readBits(1) == 1) {
              values[1] = -values[1];
            }
          }

          return values;
        }
      }

      valoffset += _curTable[bitlength].length;
      bitlength++;
      if (bitlength >= _curTable.length) {
        return [128, 128];
      }
    }

    return [128, 128];
  }

  void _initializeQuantizationHuffman(uint gr, uint ch) {
    _curCountTable = count1table_select[gr][ch];
  }

  uint _decodeQuantization() {
    uint code;

    if (_curCountTable == 1) {
      // Quantization Huffman Table B is trivial...
      // It is simply the bitwise negation of 4 bits from the stream.
      // code = ~readBits(4);
      code = _readBits(4);
      code = ~code;
    }
    else {
      // Quantization Huffman Table A is the only case,
      // so it is written here by hand:

      // state 1
      code = _readBits(1);

      if (code == 0b1) {
        return 0b0000;
      }

      // state 2
      code = _readBits(3);

      if (code >= 0b0100 && code <= 0b0111) {
        uint idx = code - 0b0100;
        const uint[] stage2_values = [0b0010, 0b0101, 0b0110, 0b0111];
        return stage2_values[idx];
      }

      // state 3
      code <<= 1;
      code |= _readBits(1);

      if (code >= 0b00011 && code <= 0b00111) {
        uint idx = code - 0b00011;
        const uint[] stage3_values = [0b1001, 0b0110, 0b0011, 0b1010, 0b1100];
        return stage3_values[idx];
      }

      // state 4
      code <<= 1;
      code |= _readBits(1);

      if (code <= 0b000101) {
        const uint[] stage4_values = [0b1011, 0b1111, 0b1101, 0b1110, 0b0111, 0b0101];
        return stage4_values[code];
      }

      // invalid code;
      code = 0;
    }

    return code;
  }

  int[] _readQuantizationCode() {
    uint code = _decodeQuantization();

    int v = ((code >> 3) & 1);
    int w = ((code >> 2) & 1);
    int x = ((code >> 1) & 1);
    int y = ((code >> 0) & 1);

    // Get Sign Bits (for non-zero values)
    if (v > 0 && _readBits(1) == 1) {
      v = -v;
    }

    if (w > 0 && _readBits(1) == 1) {
      w = -w;
    }

    if (x > 0 && _readBits(1) == 1) {
      x = -x;
    }

    if (y > 0 && _readBits(1) == 1) {
      y = -y;
    }

    return [v, w, x, y];
  }

  void _readScalefactors(uint gr, uint ch) {
    if (blocksplit_flag[gr][ch] == 1 && block_type[gr][ch] == 2) {
      if (switch_point[gr][ch] == 0) {

        // Decoding scalefactors for a short window.
        for (uint cb = 0; cb < 6; cb++) {
          for (uint window = 0; window < 3; window++) {
            scalefac[gr][ch].short_window[cb][window] = _readBits(slen1[gr][ch]);
          }
        }

        for (uint cb = 6; cb < cb_limit_short; cb++) {
          for (uint window = 0; window < 3; window++) {
            scalefac[gr][ch].short_window[cb][window] = _readBits(slen2[gr][ch]);
          }
        }

        for (uint window = 0; window < 3; window++) {
          scalefac[gr][ch].short_window[12][window] = 0;
        }
      }
      else {
        // Decoding scalefactors for a long window with a switch point to short.
        for (uint cb = 0; cb < 8; cb++) {
          if ((scfsi[cb][ch] == 0) || (gr == 0)) {
            scalefac[gr][ch].long_window[cb] = _readBits(slen1[gr][ch]);
          }
        }

        for (uint cb = 3; cb < 6; cb++) {
          for (uint window = 0; window < 3; window++) {
            if ((scfsi[cb][ch] == 0) || (gr == 0)) {
              scalefac[gr][ch].short_window[cb][window] = _readBits(slen1[gr][ch]);
            }
          }
        }

        for (uint cb = 6; cb < cb_limit_short; cb++) {
          for (uint window = 0; window < 3; window++) {
            if ((scfsi[cb][ch] == 0) || (gr == 0)) {
              scalefac[gr][ch].short_window[cb][window] = _readBits(slen2[gr][ch]);
            }
          }
        }

        for (uint window = 0; window < 3; window++) {
          if ((scfsi[cb_limit_short][ch] == 0) || (gr == 0)) {
            scalefac[gr][ch].short_window[cb_limit_short][window] = 0;
          }
        }
      }
    }
    else {
      // The block_type cannot be 2 in this block (so, it must be block 0, 1, or 3).
      // Decoding the scalefactors for a long window
      if ((scfsi[0][ch] == 0) || (gr == 0)) {
        for (uint cb = 0; cb < 6; cb++) {
          scalefac[gr][ch].long_window[cb] = _readBits(slen1[gr][ch]);
        }
      }

      if ((scfsi[1][ch] == 0) || (gr == 0)) {
        for (uint cb = 6; cb < 11; cb++) {
          scalefac[gr][ch].long_window[cb] = _readBits(slen1[gr][ch]);
        }
      }

      if ((scfsi[2][ch] == 0) || (gr == 0)) {
        for (uint cb = 11; cb < 16; cb++) {
          scalefac[gr][ch].long_window[cb] = _readBits(slen2[gr][ch]);
        }
      }

      if ((scfsi[3][ch] == 0) || (gr == 0)) {
        for (uint cb = 16; cb < 21; cb++) {
          scalefac[gr][ch].long_window[cb] = _readBits(slen2[gr][ch]);
        }
      }

      // (The reference implementation does nothing with subband 21)

      // We fill it with a high negative integer:
      scalefac[gr][ch].long_window[21] = -858993460;

      scalefac[gr][ch].long_window[22] = 0;
    }
  }

  static const auto max_table_entry = 15;

  void _decodeHuffman(uint gr, uint ch) {
    // part2_3_length is the length of all of the data
    // (huffman + scalefactors). part2_length is just
    // the scalefactors by themselves.

    // Note: SSLIMIT * SBLIMIT = 32 * 18 = 576

    uint region1Start;
    uint region2Start;
    if (blocksplit_flag[gr][ch] == 1 && block_type[gr][ch] == 2) {
      // Short Blocks
      region1Start = 36;
      region2Start = 576; // There isn't a region 2 for short blocks
    }
    else {
      // Long Blocks
      region1Start = sfindex_long[_header.samplingFrequency][region_address1[gr][ch] + 1];
      region2Start = sfindex_long[_header.samplingFrequency][region_address1[gr][ch] + region_address2[gr][ch] + 2];
    }
    
    uint maxBand = big_values[gr][ch] * 2;

    if (region1Start > maxBand) { region1Start = maxBand; }
    if (region2Start > maxBand) { region2Start = maxBand; }

    uint freqIndex;

    uint pos    = _curByte;
    uint posbit = _curPos;

    // The number of bits used for the huffman data
    uint huffmanLength = (part2_3_length[gr][ch] - part2_length);

    // The bit position in the stream to stop.
    uint maxBit = huffmanLength + _curPos + (_curByte * 8);

    // Region 0
    if (freqIndex < region1Start) {
      _initializeHuffman(0,gr,ch);
    }

    for (; freqIndex < region1Start; freqIndex+=2) {
      int[] code = _readCode();
      _codedData[freqIndex / SSLIMIT][freqIndex % SSLIMIT] = code[0];
      _codedData[(freqIndex + 1) / SSLIMIT][(freqIndex + 1) % SSLIMIT] = code[1];
    }

    // Region 1
    if (freqIndex < region2Start) {
      _initializeHuffman(1, gr, ch);
    }

    for (; freqIndex < region2Start; freqIndex+=2) {
      int[] code = _readCode();
      _codedData[freqIndex / SSLIMIT][freqIndex % SSLIMIT] = code[0];
      _codedData[(freqIndex + 1) / SSLIMIT][(freqIndex + 1) % SSLIMIT] = code[1];
    }

    // Region 2
    if (freqIndex < maxBand) {
      _initializeHuffman(2,gr,ch);
    }

    for (; freqIndex < maxBand; freqIndex+=2) {
      int[] code = _readCode();
      _codedData[freqIndex / SSLIMIT][freqIndex % SSLIMIT] = code[0];
      _codedData[(freqIndex + 1) / SSLIMIT][(freqIndex + 1) % SSLIMIT] = code[1];
    }

    // Read in Count1 Area
    _initializeQuantizationHuffman(gr,ch);

    for (; (_curPos + (_curByte * 8)) < maxBit && freqIndex < 574; freqIndex += 4) {
      int[4] code = _readQuantizationCode();
      _codedData[freqIndex / SSLIMIT][freqIndex % SSLIMIT] = code[0];
      _codedData[(freqIndex + 1) / SSLIMIT][(freqIndex + 1) % SSLIMIT] = code[1];
      _codedData[(freqIndex + 2) / SSLIMIT][(freqIndex + 2) % SSLIMIT] = code[2];
      _codedData[(freqIndex + 3) / SSLIMIT][(freqIndex + 3) % SSLIMIT] = code[3];
    }

    // Zero the rest
    for (; freqIndex < 576; freqIndex++) {
      _codedData[freqIndex / SSLIMIT][freqIndex % SSLIMIT] = 0;
    }

    // Resync to the correct position
    // (where we started + the number of bits that would have been used)
    _curByte = maxBit / 8;
    _curPos = maxBit % 8;
  }

  void _requantizeSample(uint gr, uint ch) {
    uint criticalBandBegin;
    uint criticalBandWidth;
    uint criticalBandBoundary;
    uint criticalBandIndex;

    const int[22] pretab = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 3, 3, 3, 2, 0];

    // Initialize the critical boundary information
    if ((blocksplit_flag[gr][ch] == 1) && (block_type[gr][ch] == 2)) {
      if (switch_point[gr][ch] == 0) {
        // Short blocks
        criticalBandBoundary = sfindex_short[_header.samplingFrequency][1] * 3;
        criticalBandWidth = sfindex_short[_header.samplingFrequency][1];
        criticalBandBegin = 0;
      }
      else {
        // Long blocks come first for switched windows
        criticalBandBoundary = sfindex_long[_header.samplingFrequency][1];
      }
    }
    else {
      // Long windows
      criticalBandBoundary = sfindex_long[_header.samplingFrequency][1];
    }

    for (uint sb; sb < SBLIMIT; sb++) {
      for (uint ss; ss < SSLIMIT; ss++) {
        // Get the critical band boundary
        if ((sb * 18) + ss == criticalBandBoundary) {
          if (blocksplit_flag[gr][ch] == 1 && block_type[gr][ch] == 2) {
            if (switch_point[gr][ch] == 0) {
              // Requantizing the samples for a short window.
              criticalBandIndex++;
              criticalBandBoundary = sfindex_short[_header.samplingFrequency][criticalBandIndex+1]*3;
              criticalBandWidth = sfindex_short[_header.samplingFrequency][criticalBandIndex + 1] - sfindex_short[_header.samplingFrequency][criticalBandIndex];
              criticalBandBegin = sfindex_short[_header.samplingFrequency][criticalBandIndex] * 3;
            }
            else {
              // Requantizing the samples for a long window that switches to short.

              // The first two are long windows and the last two are short windows
              if (((sb * 18) + ss) == sfindex_long[_header.samplingFrequency][8]) {
                criticalBandBoundary = sfindex_short[_header.samplingFrequency][4] * 3;
                criticalBandIndex = 3;
                criticalBandWidth = sfindex_short[_header.samplingFrequency][criticalBandIndex + 1] - sfindex_short[_header.samplingFrequency][criticalBandIndex];
                criticalBandBegin = sfindex_short[_header.samplingFrequency][criticalBandIndex] * 3;
              }
              else if (((sb * 18) + ss) < sfindex_long[_header.samplingFrequency][8]) {
                criticalBandIndex++;
                criticalBandBoundary = sfindex_long[_header.samplingFrequency][criticalBandIndex+1];
              }
              else {
                criticalBandIndex++;
                criticalBandBoundary = sfindex_short[_header.samplingFrequency][criticalBandIndex + 1] * 3;
                criticalBandWidth = sfindex_short[_header.samplingFrequency][criticalBandIndex + 1] - sfindex_short[_header.samplingFrequency][criticalBandIndex];
                criticalBandBegin = sfindex_short[_header.samplingFrequency][criticalBandIndex] * 3;
              }
            }
          }
          else {
            // The block_type cannot be 2 in this block (so, it must be block 0, 1, or 3).

            // Requantizing the samples for a long window
            criticalBandIndex++;
            criticalBandBoundary = sfindex_long[_header.samplingFrequency][criticalBandIndex+1];
          }
        }

        // Global gain
        _quantizedData[ch][sb][ss] = pow(2.0, (0.25 * (cast(double)global_gain[gr][ch] - 210.0)));
        //printf("g : %d %d: %f\n", sb,ss,quantizedData[ch][sb][ss]);
        static bool output = false;
        // Perform the scaling that depends on the type of window
        if (blocksplit_flag[gr][ch] == 1
            && (((block_type[gr][ch] == 2) && (switch_point[gr][ch] == 0))
              || ((block_type[gr][ch] == 2) && (switch_point[gr][ch] == 1) && (sb >= 2)))) {

          // Short blocks (either via block_type 2 or the last 2 bands for switched windows)

          uint sbgainIndex = (((sb * 18) + ss) - criticalBandBegin) / criticalBandWidth;

          // if (output) printf("%d %d\n", sbgainIndex, criticalBandIndex);
          _quantizedData[ch][sb][ss] *= pow(2.0, 0.25 * -8.0
              * subblock_gain[sbgainIndex][gr][ch]);
          _quantizedData[ch][sb][ss] *= pow(2.0, 0.25 * -2.0 * (1.0 + scalefac_scale[gr][ch])
              * scalefac[gr][ch].short_window[criticalBandIndex][sbgainIndex]);
        }
        else {
          // Long blocks (either via block_type 0, 1, or 3, or the 1st 2 bands
          double powExp = -0.5 * (1.0 + cast(double)scalefac_scale[gr][ch])
            * (cast(double)scalefac[gr][ch].long_window[criticalBandIndex]
                + (cast(double)preflag[gr][ch] * cast(double)pretab[criticalBandIndex]));
          double powResult = pow(2.0, powExp);
          //if (powResult > 0.0) {
          //printf("r : %f\nfrom : %f\n", powResult, powExp);
          //printf("with : %f %d [%d, %d, %d] %f %f\n", cast(double)scalefac_scale[gr][ch], scalefac[gr][ch].long_window[criticalBandIndex], gr, ch, criticalBandIndex,
          //  cast(double)preflag[gr][ch], cast(double)pretab[criticalBandIndex]);
          //}
          _quantizedData[ch][sb][ss] *= powResult;
        }

        // Scale values

        double powResult = pow(cast(double)abs(_codedData[sb][ss]), 4.0/3.0);
        //  printf("%f\n", powResult);

        _quantizedData[ch][sb][ss] *= powResult;
        if (_codedData[sb][ss] < 0) {
          _quantizedData[ch][sb][ss] = -_quantizedData[ch][sb][ss];
        }
        //printf("%d %d: [%d] %.21f\n", sb,ss, codedData[sb][ss], quantizedData[ch][sb][ss]);
      }
    }
  }
  void _normalizeStereo(uint gr) {
    double io;

    if ((scalefac_compress[gr][0] % 2) == 1) {
      io = 0.707106781188;
    }
    else {
      io = 0.840896415256;
    }

    short[576] decodedPos;
    double[576] decodedRatio;
    double[576][2] k;

    int i;
    int sb;
    int ss;
    int ch;
    
    int scalefactorBand;

    // Initialize
    decodedPos[0..$] = 7;

    bool intensityStereo = (_header.mode == MPEG_MODE_JOINT_STEREO) && (_header.modeExtension & 0x1);
    bool msStereo = (_header.mode == MPEG_MODE_JOINT_STEREO) && (_header.modeExtension & 0x2);

    if ((_channels == 2) && intensityStereo) {
      if ((blocksplit_flag[gr][ch] == 1) && (block_type[gr][ch] == 2)) {
        if (switch_point[gr][ch] == 0) {
          for (uint j = 0; j < 3; j++) {
            int scalefactorCount = -1;

            for (scalefactorBand = 12; scalefactorBand >= 0; scalefactorBand--) {
              int lines = sfindex_short[_header.samplingFrequency][scalefactorBand + 1]
                - sfindex_short[_header.samplingFrequency][scalefactorBand];

              i = 3 * sfindex_short[_header.samplingFrequency][scalefactorBand]
                + ((j + 1) * lines) - 1;

              for (; lines > 0; lines--) {
                if (_quantizedData[1][i / SSLIMIT][i % SSLIMIT] != 0.0) {
                  scalefactorCount = scalefactorBand;
                  scalefactorBand = -10;
                  lines = -10;
                }
                i--;
              }
            }

            scalefactorBand = scalefactorCount + 1;

            for (; scalefactorBand < 12; scalefactorBand++) {
              sb = sfindex_short[_header.samplingFrequency][scalefactorBand+1]
                - sfindex_short[_header.samplingFrequency][scalefactorBand];

              i = 3 * sfindex_short[_header.samplingFrequency][scalefactorBand] + (j * sb);

              for ( ; sb > 0; sb--) {
                decodedPos[i] = cast(short)scalefac[gr][1].short_window[scalefactorBand][j];
                if (decodedPos[i] != 7) {
                  // IF (MPEG2) { ... }
                  // ELSE {
                  decodedRatio[i] = Trig.tan(cast(double)decodedPos[i] * (Trig.PI / 12));
                  // }
                }
                i++;
              }
            }

            sb = sfindex_short[_header.samplingFrequency][12] - sfindex_short[_header.samplingFrequency][11];
            scalefactorBand = (3 * sfindex_short[_header.samplingFrequency][11]) + (j * sb);
            sb = sfindex_short[_header.samplingFrequency][13] - sfindex_short[_header.samplingFrequency][12];

            i = (3 * sfindex_short[_header.samplingFrequency][11]) + (j * sb);

            for (; sb > 0; sb--) {
              decodedPos[i] = decodedPos[scalefactorBand];
              decodedRatio[i] = decodedRatio[scalefactorBand];
              k[0][i] = k[0][scalefactorBand];
              k[1][i] = k[1][scalefactorBand];
              i++;
            }
          }
        }
        else {
          int maxScalefactorBand;

          for (uint j; j<3; j++) {
            int scalefactorCount = 2;
            for (scalefactorBand = 12; scalefactorBand >= 3; scalefactorBand--) {
              int lines = sfindex_short[_header.samplingFrequency][scalefactorBand+1]
                - sfindex_short[_header.samplingFrequency][scalefactorBand];

              i = 3 * sfindex_short[_header.samplingFrequency][scalefactorBand]
                + ((j + 1) * lines) - 1;

              for (; lines > 0; lines--) {
                if (_quantizedData[1][i/SSLIMIT][i%SSLIMIT] != 0.0) {
                  scalefactorCount = scalefactorBand;
                  scalefactorBand = -10;
                  lines = -10;
                }
                i--;
              }
            }

            scalefactorBand = scalefactorCount + 1;

            if (scalefactorBand > maxScalefactorBand) {
              maxScalefactorBand = scalefactorBand;
            }

            for (; scalefactorBand < 12; scalefactorBand++) {
              sb = sfindex_short[_header.samplingFrequency][scalefactorBand+1]
                - sfindex_short[_header.samplingFrequency][scalefactorBand];

              i = 3 * sfindex_short[_header.samplingFrequency][scalefactorBand]
                + (j * sb);

              for (; sb > 0; sb--) {
                decodedPos[i] = cast(short)scalefac[gr][1].short_window[scalefactorBand][j];
                if (decodedPos[i] != 7) {
                  // IF (MPEG2) { ... }
                  // ELSE {
                  decodedRatio[i] = Trig.tan(cast(double)decodedPos[i] * (Trig.PI / 12.0));
                  // }
                }
                i++;
              }
            }

            sb = sfindex_short[_header.samplingFrequency][12]
              - sfindex_short[_header.samplingFrequency][11];
            scalefactorBand = 3 * sfindex_short[_header.samplingFrequency][11]
              + j * sb;
            sb = sfindex_short[_header.samplingFrequency][13]
              - sfindex_short[_header.samplingFrequency][12];

            i = 3 * sfindex_short[_header.samplingFrequency][11] + j * sb;
            for (; sb > 0; sb--) {
              decodedPos[i] = decodedPos[scalefactorBand];
              decodedRatio[i] = decodedRatio[scalefactorBand];
              k[0][i] = k[0][scalefactorBand];
              k[1][i] = k[1][scalefactorBand];
              i++;
            }
          }

          if (maxScalefactorBand <= 3) {
            i = 2;
            ss = 17;
            sb = -1;
            while (i >= 0) {
                if (_quantizedData[1][i][ss] != 0.0) {
                  sb = (i * 18) + ss;
                  i = -1;
                }
                else {
                  ss--;
                  if (ss < 0) {
                    i--;
                    ss = 17;
                  }
                }
              }

              i = 0;

              while (sfindex_long[_header.samplingFrequency][i] <= sb) {
                i++;
              }

              scalefactorBand = i;
              i = sfindex_long[_header.samplingFrequency][i];

              for (; scalefactorBand < 8; scalefactorBand++) {
                sb = sfindex_long[_header.samplingFrequency][scalefactorBand+1]
                  - sfindex_long[_header.samplingFrequency][scalefactorBand];
                for (; sb > 0; sb--) {
                  decodedPos[i] = cast(short)scalefac[gr][1].long_window[scalefactorBand];
                  if (decodedPos[i] != 7) {
                    // IF (MPEG2) { ... }
                    // ELSE {
                    decodedRatio[i] = Trig.tan(cast(double)decodedPos[i] * (Trig.PI / 12.0));
                    // }
                  }
                  i++;
                }
              }
            }
          }
        }
        else {
          i = 31;
          ss = 17;
          sb = 0;

          while (i >= 0) {
            if (_quantizedData[1][i][ss] != 0.0) {
              sb = (i * 18) + ss;
              i = -1;
            }
            else {
              ss--;
              if (ss < 0) {
                i--;
                ss = 17;
              }
            }
          }
          i = 0;

          while (sfindex_long[_header.samplingFrequency][i] <= sb) {
            i++;
          }

          scalefactorBand = i;
          i = sfindex_long[_header.samplingFrequency][i];

          for (; scalefactorBand < 21; scalefactorBand++) {
            sb = sfindex_long[_header.samplingFrequency][scalefactorBand+1]
              - sfindex_long[_header.samplingFrequency][scalefactorBand];

            for (; sb > 0; sb--) {
              decodedPos[i] = cast(short)scalefac[gr][1].long_window[scalefactorBand];
              if (decodedPos[i] != 7) {
                // IF (MPEG2) { ... }
                // ELSE {
                decodedRatio[i] = Trig.tan(cast(double)decodedPos[i] * (Trig.PI / 12.0));
                // }
              }
              i++;
            }
          }

          scalefactorBand = sfindex_long[_header.samplingFrequency][20];

          for (sb = 576 - sfindex_long[_header.samplingFrequency][21]; sb > 0; sb--) {
            decodedPos[i] = decodedPos[scalefactorBand];
            decodedRatio[i] = decodedRatio[scalefactorBand];
            k[0][i] = k[0][scalefactorBand];
            k[1][i] = k[1][scalefactorBand];
            i++;
          }
        }
      }

      for (ch = 0; ch < 2; ch++) {
        for (sb = 0; sb < SBLIMIT; sb++) {
          for (ss = 0; ss < SSLIMIT; ss++) {
            _normalizedData[ch][sb][ss] = 0;
          }
        }
      }

      if (_channels == 2) {
        for (sb = 0; sb < SBLIMIT; sb++) {
          for (ss = 0; ss < SSLIMIT; ss++) {
            i = (sb * 18) + ss;
            if (decodedPos[i] == 7) {
              if (msStereo) {
                _normalizedData[0][sb][ss] = (_quantizedData[0][sb][ss] + _quantizedData[1][sb][ss])
                  / 1.41421356;
                _normalizedData[1][sb][ss] = (_quantizedData[0][sb][ss] - _quantizedData[1][sb][ss])
                  / 1.41421356;
              }
              else {
                _normalizedData[0][sb][ss] = _quantizedData[0][sb][ss];
                _normalizedData[1][sb][ss] = _quantizedData[1][sb][ss];
              }
            }
            else if (intensityStereo) {
              // IF (MPEG2) {
              // _normalizedData[0][sb][ss] = _quantizedData[0][sb][ss] * k[0][i];
              // _normalizedData[1][sb][ss] = _quantizedData[0][sb][ss] * k[1][i];
              // }
              // ELSE {
              _normalizedData[0][sb][ss] = _quantizedData[0][sb][ss] * (decodedRatio[i] / (1 + decodedRatio[i]));
              _normalizedData[1][sb][ss] = _quantizedData[0][sb][ss] * (1 / (1 + decodedRatio[i]));
              // }
            }
            else {
              // Error ...
            }
          }
        }
      }
      else { // Mono
        for (sb = 0; sb < SBLIMIT; sb++) {
          for (ss = 0; ss < SSLIMIT; ss++) {
            _normalizedData[0][sb][ss] = _quantizedData[0][sb][ss];
        }
      }
    }
  }

  void _reorder(uint gr, uint ch) {
    int sfreq = _header.samplingFrequency;

    for (uint sb; sb < SBLIMIT; sb++) {
      for (uint ss; ss < SSLIMIT; ss++) {
        _reorderedData[sb][ss] = 0;
      }
    }

    if ((blocksplit_flag[gr][ch] == 1) && (block_type[gr][ch] == 2)) {
      if (switch_point[gr][ch] == 0) {
        // Recoder the short blocks
        uint scalefactorStart;
        uint scalefactorLines;

        for (uint scalefactorBand; scalefactorBand < 13; scalefactorBand++) {
          scalefactorStart = sfindex_short[sfreq][scalefactorBand];
          scalefactorLines = sfindex_short[sfreq][scalefactorBand + 1] - scalefactorStart;

          for (uint window; window < 3; window++) {
            for (uint freq; freq < scalefactorLines; freq++) {
              uint srcLine = (scalefactorStart * 3) + (window * scalefactorLines) + freq;
              uint destLine = (scalefactorStart * 3) + window + (freq * 3);
              _reorderedData[destLine / SSLIMIT][destLine % SSLIMIT] =
                _normalizedData[ch][srcLine / SSLIMIT][srcLine % SSLIMIT];
            }
          }
        }
      }
      else {
        // We do not reorder the long blocks
        for (uint sb; sb < 2; sb++) {
          for (uint ss; ss < SSLIMIT; ss++) {
            _reorderedData[sb][ss] = _normalizedData[ch][sb][ss];
          }
        }

        // We reorder the short blocks
        uint scalefactorStart;
        uint scalefactorLines;

        for (uint scalefactorBand = 3; scalefactorBand < 13; scalefactorBand++) {
          scalefactorStart = sfindex_short[sfreq][scalefactorBand];
          scalefactorLines = sfindex_short[sfreq][scalefactorBand + 1] - scalefactorStart;

          for (uint window; window < 3; window++) {
            for (uint freq; freq < scalefactorLines; freq++) {
              uint srcLine = (scalefactorStart * 3) + (window * scalefactorLines) + freq;
              uint destLine = (scalefactorStart * 3) + window + (freq * 3);
              _reorderedData[destLine / SSLIMIT][destLine % SSLIMIT] =
                _normalizedData[ch][srcLine / SSLIMIT][srcLine % SSLIMIT];
            }
          }
        }
      }
    }
    else {
      // We do not reorder long blocks
      for (uint sb; sb < SBLIMIT; sb++) {
        for (uint ss; ss < SSLIMIT; ss++) {
          _reorderedData[sb][ss] = _normalizedData[ch][sb][ss];
        }
      }
    }
  }

  // Butterfly anti-alias
  void _antialias(uint gr, uint ch) {
    uint subbandLimit = SBLIMIT - 1;

    // Ci[i] = [-0.6,-0.535,-0.33,-0.185,-0.095,-0.041,-0.0142,-0.0037];
    // cs[i] = 1.0 / (sqrt(1.0 + (Ci[i] * Ci[i])));
    // ca[i] = ca[i] * Ci[i];

    const double cs[8] = [
      0.85749292571254418689325777610964,
      0.88174199731770518177557399759066,
      0.94962864910273289204833276115398,
      0.98331459249179014599030200066392,
      0.99551781606758576429088040422867,
      0.99916055817814750452934664352117,
      0.99989919524444704626703489425565,
      0.99999315507028023572010150517204
        ];

    const double ca[8] = [
      -0.5144957554275265121359546656654,
      -0.47173196856497227224993208871065,
      -0.31337745420390185437594981118049,
      -0.18191319961098117700820587012266,
      -0.09457419252642064760763363840166,
      -0.040965582885304047685703212384361,
      -0.014198568572471148056991895498421,
      -0.0036999746737600368721643755691364
        ];

    // Init our working array with quantized data
    for (uint sb; sb < SBLIMIT; sb++) {
      for (uint ss; ss < SSLIMIT; ss++) {
        _hybridData[sb][ss] = _reorderedData[sb][ss];
      }
    }

    if ((blocksplit_flag[gr][ch] == 1) && (block_type[gr][ch] == 2) && (switch_point[gr][ch] == 0)) {
      return;
    }

    if ((blocksplit_flag[gr][ch] == 1) && (block_type[gr][ch] == 2) && (switch_point[gr][ch] == 1)) {
      subbandLimit = 1;
    }

    // 8 butterflies for each pair of subbands
    for (uint sb; sb < subbandLimit; sb++) {
      for (uint ss; ss < 8; ss++) {
        double bu = _reorderedData[sb][17 - ss];
        double bd = _reorderedData[sb + 1][ss];
        _hybridData[sb][17 - ss] = (bu * cs[ss]) - (bd * ca[ss]);
        _hybridData[sb + 1][ss] = (bd * cs[ss]) + (bu * ca[ss]);
      }
    }
  }

  double[] _inverseMDCT(double[18] working, int blockType) {
    double[] ret = new double[36];

    // The Constant Parts of the Windowing equations

    const double[36][4] win = [
      // Block Type 0
      // win[i] = Trig.sin( (Trig.PI / 36) * ( i + 0.5 ) ) ; i = 0 to 35
      [
      0.043619387365336000084, 0.130526192220051573400, 0.216439613938102876070,
      0.300705799504273119100, 0.382683432365089781770, 0.461748613235033911190,
      0.537299608346823887030, 0.608761429008720655880, 0.675590207615660132130,
      0.737277336810123973260, 0.793353340291235165080, 0.843391445812885720550,
      0.887010833178221602670, 0.923879532511286738480, 0.953716950748226821580,
      0.976296007119933362260, 0.991444861373810382150, 0.999048221581857798230,
      0.999048221581857798230, 0.991444861373810382150, 0.976296007119933362260,
      0.953716950748226932610, 0.923879532511286738480, 0.887010833178221824720,
      0.843391445812885831570, 0.793353340291235165080, 0.737277336810124084280,
      0.675590207615660354170, 0.608761429008720877930, 0.537299608346824109080,
      0.461748613235033911190, 0.382683432365089892800, 0.300705799504273341140,
      0.216439613938103181380, 0.130526192220051573400, 0.043619387365336069473
      ],
      // Block Type 1
      // win[i] = Trig.sin( (Trig.PI / 36) * ( i + 0.5 ) ) ; i = 0 to 17
      // win[i] = 1 ; i = 18 to 23
      // win[i] = Trig.sin( (Trig.PI / 12) * ( i - 18 + 0.5 ) ) ; i = 24 to 29
      // win[i] = 0 ; i = 30 to 35
      [
      0.043619387365336000084, 0.130526192220051573400, 0.216439613938102876070,
      0.300705799504273119100, 0.382683432365089781770, 0.461748613235033911190,
      0.537299608346823887030, 0.608761429008720655880, 0.675590207615660132130,
      0.737277336810123973260, 0.793353340291235165080, 0.843391445812885720550,
      0.887010833178221602670, 0.923879532511286738480, 0.953716950748226821580,
      0.976296007119933362260, 0.991444861373810382150, 0.999048221581857798230,
      1.000000000000000000000, 1.000000000000000000000, 1.000000000000000000000,
      1.000000000000000000000, 1.000000000000000000000, 1.000000000000000000000,
      0.991444861373810382150, 0.923879532511286738480, 0.793353340291235165080,
      0.608761429008720433840, 0.382683432365089448710, 0.130526192220051129310,
      0.000000000000000000000, 0.000000000000000000000, 0.000000000000000000000,
      0.000000000000000000000, 0.000000000000000000000, 0.000000000000000000000
      ],
      // Block Type 2
      // win[i] = Trig.sin( (Trig.PI / 12.0) * (i + 0.5) ) ; i = 0 to 11
      // win[i] = 0.0 ; i = 12 to 35
      [
      0.130526192220051601150, 0.382683432365089781770, 0.608761429008720766900,
      0.793353340291235165080, 0.923879532511286849500, 0.991444861373810382150,
      0.991444861373810382150, 0.923879532511286738480, 0.793353340291235165080,
      0.608761429008720433840, 0.382683432365089448710, 0.130526192220051129310,
      0.000000000000000000000, 0.000000000000000000000, 0.000000000000000000000,
      0.000000000000000000000, 0.000000000000000000000, 0.000000000000000000000,
      0.000000000000000000000, 0.000000000000000000000, 0.000000000000000000000,
      0.000000000000000000000, 0.000000000000000000000, 0.000000000000000000000,
      0.000000000000000000000, 0.000000000000000000000, 0.000000000000000000000,
      0.000000000000000000000, 0.000000000000000000000, 0.000000000000000000000,
      0.000000000000000000000, 0.000000000000000000000, 0.000000000000000000000,
      0.000000000000000000000, 0.000000000000000000000, 0.000000000000000000000
      ],
      // Block Type 3
      // win[i] = 0 ; i = 0 to 5
      // win[i] = Trig.sin( (Trig.PI / 12) * ( i - 6 + 0.5 ) ) ; i = 6 to 11
      // win[i] = 1 ; i = 12 to 17
      // win[i] = Trig.sin( (Trig.PI / 36) * ( i + 0.5 ) ) ; i = 18 to 35
      [
      0.000000000000000000000, 0.000000000000000000000, 0.000000000000000000000,
      0.000000000000000000000, 0.000000000000000000000, 0.000000000000000000000,
      0.130526192220051601150, 0.382683432365089781770, 0.608761429008720766900,
      0.793353340291235165080, 0.923879532511286849500, 0.991444861373810382150,
      1.000000000000000000000, 1.000000000000000000000, 1.000000000000000000000,
      1.000000000000000000000, 1.000000000000000000000, 1.000000000000000000000,
      0.999048221581857798230, 0.991444861373810382150, 0.976296007119933362260,
      0.953716950748226932610, 0.923879532511286738480, 0.887010833178221824720,
      0.843391445812885831570, 0.793353340291235165080, 0.737277336810124084280,
      0.675590207615660354170, 0.608761429008720877930, 0.537299608346824109080,
      0.461748613235033911190, 0.382683432365089892800, 0.300705799504273341140,
      0.216439613938103181380, 0.130526192220051573400, 0.043619387365336069473
      ]
    ];

    double[4*36] cosLookup = [
       1.000000000000000000000,  0.999048221581857798230,  0.996194698091745545190,  0.991444861373810382150,
       0.984807753012208020310,  0.976296007119933362260,  0.965925826289068312210,  0.953716950748226932610,
       0.939692620785908427900,  0.923879532511286738480,  0.906307787036649936670,  0.887010833178221713700,
       0.866025403784438707610,  0.843391445812885720550,  0.819152044288991798550,  0.793353340291235165080,
       0.766044443118978013450,  0.737277336810124084280,  0.707106781186547572730,  0.675590207615660354170,
       0.642787609686539362910,  0.608761429008720655880,  0.573576436351046159420,  0.537299608346823887030,
       0.500000000000000111020,  0.461748613235034077720,  0.422618261740699441280,  0.382683432365089837290,
       0.342020143325668823930,  0.300705799504273285630,  0.258819045102520739470,  0.216439613938102903830,
       0.173648177666930414450,  0.130526192220051712170,  0.087155742747658360158,  0.043619387365336007023,
       0.000000000000000061230, -0.043619387365335889061, -0.087155742747658013214, -0.130526192220051601150,
      -0.173648177666930303430, -0.216439613938102792810, -0.258819045102520628450, -0.300705799504272952570,
      -0.342020143325668712900, -0.382683432365089726260, -0.422618261740699330260, -0.461748613235033744660,
      -0.499999999999999777950, -0.537299608346823553970, -0.573576436351045826350, -0.608761429008720655880,
      -0.642787609686539362910, -0.675590207615660243150, -0.707106781186547461710, -0.737277336810123973260,
      -0.766044443118977902420, -0.793353340291235054060, -0.819152044288991576510, -0.843391445812885498510,
      -0.866025403784438707610, -0.887010833178221713700, -0.906307787036649936670, -0.923879532511286738480,
      -0.939692620785908316880, -0.953716950748226821580, -0.965925826289068201190, -0.976296007119933251230,
      -0.984807753012208020310, -0.991444861373810382150, -0.996194698091745545190, -0.999048221581857798230,
      -1.000000000000000000000, -0.999048221581857798230, -0.996194698091745545190, -0.991444861373810493170,
      -0.984807753012208131330, -0.976296007119933473280, -0.965925826289068312210, -0.953716950748226932610,
      -0.939692620785908427900, -0.923879532511286849500, -0.906307787036650047690, -0.887010833178221824720,
      -0.866025403784438818630, -0.843391445812885831570, -0.819152044288992020600, -0.793353340291235165080,
      -0.766044443118978013450, -0.737277336810124084280, -0.707106781186547683750, -0.675590207615660354170,
      -0.642787609686539473940, -0.608761429008720877930, -0.573576436351046381460, -0.537299608346824220100,
      -0.500000000000000444080, -0.461748613235034410790, -0.422618261740699940880, -0.382683432365090336890,
      -0.342020143325669379040, -0.300705799504272952570, -0.258819045102520628450, -0.216439613938102820560,
      -0.173648177666930331180, -0.130526192220051628910, -0.087155742747658249136, -0.043619387365336131923,
      -0.000000000000000183690,  0.043619387365335764161,  0.087155742747657888314,  0.130526192220051268080,
       0.173648177666929970360,  0.216439613938102459740,  0.258819045102520295380,  0.300705799504272619500,
       0.342020143325668157790,  0.382683432365089171150,  0.422618261740698830660,  0.461748613235034077720,
       0.500000000000000111020,  0.537299608346823887030,  0.573576436351046048400,  0.608761429008720544860,
       0.642787609686539251890,  0.675590207615660132130,  0.707106781186547350690,  0.737277336810123862240,
       0.766044443118977791400,  0.793353340291234943030,  0.819152044288991576510,  0.843391445812885498510,
       0.866025403784438374540,  0.887010833178221491650,  0.906307787036649714620,  0.923879532511286516430,
       0.939692620785908094830,  0.953716950748226710560,  0.965925826289068312210,  0.976296007119933362260,
       0.984807753012208020310,  0.991444861373810382150,  0.996194698091745545190,  0.999048221581857798230,
    ];

    // Zero to initialize
    ret[0..$] = 0.0;

    if (blockType == 2) {
      uint N = 12;
      for (uint i; i < 3; i++) {
        double[12] tmp;

        for (uint p; p < N; p++) {
          double sum = 0.0;
          for (uint m; m < (N / 2); m++) {
            sum += working[i + (3 * m)] * Trig.cos((Trig.PI / cast(double)(2 * N)) * cast(double)((2 * p) + 1 + (N / 2)) * ((2 * m) + 1));
          }
          tmp[p] = sum * win[2][p];
        }
        for (uint p; p < N; p++) {
          ret[(6 * i) + p + 6] += tmp[p];
        }
      }
    }
    else {
      uint N = 36;
      for (uint p; p < 36; p++) {
        double sum = 0.0;
        for (uint m; m < 18; m++) {
          sum += working[m] * cosLookup[(((2 * p) + 1 + 18) * ((2 * m) + 1)) % (4 * 36)];
        }
        ret[p] = sum * win[blockType][p];
      }
    }

    return ret;
  }

  void _hybridSynthesis(uint gr, uint ch, uint sb) {
    int blockType = block_type[gr][ch];

    if ((blocksplit_flag[gr][ch] == 1) && (switch_point[gr][ch] == 1) && (sb < 2)) {
      blockType = 0;
    }

    double[36] output = _inverseMDCT(_hybridData[sb], blockType);

    // Overlapping and Adding with Previous Block:
    // The last half gets reserved for the next block, and used in this block
    for (uint ss; ss < SSLIMIT; ss++) {
      _polysynthData[ch][sb][ss] = output[ss] + _previousBlock[ch][sb][ss];
      _previousBlock[ch][sb][ss] = cast(ZeroDouble)output[ss+18];
    }
  }

  void _polyphaseSynthesis(uint gr, uint ss, Waveform output) {
    double sum;

    long foo;

    double* bufOffsetPtr;
    double* bufOffsetPtr2;

    if (_channels == 1) {
      uint channel = 0;

      _bufOffset[channel] = (_bufOffset[channel] - 64) & 0x3ff;
      bufOffsetPtr = cast(double*)&BB[channel][_bufOffset[channel]];

      for (int i = 0; i < 64; i++) {
        sum = 0;
        for (int k = 0; k < 32; k++) {
          sum += _polysynthData[channel][k][ss] * nCoefficients[i][k];
        }
        bufOffsetPtr[i] = sum;
      }

      for (int j = 0; j < 32; j++) {
        sum = 0;
        for (int i = 0; i < 16; i++) {
          int k = j + (i << 5);

          sum += windowCoefficients[k] * BB[channel][((k + (((i + 1) >> 1) << 6)) + _bufOffset[channel]) & 0x3ff];
        }

        if(sum > 0) {
          foo = cast(long)(sum * cast(double)32768 + cast(double)0.5);
        }
        else {
          foo = cast(long)(sum * cast(double)32768 - cast(double)0.5);
        }

        if (foo >= cast(long)32768) {
//          toBuffer.write(cast(short)(32768-1));
          //++clip;
        }
        else if (foo < cast(long)-32768) {
//          toBuffer.write(cast(short)(-32768));
          //++clip;
        }
        else {
//          toBuffer.write(cast(short)foo);
        }
      }
    }
    else {
      // INTERLEAVE CHANNELS!

      _bufOffset[0] = (_bufOffset[0] - 64) & 0x3ff;
      bufOffsetPtr = cast(double*)&BB[0][_bufOffset[0]];

      _bufOffset[1] = (_bufOffset[1] - 64) & 0x3ff;
      bufOffsetPtr2 = cast(double*)&BB[1][_bufOffset[1]];

      double sum2;

      for (int i = 0; i < 64; i++) {
        sum  = 0;
        sum2 = 0;
        for (int k = 0; k < 32; k++) {
          sum  += _polysynthData[0][k][ss] * nCoefficients[i][k];
          sum2 += _polysynthData[1][k][ss] * nCoefficients[i][k];
        }
        bufOffsetPtr[i]  = sum;
        bufOffsetPtr2[i] = sum2;
      }

      long[32] ch1;
      long[32] ch2;

      for (int j = 0; j < 32; j++) {
        sum  = 0;
        sum2 = 0;
        for (int i = 0; i < 16; i++) {
          int k = j + (i << 5);

          sum  += windowCoefficients[k] * BB[0][( (k + ( ((i+1)>>1) << 6) ) + _bufOffset[0]) & 0x3ff];
          sum2 += windowCoefficients[k] * BB[1][( (k + ( ((i+1)>>1) << 6) ) + _bufOffset[1]) & 0x3ff];
        }

        if(sum > 0) {
          foo = cast(long)(sum * cast(double)32768 + cast(double)0.5);
        }
        else {
          foo = cast(long)(sum * cast(double)32768 - cast(double)0.5);
        }

        if (foo >= cast(long)32768) {
          //toBuffer.write(cast(short)(32768-1));
          ch1[j] = 32768;
        }
        else if (foo < cast(long)-32768) {
          //toBuffer.write(cast(short)(-32768));
          ch1[j] = -32768;
        }
        else {
          //toBuffer.write(cast(short)foo);
          ch1[j] = foo;
        }

        if(sum2 > 0) {
          foo = cast(long)(sum2 * cast(double)32768 + cast(double)0.5);
        }
        else {
          foo = cast(long)(sum2 * cast(double)32768 - cast(double)0.5);
        }

        if (foo >= cast(long)32768) {
          //toBuffer.write(cast(short)(32768-1));
          ch2[j] = 32768;
        }
        else if (foo < cast(long)-32768) {
          //toBuffer.write(cast(short)(-32768));
          ch2[j] = -32768;
        }
        else {
          //toBuffer.write(cast(short)foo);
          ch2[j] = foo;
        }
      }
    }
  }

  void _readHeader() {
    if (_input.available < uint.sizeof) {
      _currentState = _state;
      _state = State.Required;
      return;
    }

    ubyte* ptr = cast(ubyte*)&_mpegHeader;
    _input.read(ptr[0 .. uint.sizeof]);

    _mpegHeader = _cpu.fromBigEndian32(_mpegHeader);

    _state = State.AmbiguousSync;
  }

  void _ambiguousSync() {
    printf("%.8x\n", _mpegHeader);
    if ((_mpegHeader & 0xffffff00) == 0x49443300) {
      // Id3 header found, read id3
      if (_id3.signature[0] != 0x49) {
        ubyte* ptr = cast(ubyte*)&_id3;
        ptr += 4; // Skip header, which was read already
        if (_input.available < (_id3.sizeof - 4)) {
          _currentState = _state;
          _state = State.Required;
          return;
        }

        _input.read(ptr[0 .. (_id3.sizeof - 4)]);
      }

      _id3.signature[0] = 0x49;

      _id3.ver[0] = cast(ubyte)(_mpegHeader & 0xff);

      long id3length = 0;
      foreach(b; _id3.len) {
        id3length <<= 7;
        b &= 0x7f;
        id3length |= b;
      }

      if (_input.available < id3length) {
        _currentState = _state;
        _state = State.Required;
        return;
      }

      _input.seek(id3length);
      _state = State.ReadHeader;
      return;
    }

    // Actually an mpeg sync frame
    if ((_mpegHeader & MPEG_SYNC_BITS) == MPEG_SYNC_BITS) {
      // pull apart header

      // the header looks like this:

      // SYNCWORD      12 bits
      // ID        1 bit
      // LAYER      2 bits
      // PROTECTION BIT  1 bit
      // BITRATE INDEX  4 bits
      // SAMPLING FREQ  2 bits
      // PADDING BIT    1 bit
      // PRIVATE BIT    1 bit
      // MODE        2 bits
      // MODE EXTENSION  2 bits
      // COPYRIGHT    1 bit
      // ORIGINAL/HOME  1 bit
      // EMPHASIS      2 bits
      _header.id = (_mpegHeader & MPEG_ID_BIT ? 1 : 0);
      _header.layer = (_mpegHeader & MPEG_LAYER) >> MPEG_LAYER_SHIFT;

      if (_header.layer != 1) {
        printf("not layer 3\n");
        _state = State.Invalid;
        return;
      }

      _header.protectedBit = (_mpegHeader & MPEG_PROTECTION_BIT ? 1 : 0);
      _header.bitrateIndex = (_mpegHeader & MPEG_BITRATE_INDEX) >> MPEG_BITRATE_INDEX_SHIFT;
      _header.samplingFrequency = (_mpegHeader & MPEG_SAMPLING_FREQ) >> MPEG_SAMPLING_FREQ_SHIFT;
      _header.padding = (_mpegHeader & MPEG_PADDING_BIT ? 1 : 0);
      _header.privateBit = (_mpegHeader & MPEG_PRIVATE_BIT ? 1 : 0);
      _header.mode = (_mpegHeader & MPEG_MODE) >> MPEG_MODE_SHIFT;
      _header.modeExtension = (_mpegHeader & MPEG_MODE_EXTENSION) >> MPEG_MODE_EXTENSION_SHIFT;
      _header.copyright = (_mpegHeader & MPEG_COPYRIGHT ? 1 : 0);
      _header.original = (_mpegHeader & MPEG_ORIGINAL ? 1 : 0);
      _header.emphasis = (_mpegHeader & MPEG_EMPHASIS) >> MPEG_EMPHASIS_SHIFT;

      _bufferLength = cast(uint)(144 * (cast(double)bitRates[_header.bitrateIndex]
                    / cast(double)_samplingFrequencies[_header.samplingFrequency]));

      if (_header.padding) {
        _bufferLength++;
      }
      _bufferLength -= 4;

      if (_header.samplingFrequency == 0) {
        _samplingFrequency = 44100;
        printf("freq: 44100\n");
      }
      else if (_header.samplingFrequency == 1) {
        _samplingFrequency = 48000;
        printf("freq: 48000\n");
      }
      else {
        _samplingFrequency = 32000;
        printf("freq: 32000\n");
      }

      switch (_header.mode) {
        case MPEG_MODE_STEREO:
        case MPEG_MODE_DUAL_CHANNEL:
          _channels = 2;
          printf("channels: 2\n");
          break;

        case MPEG_MODE_SINGLE_CHANNEL:
          _channels = 1;
          printf("channels: 1\n");
          break;

        case MPEG_MODE_JOINT_STEREO:
          printf("channels: 2 joint stereo\n");
          _channels = 2;
          break;

        default:
          printf("mode makes little sense\n");
          _state = State.Invalid;
          return;
      }

      _averageBytesPerSecond = _samplingFrequency * 2 * _channels;
      _blockAlign = 2 * _channels;
      _bitsPerSample = 16;

      if (_header.protectedBit == 0) {
        printf("crc\n");
        _state = State.ReadCRC;
      }
      else {
        printf("reading data\n");
        _state = State.ReadAudioData;
      }

      if (!_accepted) {
      }

      _accepted = true;
    }
    else {
      // Not a sync... so we increment to the next byte and try again
      printf("not sync\n");
      if (_input.available < 1) {
        _currentState = _state;
        _state = State.Required;
        return;
      }

      ubyte b;
      ubyte* ptr = &b;
      _input.read(ptr[0..1]);

      _mpegHeader <<= 8;
      _mpegHeader |= cast(uint)b;
    }
  }

  void _readCRC() {
    if (_input.available < _crc.sizeof) {
      _currentState = _state;
      _state = State.Required;
      return;
    }

    ubyte* ptr = cast(ubyte*)&_crc;
    _input.read(ptr[0 .. _crc.sizeof]);

    _state = State.ReadAudioData;
  }

  void _bufferAudio() {
    _samplesLeft = 1728 * NUM_BLOCKS;

    _state = State.ReadHeader;
  }

  void _readAudioData() {
    _curByte = _audioData.length - _bufferLength;
    _curPos  = 0;

    switch (_header.mode) {
      case MPEG_MODE_STEREO:
      case MPEG_MODE_DUAL_CHANNEL:
      case MPEG_MODE_SINGLE_CHANNEL:
        printf("read single channel\n");
        _state = State.ReadAudioDataSingleChannel;
        break;

      case MPEG_MODE_JOINT_STEREO:
        _state = State.ReadAudioDataJointStereo;
        break;

      default:
        printf("invalid mode\n");
        _state = State.Invalid;
        break;
    }
  }

  void _readAudioDataSingleChannel() {
    if (_channels == 1) {
      _audioHeaderLength = 17;
    }
    else {
      _audioHeaderLength = 32;
    }

    if (_input.available < _audioHeaderLength) {
      _currentState = _state;
      _state = State.Required;
      return;
    }

    _input.read(_audioHeader.ptr[0 .. _audioHeaderLength]);
    _audioRef = _audioHeader;
    _audioRefLength = _audioHeader.length;
    _curByte = 0;
    _curPos = 0;

    // Actually main_data_end in the spec
    // But that doesn't make any sense in this context
    _mainDataBegin = _readBits(9);

    // Ignore private bits
    if (_channels == 1) {
      _readBits(5);
    }
    else {
      _readBits(3);
    }

    for (uint ch = 0; ch < _channels; ch++) {
      for (uint scfsi_band = 0; scfsi_band < 4; scfsi_band++) {
        scfsi[scfsi_band][ch] = _readBits(1);
      }
    }

    // 18 or 16 bits read

    for (uint gr = 0; gr < 2; gr++) {
      for (uint ch = 0; ch < _channels; ch++) {
        part2_3_length[gr][ch]    = _readBits(12);
        big_values[gr][ch]        = _readBits(9);
        global_gain[gr][ch]       = _readBits(8);
        scalefac_compress[gr][ch] = _readBits(4);
        blocksplit_flag[gr][ch]   = _readBits(1);

        slen1[gr][ch] = slen1_interpret[scalefac_compress[gr][ch]];
        slen2[gr][ch] = slen2_interpret[scalefac_compress[gr][ch]];

        if (blocksplit_flag[gr][ch]) {
          block_type[gr][ch]   = _readBits(2);
          switch_point[gr][ch] = _readBits(1);
          for (uint region = 0; region < 2; region++) {
            table_select[region][gr][ch] = _readBits(5);
          }

          // window -- Number of actual time slot in case of
          // block_type == 2, 0 = window = 2.

          for (uint window = 0; window < 3; window++) {
            subblock_gain[window][gr][ch] = _readBits(3);
          }

          if (block_type[gr][ch] == 2 && switch_point[gr][ch] == 0) {
            region_address1[gr][ch] = 8;
          }
          else {
            region_address1[gr][ch] = 7;
          }

          region_address2[gr][ch] = 20 - region_address1[gr][ch];

          if (switch_point[gr][ch] == 1) {
            switch_point_l[gr][ch] = 8;
            switch_point_s[gr][ch] = 3;
          }
          else {
            switch_point_l[gr][ch] = 0;
            switch_point_s[gr][ch] = 0;
          }
        }
        else {
          block_type[gr][ch] = 0;

          for (uint region = 0; region < 3; region++) {
            table_select[region][gr][ch] = _readBits(5);
          }

          region_address1[gr][ch] = _readBits(4);
          region_address2[gr][ch] = _readBits(3);

          switch_point[gr][ch] = 0;
          switch_point_l[gr][ch] = 0;
          switch_point_s[gr][ch] = 0;
        }

        preflag[gr][ch]            = _readBits(1);
        scalefac_scale[gr][ch]     = _readBits(1);
        count1table_select[gr][ch] = _readBits(1);
      }
    }

    _bufferLength -= _audioHeaderLength;
    _audioData ~= new ubyte[_bufferLength];

    printf("scale factors\n");
    _state = State.ReadAudioDataScaleFactors;
  }

  void _readAudioDataScaleFactors(Waveform output) {
    if (_input.available < _bufferLength) {
      _currentState = _state;
      _state = State.Required;
      return;
    }

    _input.read(_audioData.ptr[_audioData.length - _bufferLength .. _audioData.length]);

    _curByte  = _audioData.length;
    _curByte -= _bufferLength;
    _curByte -= _mainDataBegin;

    _mainDataBegin = _curByte;

    _audioRefLength = _audioData.length;
    _audioRef = _audioData;

    _curPos = 0;

    for (uint gr = 0; gr < 2; gr++) {
      for (uint ch = 0; ch < _channels; ch++) {
        part2_length = (_curByte * 8) + _curPos;

        // Read the scalefactors for this granule
        _readScalefactors(gr, ch);

        part2_length = ((_curByte * 8) + _curPos) - part2_length;

        // Decode the current huffman data
        _decodeHuffman(gr, ch);

        // Requantize
        _requantizeSample(gr, ch);
      }

      // Account for a mode switch from intensity stereo to MS_stereo
      _normalizeStereo(gr);

      for (uint ch = 0; ch < _channels; ch++) {
        // Reorder the short blocks
        _reorder(gr, ch);

        // Perform anti-alias pass on subband butterflies
        _antialias(gr, ch);

        // Perform hybrid synthesis pass
        for (uint sb; sb < SBLIMIT; sb++) {
          _hybridSynthesis(gr, ch, sb);
        }

        // Multiply every second subband's every second input by -1
        // To correct for frequency inversion of the polyphase filterbank
        for (uint sb; sb < SBLIMIT; sb++) {
          for (uint ss; ss < SSLIMIT; ss++) {
            if (((ss % 2) == 1) && ((sb % 2) == 1)) {
              _polysynthData[ch][sb][ss] = -_polysynthData[ch][sb][ss];
            }
          }
        }
      }

      // Polyphase Synthesis
      for (uint ss; ss < 18; ss++) {
        _polyphaseSynthesis(gr, ss, output);
      }
    }

    _samplesLeft -= (3 * 18 * 32 * _channels);

    if (_samplesLeft <= 0) {
      _state = State.BufferAudio;
      return;
    }

    _mainDataEnd = _curByte + 1;

    _state = State.ReadHeader;
  }

  Stream _input;

public:
  this(Stream input) {
    _input = input;
  }

  AudioDecoder decoder() {
    return new AudioDecoder(&decode, &description, &tags);
  }

  AudioDecoder.State decode(Waveform output) {
    _cpu = Architecture.currentCpu;

    for(;;) {
      switch (_state) {
        case State.Init:
          printf("init\n");
          _init();
          break;

        case State.BufferAudio:
          printf("buffer audio\n");
          _bufferAudio();
          break;

        case State.ReadHeader:
          printf("read header\n");
          _readHeader();
          break;
          
        case State.AmbiguousSync:
          _ambiguousSync();
          break;

        case State.ReadCRC:
          _readCRC();
          break;

        case State.ReadAudioData:
          _readAudioData();
          break;

        case State.ReadAudioDataSingleChannel:
          _readAudioDataSingleChannel();
          break;

        case State.ReadAudioDataScaleFactors:
          if (output is null) {
            return AudioDecoder.State.WaveformRequired;
          }

          _readAudioDataScaleFactors(output);
          break;

        case State.Required:
          _state = _currentState;

          if (_state < State.ReadHeader) {
            return AudioDecoder.State.Insufficient;
          }

          return AudioDecoder.State.Accepted;

        case State.Complete:
          return AudioDecoder.State.Complete;

        default:
        case State.Invalid:
          return AudioDecoder.State.Invalid;
      }
    }

    return AudioDecoder.State.Invalid;
  }

  AudioDecoder.State seek(long microseconds) {
    _cpu = Architecture.currentCpu;

    for(;;) {
      switch (_state) {
        case State.Init:
          _init();
          break;

        case State.Required:
          _state = _currentState;

          if (_state < State.ReadHeader) {
            return AudioDecoder.State.Insufficient;
          }

          return AudioDecoder.State.Accepted;

        case State.Complete:
          return AudioDecoder.State.Complete;

        default:
        case State.Invalid:
          return AudioDecoder.State.Invalid;
      }
    }

    return AudioDecoder.State.Invalid;
  }

  Time duration() {
    return new Time;
  }

  char[] description() {
    return "Mpeg-3 Audio";
  }

  char[][] tags() {
    return ["mp3"];
  }
}
