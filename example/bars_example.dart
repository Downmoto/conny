import 'package:conny/conny.dart';
import 'dart:io';
import 'dart:math';

void main(List<String> args) {
  int state = 0;

  for (int i = 0; i < 5; i++) {
    Bar bar = Bar("BAR [${i + 1}]: ", 50);
    bar.showPercent = true;
    bar.showName = true;
    Random rnd = Random();

    int r = rnd.nextInt(256);
    int g = rnd.nextInt(256);
    int b = rnd.nextInt(256);

    for (String s in bar.start()) {
      if (i == 2) {
        bar.light = 0x2500;
        bar.dark = 0x2501;
      }
      Conny.write(WriteOptions(fg: [r, g, b]), s, newline: false);

      sleep(Duration(milliseconds: 100));
      bar.updateState(state += 10);
    }

    state = 0;
    stdout.writeln();
  }
}
