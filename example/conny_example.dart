import 'package:conny/conny.dart';
import 'dart:io';

void main() {
  Conny.setGraphic(bold: true, strike: true);
  Conny.setColourRGB({'r':0,'g':0,'b':60, 'l':50}, {'r':0,'g':0,'b':0});
  stdout.writeln("hello mom");
  Conny.reset();
}
