enum UnitOfLength {
  cm,
  inches,
}

extension UnitOfLengthStr on UnitOfLength {
  String get unitStr {
    switch (this) {
      case UnitOfLength.cm:
        return "cm";
      case UnitOfLength.inches:
        return "inches";
    }
  }
}
