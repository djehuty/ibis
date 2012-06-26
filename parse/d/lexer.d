module parse.d.lexer;

import parse.d.token;

import io.file;

class DLexer {
private:
  void _error(char[] msg) {
    //Console.forecolor = Color.Red;
    //Console.putln("Lexical Error: file.d @ ", _lineNumber+1, ":", _pos+1, " - ", msg);
    //Console.putln();
  }

  // Describe the number lexer states
  enum DLexerState : uint {
    Normal,
    String,
    Comment,
    Identifier,
    Integer,
    FloatingPoint
  }

  DLexerState state;
  bool inEscape;
  uint characterEscapeDigitsLeft;
  bool foundLeadingChar;
  bool foundLeadingSlash;
  uint nestedCommentDepth;

  // Describe the string lexer states
  enum StringType : uint {
    DoubleQuote,    // "..."
    WhatYouSeeQuote,  // `...`
    RawWhatYouSeeQuote,  // r"..."
    Character,      // '.'
  }

  StringType inStringType;

  // Describe the comment lexer states
  enum CommentType : uint {
    BlockComment,
    LineComment,
    NestedComment
  }

  struct DTokenInTraining {
    char[] string;
    ulong integer;
    double decimal;
    long line;
    long lineEnd;
    long column;
    long columnEnd;

    DToken.Type type;

    DToken toToken() {
      return new DToken(type, line, lineEnd, column, columnEnd, integer, decimal, string);
    }
  }

  CommentType inCommentType;
  char[] cur_string;

  char[] _line;
  size_t _lineNumber;
  size_t _pos;

  static const DToken.Type[] tokenMapping = [
    '!':DToken.Type.Bang,
    ':':DToken.Type.Colon,
    '?':DToken.Type.Question,
    ';':DToken.Type.Semicolon,
    '$':DToken.Type.Dollar,
    '.':DToken.Type.Dot,
    ',':DToken.Type.Comma,
    '(':DToken.Type.LeftParen,
    ')':DToken.Type.RightParen,
    '{':DToken.Type.LeftCurly,
    '}':DToken.Type.RightCurly,
    '[':DToken.Type.LeftBracket,
    ']':DToken.Type.RightBracket,
    '<':DToken.Type.LessThan,
    '>':DToken.Type.GreaterThan,
    '=':DToken.Type.Assign,
    '+':DToken.Type.Add,
    '-':DToken.Type.Sub,
    '~':DToken.Type.Cat,
    '*':DToken.Type.Mul,
    '/':DToken.Type.Div,
    '^':DToken.Type.Xor,
    '|':DToken.Type.Or,
    '&':DToken.Type.And,
    '%':DToken.Type.Mod,
    ];

  int cur_base;
  ulong cur_integer;
  bool cur_integer_signed;
  ulong cur_decimal;
  ulong cur_exponent;
  ulong cur_denominator;
  bool inDecimal;
  bool inExponent;

  char[][] _lines;

  // Simple stack of tokens
  DToken[] _bank;

  DToken[] _comment_bank;

  void _comment_bank_push(DToken token) {
    _comment_bank ~= token;
  }

  bool _comment_bank_empty() {
    return _comment_bank.length == 0;
  }

  DToken _comment_bank_pop() {
    DToken ret = _comment_bank[$-1];
    _comment_bank = _comment_bank[0..$-1];
    return ret;
  }

  void _bank_push(DToken token) {
    _bank ~= token;
  }

  bool _bank_empty() {
    return _bank.length == 0;
  }

  DToken _bank_pop() {
    DToken ret = _bank[$-1];
    _bank = _bank[0..$-1];
    return ret;
  }

  DToken _next() {
    DTokenInTraining current;
    current.line = _lineNumber;
    current.column = _pos + 1;

    // will give us a string for the line of utf8 characters.
    for(;;) {
      if (_line is null || _pos >= _line.length) {
        if (_lineNumber >= _lines.length) {
          // EOF
          return current.toToken;
        }
        _line = _lines[_lineNumber];
        _lineNumber++;
        _pos = 0;
        current.line = current.line + 1;
        current.column = 1;
      }

      // now break up the line into tokens
      // the return for the line is whitespace, and can be ignored

      for(; _pos <= _line.length; _pos++) {
        char chr;
        char nextChr;
        if (_pos == _line.length) {
          chr = '\n';
          nextChr = '\n';
        }
        else {
          chr = _line[_pos];
          if (_pos == _line.length-1) {
            nextChr = '\n';
          }
          else {
            nextChr = _line[_pos+1];
          }
        }
        switch (state) {
          default:
            // error
            _error("error");
            return DToken.init;

          case DLexerState.Normal:
            DToken.Type newType = tokenMapping[chr];
            // Comments
            if (current.type == DToken.Type.Div) {
              if (newType == DToken.Type.Add) {
                inEscape = false;
                foundLeadingSlash = false;
                foundLeadingChar = false;
                nestedCommentDepth = 1;
                current.type = DToken.Type.EOF;
                state = DLexerState.Comment;
                inCommentType = CommentType.NestedComment;
                cur_string = "";
                continue;
              }
              else if (newType == DToken.Type.Div) {
                cur_string = _line[_pos+1..$];
                current.type = DToken.Type.Comment;
                current.string = cur_string;
                current.lineEnd = _lineNumber;
                _pos = _line.length;
                return current.toToken;
              }
              else if (newType == DToken.Type.Mul) {
                inEscape = false;
                foundLeadingSlash = false;
                foundLeadingChar = false;
                nestedCommentDepth = 1;
                current.type = DToken.Type.EOF;
                state = DLexerState.Comment;
                inCommentType = CommentType.BlockComment;
                cur_string = "";
                continue;
              }
            }

            if (newType != DToken.Type.EOF) {
              switch(current.type) {
                case DToken.Type.And: // &
                  if (newType == DToken.Type.And) {
                    // &&
                    current.type = DToken.Type.LogicalAnd;
                  }
                  else if (newType == DToken.Type.Assign) {
                    // &=
                    current.type = DToken.Type.AndAssign;
                  }
                  else {
                    goto default;
                  }
                  break;
                case DToken.Type.Or: // |
                  if (newType == DToken.Type.Or) {
                    // ||
                    current.type = DToken.Type.LogicalOr;
                  }
                  else if (newType == DToken.Type.Assign) {
                    // |=
                    current.type = DToken.Type.OrAssign;
                  }
                  else {
                    goto default;
                  }
                  break;
                case DToken.Type.Add: // +
                  if (newType == DToken.Type.Assign) {
                    // +=
                    current.type = DToken.Type.AddAssign;
                  }
                  else if (newType == DToken.Type.Add) {
                    // ++
                    current.type = DToken.Type.Increment;
                  }
                  else {
                    goto default;
                  }
                  break;
                case DToken.Type.Sub: // -
                  if (newType == DToken.Type.Assign) {
                    // -=
                    current.type = DToken.Type.SubAssign;
                  }
                  else if (newType == DToken.Type.Sub) {
                    // --
                    current.type = DToken.Type.Decrement;
                  }
                  else {
                    goto default;
                  }
                  break;
                case DToken.Type.Div: // /
                  if (newType == DToken.Type.Assign) {
                    // /=
                    current.type = DToken.Type.DivAssign;
                  }
                  else if (newType == DToken.Type.Add) {
                    // /+
                    current.type = DToken.Type.Comment;
                  }
                  else if (newType == DToken.Type.Div) {
                    // //
                    current.type = DToken.Type.Comment;
                  }
                  else if (newType == DToken.Type.Mul) {
                    // /*
                    current.type = DToken.Type.Comment;
                  }
                  else {
                    goto default;
                  }
                  break;
                case DToken.Type.Mul: // *
                  if (newType == DToken.Type.Assign) {
                    // *=
                    current.type = DToken.Type.MulAssign;
                  }
                  else {
                    goto default;
                  }
                  break;
                case DToken.Type.Mod: // %
                  if (newType == DToken.Type.Assign) {
                    // %=
                    current.type = DToken.Type.ModAssign;
                  }
                  else {
                    goto default;
                  }
                  break;
                case DToken.Type.Xor: // ^
                  if (newType == DToken.Type.Assign) {
                    // ^=
                    current.type = DToken.Type.XorAssign;
                  }
                  else {
                    goto default;
                  }
                  break;
                case DToken.Type.Cat: // ~
                  if (newType == DToken.Type.Assign) {
                    // ~=
                    current.type = DToken.Type.CatAssign;
                  }
                  else {
                    goto default;
                  }
                  break;
                case DToken.Type.Assign: // =
                  if (newType == DToken.Type.Assign) {
                    // ==
                    current.type = DToken.Type.Equals;
                  }
                  else {
                    goto default;
                  }
                  break;
                case DToken.Type.LessThan: // <
                  if (newType == DToken.Type.LessThan) {
                    // <<
                    current.type = DToken.Type.ShiftLeft;
                  }
                  else if (newType == DToken.Type.Assign) {
                    // <=
                    current.type = DToken.Type.LessThanEqual;
                  }
                  else if (newType == DToken.Type.GreaterThan) {
                    // <>
                    current.type = DToken.Type.LessThanGreaterThan;
                  }
                  else {
                    goto default;
                  }
                  break;
                case DToken.Type.GreaterThan: // >
                  if (newType == DToken.Type.GreaterThan) {
                    // >>
                    current.type = DToken.Type.ShiftRight;
                  }
                  else if (newType == DToken.Type.Assign) {
                    // >=
                    current.type = DToken.Type.GreaterThanEqual;
                  }
                  else {
                    goto default;
                  }
                  break;
                case DToken.Type.ShiftLeft: // <<
                  if (newType == DToken.Type.Assign) {
                    // <<=
                    current.type = DToken.Type.ShiftLeftAssign;
                  }
                  else {
                    goto default;
                  }
                  break;
                case DToken.Type.ShiftRight: // >>
                  if (newType == DToken.Type.Assign) {
                    // >>=
                    current.type = DToken.Type.ShiftRightAssign;
                  }
                  else if (newType == DToken.Type.GreaterThan) {
                    // >>>
                    current.type = DToken.Type.ShiftRightSigned;
                  }
                  else {
                    goto default;
                  }
                  break;
                case DToken.Type.ShiftRightSigned: // >>>
                  if (newType == DToken.Type.Assign) {
                    // >>>=
                    current.type = DToken.Type.ShiftRightSignedAssign;
                  }
                  else {
                    goto default;
                  }
                  break;
                case DToken.Type.LessThanGreaterThan: // <>
                  if (newType == DToken.Type.Assign) {
                    // <>=
                    current.type = DToken.Type.LessThanGreaterThanEqual;
                  }
                  else {
                    goto default;
                  }
                  break;
                case DToken.Type.Bang: // !
                  if (newType == DToken.Type.LessThan) {
                    // !<
                    current.type = DToken.Type.NotLessThan;
                  }
                  else if (newType == DToken.Type.GreaterThan) {
                    // !>
                    current.type = DToken.Type.NotGreaterThan;
                  }
                  else if (newType == DToken.Type.Assign) {
                    // !=
                    current.type = DToken.Type.NotEquals;
                  }
                  else {
                    goto default;
                  }
                  break;
                case DToken.Type.NotLessThan: // !<
                  if (newType == DToken.Type.GreaterThan) {
                    // !<>
                    current.type = DToken.Type.NotLessThanGreaterThan;
                  }
                  else if (newType == DToken.Type.Assign) {
                    // !<=
                    current.type = DToken.Type.NotLessThanEqual;
                  }
                  else {
                    goto default;
                  }
                  break;
                case DToken.Type.NotGreaterThan: // !>
                  if (newType == DToken.Type.Assign) {
                    // !>=
                    current.type = DToken.Type.NotGreaterThanEqual;
                  }
                  else {
                    goto default;
                  }
                  break;
                case DToken.Type.NotLessThanGreaterThan: // !<>
                  if (newType == DToken.Type.Assign) {
                    // !<>=
                    current.type = DToken.Type.NotLessThanGreaterThanEqual;
                  }
                  else {
                    goto default;
                  }
                  break;
                case DToken.Type.Dot: // .
                  if (newType == DToken.Type.Dot) {
                    // ..
                    current.type = DToken.Type.Slice;
                  }
                  else {
                    goto default;
                  }
                  break;
                case DToken.Type.Slice: // ..
                  if (newType == DToken.Type.Dot) {
                    // ...
                    current.type = DToken.Type.Variadic;
                  }
                  else {
                    goto default;
                  }
                  break;
                case DToken.Type.EOF:
                  current.type = tokenMapping[chr];
                  break;
                default:
                  // DToken Error
                  if (current.type != DToken.Type.EOF) {
                    current.columnEnd = _pos;
                    current.lineEnd = _lineNumber;
                    return current.toToken;
                  }
//                  _error("Unknown operator.");
                  return DToken.init;
              }

              continue;
            }

            // A character that will switch states continues

            // Strings
            if (chr == '\'') {
              state = DLexerState.String;
              inStringType = StringType.Character;
              cur_string = "";
              if (current.type != DToken.Type.EOF) {
                current.columnEnd = _pos;
                current.lineEnd = _lineNumber;
                _pos++;
                return current.toToken;
              }
              continue;
            }
            else if (chr == '"') {
              state = DLexerState.String;
              inStringType = StringType.DoubleQuote;
              cur_string = "";
              if (current.type != DToken.Type.EOF) {
                current.columnEnd = _pos;
                current.lineEnd = _lineNumber;
                _pos++;
                return current.toToken;
              }
              continue;
            }
            else if (chr == '`') {
              state = DLexerState.String;
              inStringType = StringType.WhatYouSeeQuote;
              cur_string = "";
              if (current.type != DToken.Type.EOF) {
                current.columnEnd = _pos;
                current.lineEnd = _lineNumber;
                _pos++;
                return current.toToken;
              }
              continue;
            }

            // Whitespace
            else if (chr == ' ' || chr == '\t' || chr == '\n') {
              if (current.type != DToken.Type.EOF) {
                current.columnEnd = _pos;
                current.lineEnd = _lineNumber;
                _pos++;
                return current.toToken;
              }
              current.column = current.column + 1;
              continue;
            }

            // Identifiers
            else if ((chr >= 'a' && chr <= 'z') || (chr >= 'A' && chr <= 'Z') || chr == '_') {
              state = DLexerState.Identifier;
              cur_string = "";
              if (current.type != DToken.Type.EOF) {
                current.columnEnd = _pos;
                current.lineEnd = _lineNumber;
                return current.toToken;
              }
              goto case DLexerState.Identifier;
            }

            // Numbers
            else if (chr >= '0' && chr <= '9') {
              // reset to invalid base
              cur_base = 0;
              cur_decimal = 0;
              cur_denominator = 1;
              cur_exponent = 0;

              if (current.type == DToken.Type.Dot) {
                current.type = DToken.Type.EOF;
                inDecimal = true;
                inExponent = false;
                cur_integer = 0;
                cur_base = 10;
                state = DLexerState.FloatingPoint;
                goto case DLexerState.FloatingPoint;
              }
              else {
                state = DLexerState.Integer;

                if (current.type != DToken.Type.EOF) {
                  current.columnEnd = _pos;
                  current.lineEnd = _lineNumber;
                  return current.toToken;
                }
                goto case DLexerState.Integer;
              }
            }
            break;

          case DLexerState.String:
            if (inEscape) {
              if (characterEscapeDigitsLeft > 0) {
                characterEscapeDigitsLeft--;
                cur_integer *= 16;
                if (chr >= '0' && chr <= '9') {
                  cur_integer += (chr - '0');
                }
                else if (chr >= 'a' && chr <= 'f') {
                  cur_integer += (chr - 'a') + 10;
                }
                else if (chr >= 'A' && chr <= 'F') {
                  cur_integer += (chr - 'A') + 10;
                }

                if (characterEscapeDigitsLeft == 0) {
                  cur_string ~= cast(char)cur_integer;
                  inEscape = false;
                }

                continue;
              }

              inEscape = false;
              if (chr == 't') {
                chr = '\t';
              }
              else if (chr == 'b') {
                chr = '\b';
              }
              else if (chr == 'r') {
                chr = '\r';
              }
              else if (chr == 'n') {
                chr = '\n';
              }
              else if (chr == '0') {
                chr = '\0';
              }
              else if (chr == 'x' || chr == 'X') {
                // Expect 2 digit code
                characterEscapeDigitsLeft = 2;
                cur_integer = 0;
                inEscape = true;
              }
              else if (chr == 'u') {
                // Expect 4 digit code
                characterEscapeDigitsLeft = 4;
                cur_integer = 0;
                inEscape = true;
              }
              else if (chr == 'U') {
                // Expect 8 digit code
                characterEscapeDigitsLeft = 8;
                cur_integer = 0;
                inEscape = true;
              }

              if (!inEscape) {
                cur_string ~= chr;
              }
              continue;
            }

            if (inStringType == StringType.DoubleQuote) {
              if (chr == '"') {
                state = DLexerState.Normal;
                current.type = DToken.Type.StringLiteral;
                current.columnEnd = _pos;
                current.lineEnd = _lineNumber;
                if (cur_string !is null) {
                  current.string = cur_string;
                }
                _pos++;
                return current.toToken;
              }
            }
            else if (inStringType == StringType.RawWhatYouSeeQuote) {
              if (chr == '"') {
                state = DLexerState.Normal;
                current.type = DToken.Type.StringLiteral;
                current.columnEnd = _pos;
                current.lineEnd = _lineNumber;
                if (cur_string !is null) {
                  current.string = cur_string;
                }
                _pos++;
                return current.toToken;
              }
            }
            else if (inStringType == StringType.WhatYouSeeQuote) {
              if (chr == '`') {
                state = DLexerState.Normal;
                current.type = DToken.Type.StringLiteral;
                current.columnEnd = _pos;
                current.lineEnd = _lineNumber;
                if (cur_string !is null) {
                  current.string = cur_string;
                }
                _pos++;
                return current.toToken;
              }
            }
            else { // StringType.Character
              if (chr == '\'') {
                if (cur_string.length > 1) {
                  // error
                  goto default;
                }
                state = DLexerState.Normal;
                current.type = DToken.Type.CharacterLiteral;
                current.columnEnd = _pos;
                current.lineEnd = _lineNumber;
                if (cur_string !is null) {
                  current.string = cur_string;
                }
                _pos++;
                return current.toToken;
              }
            }

            if ((inStringType == StringType.DoubleQuote || inStringType == StringType.Character) && (chr == '\\')) {
              // Escaped Characters
              inEscape = true;
            }
            else {
              cur_string ~= chr;
            }
            continue;
          case DLexerState.Comment:
            if (inEscape) {
              // Ignore escaped characters
              cur_string ~= [chr];
              inEscape = false;
            }
            else if (chr == '\\') {
              inEscape = true;
              foundLeadingChar = false;
              foundLeadingSlash = false;
            }
            else if (chr == '/' && !foundLeadingChar && inCommentType == CommentType.NestedComment) {
              foundLeadingSlash = true;
              cur_string ~= [chr];
            }
            else if (chr == '+' && foundLeadingSlash) {
              foundLeadingSlash = false;
              cur_string ~= [chr];
              nestedCommentDepth++;
            }
            else if ((chr == '*' && inCommentType == CommentType.BlockComment) ||
                     (chr == '+' && inCommentType == CommentType.NestedComment)) {
              cur_string ~= [chr];
              foundLeadingChar = true;
              foundLeadingSlash = false;
            }
            else if (foundLeadingChar && chr == '/') {
              nestedCommentDepth--;

              // Good
              if (nestedCommentDepth == 0) {
                state = DLexerState.Normal;
                current.string = cur_string[0..$-1];
                current.type = DToken.Type.Comment;
                _pos++;
                return current.toToken;
              }
              cur_string ~= [chr];

              foundLeadingChar = false;
              foundLeadingSlash = false;
            }
            else {
              foundLeadingChar = false;
              foundLeadingSlash = false;
              cur_string ~= [chr];
            }
            continue;
          case DLexerState.Identifier:
            // check for valid succeeding character
            if ((chr < 'a' || chr > 'z') && (chr < 'A' || chr > 'Z') && chr != '_' && (chr < '0' || chr > '9')) {
              // Invalid identifier symbol
              static DToken.Type keywordStart = DToken.Type.Abstract;
              static const char[][] keywordList = ["abstract", "alias", "align", "asm", "assert", "auto",
                "body", "bool", "break", "byte", "case", "cast","catch","cdouble","cent","cfloat","char",
                "class","const","continue","creal","dchar","debug","default","delegate","delete","deprecated",
                "do","double","else","enum","export","extern","false","final","finally","float","for","foreach",
                "foreach_reverse","function","goto","idouble","if","ifloat","import","in","inout","int","interface",
                "invariant","ireal","is","lazy","long","macro","mixin","module","new","null","out","override",
                "package","pragma","private","protected","public","real","ref","return","scope","short","static",
                "struct","super","switch","synchronized","template","this","throw","true","try",
                "typedef","typeid","typeof","ubyte","ucent","uint","ulong","union","unittest","ushort","version",
                "void","volatile","wchar","while","with"
              ];
              current.type = DToken.Type.Identifier;

              foreach(size_t i, keyword; keywordList) {
                if (cur_string == keyword) {
                  current.type = cast(DToken.Type)(keywordStart + i);
                  cur_string = null;
                  break;
                }
              }

              if (cur_string !is null) {
                current.string = cur_string;
              }
              state = DLexerState.Normal;
              if (current.type != DToken.Type.EOF) {
                current.columnEnd = _pos;
                current.lineEnd = _lineNumber;
                return current.toToken;
              }
              goto case DLexerState.Normal;
            }
            cur_string ~= chr;
            continue;
          case DLexerState.Integer:
            // check for valid succeeding character

            // we may want to switch to floating point state
            // may want to defer because this is a .. or ... token
            if (chr == '.') {
              if (nextChr == '.') {
                // 5.. implies that this token is an Integer followed by a slice token
                current.columnEnd = _pos;
                current.lineEnd = _lineNumber;

                state = DLexerState.Normal;
                return current.toToken;
              }

              if (cur_base <= 0) {
                cur_base = 10;
              }
              else if (cur_base == 2) {
                _error("Cannot have binary floating point literals");
                return DToken.init;
              }
              else if (cur_base == 8) {
                _error("Cannot have octal floating point literals");
                return DToken.init;
              }

              // Reset this just in case, it will get interpreted
              // in the Floating Point state
              inDecimal = false;
              inExponent = false;

              state = DLexerState.FloatingPoint;
              goto case DLexerState.FloatingPoint;
            }
            else if ((chr == 'p' || chr == 'P') && cur_base == 16) {
              // Reset this just in case, it will get interpreted
              // in the Floating Point state
              inDecimal = false;
              inExponent = false;

              state = DLexerState.FloatingPoint;
              goto case DLexerState.FloatingPoint;
            }
            else if (chr == '_') {
              // ignore
              if (cur_base == -1) {
                // OCTAL
                cur_base = 8;
              }
            }
            else if (cur_base == 0) {
              // this is the first value
              if (chr == '0') {
                // octal or 0 or 0.0, etc
                // use an invalid value so we can decide
                cur_base = -1;
                cur_integer = 0;
              }
              else if (chr >= '1' && chr <= '9') {
                cur_base = 10;
                cur_integer = (chr - '0');
              }
              // Cannot be any other value
              else {
                _error("Integer literal expected.");
                return DToken.init;
              }
            }
            else if (cur_base == -1) {
              // this is the second value of an ambiguous base
              if (chr >= '0' && chr <= '7') {
                // OCTAL
                cur_base = 8;
                cur_integer = (chr - '0');
              }
              else if (chr == 'x' || chr == 'X') {
                // HEX
                cur_base = 16;
              }
              else if (chr == 'b' || chr == 'B') {
                // BINARY
                cur_base = 2;
              }
              else {
                // 0 ?
                current.type = DToken.Type.IntegerLiteral;
                current.columnEnd = _pos;
                current.lineEnd = _lineNumber;

                state = DLexerState.Normal;
                return current.toToken;
              }
            }
            else if (cur_base == 16) {
              if ((chr < '0' || chr > '9') && (chr < 'a' || chr > 'f') && (chr < 'A' || chr > 'F')) {
                current.type = DToken.Type.IntegerLiteral;
                current.integer = cur_integer;
                current.columnEnd = _pos;
                current.lineEnd = _lineNumber;

                state = DLexerState.Normal;
                return current.toToken;
              }
              else {
                cur_integer *= cur_base;
                if (chr >= 'a' && chr <= 'f') {
                  cur_integer += 10 + (chr - 'a');
                }
                else if (chr >= 'A' && chr <= 'F') {
                  cur_integer += 10 + (chr - 'A');
                }
                else {
                  cur_integer += (chr - '0');
                }
              }
            }
            else if (cur_base == 10) {
              if (chr < '0' || chr > '9') {
                current.type = DToken.Type.IntegerLiteral;
                current.integer = cur_integer;
                current.columnEnd = _pos;
                current.lineEnd = _lineNumber;

                state = DLexerState.Normal;
                return current.toToken;
              }
              else {
                cur_integer *= cur_base;
                cur_integer += (chr - '0');
              }
            }
            else if (cur_base == 8) {
              if (chr >= '8' && chr <= '9') {
                _error("Digits higher than 7 in an octal integer literal are invalid.");
                return DToken.init;
              }
              else if (chr < '0' || chr > '7') {
                current.type = DToken.Type.IntegerLiteral;
                current.integer = cur_integer;
                current.columnEnd = _pos;
                current.lineEnd = _lineNumber;

                state = DLexerState.Normal;
                return current.toToken;
              }
              else {
                cur_integer *= cur_base;
                cur_integer += (chr - '0');
              }
            }
            else if (cur_base == 2) {
              if (chr < '0' || chr > '1') {
                current.type = DToken.Type.IntegerLiteral;
                current.integer = cur_integer;
                current.columnEnd = _pos;
                current.lineEnd = _lineNumber;

                state = DLexerState.Normal;
                return current.toToken;
              }
              else {
                cur_integer *= cur_base;
                cur_integer += (chr - '0');
              }
            }

            continue;
          case DLexerState.FloatingPoint:
            if (chr == '_') {
              continue;
            }
            else if (chr == '.' && (cur_base == 10 || cur_base == 16)) {
              // We are now parsing the decimal portion
              if (inDecimal) {
                _error("Only one decimal point is allowed per floating point literal.");
                return DToken.init;
              }
              else if (inExponent) {
                _error("Cannot put a decimal point after an exponent in a floating point literal.");
              }
              inDecimal = true;
            }
            else if (cur_base == 16 && (chr == 'p' || chr == 'P')) {
              // We are now parsing the exponential portion
              inDecimal = false;
              inExponent = true;
              cur_exponent = -1;
            }
            else if (cur_base == 10 && (chr == 'e' || chr == 'E')) {
              // We are now parsing the exponential portion
              inDecimal = false;
              inExponent = true;
              cur_exponent = -1;
            }
            else if (cur_base == 10) {
              if (chr == 'p' || chr == 'P') {
                _error("Cannot have a hexidecimal exponent in a non-hexidecimal floating point literal.");
                return DToken.init;
              }
              else if (chr < '0' || chr > '9') {
                if (inExponent && cur_exponent == -1) {
                  _error("You need to specify a value for the exponent part of the floating point literal.");
                  return DToken.init;
                }
                current.type = DToken.Type.FloatingPointLiteral;
                double value = cast(double)cur_integer + (cast(double)cur_decimal / cast(double)cur_denominator);
                double exp = 1;
                for(size_t i = 0; i < cur_exponent; i++) {
                  exp *= cur_base;
                }
                value *= exp;
                current.decimal = value;
                current.columnEnd = _pos;
                current.lineEnd = _lineNumber;

                state = DLexerState.Normal;
                return current.toToken;
              }
              else if (inExponent) {
                if (cur_exponent == -1) {
                  cur_exponent = 0;
                }
                cur_exponent *= cur_base;
                cur_exponent += (chr - '0');
              }
              else {
                cur_decimal *= cur_base;
                cur_denominator *= cur_base;
                cur_decimal += (chr - '0');
              }
            }
            else { // cur_base == 16
              if ((chr < '0' || chr > '9') && (chr < 'a' || chr > 'f') && (chr < 'A' || chr > 'F')) {
                if (inDecimal && !inExponent) {
                  _error("You need to provide an exponent with the decimal portion of a hexidecimal floating point number. Ex: 0xff.3p2");
                  return DToken.init;
                }
                if (inExponent && cur_exponent == -1) {
                  _error("You need to specify a value for the exponent part of the floating point literal.");
                  return DToken.init;
                }
                current.type = DToken.Type.FloatingPointLiteral;
                double value = cast(double)cur_integer + (cast(double)cur_decimal / cast(double)cur_denominator);
                double exp = 1;
                for(size_t i = 0; i < cur_exponent; i++) {
                  exp *= 2;
                }
                value *= exp;
                current.decimal = value;
                current.columnEnd = _pos;
                current.lineEnd = _lineNumber;

                state = DLexerState.Normal;
                return current.toToken;
              }
              else if (inExponent) {
                if (cur_exponent == -1) {
                  cur_exponent = 0;
                }
                cur_exponent *= cur_base;
                if (chr >= 'A' && chr <= 'F') {
                  cur_exponent += 10 + (chr - 'A');
                }
                else if (chr >= 'a' && chr <= 'f') {
                  cur_exponent += 10 + (chr - 'a');
                }
                else {
                  cur_exponent += (chr - '0');
                }
              }
              else {
                cur_decimal *= cur_base;
                cur_denominator *= cur_base;
                if (chr >= 'A' && chr <= 'F') {
                  cur_decimal += 10 + (chr - 'A');
                }
                else if (chr >= 'a' && chr <= 'f') {
                  cur_decimal += 10 + (chr - 'a');
                }
                else {
                  cur_decimal += (chr - '0');
                }
              }
            }
            continue;
        }
      }

      if (current.type != DToken.Type.EOF) {
        current.columnEnd = _pos;
        current.lineEnd = _lineNumber;
        return current.toToken;
      }
      current.line = current.line + 1;
      current.column = 1;

      if (state != DLexerState.String && state != DLexerState.Comment) {
        state = DLexerState.Normal;
      }
      else if (state == DLexerState.String) {
        if (inStringType == StringType.Character) {
          _error("Unmatched character literal.");
          return DToken.init;
        }
        cur_string ~= '\n';
      }
    }

    return DToken.init;
  }

public:
  char[] line(uint idx) {
    return _lines[idx-1];
  }

  DToken commentPop() {
    if (!_comment_bank_empty()) {
      return _comment_bank_pop();
    }
    return DToken.init;
  }

  void commentClear() {
    _comment_bank = [];
  }

  bool isCommentEmpty() {
    return _comment_bank_empty();
  }

  void push(DToken token) {
    _bank_push(token);
  }

  DToken pop() {
    if (!_bank_empty()) {
      return _bank_pop();
    }

    for(;;) {
      DToken t = _next();
      if (t.type == DToken.Type.Comment) {
        _comment_bank_push(t);
      }
      else {
        return t;
      }
    }
  }

  this(File f) {
    // TODO: read this file through a buffer.
    ubyte[] all_bytes = f.read(f.available);

    _lines = [];
    size_t last_idx = 0;
    for(size_t idx = 0; idx < all_bytes.length; idx++) {
      if (all_bytes[idx] == '\n') {
        _lines ~= cast(char[])all_bytes[last_idx..idx];
        last_idx = idx+1;
      }
    }
    _lines ~= cast(char[])all_bytes[last_idx..$];
  }
}
