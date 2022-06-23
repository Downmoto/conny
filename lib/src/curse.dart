import 'package:conny/src/helper/exceptions.dart';
import 'dart:io';

/// base class to control console cursor behaviour
/// 
/// all methods return a [Coord] object
/// 
/// this class keeps track of the current coord for you,
/// but it is recommended to keep track of it yourself as
/// there may be dsync caused by newlines, text wrapping, etc.
/// * use [updateCoords] if dsync occurs
class Curse {
  static const String _ESCAPE = '\x1b[';

  // internally track 
  late Coord _coord;

  /// retrieve the current internally track [Coord]
  Coord get coord => _coord;

  /// constructor
  /// * check for valid termnial state or throw [NoTerminalException]
  /// * init [_coord] private field
  Curse() {
    if (stdin.hasTerminal) {
      _coord = _getCursorPosition();
    } else {
      throw NoTerminalException();
    }
  }

  /// store [stdin]'s original state then alter it to extract cursor position, 
  /// then revert [stdin]'s state to original
  ///
  /// returns [Coord] obejct
  Coord _getCursorPosition() {
    // store original state
    var lm = stdin.lineMode;
    var em = stdin.echoMode;

    stdin.lineMode = false;
    stdin.echoMode = false;

    stdout.write('${_ESCAPE}6n');
    var bytes = <int>[];

    // read cursor position from stream
    while (true) {
      var byte = stdin.readByteSync();
      bytes.add(byte);
      if (byte == 82) {
        break;
      }
    }

    // revert to original
    stdin.lineMode = lm;
    stdin.echoMode = em;

    // decode bytes and parse position into [Coord] object
    var str = String.fromCharCodes(bytes);
    str = str.substring(str.lastIndexOf('[') + 1, str.length - 1);

    final parts =
        List<int>.from(str.split(';').map((it) => int.parse(it))).toList();

    return Coord(parts[1], parts[0]);
  }

  /// updates internal [Coord] tracker with current cursor position
  void updateCoords() => _coord = _getCursorPosition();

  /// move cursor to (0,0)/(1,1) depending on terminal behaviour
  /// 
  /// sets and returns [Coord] object
  Coord home() {
    stdout.write("$_ESCAPE${_CurseCodes.HOME}");
    _coord = _getCursorPosition();
    return _coord;
  }

  /// move cursor to [column], [row] 
  /// 
  /// throws [CursorOutOfRangeException] if [coloumn] is less
  /// than or equal to [stdout.terminalColumns]
  /// 
  /// sets and returns [Coord] object
  Coord moveTo(int column, int row) {
    if (column <= stdout.terminalColumns) {
      stdout.write("$_ESCAPE$row;$column;${_CurseCodes.HOME}");
      _coord.col = column;
      _coord.row = row;
    } else {
      throw CursorOutOfRangeException(stdout.terminalColumns);
    }

    return _coord;
  }

  /// identical to moveTo but takes a [Coord] object as its sole arg
  /// 
  /// throws [CursorOutOfRangeException] if [coloumn] is less
  /// than or equal to [stdout.terminalColumns]
  /// 
  /// sets and returns [Coord] object
  Coord moveToCoord(Coord coord) {
    if (coord.col <= stdout.terminalColumns) {
      stdout.write("$_ESCAPE${coord.row};${coord.col};${_CurseCodes.HOME}");
      _coord.col = coord.col;
      _coord.row = coord.row;
    } else {
      throw CursorOutOfRangeException(stdout.terminalColumns);
    }

    return _coord;
  }

  /// move cursor to [column]
  /// 
  /// throws [CursorOutOfRangeException] if [coloumn] is less
  /// than or equal to [stdout.terminalColumns]
  /// 
  /// sets and returns [Coord] object
  Coord moveToColumn(int column) {
    if (column <= stdout.terminalColumns) {
      stdout.write("$_ESCAPE$column;${_CurseCodes.MOVETOCOL}");
      _coord.col = column;
    } else {
      throw CursorOutOfRangeException(stdout.terminalColumns);
    }
    
    return _coord;
  }

  /// moves cursor up [by]
  /// 
  /// sets and returns [Coord] object
  Coord moveCursorUp({int by=1}) {
    stdout.write("$_ESCAPE$by${_CurseCodes.UP}");
    _coord = _getCursorPosition();
    return _coord;
  }

  /// moves cursor down [by]
  /// 
  /// sets and returns [Coord] object
  Coord moveCursorDown({int by=1}) {
    stdout.write("$_ESCAPE$by${_CurseCodes.DOWN}");
    _coord = _getCursorPosition();

    return _coord;
  }

  /// moves cursor left [by]
  /// 
  /// sets and returns [Coord] object
  Coord moveCursorLeft({int by=1}) {
    stdout.write("$_ESCAPE$by${_CurseCodes.LEFT}");
    _coord = _getCursorPosition();

    return _coord;
  }

  /// moves cursor right [by]
  /// 
  /// sets and returns [Coord] object
  Coord moveCursorRight({int by=1}) {
    stdout.write("$_ESCAPE$by${_CurseCodes.RIGHT}");
    _coord = _getCursorPosition();

    return _coord;
  }
}

/// Stores coordinates and is used by the [Curse] class
class Coord {
  late int col, row;
  Coord(this.col, this.row);
}

/// ANSI codes for cursor control
class _CurseCodes {
  static const String HOME = 'H';
  static const String MOVETOCOL = 'G';

  static const String UP = 'A';
  static const String DOWN = 'B';
  static const String RIGHT = 'C';
  static const String LEFT = 'D';
}