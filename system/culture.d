module system.culture;

import culture.locale;

import culture.english_us;
import culture.spanish_es;
import culture.french_fr;

static const char[][] _2LetterTo3Letter = [
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

version(Windows) {
}
else version(linux) {
  extern(C) char* getenv(char*);
  extern(C) int setlocale(int, char*);

  static const int LC_ALL = 6;

  static void _initLocale() {
    setlocale(LC_ALL, "\0".ptr);
  }

  static char[] _getSystemLocale() {
    char* locale_string = getenv("LANG\0".ptr);
    char[] normalized_locale_string = "";
    for(size_t idx = 0; idx < 255; idx++) {
      if (locale_string[idx] == '.' || locale_string[idx] == '\0') {
        normalized_locale_string = locale_string[0..idx];
        break;
      }
    }

    char[] lang_string = "";
    char[] country_string = "";

    for(size_t idx = 0; idx < normalized_locale_string.length; idx++) {
      if (normalized_locale_string[idx] == '_') {
        lang_string = normalized_locale_string[0..idx];
        country_string = normalized_locale_string[idx+1..$];
      }
    }

    for(size_t idx = 0; idx < _2LetterTo3Letter.length; idx += 2) {
      if (_2LetterTo3Letter[idx] == lang_string) {
        lang_string = _2LetterTo3Letter[idx + 1];
        break;
      }
    }

    return lang_string ~ country_string;
  }
}
else {
  // Somehow, this statement amuses me.
  static assert(false, "I do not know how to compile the Culture class.");
}

final class Culture {
private:
  Locale _locale;

public:
  this() {
    _initLocale();
    auto localeStr = _getSystemLocale();

    switch (localeStr) {
      case "engUS":
        _locale = (new EnglishUS).locale;
        break;
      case "fraFR":
        _locale = (new FrenchFr).locale;
        break;
      case "spaES":
        _locale = (new SpanishEs).locale;
        break;
      default:
        break;
    }
  }

  this(Locale locale) {
    _locale = locale;
  }

  Locale locale() {
    return _locale;
  }
}
