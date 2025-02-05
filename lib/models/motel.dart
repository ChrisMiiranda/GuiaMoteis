import 'suite.dart';

class Motel {
  final String nome;
  final String imagem;
  final String bairro;
  final double distancia;
  final int qtdFavoritos;
  final List<Suite> suites;
  final int qtdAvaliacoes;
  final double mediaAvaliacao;

  Motel({
    required this.nome,
    required this.imagem,
    required this.bairro,
    required this.distancia,
    required this.qtdFavoritos,
    required this.suites,
    required this.qtdAvaliacoes,
    required this.mediaAvaliacao,
  });

  factory Motel.fromJson(Map<String, dynamic> json) {
    return Motel(
      nome: json["fantasia"] ?? "Nome não disponível",
      imagem: json["logo"] ?? "https://via.placeholder.com/150",
      bairro: json["bairro"] ?? "Bairro desconhecido",
      distancia: (json["distancia"] ?? 0).toDouble(),
      qtdFavoritos: json["qtdFavoritos"] ?? 0,
      suites: (json["suites"] as List<dynamic>?)
          ?.map((s) => Suite.fromJson(s))
          .toList() ??
          [],
      qtdAvaliacoes: json["qtdAvaliacoes"] ?? 0,
      mediaAvaliacao: (json["media"] ?? 0).toDouble(),
    );
  }

  double? get menorPreco {
    final precos = suites
        .expand((suite) => suite.periodos.map((p) => p.valor))
        .toList();

    return precos.isNotEmpty ? precos.reduce((a, b) => a < b ? a : b) : null;
  }
}
