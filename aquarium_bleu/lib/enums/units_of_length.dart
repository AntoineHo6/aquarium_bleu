enum UnitsOfLength {
  cm,
  inches,
}

extension UnitsOfLengthStr on UnitsOfLength {
  String get unitStr {
    switch (this) {
      case UnitsOfLength.cm:
        return "cm";
      case UnitsOfLength.inches:
        return "inches";
    }
  }
}
