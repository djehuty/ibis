module system.storage;

import io.file;

import chrono.date_time;
import chrono.month;

import tango.io.Stdout;

version(Windows) {
}
else version(linux) {
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

  extern(C) int*    fopen(char* filename, char* mode);
  extern(C) size_t  fread(void* ptr, size_t size, size_t count, int* stream);
  extern(C) size_t  fwrite(void* ptr, size_t size, size_t count, int* stream);
  extern(C) int     fclose(int* stream);
  extern(C) int     fseek(int* stream, Clong_t offset, int origin);
  extern(C) Clong_t ftell(int* stream);

  enum { SEEK_SET, SEEK_CUR, SEEK_END }

  struct dirent {
    version(darwin) {
      uint d_ino;
      ushort d_reclen;
      ubyte d_type;
      ubyte d_namlen;
      char d_name[256];
    }
    else {
      Culong_t d_ino;
      Culong_t d_off;

      ushort d_reclen;
      ubyte d_type;
      char d_name[256];
    }
  }

  extern(C) dirent* readdir(int* dirp);
  extern(C) int readdir_r(int* dirp, dirent* entry, dirent** result);
  extern(C) int* opendir(char* dirname);

  struct timespec {
    Clong_t tv_sec;
    Clong_t tv_nsec;
  }

  struct struct_stat {
    version(darwin) {
      uint st_dev;
      uint st_ino;
      ushort st_mode;
      ushort st_nlink;
      uint st_uid;
      uint st_gid;
      uint st_rdev;
      ulong[64] fuck;
    }
    else version(linux) {
      ulong st_dev;

      version(X86) {
        ubyte[4] __pad1;
        uint __st_ino;
        uint st_mode;
        uint st_nlink;
      } else version(X86_64) {
        ulong st_ino;
        ulong st_nlink;
        uint st_mode;
      } else {
        static assert(false); // Unsupported architecture.
      }

      uint st_uid;
      uint st_gid;

      version(X86_64)
        ubyte[4] __pad0;

      ulong st_rdev;

      version(X86)
        ubyte[4] __pad2;

      long st_size;
      Clong_t st_blksize;
      long st_blocks;
      timespec st_atim;
      timespec st_mtim;
      timespec st_ctim;

      version(X86) {
        ulong st_ino;
      } else version (X86_64){
        ubyte[24] __unused;
      }
    }
    else {
      static assert(false); // Unsupported OS.
    }
  }

  extern(C) int stat(char* path, struct_stat* info);

  struct tm {
    int tm_sec;
    int tm_min;
    int tm_hour;
    int tm_mday;
    int tm_mon;
    int tm_year;
    int tm_wday;
    int tm_yday;
    int tm_isdst;
    char* tm_zone;
    int tm_gmtoff;
  }

  alias int time_t;
  extern(C) tm* gmtime(time_t* tim);
  extern(C) tm* gmtime_r(time_t* tim, tm* output);
}

final class Storage {
public:
  this() {
  }

  // Methods //

  static File open(char[] path) {
    return new File((path ~ "\0").ptr);
  }

  static File create(char[] path) {
    int* fptr = fopen((path~"\0").ptr, "w+b\0".ptr);
    fclose(fptr);

    return open(path);
  }

  static File create(char[][] tags) {
    char[] path = "";
    foreach(tag; tags) {
      path ~= "/" ~ tag;
    }

    // Create file at path and return open file buffer
    return create(path);
  }

  static DateTime modified(char[] path) {
    struct_stat stat_params;
    stat((path ~ "\0").ptr, &stat_params);

    timespec val = stat_params.st_mtim;

    tm time_struct;
    int seconds = val.tv_sec;
    gmtime_r(&seconds, &time_struct);

    // get microseconds
    long micros;
    micros = time_struct.tm_sec + (time_struct.tm_min * 60);
    micros += time_struct.tm_hour * 60 * 60;
    micros *= 1000000;
    micros += val.tv_nsec / 1000;
    return new DateTime(cast(Month)time_struct.tm_mon, time_struct.tm_mday,
                        time_struct.tm_year + 1900, micros);
  }

  static void tag(File f, char[][] tags) {
    char[] path = "";
    foreach(tag; tags) {
      path ~= "/" ~ tag;
    }

    // Place file in buffer f into path given
  }

  static char[][] query(bool match, char[][] tags) {
    char[] path = "";
    foreach(tag; tags) {
      path ~= "/" ~ tag;
    }

    char[][] ret = [];
    // Iterate directory for files
    // Recursively if match is false
    // Return absolute paths as identifiers

    int* dir_p = opendir((path ~ "\0").ptr);

    dirent* current_dir = null;
    for(;;) {
      current_dir = readdir(dir_p);
      if (current_dir !is null) {
        size_t len = 0;
        foreach(size_t idx, chr; current_dir.d_name) {
          len = idx;
          if (chr == '\0') {
            break;
          }
        }
        ret ~= path ~ "/" ~ current_dir.d_name[0..len];
      }
      else {
        break;
      }
    }

    return ret;
  }
}
