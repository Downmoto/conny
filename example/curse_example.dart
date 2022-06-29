import 'dart:io';
import 'package:conny/conny.dart';

void main(List<String> args) {
  Curse c = Curse();
  Conny.erase(screen: true);
  c.home();

  int col = stdout.terminalColumns;
  // int row = stdout.terminalLines;

  int sqr = (col % 2 == 0 ? 26 : 25);

  String h = "Hello World!";


  String top = "";

  for (var i = 0; i < sqr; i++) {
    top += "-";
  }

  String side = "|";

  // x, y
  Coord c1 = Coord((col ~/ 2) - (top.length ~/ 2), 0);
  Coord c2 = Coord((col ~/ 2) + (top.length ~/ 2), 0);

  c.moveToCoord(c1);
  Conny.write(WriteOptions(fg: [255, 82, 82]), top);

  for (var i = 2; i < sqr ~/ 2; i++) {
    c.moveTo(c1.col, c1.row + i);
    Conny.write(WriteOptions(fg: [255, 82, 82]), side);
    c.moveTo(c2.col - 1, c2.row + i);
    Conny.write(WriteOptions(fg: [130, 160, 200]), side);
  }


  c.moveTo(c1.col, c1.row + (sqr~/2));
  Conny.write(WriteOptions(fg: [130, 160, 200]), top);
  c.updateCoords();

  Coord end = c.coord;
  int n = end.col;
  int m = end.row;

  c.moveToCoord(Coord((col ~/ 2) - (h.length ~/ 2), (sqr~/2) ~/ 2));
  stdout.write(h);

  c.moveTo(n,m);
}
