/// this is thrown to indicate [stdout] is not attached to a terminal
class NoTerminalException implements Exception {
  final String _cause = "STDOUT has no terminal";

  @override
  String toString() {
    return _cause;
  }
}

/// this is thrown to indicate a value is out of range of [_rangeMin] and [_rangeMax]
class OutOfRangeException implements Exception {
  late final String _cause;
  late final int _rangeMin;
  late final int _rangeMax;

  OutOfRangeException(this._cause, this._rangeMin, this._rangeMax);

  @override
  String toString() {
    return "$_cause; Stay in range of $_rangeMin : $_rangeMax";
  }
}

/// this is thrown to indicate cursor has moved beyond the max columns
class CursorOutOfRangeException implements Exception {
  late final int _max;

  CursorOutOfRangeException(this._max);

  @override
  String toString() {
    return "Curser moved beyond $_max coloumns";
  }
}