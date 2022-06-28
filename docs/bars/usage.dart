import 'package:conny/conny.dart';
import 'dart:io';

void main(List<String> args) {
  Bar bar = Bar("loading bar", 30);
  bar.showName = true;

  int state = 0;
  for (String s in bar.start()) {
    stdout.write(s);
    bar.updateState(state += 10);
  }
}