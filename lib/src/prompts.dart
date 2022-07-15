// import 'package:conny/src/helper/exceptions.dart';
import 'package:conny/src/curse.dart';
import 'package:conny/src/conny.dart';
import 'dart:io';

/// base class for custom prompts
///
/// construct the class and use the [execute] method to run it
///
/// [tag] is defaulted to '>', it is a public field that can changed freely
class Prompt {
  // store prompt info
  late final String _question;
  late final List<Map<String, dynamic>> _answers;

  // index of selected answer
  int _selected = 0;

  // render answers inline with question
  late final bool _inline;

  // terminal defaults
  WriteOptions _mainTheme = WriteOptions();

  // cursor controller
  final Curse _c = Curse();

  // store terminal linemode and echomode settings to be reverted
  late final bool _lm;
  late final bool _em;

  /// renders before every question, set to '' to stop rendering,
  /// can be changed freely, defaulted to '>'
  String tag = '>';

  /// pressing this key will exit out of the prompt, 
  /// can be changed freely, defauled to 'q'
  String exitKey = 'q';
  int _ek = 113;

  /// construct prompts with an array of [answers] to one [question]
  ///
  /// * [question] will render first
  /// * [answers] will be rendered in order, see documentation/examples
  /// for how to structure [answers] array
  /// * [inline] is an optional param defaulted to false, setting
  /// inline to true will render answers on the same line as [question]
  /// * [theme] is a [WriteOptions] optional param, leaving it blank
  /// will render [question] and unselected [answers] with default
  /// terminal settings
  Prompt(String question, List<Map<String, dynamic>> answers,
      [bool inline = false, WriteOptions? theme])
      : _question = question,
        _answers = answers,
        _inline = inline {
    if (theme != null) _mainTheme = theme;

    _lm = stdin.lineMode;
    _em = stdin.echoMode;
  }

  /// turn off echo and line mode, hide cursor
  void _start() {
    stdin.echoMode = false;
    stdin.lineMode = false;

    _ek = exitKey.codeUnits[0];

    _c.hideCursor();
  }

  /// restore echo and line mode, unhide cursor
  void _done() {
    _c.unhideCursor();
    
    Conny.erase(screen: true);

    stdin.echoMode = _em;
    stdin.lineMode = _lm;
  }

  /// render prompt
  void _render() {
    Coord c = _c.coord;

    _c.moveCursorDown(by: _inline ? 1 : _answers.length + 1);
    Conny.erase(toCursor: true);
    _c.moveToCoord(c);
    _c.moveToColumn(0);
    Conny.write(_mainTheme, _question, newline: !_inline);

    for (var answer in _answers) {
      stdout.write(' $tag ');
      Conny.write(
          answer == _answers[_selected]
              ? answer['highlight'] ?? _mainTheme
              : _mainTheme,
          answer['answer'],
          newline: !_inline);

      if (answer['tipText'] != null && answer == _answers[_selected]) {
        if (_inline) {
          _c.updateCoords();
          Coord ct = _c.coord;

          stdout.writeln();

          Conny.write(answer['tipHighlight'] ?? _mainTheme, answer['tipText'],
              newline: false);

          _c.updateCoords();
          _c.moveToCoord(ct);
        }
      }
    }
    if (!_inline) {
      Conny.erase();
      Conny.write(_answers[_selected]['tipHighlight'] ?? _mainTheme,
          _answers[_selected]['tipText'],
          newline: false);
    }
  }

  Coord _rc = Coord(0, 0);
  void execute() {
    _start();

    List<int> bytes = [];

    _rc = _c.coord;
    _render();
    while (true) {
      int byte = stdin.readByteSync();
      bytes.add(byte);
      // print(ascii.decode(bytes));

      // exit on 'q' press
      if (byte == _ek) break;

      if (byte == _Codes.ENTER.codeUnits[0]) {
        stdout.writeln();
        _answers[_selected]['function']();
        _c.moveToCoord(_rc);

        break;
      }

      // only read arrow escapes
      if (bytes.first != 27) bytes.clear();

      // handle arrow keypresses, reset bytes array
      if (bytes.length == 3) {
        _handleDirection(bytes.last);
        _render();
        bytes.clear();
      }
    }
    _done();
  }

  /// hande arrow keypresses, by altering [_selected] value to
  /// match correct answer index
  void _handleDirection(int last) {
    switch (last) {
      case _Codes.UP:
        {
          if (!_inline) {
            if (_selected > 0) {
              _selected--;
            }
          }
        }
        break;

      case _Codes.DOWN:
        {
          if (!_inline) {
            if (_selected < _answers.length - 1) {
              _selected++;
            }
          }
        }
        break;

      case _Codes.RIGHT:
        {
          if (_inline) {
            if (_selected < _answers.length - 1) {
              _selected++;
            }
          }
        }
        break;

      case _Codes.LEFT:
        {
          if (_inline) {
            if (_selected > 0) {
              _selected--;
            }
          }
        }
        break;
    }
  }
}

class _Codes {
  static const int UP = 65;
  static const int DOWN = 66;
  static const int RIGHT = 67;
  static const int LEFT = 68;

  static const String ENTER = '\n';
}
