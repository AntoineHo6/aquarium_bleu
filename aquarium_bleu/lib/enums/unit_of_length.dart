enum UnitOfLength {
  cm,
  inch,
}

extension UnitOfLengthStr on UnitOfLength {
  String get unitStr {
    switch (this) {
      case UnitOfLength.cm:
        return "cm";
      case UnitOfLength.inch:
        return "inch";
    }
  }
}
