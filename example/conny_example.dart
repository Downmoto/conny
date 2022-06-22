import 'package:conny/conny.dart';
import 'dart:io';
import 'dart:math';

WriteOptions opt = WriteOptions(
  bold: true,
  rf: 180,
  gf: 70,
  bf: 110,
  rb: 242,
  gb: 193,
  bb: 80
);

void separator() {
  for (var i = 0; i < stdout.terminalColumns ~/ 3; i++) {
    stdout.write('-');
  }
  stdout.writeln();
}

void init() {
  stdout.write("█▀▀ █▀█ █▄░█ █▄░█ █▄█\n█▄▄ █▄█ █░▀█ █░▀█ ░█░\n");
}

void graphicExample() {
  Conny.write(opt, "Graphic examples");
  stdout.writeln();

  stdout.writeln("Base");

  Conny.setGraphic(bold: true);
  stdout.writeln("Bold");
  Conny.unsetGraphic(bold: true);

  Conny.setGraphic(dim: true);
  stdout.writeln("Dim");
  Conny.unsetGraphic(dim: true);

  Conny.setGraphic(italic: true);
  stdout.writeln("Italic");
  Conny.unsetGraphic(italic: true);

  Conny.setGraphic(underline: true);
  stdout.writeln("Underline");
  Conny.unsetGraphic(underline: true);

  Conny.setGraphic(strike: true);
  stdout.writeln("Strike");
  Conny.unsetGraphic(strike: true);
}

void mixedGraphicExample() {
  Conny.write(opt, "mixed graphics");
  stdout.writeln();

  stdout.writeln("Base");

  Conny.setGraphic(bold: true, italic: true);
  stdout.writeln("Bold, Italic");
  Conny.unsetGraphic(bold: true, italic: true);

  Conny.setGraphic(dim: true, underline: true);
  stdout.writeln("Dim, Underline");
  Conny.unsetGraphic(dim: true, underline: true);
}

void colourExample() {
  Conny.write(opt, "Colours");
  stdout.writeln();

  Random rnd = Random();

  for (var i = 0; i < 4; i++) {
    Conny.write(
      WriteOptions(
        bold: (i % 2 == 0),
        strike: (i % 2 == 0),
        rf: rnd.nextInt(256), 
        gf: rnd.nextInt(256), 
        bf: rnd.nextInt(256)),
      "Colours");
  }

  for (var i = 0; i < 4; i++) {
    Conny.write(
      WriteOptions(
        bold: (i % 2 == 0),
        strike: (i % 2 != 0),
        rf: rnd.nextInt(256),
        gf: rnd.nextInt(256),
        bf: rnd.nextInt(256),
        rb: rnd.nextInt(256),
        gb: rnd.nextInt(256),
        bb: rnd.nextInt(256)),
      "Colours");
  }
}

void main() {
  init();
  separator();

  graphicExample();
  separator();
  mixedGraphicExample();
  separator();
  Conny.write(opt, "End of Graphics Example");
  separator();

  colourExample();
  separator();
  Conny.write(opt, "End of Colours Example");
  separator();
}
