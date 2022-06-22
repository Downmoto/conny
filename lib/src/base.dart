import 'package:conny/src/exceptions.dart';
import 'dart:io';

// Base class to control console behaviour
class Conny {
  static const String _ESCAPE = '\x1b[';
  static const String _RESET = '0m';

  /* writes to stdout with options provided then resets to default.
  WriteOptions have default values and are intended to be set by user */
  static void write(WriteOptions options, String str, {bool newline = true}) {
    if (stdout.hasTerminal) {
      var o = options.options();

      setGraphic(
        bold: o['bold'],
        dim: o['dim'],
        italic: o['italic'],
        underline: o['underline'],
        strike: o['strike']);

      setColourRGB(o['fg'], o['bg']);

      if (o['dbg']) {
        setBackgroundColour(Colour.DEFAULT);
      }

      stdout.write(str);
      reset();

      if (newline) {
        stdout.writeln();
      }
    } else {
      throw NoTerminalException();
    }
  }

  // reset all set graphic and colour modes to base terminal
  static void reset() {
    if (stdout.hasTerminal) {
      stdout.write("$_ESCAPE$_RESET");
    } else {
      throw NoTerminalException();
    }
  }

  // set graphic modes, use unset() or reset() to revert graphic
  static void setGraphic(
      {bool bold = false,
      bool dim = false,
      bool italic = false,
      bool underline = false,
      bool strike = false}) {
    if (stdout.hasTerminal) {
      if (bold) {
        stdout.write("$_ESCAPE${_Graphic.SET_BOLD}");
      }
      if (dim) {
        stdout.write("$_ESCAPE${_Graphic.SET_DIM}");
      }
      if (italic) {
        stdout.write("$_ESCAPE${_Graphic.SET_ITALIC}");
      }
      if (underline) {
        stdout.write("$_ESCAPE${_Graphic.SET_UNDERLINE}");
      }
      if (strike) {
        stdout.write("$_ESCAPE${_Graphic.SET_STRIKETHROUGH}");
      }
    } else {
      throw NoTerminalException();
    }
  }

  // unset speific graphic modes, use reset() to unset all
  static void unsetGraphic(
      {bool bold = false,
      bool dim = false,
      bool italic = false,
      bool underline = false,
      bool strike = false}) {
    if (stdout.hasTerminal) {
      if (bold) {
        stdout.write("$_ESCAPE${_Graphic.UNSET_BOLD}");
      }
      if (dim) {
        stdout.write("$_ESCAPE${_Graphic.UNSET_DIM}");
      }
      if (italic) {
        stdout.write("$_ESCAPE${_Graphic.UNSET_ITALIC}");
      }
      if (underline) {
        stdout.write("$_ESCAPE${_Graphic.UNSET_UNDERLINE}");
      }
      if (strike) {
        stdout.write("$_ESCAPE${_Graphic.UNSET_STRIKETHROUGH}");
      }
    } else {
      throw NoTerminalException();
    }
  }

  // set foreground and background colours using Colour Enum
  static void setColour(Colour fg, {Colour bg = Colour.DEFAULT}) {
    // mapping enum to correct foreground colours
    var fgMap = {
      Colour.BLACK: _Colour.BLACK,
      Colour.RED: _Colour.RED,
      Colour.GREEN: _Colour.GREEN,
      Colour.YELLOW: _Colour.YELLOW,
      Colour.BLUE: _Colour.BLUE,
      Colour.MAGENTA: _Colour.MAGENTA,
      Colour.CYAN: _Colour.CYAN,
      Colour.WHITE: _Colour.WHITE,
      Colour.DEFAULT: _Colour.DEFAULT
    };

    // mapping enum to correct background colours
    var bgMap = {
      Colour.BLACK: _Colour.BLACK_BG,
      Colour.RED: _Colour.RED_BG,
      Colour.GREEN: _Colour.GREEN_BG,
      Colour.YELLOW: _Colour.YELLOW_BG,
      Colour.BLUE: _Colour.BLUE_BG,
      Colour.MAGENTA: _Colour.MAGENTA_BG,
      Colour.CYAN: _Colour.CYAN_BG,
      Colour.WHITE: _Colour.WHITE_BG,
      Colour.DEFAULT: _Colour.DEFAULT_BG
    };

    if (stdout.hasTerminal) {
      stdout.write("$_ESCAPE${fgMap[fg]};${bgMap[bg]}m");
    } else {
      throw NoTerminalException();
    }
  }

  /* set colours using an id in range of 0 - 255
  0 - 15 are the Enum Colours + bright variants
  16 - 231 are different colour variants,
  232 - 255 are grayscale starting with a lighter black */
  static void setColour256(int idfg, int idbg) {
    if (stdout.hasTerminal) {
      if ((idfg > 0 && idfg < 256) && (idbg > 0 && idbg < 256)) {
        stdout.write("$_ESCAPE${_Colour.ID}${idfg}m");
        stdout.write("$_ESCAPE${_Colour.ID_BG}${idbg}m");
      } else {
        reset();
        throw OutOfRangeException("Out of ID range", 0, 225);
      }
    } else {
      throw NoTerminalException();
    }
  }

  /* set colours using RGB values
  params should mimic this map:
  Map<String, int> varName = {
    'r' : intValue in range of 0 - 255,
    'g' : intValue in range of 0 - 255,
    'b' : intValue in range of 0 - 255
  }
  The key names must be r, g, b */
  static void setColourRGB(Map<String, int> fg, Map<String, int> bg) {
    if (stdout.hasTerminal) {
      if (fg.length == 3) {
        fg.forEach((key, value) {
          if (value < 0 || value > 255) {
            reset();
            throw OutOfRangeException("Out of RGB range", 0, 255);
          }
        });
        stdout.write("$_ESCAPE${_Colour.RGB}${fg['r']};${fg['g']};${fg['b']}m");
      } else {
        reset();
        throw OutOfRangeException(
            "Foreground RGB map out of range. EG var rgb = {'r':0,'g':0,'b':0}",
            3,
            3);
      }

      if (bg.length == 3) {
        bg.forEach((key, value) {
          if (value < 0 || value > 256) {
            reset();
            throw OutOfRangeException("Out of RGB range", 0, 255);
          }
        });
        stdout.write(
            "$_ESCAPE${_Colour.RGB_BG}${bg['r']};${bg['g']};${bg['b']}m");
      } else {
        reset();
        throw OutOfRangeException(
            "Background RGB map out of range. EG var rgb = {'r':0,'g':0,'b':0}",
            3,
            3);
      }
    } else {
      throw NoTerminalException();
    }
  }

  static void setBackgroundColour(Colour clr) {
    // mapping enum to correct background colours
    var clMap = {
      Colour.BLACK: _Colour.BLACK_BG,
      Colour.RED: _Colour.RED_BG,
      Colour.GREEN: _Colour.GREEN_BG,
      Colour.YELLOW: _Colour.YELLOW_BG,
      Colour.BLUE: _Colour.BLUE_BG,
      Colour.MAGENTA: _Colour.MAGENTA_BG,
      Colour.CYAN: _Colour.CYAN_BG,
      Colour.WHITE: _Colour.WHITE_BG,
      Colour.DEFAULT: _Colour.DEFAULT_BG
    };

    if (stdout.hasTerminal) {
      stdout.write("$_ESCAPE${clMap[clr]}m");
    } else {
      throw NoTerminalException();
    }
  }

  static void setBackgroundColour256(int idclr) {
    if (stdout.hasTerminal) {
      if (idclr > 0 && idclr < 256) {
        stdout.write("$_ESCAPE${_Colour.ID_BG}${idclr}m");
      } else {
        reset();
        throw OutOfRangeException("Out of ID range", 0, 255);
      }
    } else {
      throw NoTerminalException();
    }
  }

  static void setBackgroundColourRGB(Map<String, int> clr) {
    if (stdout.hasTerminal) {
      if (clr.length == 3) {
        clr.forEach((key, value) {
          if (value < 0 || value > 255) {
            reset();
            throw OutOfRangeException("Out of RGB range", 0, 255);
          }
        });
        stdout.write("$_ESCAPE${_Colour.RGB}${clr['r']};${clr['g']};${clr['b']}m");
      } else {
        reset();
        throw OutOfRangeException(
            "Background RGB map out of range. EG var rgb = {'r':0,'g':0,'b':0}",
            3,
            3);
      }
    } else {
      throw NoTerminalException();
    }
  }

  // erase line or screen, this does not reposition cursor
  static void erase({bool screen = false}) {
    if (stdout.hasTerminal) {
      if (!screen) {
        stdout.writeln("$_ESCAPE${_Erase.LINE}");
      } else {
        stdout.write("$_ESCAPE${_Erase.SCREEN}");
      }
    } else {
      throw NoTerminalException();
    }
  }
}

// Holds options for Conny.write
class WriteOptions {
  // graphics
  late bool _bold;
  late bool _dim;
  late bool _italic;
  late bool _underline;
  late bool _strike;

  // colours
  late int _rf;
  late int _gf;
  late int _bf;

  late bool _dbg;

  late int _rb;
  late int _gb;
  late int _bb;

  WriteOptions(
      {bool bold = false,
      bool dim = false,
      bool italic = false,
      bool underline = false,
      bool strike = false,
      bool defaultBackground = true,
      int rf = 0,
      int gf = 0,
      int bf = 0,
      int rb = 0,
      int gb = 0,
      int bb = 0}) {
    _bold = bold;
    _dim = dim;
    _italic = italic;
    _underline = underline;
    _strike = strike;

    _rf = rf;
    _gf = gf;
    _bf = bf;

    _dbg = defaultBackground;

    _rb = rb;
    _gb = gb;
    _bb = bb;
  }

  Map<String, dynamic> options() {
    return {
      'bold': _bold,
      'dim': _dim,
      'italic': _italic,
      'underline': _underline,
      'strike': _strike,
      'dbg': _dbg,
      'fg': {'r': _rf, 'g': _gf, 'b': _bf},
      'bg': {'r': _rb, 'g': _gb, 'b': _bb}
    };
  }
}

// Erase chars
class _Erase {
  static const String SCREEN = '2J';
  static const String LINE = '2K';
}

// These colours are set by the terminal/user
enum Colour { BLACK, RED, GREEN, YELLOW, BLUE, MAGENTA, CYAN, WHITE, DEFAULT }

// Colour chars, m stripped
class _Colour {
  static const String ID = '38;5;';
  static const String ID_BG = '48;5;';

  static const String RGB = '38;2;';
  static const String RGB_BG = '48;2;';

  static const String BLACK = '30';
  static const String BLACK_BG = '40';

  static const String RED = '31';
  static const String RED_BG = '41';

  static const String GREEN = '32';
  static const String GREEN_BG = '42';

  static const String YELLOW = '33';
  static const String YELLOW_BG = '43';

  static const String BLUE = '34';
  static const String BLUE_BG = '44';

  static const String MAGENTA = '35';
  static const String MAGENTA_BG = '45';

  static const String CYAN = '36';
  static const String CYAN_BG = '46';

  static const String WHITE = '37';
  static const String WHITE_BG = '47';

  static const String DEFAULT = '39';
  static const String DEFAULT_BG = '49';
}

// Graphic chars
class _Graphic {
  static const String SET_BOLD = '1m';
  static const String UNSET_BOLD = '22m';

  static const String SET_DIM = '2m';
  static const String UNSET_DIM = '22m';

  static const String SET_ITALIC = '3m';
  static const String UNSET_ITALIC = '23m';

  static const String SET_UNDERLINE = '4m';
  static const String UNSET_UNDERLINE = '24m';

  static const String SET_STRIKETHROUGH = '9m';
  static const String UNSET_STRIKETHROUGH = '29m';
}
