module binding.c;

/* C long types */
version(Windows) {
}
else {
  pragma(lib, `"c"`);
}

version(GNU) {
  import gcc.builtins;
  alias __builtin_Clong Clong_t;
  alias __builtin_Culong Culong_t;
}
else version(X86_64) {
  alias long Clong_t;
  alias ulong Culong_t;
}
else {
  alias int Clong_t;
  alias uint Culong_t;
}

/* stdarg */

version(GNU) {
  private import std.c.stdarg;
}
else version(LDC) {
  private import ldc.cstdarg;
}
else {
  private import dmd.cstdarg;
}

alias va_list Cva_list;
alias va_start Cva_start;
alias va_end Cva_end;

/* stdout */

align(1) struct _iobuf {
  version( Win32 ) {
    char* _ptr;
    int   _cnt;
    char* _base;
    int   _flag;
    int   _file;
    int   _charbuf;
    int   _bufsiz;
    int   __tmpnum;
  }
  else version( linux ) {
    char*   _read_ptr;
    char*   _read_end;
    char*   _read_base;
    char*   _write_base;
    char*   _write_ptr;
    char*   _write_end;
    char*   _buf_base;
    char*   _buf_end;
    char*   _save_base;
    char*   _backup_base;
    char*   _save_end;
    void*   _markers;
    _iobuf* _chain;
    int     _fileno;
    int     _blksize;
    int     _old_offset;
    ushort  _cur_column;
    byte    _vtable_offset;
    char[1] _shortbuf;
    void*   _lock;
  }
  else version( darwin ) {
    ubyte*    _p;
    int       _r;
    int       _w;
    short     _flags;
    short     _file;
    __sbuf    _bf;
    int       _lbfsize;

    int* function(void*)                    _close;
    int* function(void*, char*, int)        _read;
    fpos_t* function(void*, fpos_t, int)    _seek;
    int* function(void*, char *, int)       _write;

    __sbuf    _ub;
    __sFILEX* _extra;
    int       _ur;

    ubyte[3]  _ubuf;
    ubyte[1]  _nbuf;

    __sbuf    _lb;

    int       _blksize;
    fpos_t    _offset;
  }
  else version( freebsd ) {
    ubyte*    _p;
    int       _r;
    int       _w;
    short     _flags;
    short     _file;
    __sbuf    _bf;
    int       _lbfsize;

    void* function()                        _cookie;
    int* function(void*)                    _close;
    int* function(void*, char*, int)        _read;
    fpos_t* function(void*, fpos_t, int)    _seek;
    int* function(void*, char *, int)       _write;

    __sbuf    _ub;
    __sFILEX* _extra;
    int       _ur;

    ubyte[3]  _ubuf;
    ubyte[1]  _nbuf;

    __sbuf    _lb;

    int       _blksize;
    fpos_t    _offset;
  }
  else version( solaris ) {
    // From OpenSolaris <ast/sfio_s.h>
    ubyte*  _next;
    ubyte*  _endw;
    ubyte*  _endr;
    ubyte*  _endb;
    _iobuf* _push;
    ushort  _flags;
    short   _file;
    ubyte*  _data;
    ptrdiff_t _size;
    ptrdiff_t _val;
  }
  else {
    static assert( false, "Platform not supported." );
  }
}

const int _NFILE = 60;
alias _iobuf FILE;
alias int fpos_t;

version(Win32) {
  extern(C) extern FILE[_NFILE] _iob;
  FILE* stdin  = &_iob[0];
  FILE* stdout = &_iob[1];
  FILE* stderr = &_iob[2];
}
else version(linux) {
  extern(C) extern FILE* stdin;
  extern(C) extern FILE* stdout;
  extern(C) extern FILE* stderr;
}
else version(darwin) {
  extern(C) extern FILE* __stdinp;
  extern(C) extern FILE* __stdoutp;
  extern(C) extern FILE* __stderrp;

  alias __stdinp stdin;
  alias __stdoutp stdout;
  alias __stderrp stderr;
}
else version(freebsd) {
    extern(C) extern FILE[3] __sF;

    FILE* stdin  = &__sF[0];
    FILE* stdout = &__sF[1];
    FILE* stderr = &__sF[2];
}
else version(solaris) {
    extern(C) extern FILE[_NFILE] __iob;

    FILE* stdin  = &__iob[0];
    FILE* stdout = &__iob[1];
    FILE* stderr = &__iob[2];
}
else {
  static assert(false, "Platform not supported.");
}

// wchar_t
version(Windows) {
  alias ushort wchar_t;
}
else {
  alias uint wchar_t;
}

extern(C) FILE[_NFILE]* _imp__iob;

const int EOF = -1;
const int FOPEN_MAX = 16;
const int FILENAME_MAX = 4095;
const int TMP_MAX = 238328;
const int L_tmpnam = 20;

enum { SEEK_SET, SEEK_CUR, SEEK_END }

// Standard C

extern(C) void exit(int);

extern(C) int system(char*);

extern(C) int     printf   (char*, ...);
extern(C) char*   tmpnam   (char*);
extern(C) FILE*   fopen    (char*, char*);
extern(C) FILE*   _fsopen  (char*, char*,   int);
extern(C) FILE*   freopen  (char*, char*,   FILE*);
extern(C) int     fseek    (FILE*, Clong_t, int);
extern(C) Clong_t ftell    (FILE*);
extern(C) char*   fgets    (char*, int,     FILE*);
extern(C) int     fgetc    (FILE*);
extern(C) int     _fgetchar();
extern(C) int     fflush   (FILE*);
extern(C) int     fclose   (FILE*);
extern(C) int     fputs    (char*, FILE *);
extern(C) char*   gets     (char*);
extern(C) int     fputc    (int,   FILE*);
extern(C) int     _fputchar(int);
extern(C) int     puts     (char*);
extern(C) int     ungetc   (int,   FILE*);
extern(C) size_t  fread    (void*, size_t,  size_t, FILE *);
extern(C) size_t  fwrite   (void*, size_t,  size_t, FILE *);
extern(C) int     fprintf  (FILE*, char*,   ...);
extern(C) int     vfprintf (FILE*, char*,   Cva_list);
extern(C) int     vprintf  (char*, Cva_list);
extern(C) int     sprintf  (char*, char*,   ...);
extern(C) int     vsprintf (char*, char*,   Cva_list);
extern(C) int     scanf    (char*, ...);
extern(C) int     fscanf   (FILE*, char*,   ...);
extern(C) int     sscanf   (char*, char*,   ...);
extern(C) void    setbuf   (FILE*, char*);
extern(C) int     setvbuf  (FILE*, char*,   int,    size_t);
extern(C) int     remove   (char*);
extern(C) int     rename   (char*, char*);
extern(C) void    perror   (char*);
extern(C) int     fgetpos  (FILE*, fpos_t*);
extern(C) int     fsetpos  (FILE*, fpos_t*);
extern(C) FILE*   tmpfile  ();
extern(C) int     _rmtmp   ();
extern(C) int     _fillbuf (FILE*);
extern(C) int     _flushbu (int,   FILE*);

extern(C) int     getw     (FILE*);
extern(C) int     putw     (int,   FILE*);

extern(C) int     getchar  ();
extern(C) int     putchar  (int);
extern(C) int     getc     (FILE*);
extern(C) int     putc     (int,   FILE*);

extern(C) void*   malloc   (size_t);
extern(C) void*   realloc  (void*, size_t);
extern(C) void*   calloc   (size_t);
extern(C) void    free     (void*);
