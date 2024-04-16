class Food {
  int? id;
  String? name;
  double? weight;

  Food({
    this.id,
    this.name,
    this.weight,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'nome': name,
      'peso': weight,
    };
  }

  @override
  String toString() {
    return 'Food { nome: $name, peso: $weight}';
  }
}
