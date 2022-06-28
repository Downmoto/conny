import 'package:conny/conny.dart';
import 'dart:io';
import 'dart:math';

void main(List<String> args) {
  init();
  graphic();
  colour();
}

void init() {
  Conny.erase(screen: true);
  
  Curse c = Curse();
  c.home();

  Conny.write(title, "█▀▀ █▀█ █▄░█ █▄░█ █▄█\n█▄▄ █▄█ █░▀█ █░▀█ ░█░");
  separator();
}

void graphic() {
  Conny.write(subtitles, "Graphics\n");

  String bold = Conny.style(WriteOptions(bold: true), "Bold");
  String dim = Conny.style(WriteOptions(dim: true), "Dim");
  String italic = Conny.style(WriteOptions(italic: true), "Italic");
  String underline = Conny.style(WriteOptions(underline: true), "Underline");
  String strike = Conny.style(WriteOptions(strike: true), "Strikethrough");

  String mixed = Conny.style(WriteOptions(
    bold: true,
    italic: true,
    strike: true
  ), "Mixed graphics");

  stdout.writeln("$bold $dim $italic");
  stdout.writeln("$underline $strike");
  stdout.writeln(mixed);

  Conny.write(subtitles, "\nColour Graphics\n");

  Random rnd = Random();

  for (var i = 0; i < 3; i++) {
    int r = rnd.nextInt(255);
    int g = rnd.nextInt(255);
    int b = rnd.nextInt(255);

    int rb = rnd.nextInt(255);
    int gb = rnd.nextInt(255);
    int bb = rnd.nextInt(255);

    Conny.write(WriteOptions(
      bold: true,
      italic: true,
      fg: [r, g, b],
      bg: [rb, gb, bb]
    ), "Colour graphics");
  }

  separator();
}

void colour() {
  Conny.write(subtitles, "Colours\n");

  Random rnd = Random();
  for (var i = 0; i < 10; i++) {
    int r = rnd.nextInt(255);
    int g = rnd.nextInt(255);
    int b = rnd.nextInt(255);

    for (var j = 0; j < 10; j++) {
      Conny.write(WriteOptions(
        bg: [r, g, b]), 
        " ", 
        newline: false);
    }

    for (var j = 0; j < 10; j++) {
      Conny.write(WriteOptions(
        bg: [b, r, g]), 
        " ", 
        newline: false);
    }

    for (var j = 0; j < 10; j++) {
      Conny.write(WriteOptions(
        bg: [g, b, r]), 
        " ", 
        newline: false);
    }
    stdout.writeln();
  }
  stdout.writeln();
}

void separator() {
  for (var i = 0; i < 30; i++) {
    stdout.write('-');
  }
  stdout.writeln();
}

WriteOptions title = WriteOptions(
  fg: [120, 170, 220],
  bg: [30, 60, 255]
);

WriteOptions subtitles = WriteOptions(
  bold: true,
  fg: [90, 200, 230]
);