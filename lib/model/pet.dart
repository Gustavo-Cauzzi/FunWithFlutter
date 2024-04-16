class Pet {
  int? id;
  String? name;
  String? type;

  Pet({
    this.id,
    this.name,
    this.type,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'nome': name,
      'tipo': type,
    };
  }

  @override
  String toString() {
    return 'Pet { nome: $name, tipo: $type}';
  }
}
