class NumUtil {
  static bool isInteger(num value) => value is int || value == value.roundToDouble();
}
