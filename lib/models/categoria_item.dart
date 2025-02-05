class CategoriaItem {
  final String nome;
  final String icone;

  CategoriaItem({required this.nome, required this.icone});

  factory CategoriaItem.fromJson(Map<String, dynamic> json) {
    return CategoriaItem(
      nome: json["nome"] ?? "Categoria desconhecida",
      icone: json["icone"] ?? "https://via.placeholder.com/50",
    );
  }
}
