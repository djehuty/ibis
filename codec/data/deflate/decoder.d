module codec.data.deflate.decoder;

import codec.data.decoder;

import io.stream;

import system.architecture;
import system.cpu;

final class DeflateDecoder {
private:
  enum State {
    Init,

    Invalid,
    Required,

    ReadByte,

    ReadBits,
    ReadBit,

    ReadBitsRev,
    ReadBitRev,

    ReadBFinal,
    ReadBType,

    DeflateNoCompression,
    DeflateNoCompressionSkip,
    DeflateNoCompressionCopy,

    DeflateFixedCheckCode,
    DeflateFixedGetLength,
    DeflateFixedGetDistance,
    DeflateFixedGetDistanceEx,

    DeflateDynamicCompression,
    DeflateDynamicHDIST,
    DeflateDynamicHCLEN,
    DeflateDynamicGetCodeLen,
    DeflateDynamicDecodeLens,

    DeflateDynamicDecodeLen16,
    DeflateDynamicDecodeLen17,
    DeflateDynamicDecodeLen18,
    DeflateDynamicDecodeDist,
    DeflateDynamicBuildTree,
    DeflateDynamicDecoder,
    DeflateDynamicGetLength,
    DeflateDynamicGetDistance,
    DeflateDynamicGetDistEx,

    Complete,
  }

  enum Compression {
    None,
    FixedHuffman,
    DynamicHuffman,
  }

  struct HuffmanRange {
    ushort huffmanBase;
    ushort huffmanMinorCode;
    ushort huffmanMajorCode;
  }

  struct HuffmanEntry {
    ushort            huffmanRangesCount;
    HuffmanRange[144] huffmanRanges;
  }

  struct HuffmanTable {
    HuffmanEntry[16] huffmanEntries;
  }

  struct DeflateBlockInfo {
    int isLastBlock;
    int blockType;
  }

  struct DeflateLengthEntry {
    ubyte  extraBits;
    ushort base;
  }

  static const HuffmanTable _deflateFixedHuffmanTable  = { [
    { 0, [{0}] },                                      //  1 bit
    { 0, [{0}] },                                      //  2 bits
    { 0, [{0}] },                                      //  3 bits
    { 0, [{0}] },                                      //  4 bits
    { 0, [{0}] },                                      //  5 bits
    { 0, [{0}] },                                      //  6 bits
    { 1, [ { 256, 0x00, 0x17 } ] },                    //  7 bits
    { 2, [ { 0, 0x30, 0xBF }, { 280, 0xC0, 0xC7 } ] }, //  8 bits
    { 1, [ { 144, 0x190, 0x1FF } ] },                  //  9 bits

    /*

    { 0 } ...                                          // 10 - 16 bits
     
    */

  ] };

  static const DeflateLengthEntry _deflateLengthTable[29] = [ 
    { 0, 3 },
    { 0, 4 },
    { 0, 5 },
    { 0, 6 },
    { 0, 7 },
    { 0, 8 },
    { 0, 9 },
    { 0, 10 },
    { 1, 11 },
    { 1, 13 },
    { 1, 15 },
    { 1, 17 },
    { 2, 19 },
    { 2, 23 },
    { 2, 27 },
    { 2, 31 },
    { 3, 35 },
    { 3, 43 },
    { 3, 51 },
    { 3, 59 },
    { 4, 67 },
    { 4, 83 },
    { 4, 99 },
    { 4, 115 },
    { 5, 131 },
    { 5, 163 },
    { 5, 195 },
    { 5, 227 },
    { 0, 258 }   
  ];

  static const DeflateLengthEntry[30] _globalDeflateDistanceTable = [
    {  0, 1     },
    {  0, 2     },
    {  0, 3     },
    {  0, 4     },
    {  1, 5     },
    {  1, 7     },
    {  2, 9     },
    {  2, 13    },
    {  3, 17    },
    {  3, 25    },
    {  4, 33    },
    {  4, 49    },
    {  5, 65    },
    {  5, 97    },
    {  6, 129   },
    {  6, 193   },
    {  7, 257   },
    {  7, 385   },
    {  8, 513   },
    {  8, 769   },
    {  9, 1025  },
    {  9, 1537  },
    { 10, 2049  },
    { 10, 3073  },
    { 11, 4097  },
    { 11, 6145  },
    { 12, 8193  },
    { 12, 12289 },
    { 13, 16385 },
    { 13, 24577 }
  ];

  // This is used to refer to the correct spot in the code lengths array.
  // For computing huffman tables for dynamic compression, code lengths occur
  //  in this order:
  //  16, 17, 18, 0, 8, 7, 9, 6, 10, 5, 11, 4, 12, 3, 13, 2, 14, 1, 15
  // This works under the assumption  that the later code lengths will be 0 and
  //  thus not necessary to include. Also, 16, 17, 18, 0 are thus not necessary
  //  (thus why HCLEN + 4 is the number of codes to retrieve)
  static const ubyte _deflateCodeLengthsReference[19] = [
    16, 17, 18, 0, 8, 7, 9, 6, 10, 5, 11, 4, 12, 3, 13, 2, 14, 1, 15
  ];

  // Bit mask for getting the bit
  ubyte _deflateCurMask;
  ubyte _deflateCurBit;
  ubyte _deflateCurByte;

  uint  _deflateBitsLeft;
  uint  _deflateCurValue;
  ubyte _deflateCurValueBit;

  State _deflateLastState;
  uint  _deflateCurCode;

  // Block header
  DeflateBlockInfo _deflateCurBlock;

  // For Compression.None
  ushort _deflateDataLength;

  // For Huffman Compression

  // Current Huffman tables
  HuffmanTable _deflateInternalHuffmanTable;
  HuffmanTable _deflateInternalDistanceTable;

  // Regular Huffman Decoder
  uint _deflateCurHuffmanBitLength;
  HuffmanTable* _deflateCurHuffmanTable;
  HuffmanEntry* _deflateCurHuffmanEntry;

  // Distance Tree Decoder
  HuffmanEntry* _deflateCurDistanceEntry;
  uint          _deflateCurDistanceBitLength;

  // Track Length, Distance
  ushort _deflateLength;
  ushort _deflateDistance;

  // Counter
  uint _deflateCounter;
  uint _deflateCounterMax;

  // Dynamic Huffman Tree Building
  ushort _deflateHLIT;
  ushort _deflateHDIST;
  ushort _deflateHCLEN;

  // Holds the bit length of the code
  ubyte[19] _deflateCodeLengths;

  // Counts how many of each length have been found
  ubyte[7]  _deflateCodeLengthCount;

  // The Huffman table for code lengths
  HuffmanTable _deflateCodeLengthTable;

  // The minimum code size for a code length code
  ushort _deflateCodeLengthCodeSize = 1;
  ushort _deflateDistanceCodeLengthCodeSize = 1;

  // Huffman table for actual codes
  ubyte[288]  _deflateHuffmanLengths;
  ubyte[32]   _deflateDistanceLengths;
  
  ushort[16]  _deflateHuffmanLengthCounts;
  ushort[16]  _deflateDistanceLengthCounts;

  ushort*     _deflateCurLengthCountArray;
  ubyte*      _deflateCurLengthArray;

  ushort[578] _deflateHuffmanTable;
  ushort[68]  _deflateDistanceTable;

  ushort[16]  _deflateHuffmanNextCodes;

  ushort      _deflateTreePosition;

  State  _state;
  State  _nextState;
  State  _currentState;

  Stream _input;

  Cpu _cpu;

  void _init() {
    _deflateCurValue    = 0;
    _deflateCurValueBit = 0;

    _deflateLastState   = State.ReadBFinal;

    _state     = State.ReadByte;
    _nextState = State.ReadBit;
  }

  void _readByte() {
    if (_input.available == 0) {
      _state = State.Required;
      _currentState = State.ReadByte;
      return;
    }

    ubyte* ptr = &_deflateCurByte;
    _input.read(ptr[0..1]);

    _deflateCurMask = 1; // 0b00000001
    _deflateCurBit  = 0;

    _state = _nextState;
  }

  void _readBits() {
    if (_deflateCurMask == 0) {
      _state = State.ReadByte;
      _nextState = State.ReadBits;
      return;
    }

    ubyte masked = _deflateCurByte & _deflateCurMask;
    if (masked > 0) {
      if (_deflateCurBit > _deflateCurValueBit) {
        _deflateCurValue |= masked >> (_deflateCurBit - _deflateCurValueBit);
      }
      else if (_deflateCurBit == _deflateCurValueBit) {
        _deflateCurValue |= masked;
      }
      else {
        _deflateCurValue |= masked << (_deflateCurValueBit - _deflateCurBit);
      }
    }

    _deflateCurMask <<= 1;

    _deflateBitsLeft--;
    _deflateCurBit++;
    _deflateCurValueBit++;

    if (_deflateBitsLeft == 0) {
      _state = _deflateLastState;
    }
  }

  void _readBit() {
    if (_deflateCurMask == 0) {
      _state     = State.ReadByte;
      _nextState = State.ReadBit;
      return;
    }

    ubyte masked = _deflateCurByte & _deflateCurMask;
    if (masked > 0) {
      if (_deflateCurBit > _deflateCurValueBit) {
        _deflateCurValue |= masked >> (_deflateCurBit - _deflateCurValueBit);
      }
      else if (_deflateCurBit == _deflateCurValueBit) {
        _deflateCurValue |= masked;
      }
      else {
        _deflateCurValue |= masked << (_deflateCurValueBit - _deflateCurBit);
      }
    }

    _deflateCurMask <<= 1;
    _deflateCurBit++;
    _deflateCurValueBit++;

    _state = _deflateLastState;
  }

  void _readBitsRev() {
    if (_deflateCurMask == 0) {
      _state     = State.ReadByte;
      _nextState = State.ReadBitsRev;
      return;
    }

    _deflateCurValue <<= 1;

    ubyte masked = _deflateCurByte & _deflateCurMask;
    if (masked > 0) {
      _deflateCurValue++;
    }

    _deflateCurMask <<= 1;
    _deflateCurBit++;

    _deflateBitsLeft--;

    if (_deflateBitsLeft == 0) {
      _state = _deflateLastState;
    }
  }

  void _readBitRev() {
    if (_deflateCurMask == 0) {
      _state     = State.ReadByte;
      _nextState = State.ReadBitRev;
      return;
    }

    _deflateCurValue <<= 1;

    ubyte masked = _deflateCurByte & _deflateCurMask;
    if (masked > 0) {
      _deflateCurValue++;
    }

    _deflateCurMask <<= 1;
    _deflateCurBit++;

    _deflateBitsLeft--;

    _state = _deflateLastState;
  }

  void _readBFinal() {
    _deflateCurBlock.isLastBlock = _deflateCurValue;

    _state = State.ReadBits;
    _deflateLastState = State.ReadBType;

    _deflateCurValue = 0;
    _deflateCurValueBit = 0;
    _deflateBitsLeft = 2;
  }

  void _readBType() {
    _deflateCurBlock.blockType = _deflateCurValue;

    _deflateCurValue = 0;
    _deflateCurValueBit = 0;

    switch (_deflateCurBlock.blockType) {
      case Compression.None:
        _state = State.DeflateNoCompression;
        break;

      case Compression.FixedHuffman:
        _deflateCurHuffmanTable = &_deflateFixedHuffmanTable;

        _deflateCurValue = 0;
        _deflateCurValueBit = 0;
        _deflateCurHuffmanBitLength = 6;
        _deflateCurHuffmanEntry = &_deflateCurHuffmanTable.huffmanEntries[
          _deflateCurHuffmanBitLength];

        _deflateBitsLeft = 7;

        _state = State.ReadBitsRev;
        _deflateLastState = State.DeflateFixedCheckCode;
        break;

      case Compression.DynamicHuffman:
        _deflateBitsLeft = 5;

        _state = State.ReadBits;
        _deflateLastState = State.DeflateDynamicCompression;
        break;

      default:
        _state = State.Invalid;
        break;
    }
  }

  void _deflateNoCompression() {
    if (_input.available < 2) {
      _currentState = _state;
      _state = State.Required;
      return;
    }

    ubyte* ptr = cast(ubyte*)&_deflateDataLength;
    _input.read(ptr[0..2]);
    
    _deflateDataLength = _cpu.fromLittleEndian16(_deflateDataLength);

    _state = State.DeflateNoCompressionSkip;
  }

  void _deflateNoCompressionSkip() {
    if (_input.available < 2) {
      _currentState = _state;
      _state = State.Required;
      return;
    }

    _input.seek(2);

    _state = State.DeflateNoCompressionCopy;
  }

  void _deflateNoCompressionCopy(Stream output) {
    if (_input.available < _deflateDataLength) {
      _currentState = _state;
      _state = State.Required;
      return;
    }

    output.append(_input, _deflateDataLength);

    if (_deflateCurBlock.isLastBlock > 0) {
      _state = State.Complete;
      return;
    }

    // Read another block header

    _deflateCurValue    = 0;
    _deflateCurValueBit = 0;
    _deflateLastState   = State.ReadBFinal;

    _state = State.ReadBit;
  }

  // Fixed Huffman Decoding

  // Determine if the code is within huffman tables
  // Otherwise, add a bit unless current bit is the 7th bit (the max)
  void _deflateFixedCheckCode(Stream output) {
    for (size_t i = 0; i < _deflateCurHuffmanEntry.huffmanRangesCount; i++) {
      auto range = _deflateCurHuffmanEntry.huffmanRanges[i];
      if ((_deflateCurValue >= range.huffmanMinorCode) &&
          (_deflateCurValue <= range.huffmanMajorCode)) {
        _deflateCurCode  = _deflateCurValue - range.huffmanMinorCode;
        _deflateCurCode += range.huffmanBase;

        if (_deflateCurCode < 256) {
          // A literal code... output
          output.append([cast(ubyte)_deflateCurCode]);

          _deflateCurValue = 0;
          _deflateCurValueBit = 0;
          _deflateCurHuffmanBitLength = 6;
          _deflateCurHuffmanEntry = &_deflateCurHuffmanTable.huffmanEntries[
            _deflateCurHuffmanBitLength];

          _deflateBitsLeft = 7;
          _state = State.ReadBitsRev;
          _deflateLastState = State.DeflateFixedCheckCode;
        }
        else if (_deflateCurCode == 256) {
          // End of block code
          
          // Return to gathering blocks if this isn't the last one
          if (_deflateCurBlock.isLastBlock) {
            _state = State.Complete;
            return;
          }

          _deflateCurValue = 0;
          _deflateCurValueBit = 0;
          _deflateLastState = State.ReadBFinal;

          _state = State.ReadBit;
        }
        else {
          // Length Code

          // Calculate the true length

          _deflateLength = _deflateLengthTable[_deflateCurCode - 257].base;

          _deflateCurValue = 0;
          _deflateCurValueBit = 0;

          if (_deflateLengthTable[_deflateCurCode - 257].extraBits > 0) {
            _state = State.ReadBits;
            _deflateBitsLeft  = _deflateLengthTable[_deflateCurCode - 257].extraBits;
            _deflateLastState = State.DeflateFixedGetLength;
          }
          else {
            // We have the length, find the distance

            // In fixed huffman, the distance is a fixed 5 bit value, plus any
            // extra bits given in the table for distance codes
            _state = State.ReadBitsRev;
            _deflateBitsLeft = 5;
            _deflateLastState = State.DeflateFixedGetDistance;
          }
        }
      }
    }

    if (_state == State.DeflateFixedCheckCode) {
      // Huffman code not yet found, read another bit
      // Increment huffman entry counter

      _deflateCurHuffmanEntry++;
      _deflateCurHuffmanBitLength++;

      _state = State.ReadBitRev;

      if (_deflateCurHuffmanBitLength == 16) {
        // Huffman Maximum Code Length Exceeded
        _state = State.Invalid;
        return;
      }
    }
  }

  void _deflateFixedGetLength() {
    _deflateLength += _deflateCurValue;

    // In fixed huffman, the distance is a fixed 5 bit value, plus any
    // extra bits given in the table for distance codes

    _deflateBitsLeft = 5;

    _deflateCurValue    = 0;
    _deflateCurValueBit = 0;

    _state = State.ReadBitsRev;
    _deflateLastState = State.DeflateFixedGetDistance;
  }

  void _deflateFixedGetDistance() {
    auto distanceTable = _globalDeflateDistanceTable[_deflateCurValue];

    _deflateDistance = distanceTable.base;

    if (distanceTable.extraBits > 0) {
      _state = State.ReadBits;

      _deflateBitsLeft = distanceTable.extraBits;
      _deflateLastState = State.DeflateFixedGetDistanceEx;

      _deflateCurValue = 0;
      _deflateCurValueBit = 0;
    }
    else {
      // Distance requires no other input
      // Add to the data stream using interpret state
      // And then return to gather another code

      _deflateCurValue = 0;
      _deflateCurValueBit = 0;
      _deflateCurHuffmanBitLength = 6;
      _deflateCurHuffmanEntry = &_deflateCurHuffmanTable.huffmanEntries[
        _deflateCurHuffmanBitLength];

      _deflateBitsLeft = 7;
      _state = State.ReadBitsRev;
      _deflateLastState = State.DeflateFixedCheckCode;

      // TODO: Duplicate from end code
    }
  }

  void _deflateFixedGetDistanceEx() {
    _deflateDistance += _deflateCurValue;

    // Add to the data stream by using interpret state
    // And then return to gather another code

    _deflateCurValue = 0;
    _deflateCurValueBit = 0;
    _deflateCurHuffmanBitLength = 6;
    _deflateCurHuffmanEntry = &_deflateCurHuffmanTable.huffmanEntries[
      _deflateCurHuffmanBitLength];

    _deflateBitsLeft = 7;
    _state = State.ReadBitsRev;
    _deflateLastState = State.DeflateFixedCheckCode;

    // TODO: Duplicate from end code
  }

  void _deflateDynamicCompression() {
    _deflateHLIT = cast(ushort)_deflateCurValue;

    // Initialize Code Length Huffman Table
    for (size_t i = 0; i < 16; i++) {
      _deflateCodeLengthTable.huffmanEntries[i].huffmanRangesCount = 0;
    }

    // Initialize the Code Length count
    for (size_t i = 0; i < 7; i++) {
      _deflateCodeLengthCount[i] = 0;
    }

    for (size_t i = 0; i < 8; i++) {
      _deflateHuffmanLengthCounts[i] = 0;
    }

    _deflateBitsLeft = 5;
    _state = State.ReadBits;
    _deflateLastState = State.DeflateDynamicHDIST;
    _deflateCurValue = 0;
    _deflateCurValueBit = 0;
  }

  void _deflateDynamicHDIST() {
    _deflateHDIST = cast(ushort)_deflateCurValue;

    _deflateBitsLeft = 4;

    _state = State.ReadBits;

    _deflateLastState   = State.DeflateDynamicHCLEN;
    _deflateCurValue    = 0;
    _deflateCurValueBit = 0;
  }

  void _deflateDynamicHCLEN() {
    _deflateHCLEN = cast(ushort)_deflateCurValue;

    _deflateCounterMax = _deflateHCLEN + 4;
    _deflateCounter = 0;

    _deflateBitsLeft = 3;
    _state = State.ReadBits;

    _deflateLastState = State.DeflateDynamicGetCodeLen;

    _deflateCurValue = 0;
    _deflateCurValueBit = 0;
  }

  void _deflateDynamicGetCodeLen() {
    _deflateCodeLengths[_deflateCodeLengthsReference[_deflateCounter]] 
      = cast(ubyte)_deflateCurValue;

    if (_deflateCurValue != 0) {
      _deflateCodeLengthCount[_deflateCurValue]++;
    }

    _deflateHuffmanLengthCounts[_deflateCurValue]++;

    _deflateCurValue    = 0;
    _deflateCurValueBit = 0;

    _deflateCounter++;

    if (_deflateCounter != _deflateCounterMax) {
      // Read 3 more bits
      _deflateBitsLeft = 3;
      _state = State.ReadBits;
    }
    else {
      for ( ; _deflateCounter < 19; _deflateCounter++) {
        _deflateCodeLengths[_deflateCodeLengthsReference[_deflateCounter]] = 0;
        _deflateHuffmanLengthCounts[0]++;
      }

      for (size_t i = 0; i < 578; i++) {
        _deflateHuffmanTable[i] = 0xffff;
      }

      // Build Code Length Tree

      uint pos, pos_exp, filled;

      _deflateCounter = 0;

      _deflateHuffmanNextCodes[0] = 0;

      for (size_t p = 1; p < 16; p++) {
        _deflateHuffmanNextCodes[p]
          = cast(ushort)((_deflateHuffmanNextCodes[p - 1] + _deflateHuffmanLengthCounts[p - 1]) * 2);
      }

      pos = 0;
      filled = 0;

      for (size_t i = 0; i < 19; i++) {
        uint curentry = _deflateHuffmanNextCodes[_deflateCodeLengths[i]]++;

        // Go through every bit
        for (size_t o = 0; o < _deflateCodeLengths[i]; o++) {
          ubyte bit = cast(ubyte)((curentry >> (_deflateCodeLengths[i] - o - 1)) & 1);

          pos_exp = (2 * pos) + bit;

          if ((o + 1) > (19 - 2)) {
            // Error. Tree is mishaped.
          }
          else if (_deflateHuffmanTable[pos_exp] == 0xffff) {
            // Not in tree

            // Is this the last bit?
            if ((o + 1) == _deflateCodeLengths[i]) {
              _deflateHuffmanTable[pos_exp] = cast(ushort)i;
              pos = 0;
            }
            else {
              filled++;

              _deflateHuffmanTable[pos_exp] = cast(ushort)(filled + 19);
              pos = filled;
            }
          }
          else {
            // In tree
            pos = _deflateHuffmanTable[pos_exp] - 19;
          }
        }
      }

      // Table is built
      // Decode code lengths
      _deflateCounter = 0; 
      _deflateCounterMax = _deflateHLIT + 257;

      for (size_t i = 0; i < 16; i++) {
        _deflateHuffmanLengthCounts[i]  = 0;
        _deflateDistanceLengthCounts[i] = 0;
      }

      _deflateLastState = State.DeflateDynamicDecodeLens;

      _deflateCurHuffmanTable = &_deflateCodeLengthTable;
      _deflateCurHuffmanEntry = &_deflateCodeLengthTable.huffmanEntries[
        _deflateCodeLengthCodeSize - 1];

      _deflateBitsLeft = _deflateCodeLengthCodeSize;
      _deflateCurHuffmanBitLength = _deflateCodeLengthCodeSize;

      _deflateCurLengthArray      = _deflateHuffmanLengths.ptr;
      _deflateCurLengthCountArray = _deflateHuffmanLengthCounts.ptr;

      _state = State.DeflateDynamicDecodeLens;

      _deflateCurValue = 0;
      _deflateCurValueBit = 0;
      _deflateTreePosition = 0;
    }
  }

  void _deflateDynamicDecodeLens() {
    // Get bit

    if (_deflateCurMask == 0) {
      _state = State.ReadByte;
      _nextState = State.DeflateDynamicDecodeLens;
      return;
    }

    ubyte masked = _deflateCurByte & _deflateCurMask;
    if (masked > 0) {
      _deflateCurValue = 1;
    }
    else {
      _deflateCurValue = 0;
    }

    _deflateCurMask <<= 1;
    _deflateCurBit++;

    // Check in the tree
    if (_deflateTreePosition >= 19) {
      // Corrupt data... out of position
      _state = State.Invalid;
      return;
    }

    _deflateCurCode = _deflateHuffmanTable[
      (2 * _deflateTreePosition) + _deflateCurValue];

    if (_deflateCurCode < 19) {
      _deflateTreePosition = 0;
    }
    else {
      _deflateTreePosition = cast(ushort)(_deflateCurCode - 19);
    }

    if (_deflateTreePosition == 0) {
      // Interpret Code

      if (_deflateCurCode < 16) {
        // 0 .. 15 are literal lengths
        // Just insert into array

        _deflateCurLengthArray[_deflateCounter] = cast(ubyte)_deflateCurCode;
        _deflateCurLengthCountArray[_deflateCurCode]++;
        _deflateCounter++;

        if (_deflateCounter == _deflateCounterMax) {
          // We have gotten the maximum codes we were supposed to find
          // We have to now decode the distance array or the tree now
          _state = State.DeflateDynamicDecodeDist;
          return;
        }

        // Read another code
        _deflateCurValue = 0;
        _deflateCurValueBit = 0;

        _deflateCurHuffmanTable = &_deflateCodeLengthTable;
        _deflateCurHuffmanEntry = &_deflateCodeLengthTable.huffmanEntries[0];

        _deflateBitsLeft = 1;
        _deflateCurHuffmanBitLength = 1;
      }
      else if (_deflateCurCode == 16) {
        // Copy previous length 3 - 6 times
        // Next two (2) bits determine length: (bits[2] + 3)

        _deflateCurValue    = 0;
        _deflateCurValueBit = 0;

        _deflateBitsLeft = 2;
        _state = State.ReadBits;
        _deflateLastState = State.DeflateDynamicDecodeLen16;
      }
      else if (_deflateCurCode == 17) {
        // Repeat code length of 0 for 3 - 10 times
        // Next three (3) bits determine length

        _deflateCurValue = 0;
        _deflateCurValueBit = 0;

        _deflateBitsLeft = 3;
        _state = State.ReadBits;
        _deflateLastState = State.DeflateDynamicDecodeLen17;
      }
      else if (_deflateCurCode == 18) {
        // Repeat code length of 0 for 11 - 138 times
        // Next seven (7) bits determine length

        _deflateCurValue = 0;
        _deflateCurValueBit = 0;

        _deflateBitsLeft = 7;
        _state = State.ReadBits;
        _deflateLastState = State.DeflateDynamicDecodeLen18;
      }
    }
  }

  void _deflateDynamicDecodeLen16() {
    // Take last code and repeat 'curvalue' + 3 times
    _deflateCurValue += 3;

    if (_deflateCounter != 0) {
      _deflateCurCode = _deflateCurLengthArray[_deflateCounter - 1];
    }
    else {
      // Corrupt data, counter is 0?
      _state = State.Invalid;
      return;
    }

    _deflateLastState = State.DeflateDynamicDecodeLens;

    _deflateCurHuffmanTable = &_deflateCodeLengthTable;
    _deflateCurHuffmanEntry = &_deflateCodeLengthTable.huffmanEntries[0];

    _deflateBitsLeft = 1;
    _deflateCurHuffmanBitLength = 1;

    _state = State.DeflateDynamicDecodeLens;

    for (size_t i = 0; i < _deflateCurValue; i++) {
      _deflateCurLengthArray[_deflateCounter] = cast(ubyte)_deflateCurCode;
      _deflateCurLengthCountArray[_deflateCurCode]++;

      _deflateCounter++;

      if (_deflateCounter == _deflateCounterMax) {
        // We cannot repeat the value
        _state = State.DeflateDynamicDecodeDist;
        break;
      }
    }

    _deflateCurValue    = 0;
    _deflateCurValueBit = 0;
  }

  void _deflateDynamicDecodeLen18() {
    _deflateCurValue += 8;

    _deflateDynamicDecodeLen17();
  }

  void _deflateDynamicDecodeLen17() {
    _deflateCurValue += 3;

    // Take 0 and repeat 'curvalue' times

    _deflateLastState = State.DeflateDynamicDecodeLens;

    _deflateCurHuffmanTable = &_deflateCodeLengthTable;
    _deflateCurHuffmanEntry = &_deflateCodeLengthTable.huffmanEntries[0];

    _deflateBitsLeft = 1;
    _deflateCurHuffmanBitLength = 1;

    _state = State.DeflateDynamicDecodeLens;

    for (size_t i = 0; i < _deflateCurValue; i++) {
      _deflateCurLengthArray[_deflateCounter] = 0;
      _deflateCurLengthCountArray[0]++;

      _deflateCounter++;

      if (_deflateCounter == _deflateCounterMax) {
        // We cannot repeat the value
        // Just stop.

        _state = State.DeflateDynamicDecodeDist;
        break;
      }
    }

    _deflateCurValue    = 0;
    _deflateCurValueBit = 0;
  }

  void _deflateDynamicDecodeDist() {
    if (_deflateCurLengthArray is _deflateDistanceLengths.ptr) {
      // Finish initializing the rest of the distance code length array

      // Write out the rest of the entries to 0
      for ( ; _deflateCounter < 32; _deflateCounter++) {
        _deflateDistanceLengths[_deflateCounter] = 0;
        _deflateDistanceLengthCounts[0]++;
      }

      _state = State.DeflateDynamicBuildTree;
      return;
    }

    // Finish initializing the rest of the huffman code length array

    // Write out the rest of the entries to 0
    for ( ; _deflateCounter < 288; _deflateCounter++) {
      _deflateHuffmanLengths[_deflateCounter] = 0;
      _deflateHuffmanLengthCounts[0]++;
    }

    // Now initialize the length decoder to build the distance array
    _deflateCounter = 0;
    _deflateCounterMax = _deflateHDIST + 1;

    _deflateLastState = State.DeflateDynamicDecodeLens;

    _deflateCurHuffmanTable = &_deflateCodeLengthTable;
    _deflateCurHuffmanEntry = &_deflateCodeLengthTable.huffmanEntries[
      _deflateCodeLengthCodeSize - 1];

    _deflateBitsLeft = _deflateCodeLengthCodeSize;
    _deflateCurHuffmanBitLength = _deflateCodeLengthCodeSize;

    _deflateCurLengthArray = _deflateDistanceLengths.ptr;
    _deflateCurLengthCountArray = _deflateDistanceLengthCounts.ptr;

    _state = State.DeflateDynamicDecodeLens;

    _deflateCurValue = 0;
    _deflateCurValueBit = 0;
  }

  void _deflateDynamicBuildTree() {
    for (size_t i = 0; i < 578; i++) {
      _deflateHuffmanTable[i] = 0xffff;
    }

    for (size_t i = 0; i < 68; i++) {
      _deflateDistanceTable[i] = 0xffff;
    }

    // Build Code Length Tree
    uint pos, pos_exp, filled;

    _deflateHuffmanNextCodes[0] = 0;

    for (size_t p = 1; p < 16; p++) {
      _deflateHuffmanNextCodes[p]
        = cast(ushort)((_deflateHuffmanNextCodes[p - 1] +
                        _deflateHuffmanLengthCounts[p - 1]) * 2);
    }

    pos = 0;
    filled = 0;

    for (size_t i = 0; i < 288; i++) {
      uint curentry = _deflateHuffmanNextCodes[_deflateHuffmanLengths[i]]++;

      // Go through every bit
      for (size_t o = 0; i < _deflateHuffmanLengths[i]; o++) {
        ubyte bit = cast(ubyte)((curentry >> (_deflateHuffmanLengths[i] - o - 1)) & 1);

        pos_exp = (2 * pos) + bit;

        if ((o + 1) > (288 - 2)) {
          // Error. Tree is mishaped.
          _state = State.Invalid;
          return;
        }
        else if (_deflateHuffmanTable[pos_exp] == 0xffff) {
          // Is this the last bit?
          if (o + 1 == _deflateHuffmanLengths[i]) {
            // Output the code
            _deflateHuffmanTable[pos_exp] = cast(ushort)i;

            pos = 0;
          }
          else {
            filled++;

            _deflateHuffmanTable[pos_exp] = cast(ushort)(filled + 288);
            pos = filled;
          }
        }
        else {
          pos = _deflateHuffmanTable[pos_exp] - 288;
        }
      }
    }

    _deflateHuffmanNextCodes[0] = 0;

    for (size_t p = 1; p < 16; p++) {
      _deflateHuffmanNextCodes[p]
        = cast(ushort)((_deflateHuffmanNextCodes[p - 1] +
                        _deflateHuffmanLengthCounts[p - 1]) * 2);
    }

    pos = 0;
    filled = 0;

    for (size_t i = 0; i < 32; i++) {
      uint curentry = _deflateHuffmanNextCodes[_deflateDistanceLengths[i]]++;

      // Go through every bit
      for (size_t o = 0; i < _deflateDistanceLengths[i]; o++) {
        ubyte bit = cast(ubyte)((curentry >> (_deflateDistanceLengths[i] - o - 1)) & 1);

        pos_exp = (2 * pos) + bit;

        if ((o + 1) > (32 - 2)) {
          // Error. Tree is mishaped.
          _state = State.Invalid;
          return;
        }
        else if (_deflateDistanceTable[pos_exp] == 0xffff) {
          // Is this the last bit?
          if (o + 1 == _deflateDistanceLengths[i]) {
            // Output the code
            _deflateDistanceTable[pos_exp] = cast(ushort)i;

            pos = 0;
          }
          else {
            filled++;

            _deflateDistanceTable[pos_exp] = cast(ushort)(filled + 32);
            pos = filled;
          }
        }
        else {
          pos = _deflateHuffmanTable[pos_exp] - 32;
        }
      }
    }

    // Build Code Length Tree
    // Decode
    // Init Huffman to minimum code length

    _state = State.DeflateDynamicDecoder;
    _deflateTreePosition = 0;
  }

  void _deflateDynamicDecoder(Stream output) {
    // Get bit

    if (_deflateCurMask == 0) {
      _state = State.ReadByte;
      _nextState = State.DeflateDynamicDecoder;
      return;
    }

    ubyte masked = _deflateCurByte & _deflateCurMask;
    if (masked > 0) {
      _deflateCurValue = 1;
    }
    else {
      _deflateCurValue = 0;
    }

    _deflateCurMask <<= 1;
    _deflateCurBit++;

    // Check in tree
    _deflateCurCode = _deflateHuffmanTable[
      (2 * _deflateTreePosition) + _deflateCurValue];

    if (_deflateCurCode < 288) {
      _deflateTreePosition = 0;
    }
    else {
      _deflateTreePosition = cast(ushort)(_deflateCurCode - 288);
    }

    if (_deflateTreePosition == 0) {
      // Interpret Code

      if (_deflateCurCode < 256) {
        // Literal Code

        // Append to output stream
        output.append([cast(ubyte)_deflateCurCode]);

        // Return to gather another code
        _deflateCurValue = 0;
        _deflateCurValueBit = 0;
        _deflateCurHuffmanBitLength = _deflateCodeLengthCodeSize - 1;
        _deflateCurHuffmanTable = &_deflateInternalHuffmanTable;
        _deflateCurHuffmanEntry = &_deflateCurHuffmanTable.huffmanEntries[
          _deflateCurHuffmanBitLength];

        _deflateBitsLeft = _deflateCodeLengthCodeSize;
        _state = State.DeflateDynamicDecoder;
        _deflateLastState = State.DeflateDynamicDecoder;
      }
      else if (_deflateCurCode == 256) {
        // End of block code

        // Return to gathering blocks if this is not the last one
        if (_deflateCurBlock.isLastBlock > 0) {
          _state = State.Complete;
          return;
        }

        _deflateCurValue = 0;
        _deflateCurValueBit = 0;
        _deflateLastState = State.ReadBFinal;

        _state = State.ReadBit;
      }
      else {
        // Length code

        // Calculate the true length
        auto lengthTable = _deflateLengthTable[_deflateCurCode - 257];
        _deflateLength = lengthTable.base;

        _deflateCurValue = 0;
        _deflateCurValueBit = 0;

        if (lengthTable.extraBits > 0) {
          _state = State.ReadBits;
          _deflateBitsLeft = lengthTable.extraBits;
          _deflateLastState = State.DeflateDynamicGetLength;
        }
        else {
          // We already have the length, find the distance
          _state = State.DeflateDynamicGetDistance;
        }
      }
    }
  }

  // _deflateCurValue holds the extra bits
  void _deflateDynamicGetLength() {
    _deflateLength += _deflateCurValue;

    _state = State.DeflateDynamicGetDistance;
    
    _deflateCurValue = 0;
    _deflateCurValueBit = 0;
    _deflateBitsLeft = _deflateDistanceCodeLengthCodeSize;
    _deflateLastState = State.DeflateDynamicGetDistance;
  }

  // _deflateCurValue is the resulting code
  // Ensure that it is within the huffman tree.
  // Then we can read the extra bits...
  // If not, then we can read another bit
  void _deflateDynamicGetDistance() {
    // Get bit
    if (_deflateCurMask == 0) {
      _state = State.ReadByte;
      _nextState = State.DeflateDynamicGetDistance;
      return;
    }

    ubyte masked = _deflateCurByte & _deflateCurMask;
    if (masked > 0) {
      _deflateCurValue = 1;
    }
    else {
      _deflateCurValue = 0;
    }

    _deflateCurMask <<= 1;
    _deflateCurBit++;

    // Check in tree
    _deflateCurCode = _deflateDistanceTable[
      (2 * _deflateTreePosition) + _deflateCurValue];

    if (_deflateCurCode < 32) {
      _deflateTreePosition = 0;
    }
    else {
      _deflateTreePosition = cast(ushort)(_deflateCurCode - 32);
    }

    if (_deflateTreePosition == 0) {
      // Interpret Code
      auto distanceTable = _globalDeflateDistanceTable[_deflateCurCode];
      _deflateDistance = distanceTable.base;

      if (distanceTable.extraBits > 0) {
        _state = State.ReadBits;

        _deflateBitsLeft = distanceTable.extraBits;
        _deflateLastState = State.DeflateDynamicGetDistEx;

        _deflateCurValue = 0;
        _deflateCurValueBit = 0;
      }
      else {
        // The distance requires no other input
        // Add to the data stream
        // Return to get another code

        // TODO: duplicate from end

        _state = State.DeflateDynamicDecoder;
      }
    }
  }

  void _deflateDynamicGetDistEx() {
    _deflateDistance += _deflateCurValue;

    _deflateCurValue = 0;
    _deflateCurValueBit = 0;

    _deflateBitsLeft = _deflateCodeLengthCodeSize;

    // TODO : duplicate from end

    _state = State.DeflateDynamicDecoder;
  }

public:
  this(Stream input) {
    _input = input;
  }

  DataDecoder.State decode(Stream output) {
    _cpu = Architecture.currentCpu;

    for(;;) {
      switch (_state) {
        case State.Init:
          _init();
          break;

        case State.ReadByte:
          _readByte();
          break;

        case State.ReadBits:
          _readBits();
          break;

        case State.ReadBit:
          _readBit();
          break;

        case State.ReadBitsRev:
          _readBitsRev();
          break;

        case State.ReadBitRev:
          _readBitRev();
          break;

        case State.ReadBFinal:
          _readBFinal();
          break;

        case State.ReadBType:
          _readBType();
          break;

        case State.DeflateNoCompression:
          _deflateNoCompression();
          break;

        case State.DeflateNoCompressionSkip:
          _deflateNoCompressionSkip();
          break;

        case State.DeflateNoCompressionCopy:
          if (output is null) {
            return DataDecoder.State.StreamRequired;
          }

          _deflateNoCompressionCopy(output);
          break;

        case State.DeflateFixedCheckCode:
          if (output is null) {
            return DataDecoder.State.StreamRequired;
          }

          _deflateFixedCheckCode(output);
          break;

        case State.DeflateFixedGetLength:
          _deflateFixedGetLength();
          break;

        case State.DeflateFixedGetDistance:
          _deflateFixedGetDistance();
          break;

        case State.DeflateFixedGetDistanceEx:
          _deflateFixedGetDistanceEx();
          break;

        case State.DeflateDynamicCompression:
          _deflateDynamicCompression();
          break;

        case State.DeflateDynamicHDIST:
          _deflateDynamicHDIST();
          break;

        case State.DeflateDynamicHCLEN:
          _deflateDynamicHCLEN();
          break;

        case State.DeflateDynamicGetCodeLen:
          _deflateDynamicGetCodeLen();
          break;

        case State.DeflateDynamicDecodeLens:
          _deflateDynamicDecodeLens();
          break;

        case State.DeflateDynamicDecodeLen16:
          _deflateDynamicDecodeLen16();
          break;

        case State.DeflateDynamicDecodeLen17:
          _deflateDynamicDecodeLen17();
          break;

        case State.DeflateDynamicDecodeLen18:
          _deflateDynamicDecodeLen18();
          break;

        case State.DeflateDynamicDecodeDist:
          _deflateDynamicDecodeDist();
          break;

        case State.DeflateDynamicBuildTree:
          _deflateDynamicBuildTree();
          break;

        case State.DeflateDynamicDecoder:
          if (output is null) {
            return DataDecoder.State.StreamRequired;
          }

          _deflateDynamicDecoder(output);
          break;

        case State.DeflateDynamicGetLength:
          _deflateDynamicGetLength();
          break;

        case State.DeflateDynamicGetDistance:
          _deflateDynamicGetDistance();
          break;

        case State.DeflateDynamicGetDistEx:
          _deflateDynamicGetDistEx();
          break;

        case State.Required:
          _state = _currentState;
          return DataDecoder.State.Accepted;

        case State.Complete:
          return DataDecoder.State.Complete;

        default:
          break;
      }
    }

    return DataDecoder.State.Invalid;
  }

  DataDecoder decoder() {
    return new DataDecoder(&decode,
                           &description,
                           &tags);
  }

  char[] description() {
    return "Deflate Stream";
  }

  char[][] tags() {
    return [];
  }
}
