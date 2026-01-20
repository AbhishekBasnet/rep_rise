extension Precision on double {
  /// Rounds the double to [places] decimal places and returns a double.
  /// Example: 12.3456.toPrecision(2) -> 12.35
  double toPrecision(int places) {
    return double.parse(this.toStringAsFixed(places));
  }
}