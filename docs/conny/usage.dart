import 'dart:io';
import 'package:conny/conny.dart';

void write() {
  WriteOptions opt = WriteOptions(
    bold: true,
    fg: [180, 240, 55],
    bg: [90, 120, 190]
  );

  String str = "Hello, World!";

  Conny.write(opt, str);
}

void style() {
  WriteOptions opt = WriteOptions(
    bold: true,
    fg: [180, 240, 55],
    bg: [90, 120, 190]
  );

  String str = Conny.style(opt, "Hello, World!");

  stdout.write(str);
}

void reset() {
  Conny.setGraphic(bold: true);
  stdout.write("Hello, World!");
  Conny.reset();
}

void setGraphic() {
  Conny.setGraphic(bold: true);
  stdout.write("Hello, World!");
  Conny.reset(); 
}

void unsetGraphic() {
  Conny.setGraphic(bold: true);
  stdout.write("Hello, World!");
  Conny.unsetGraphic(bold: true); 
}

void setColour() {
  Conny.setColour(Colour.RED);
  stdout.write("Hello, World!");
  Conny.reset();
}

void setColour256() {
  Conny.setColour256(230);
  stdout.write("Hello, World!");
  Conny.reset();
}

void setColourRGB() {
  Conny.setColourRGB([130, 150, 70]);
  stdout.write("Hello, World!");
  Conny.reset();
}

void setBackgroundColour() {
  Conny.setBackgroundColour(Colour.RED);
  stdout.write("Hello, World!");
  Conny.reset();
}

void setBackgroundColour256() {
  Conny.setBackgroundColour256(230);
  stdout.write("Hello, World!");
  Conny.reset();
}

void setBackgroundColourRGB() {
  Conny.setBackgroundColourRGB([130, 150, 70]);
  stdout.write("Hello, World!");
  Conny.reset();
}

void erase() {
  Conny.erase(screen: true);
}