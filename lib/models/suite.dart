import 'item_suite.dart';
import 'categoria_item.dart';
import 'periodo.dart';

class Suite {
  final String nome;
  final int quantidade;
  final bool exibirQtdDisponiveis;
  final List<String> fotos;
  final List<ItemSuite> itens;
  final List<CategoriaItem> categorias;
  final List<Periodo> periodos;

  Suite({
    required this.nome,
    required this.quantidade,
    required this.exibirQtdDisponiveis,
    required this.fotos,
    required this.itens,
    required this.categorias,
    required this.periodos,
  });

  factory Suite.fromJson(Map<String, dynamic> json) {
    return Suite(
      nome: json["nome"] ?? "Nome não disponível",
      quantidade: json["qtd"] ?? 0,
      exibirQtdDisponiveis: json["exibirQtdDisponiveis"] ?? false,
      fotos: (json["fotos"] as List<dynamic>?)
          ?.map((f) => f.toString())
          .toList() ??
          [],
      itens: (json["itens"] as List<dynamic>?)
          ?.map((i) => ItemSuite.fromJson(i))
          .toList() ??
          [],
      categorias: (json["categoriaItens"] as List<dynamic>?)
          ?.map((c) => CategoriaItem.fromJson(c))
          .toList() ??
          [],
      periodos: (json["periodos"] as List<dynamic>?)
          ?.map((p) => Periodo.fromJson(p))
          .toList() ??
          [],
    );
  }
}
