import 'dart:io';
import 'package:conny/conny.dart';

void main(List<String> args) {
  Curse c = Curse();
  Conny.erase(screen: true);

  c.home();
  stdout.write("${c.coord.col} ${c.coord.row} {1}");
  c.moveTo(10, 1);
  stdout.write("${c.coord.col} ${c.coord.row} {2}");
  c.moveCursorDown();
  stdout.write("${c.coord.col} ${c.coord.row} {3}");
  c.moveCursorDown();
  stdout.writeln("${c.coord.col} ${c.coord.row} {4}");

  stdout.writeln("${c.coord.col} ${c.coord.row} {5}");
  c.updateCoords();
  stdout.write("${c.coord.col} ${c.coord.row} {6}");


  c.moveToColumn(stdout.terminalColumns ~/ 2);
  stdout.write("${c.coord.col} ${c.coord.row} {7}");
  c.moveCursorDown(by: 3);
  c.moveCursorLeft(by: 10);

  Conny.write(WriteOptions(bold: true, rf: 40, gf: 190, bf: 10), "{8}");

  print(5 ~/ 2);
}
