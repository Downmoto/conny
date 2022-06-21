class NoTerminalException implements Exception {
  final String _cause = "STDOUT has no terminal";

  @override
  String toString() {
    return _cause;
  }
}

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