import '../src/curse.dart';
import '../src/conny.dart';
import 'dart:io';

/// base class for hadeling loading bars
/// 
/// * [printName] to print name along side bar
/// * [showPercent] to print [state] along side bar
/// 
/// [state] must be tracked and updated via [updateState] by user
/// [state] should be tracked from 0 - 100
class Bar {
  late final String _name;
  late final int _length;
  int _state = 0;

  String get name => _name;
  int get length => _length;
  int get state => _state;

  /// can be changed by user, defaults to ▓
  int light = 0x2591;
  /// can be changed by user, defaults to ░
  int dark = 0x2593;

  /// show name alongside bar
  bool showName = false;
  /// show percent alongside bar
  bool showPercent = false;

  String _bar = "";

  Bar(this._name, this._length);

  /// update [state] 
  void updateState(int state) {
    _state = state;
  }

  /// start of the loading bar, place in for loop
  /// 
  /// for (String s in bar.start())
  Iterable<String> start() => _loop();

  /// fills bar upto [fillLine] with [dark] and 
  /// to [length] - [fillLine] withh [light]
  void _fill() {
    int fillLine = (_state*_length) ~/ 100;

    _bar = "";

    for (var i = 0; i < fillLine; i++) {
      _bar += String.fromCharCode(dark);
    }

    for (var i = 0; i < _length - fillLine; i++) {
      _bar += String.fromCharCode(light);
    }
  }

  /// generator that yields the current bar
  Iterable<String> _loop() sync* {
    Curse c = Curse();
    while (_state <= 100) {
      // erase line and return cursor to start of line
      Conny.erase();
      c.moveToColumn(0);

      if (showName) {
        stdout.write(_name);
      }

      // fill the bar
      _fill();

      // append percentage to filled bar
      if (showPercent) {
        _bar += (" $_state%");
      }
      
      yield _bar;
    }
  }
}