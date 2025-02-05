class Periodo {
  final String tempoFormatado;
  final String tempo;
  final double valor;
  final double valorTotal;
  final bool temCortesia;
  final double? desconto;

  Periodo({
    required this.tempoFormatado,
    required this.tempo,
    required this.valor,
    required this.valorTotal,
    required this.temCortesia,
    this.desconto,
  });

  factory Periodo.fromJson(Map<String, dynamic> json) {
    return Periodo(
      tempoFormatado: json["tempoFormatado"] ?? "Tempo desconhecido",
      tempo: json["tempo"] ?? "0",
      valor: (json["valor"] ?? 0).toDouble(),
      valorTotal: (json["valorTotal"] ?? 0).toDouble(),
      temCortesia: json["temCortesia"] ?? false,
      desconto: json["desconto"]?["desconto"] != null
          ? (json["desconto"]["desconto"] as num).toDouble()
          : null,
    );
  }
}
