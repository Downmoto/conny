import 'package:conny/conny.dart';
import 'dart:io';
import 'dart:math';

WriteOptions opt = WriteOptions(
  bold: true,
  defaultBackground: false,
  fg: [180, 70, 110],
  bg: [242, 193, 0]
);

void separator() {
  for (var i = 0; i < stdout.terminalColumns ~/ 3; i++) {
    stdout.write('-');
  }
  stdout.writeln();
}

void init() {
  Conny.erase(screen: true);
  
  Curse c = Curse();
  c.home();

  Conny.setColour(Colour.MAGENTA);
  stdout.write("█▀▀ █▀█ █▄░█ █▄░█ █▄█\n█▄▄ █▄█ █░▀█ █░▀█ ░█░\n");
  Conny.setColour(Colour.DEFAULT);
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
  Conny.write(opt, "mixed graphic examples");
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
  Conny.write(opt, "Colour examples");
  stdout.writeln();

  Random rnd = Random();

  for (var i = 0; i < 4; i++) {
    Conny.write(
      WriteOptions(
        bold: (i % 2 == 0),
        fg: [rnd.nextInt(256), rnd.nextInt(256), rnd.nextInt(256)]
        ), "Colours", newline: false);
      
    stdout.write(' ');

    Conny.write(
      WriteOptions(
        bold: !(i % 2 ==0),
        fg: [rnd.nextInt(256), rnd.nextInt(256), rnd.nextInt(256)]
      ), "Colours");
  }

  for (var i = 0; i < 4; i++) {
    Conny.write(
      WriteOptions(
        bold: (i % 2 == 0),
        defaultBackground: false,
        fg: [rnd.nextInt(256), rnd.nextInt(256), rnd.nextInt(256)],
        bg: [rnd.nextInt(256), rnd.nextInt(256), rnd.nextInt(256)]
        ), "Colours", newline: false);

    stdout.write(' ');

    Conny.write(
      WriteOptions(
        bold: !(i % 2 == 0),
        defaultBackground: false,
        fg: [rnd.nextInt(256), rnd.nextInt(256), rnd.nextInt(256)],
        bg: [rnd.nextInt(256), rnd.nextInt(256), rnd.nextInt(256)]
        ), "Colours");
  }
}

void main() {
  init();
  separator();

  graphicExample();
  separator();
  mixedGraphicExample();
  separator();
  Conny.write(opt, "End of Graphic examples");
  separator();

  colourExample();
  separator();
  Conny.write(opt, "End of Colour examples");
  separator();
}
