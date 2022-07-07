import 'dart:async';
import 'dart:convert';

import 'package:conny/src/helper/exceptions.dart';
import 'package:conny/src/curse.dart';
import 'package:conny/src/conny.dart';
import 'dart:io';

class Prompt {
  late Map<String, dynamic> _p;
  late final int _promptCount;

  final Curse _c = Curse();
  dynamic _listner;


  List<String> inputs = [];

  Prompt(Map<String, dynamic> prompMap) {
    _p = prompMap;
    _promptCount = (_p['prompts'] as List).length;
  }

  void a() {
    stdin.echoMode = false;
    stdin.lineMode = false;

    var sub = stdin.map((event) {
      var it = ascii.decode(event);
      var c = it.replaceAll('\x1b', '');

      return c;
    });

    _listner = sub.listen((event) {
      print(event);

      if (event[0] == '\n') {
        _listner.cancel();
        
        print("end of fnc");
      }
    });
  }

  void _handleYN() {

  }

  void _handleM() {

  }

  void _handleI() {

  }

  void execute() {
    for (int i = 0; i < _promptCount; i++) {
      var p = _p["prompts"][i]["type"];

      switch(p) {
        case "yesno": { _handleYN(); }
        break;

        case "multiple": { _handleM(); }
        break;

        case "input": { _handleI(); }
        break;

        default: {
          throw "insert error here";
        }
      }
    }
    stdin.echoMode = true;
    stdin.lineMode = true;
  }
}

class _Codes {
  static const String UP = '[A';
  static const String DOWN = '[B';
  static const String RIGHT = '[C';
  static const String LEFT = '[D';
}