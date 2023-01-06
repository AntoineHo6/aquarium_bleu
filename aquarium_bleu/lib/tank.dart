class Tank {
  final String name;

  Tank({required this.name});

  static Tank fromJson(Map<String, dynamic> json) => Tank(name: json['name']);
}
