class ContextData {
  int age;

  ContextData({required this.age});

  Map<String, dynamic> toJson() => {'age': age};
}
