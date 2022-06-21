import 'package:conny/src/exceptions.dart';
import 'dart:io';

class Conny {
  static const String _ESCAPE = '\x1b[';
  static const String _RESET = '0m';

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

  static void setColourRGB(Map<String, int> fg, Map<String, int> bg) {
    if (stdout.hasTerminal) {
      if (fg.length == 3) {
        fg.forEach((key, value) {
          if (value < 0 || value > 256) {
            reset();
            throw OutOfRangeException("Out of RGB range", 0, 255);
          }
        });
        stdout.write("$_ESCAPE${_Colour.RGB};${fg['r']};${fg['g']};${fg['b']}m");
      } else {
        reset();
        throw OutOfRangeException("Foreground RGB map out of range. EG var rgb = {'r':0,'g':0,'b':0}", 3, 3);
      }

      if (bg.length == 3) {
        bg.forEach((key, value) {
          if (value < 0 || value > 256) {
            reset();
            throw OutOfRangeException("Out of RGB range", 0, 255);
          }
        });
        stdout.write("$_ESCAPE${_Colour.RGB_BG};${bg['r']};${bg['g']};${bg['b']}m");
      } else {
        reset();
        throw OutOfRangeException("Background RGB map out of range. EG var rgb = {'r':0,'g':0,'b':0}", 3, 3);
      }
    } else {
      throw NoTerminalException();
    }
  }

  // erase
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

class _Erase {
  static const String SCREEN = '2J';
  static const String LINE = '2K';
}

// These colours are set by the terminal/user
enum Colour { BLACK, RED, GREEN, YELLOW, BLUE, MAGENTA, CYAN, WHITE, DEFAULT }

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
