class Person {
  int? id;
  String? name;
  int? age;

  Person({
    this.id,
    this.name,
    this.age,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'nome': name,
      'idade': age,
    };
  }

  @override
  String toString() {
    return 'Person { nome: $name, idade: $age}';
  }
}
