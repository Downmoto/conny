import 'dart:convert';

import 'package:conny/src/helper/exceptions.dart';
import 'package:conny/src/curse.dart';
import 'package:conny/src/conny.dart';
import 'dart:io';

class Prompt {
  late Map<String, dynamic> _p;
  late final List _prompts;
  late final int _len;
  late final WriteOptions _colour;

  final Curse _c = Curse();

  dynamic _listner;
  dynamic _sub;
  int _subcount = 0;

  List<String> inputs = [];

  Prompt(Map<String, dynamic> promptMap) {
    _p = promptMap;

    _prompts = _p['prompts'] as List;
    _colour = _p['colour'];

    _len = _prompts.length;
  }

  void _cancel() {
    stdin.echoMode = true;
    stdin.lineMode = true;

    _c.unhideCursor();
  }

  void _init() {
    stdin.echoMode = false;
    stdin.lineMode = false;

    _sub = stdin.asBroadcastStream(onCancel: ((subscription) {
      if (_subcount == 0) {
        _cancel();
        subscription.cancel();
      }
    })).map((event) => event);

    // _c.hideCursor();
  }

  void _ask(var p) {
    Conny.write(_colour, p["question"], newline: false);
    stdout.write(" ");
  }

  bool _storeOnLeft = true;
  void _handleYN(var prompt, var event) {
    Coord crd = _c.coord;

    Conny.erase();

    _ask(prompt);

    if (event == _Codes.RIGHT) {
      _storeOnLeft = false;
    }

    if (event == _Codes.LEFT) {
      _storeOnLeft = true;
    }

    if (_storeOnLeft) {
      Conny.write(prompt["highlight"], prompt["yes"]["text"], newline: false);
      stdout.write(" / ");
      Conny.write(_colour, prompt["no"]["text"], newline: false);

      if (prompt["yes"]["tipText"] != null) {
        stdout.write(" ");
        Conny.write(
          prompt["yes"]["tipHighlight"] ?? _colour,
          prompt["yes"]["tipText"],
          newline: false
        );
      }
    } else {
      Conny.write(_colour, prompt["yes"]["text"], newline: false);
      stdout.write(" / ");
      Conny.write(prompt["highlight"], prompt["no"]["text"], newline: false);

      if (prompt["no"]["tipText"] != null) {
        stdout.write(" ");
        Conny.write(
          prompt["no"]["tipHighlight"] ?? _colour,
          prompt["no"]["tipText"],
          newline: false
        );
      }
    }

    if (event == _Codes.ENTER) {
      if (_storeOnLeft) prompt["yes"]["function"]();
      if (!_storeOnLeft) prompt["no"]["function"]();
    }

    _c.moveToColumn(crd.col);
  }

  void _handleM() {}

  List<String> _storeInput = [];
  void _handleI(var prompt, var event) {
    Coord crd = _c.coord;

    Conny.erase();

    _ask(prompt);

    if (event != 'dead') {
      _storeInput.add(event);
    }
    print(_storeInput.join());
  }

  int _cnt = 0;
  void execute() {
    _init();

    switch(_prompts[_cnt]['type']) {
        case 'yesno' : {
          _handleYN(_prompts[_cnt], '');
        }
        break;

        case 'input' : {
          _handleI(_prompts[_cnt], 'dead');
        }
        break;

        default: {
          _c.moveToColumn(0);
        }
      }

    _subcount++;
    _listner = _sub.listen((event) {

      if (event.length == 1 && event[0] == 27) {
        _subcount--;
        _listner.cancel();
      }

      if (event[0] == 10 && _cnt != _len - 1) {
        _cnt++;
        stdout.writeln();
      }

      var decoded = ascii.decode(event);
      var stripped = decoded.replaceAll('\x1b', '');

      switch(_prompts[_cnt]['type']) {
        case 'yesno' : {
          _handleYN(_prompts[_cnt], stripped);
        }
        break;

        case 'input' : {
          _handleI(_prompts[_cnt], stripped);
        }
        break;

        default: {
          _c.moveToColumn(0);
        }
      }


    });
  }
}

class _Codes {
  static const String UP = '[A';
  static const String DOWN = '[B';
  static const String RIGHT = '[C';
  static const String LEFT = '[D';

  static const String ENTER = '\n';
}
