enum RepeatEndType {
  never,
  on,
  after,
}

extension RepeatEndTypeStr on RepeatEndType {
  String get getStr {
    switch (this) {
      case RepeatEndType.never:
        return "never";
      case RepeatEndType.on:
        return "on";
      case RepeatEndType.after:
        return "after";
    }
  }
}
