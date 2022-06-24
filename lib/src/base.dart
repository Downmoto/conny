import 'package:conny/src/helper/exceptions.dart';
import 'dart:io';

/// base class to control console behaviour
///
/// all methods are static, return nothing and the class
/// does not/should not be instantiated
class Conny {
  static const String _ESCAPE = '\x1b[';
  static const String _RESET = '0m';

  /// writes to [stdout] with options provided then resets to default.
  ///
  /// throws [NoTerminalException] if no terminal is attached
  ///
  /// * [WriteOptions] have default values and are intended to be set by user
  /// * [str] is a [String] object which will be written to [stdout]
  /// * [newline] is an optional argument defaulted to true
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

  /// reset all set graphic and colour modes to terminal default
  ///
  /// throws [NoTerminalException] if no terminal is attached
  static void reset() {
    if (stdout.hasTerminal) {
      stdout.write("$_ESCAPE$_RESET");
    } else {
      throw NoTerminalException();
    }
  }

  /// set graphic modes, use [unsetGraphic] or [reset] to revert graphics
  ///
  /// throws [NoTerminalException] if no terminal is attached
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

  /// unset speific graphic modes, use [reset] to unset all
  ///
  /// throws [NoTerminalException] if no terminal is attached
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

  /// set foreground[fg] and background[bg] colours using [Colour] Enum
  ///
  /// throws [NoTerminalException] if no terminal is attached
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

  /// set colours using an id in range of 0 - 255
  /// 0 - 15 are the Enum Colours + bright variants
  /// 16 - 231 are different colour variants,
  /// 232 - 255 are grayscale starting with a lighter black
  ///
  /// throws [OutOfRangeException] if [idfg] or [idbg] are > 0 || < 256
  ///
  /// throws [NoTerminalException] if no terminal is attached
  ///
  /// * [idfg] foreground ID
  /// * [idbg] background ID
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

  /// set colours using RGB values
  /// params should mimic this variable:
  /// List<int> varName = [0, 0, 0]
  ///
  /// throws [OutOfRangeException] if [fg] or [bg] do not contain 3 integer values
  /// or if any of the values are > 0 || < 256
  ///
  /// throws [NoTerminalException] if no terminal is attached
  static void setColourRGB(List<int> fg, List<int> bg) {
    if (stdout.hasTerminal) {
      if (fg.length == 3) {
        for (int value in fg) {
          if (value < 0 || value > 255) {
            reset();
            throw OutOfRangeException("Out of RGB range", 0, 255);
          }
        }
        stdout.write("$_ESCAPE${_Colour.RGB}${fg[0]};${fg[1]};${fg[2]}m");
      } else {
        reset();
        throw OutOfRangeException(
            "Foreground RGB list out of range. EG var rgb = [0, 0, 0]", 3, 3);
      }

      if (bg.length == 3) {
        for (int value in bg) {
          if (value < 0 || value > 256) {
            reset();
            throw OutOfRangeException("Out of RGB range", 0, 255);
          }
        }
        stdout.write("$_ESCAPE${_Colour.RGB_BG}${bg[0]};${bg[1]};${bg[2]}m");
      } else {
        reset();
        throw OutOfRangeException(
            "Background RGB list out of range. EG var rgb = [0, 0, 0]", 3, 3);
      }
    } else {
      throw NoTerminalException();
    }
  }

  /// set background [clr] colour using [Colour] Enum
  /// 
  /// throws [NoTerminalException] if no terminal is attached
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

  /// set colour using an [int] id in range of 0 - 255
  /// 0 - 15 are the Enum Colours + bright variants
  /// 16 - 231 are different colour variants,
  /// 232 - 255 are grayscale starting with a lighter black
  ///
  /// throws [OutOfRangeException] if [idclr] is > 0 || < 256
  ///
  /// throws [NoTerminalException] if no terminal is attached
  ///
  /// * [idclr] background ID
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

  /// set colour using RGB values
  /// params should mimic this variable:
  /// List<int> varName = [0, 0, 0]
  ///
  /// throws [OutOfRangeException] if [clr] does not contain 3 integer values
  /// or if any of the values are > 0 || < 256
  ///
  /// throws [NoTerminalException] if no terminal is attached
  static void setBackgroundColourRGB(List<int> clr) {
    if (stdout.hasTerminal) {
      if (clr.length == 3) {
        for (int value in clr) {
          if (value < 0 || value > 255) {
            reset();
            throw OutOfRangeException("Out of RGB range", 0, 255);
          }
        };
        stdout.write(
            "$_ESCAPE${_Colour.RGB}${clr[0]};${clr[1]};${clr[2]}m");
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

  /// erase line or screen, this does not reposition cursor
  ///
  /// throws [NoTerminalException] if no terminal is attached
  ///
  /// * [screen] is defauled to false,
  /// thus by default [erase] erases the line the cursor is on
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

/// holds options for [Conny.write]
class WriteOptions {
  // graphics
  late bool _bold;
  late bool _dim;
  late bool _italic;
  late bool _underline;
  late bool _strike;

  // colours
  late List<int> _fg;
  late bool _dbg;
  late List<int> _bg;

  static const List<int> _default = [0, 0, 0];

  WriteOptions(
      {bool bold = false,
      bool dim = false,
      bool italic = false,
      bool underline = false,
      bool strike = false,
      bool defaultBackground = true,
      List<int> fg = _default,
      List<int> bg = _default}) {
    _bold = bold;
    _dim = dim;
    _italic = italic;
    _underline = underline;
    _strike = strike;

    _fg = fg;
    _dbg = defaultBackground;
    _bg = bg;
  }

  /// returns [Map] object of type [String] and [dynamic] with
  /// set user write options
  Map<String, dynamic> options() {
    return {
      'bold': _bold,
      'dim': _dim,
      'italic': _italic,
      'underline': _underline,
      'strike': _strike,
      'dbg': _dbg,
      'fg': _fg,
      'bg': _bg
    };
  }
}

/// erase ANSI codes
class _Erase {
  static const String SCREEN = '2J';
  static const String LINE = '2K';
}

/// these colours are set by the terminal/user
enum Colour { BLACK, RED, GREEN, YELLOW, BLUE, MAGENTA, CYAN, WHITE, DEFAULT }

/// colour ANSI codes, m stripped
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

/// graphic ANSI codes
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
