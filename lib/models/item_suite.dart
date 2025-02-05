class ItemSuite {
  final String nome;

  ItemSuite({required this.nome});

  factory ItemSuite.fromJson(Map<String, dynamic> json) {
    return ItemSuite(
      nome: json["nome"] ?? "Item desconhecido",
    );
  }
}
