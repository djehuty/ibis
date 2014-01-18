#[crate_id="system-culture#1.0"];
#[feature(globs)];

extern mod culture_locale    = "culture-locale";
extern mod locale_english_us = "locale-english_us";
extern mod locale_french_fr  = "locale-french_fr";

extern mod io_console = "io-console";

#[cfg(target_os = "linux")]
mod os {
  #[nolink]
  extern {
    #[link_name = "getenv"]
    pub fn getenv(symbol: *u8) -> *u8;
  }
}

mod io {
  pub mod console {
    pub use io_console::io::console::*;
  }
}

mod culture {
  pub mod locale {
    pub use culture_locale::culture::locale::*;
  }
}

mod locale {
  pub mod english_us {
    pub use locale_english_us::locale::english_us::*;
  }

  pub mod french_fr {
    pub use locale_french_fr::locale::french_fr::*;
  }
}

pub mod system {
  pub mod culture {
    static _2LetterTo3Letter:[&'static str, ..368] = [
      "aa", "aar", "ab", "abk", "af", "afr", "ak", "aka", "sq", "sqi", "am", "amh",
      "ar", "ara", "an", "arg", "hy", "hye", "as", "asm", "av", "ava", "ae", "ave",
      "ay", "aym", "az", "aze", "ba", "bak", "bm", "bam", "eu", "eus", "be", "bel",
      "bn", "ben", "bh", "bih", "bi", "bis", "bs", "bos", "br", "bre", "bg", "bul",
      "my", "mya", "ca", "cat", "ch", "cha", "ce", "che", "zh", "zho", "cu", "chu",
      "cv", "chv", "kw", "cor", "co", "cos", "cr", "cre", "cs", "ces", "da", "dan",
      "dv", "div", "nl", "nld", "dz", "dzo", "en", "eng", "eo", "epo", "et", "est",
      "ee", "ewe", "fo", "fao", "fj", "fij", "fi", "fin", "fr", "fra", "fy", "fry",
      "ff", "ful", "ka", "kat", "de", "deu", "gd", "gla", "ga", "gle", "gl", "glg",
      "gv", "glv", "el", "ell", "gn", "grn", "gu", "guj", "ht", "hat", "ha", "hau",
      "he", "heb", "hz", "her", "hi", "hin", "ho", "hmo", "hr", "hrv", "hu", "hun",
      "ig", "ibo", "is", "isl", "io", "ido", "ii", "iii", "iu", "iku", "ie", "ile",
      "ia", "ina", "id", "ind", "ik", "ipk", "it", "ita", "jv", "jav", "ja", "jpn",
      "kl", "kal", "kn", "kan", "ks", "kas", "kr", "kau", "kk", "kaz", "km", "khm",
      "ki", "kik", "rw", "kin", "ky", "kir", "kv", "kom", "kg", "kon", "ko", "kor",
      "kj", "kua", "ku", "kur", "lo", "lao", "la", "lat", "lv", "lav", "li", "lim",
      "ln", "lin", "lt", "lit", "lb", "ltz", "lu", "lub", "lg", "lug", "mk", "mkd",
      "mh", "mah", "ml", "mal", "mi", "mri", "mr", "mar", "ms", "msa", "mg", "mlg",
      "mt", "mlt", "mn", "mon", "na", "nau", "nv", "nav", "nr", "nbl", "nd", "nde",
      "ng", "ndo", "ne", "nep", "nn", "nno", "nb", "nob", "no", "nor", "ny", "nya",
      "oc", "oci", "oj", "oji", "or", "ori", "om", "orm", "os", "oss", "pa", "pan",
      "fa", "fas", "pi", "pli", "pl", "pol", "pt", "por", "ps", "pus", "qu", "que",
      "rm", "roh", "ro", "ron", "rn", "run", "ru", "rus", "sg", "sag", "sa", "san",
      "si", "sin", "sk", "slk", "sl", "slv", "se", "sme", "sm", "smo", "sn", "sna",
      "sd", "snd", "so", "som", "st", "sot", "es", "spa", "sc", "srd", "sr", "srp",
      "ss", "ssw", "su", "sun", "sw", "swa", "sv", "swe", "ty", "tah", "ta", "tam",
      "tt", "tat", "te", "tel", "tg", "tgk", "tl", "tgl", "th", "tha", "bo", "bod",
      "ti", "tir", "to", "ton", "tn", "tsn", "ts", "tso", "tk", "tuk", "tr", "tur",
      "tw", "twi", "ug", "uig", "uk", "ukr", "ur", "urd", "uz", "uzb", "ve", "ven",
      "vi", "vie", "vo", "vol", "cy", "cym", "wa", "wln", "wo", "wol", "xh", "xho",
      "yi", "yid", "yo", "yor", "za", "zha", "zu", "zul"
    ];

    struct LocaleResult {
      country:  ~str,
      language: ~str
    }

    fn system_poll() -> LocaleResult {
      let locale_string:~str = unsafe {
        let buf = ::os::getenv("LANG\0".as_ptr());

        // TODO: put this in text::unicode
        let mut curr = buf;
        let mut i = 0;
        while *curr != 0 {
            i += 1;
            curr = ::std::ptr::offset(buf, i);
        }

        let mut v: ~[u8] = ::std::vec::with_capacity(i as uint);
        ::std::ptr::copy_memory(v.as_mut_ptr(), buf as *u8, i as uint);
        v.set_len(i as uint);

        ::std::cast::transmute(v)
      };

      let normalized = {
        let mut end = locale_string.len();
        for i in ::std::iter::range_step(0, locale_string.len(), 1) {
          if locale_string[i] == '.' as u8 {
            end = i;
            break;
          }
        }

        locale_string.slice(0, end)
      };

      let separator = {
        let mut end = normalized.len();
        for i in ::std::iter::range_step(0, normalized.len(), 1) {
          if normalized[i] == '_' as u8 {
            end = i;
            break;
          }
        }
        end
      };

      let language = {
        let mut ret = normalized.slice(0, separator);
        for i in ::std::iter::range_step(0, _2LetterTo3Letter.len(), 2) {
          if _2LetterTo3Letter[i] == ret {
            ret = _2LetterTo3Letter[i+1];
            break;
          }
        }

        ret
      };

      let country = normalized.slice_from(separator+1);

      LocaleResult {
        language: language.to_owned(),
        country:  country.to_owned()
      }
    }

    pub fn language() -> ~str {
      system_poll().language
    }

    pub fn country() -> ~str {
      system_poll().country
    }

    pub fn local() -> ::culture::locale::Locale {
      let result = system_poll();

      match result.language {
        ~"eng" => match result.country {
          ~"US" => ::locale::english_us::locale(),
          _     => ::locale::english_us::locale(),
        },
        ~"fra" => match result.country {
          ~"FR" => ::locale::french_fr::locale(),
          _     => ::locale::french_fr::locale(),
        },
        _       => ::locale::english_us::locale(),
      }
    }
  }
}
