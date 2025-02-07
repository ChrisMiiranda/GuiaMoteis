import 'package:flutter/material.dart';
import 'package:guia_moteis/models/categoria_item.dart';
import 'package:guia_moteis/models/item_suite.dart';
import 'package:guia_moteis/models/suite.dart';
import 'package:intl/intl.dart';
import '../models/motel.dart';

class MotelCard extends StatelessWidget {
  final Motel motel;

  const MotelCard({super.key, required this.motel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMotelInfo(),
        _buildSuitesCarousel(context),
      ],
    );
  }

  Widget _buildMotelInfo() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipOval(
                child: Image.network(
                  motel.imagem,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      motel.nome,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${motel.distancia} - ${motel.bairro}",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 18),
                  Text("${motel.mediaAvaliacao} (${motel.qtdAvaliacoes})")
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildSuitesCarousel(BuildContext context) {
    if (motel.suites.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(10),
        child: Text("Nenhuma suíte disponível"),
      );
    }

    return SizedBox(
      height: 600,
      child: PageView.builder(
        itemCount: motel.suites.length,
        itemBuilder: (context, index) {
          final suite = motel.suites[index];
          return Column(
            children: [
              _buildSuiteCard(suite),
              _buildCategoriaItems(context, suite),
              _buildPeriodos(suite),
            ],
          );
        },
        controller: PageController(viewportFraction: .95),
      ),
    );
  }

  Widget _buildSuiteCard(Suite suite) {
    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              child: Image.network(
                suite.fotos.first,
                fit: BoxFit.cover,
                height: 180,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  suite.nome,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriaItems(BuildContext context, Suite suite) {
    final categorias = suite.categorias;
    return Card(
      color: Colors.white,
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ...categorias.take(4).map((categoria) => _buildIconItem(categoria)),
            GestureDetector(
              onTap: () => _showBottomSheet(context, categorias, suite.itens, suite.nome),
              child: const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text("Ver todos", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildIconItem(CategoriaItem categoria) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          Image.network(categoria.icone, width: 50, height: 50),
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context, List<CategoriaItem> categorias, List<ItemSuite> itens, String suiteNome) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  suiteNome,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text("Principais Itens", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const Divider(),
                ...categorias.map((categoria) => ListTile(
                  leading: Image.network(categoria.icone, width: 30, height: 30),
                  title: Text(categoria.nome),
                )),
                const SizedBox(height: 10),
                const Text("Tem Também", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    itens.map((item) => item.nome).join(", "),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPeriodos(Suite suite) {
    return Column(
      children: suite.periodos.map((periodo) {
        return Card(
          color: Colors.white,
          elevation: 3,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ListTile(
            title: Text(periodo.tempoFormatado),
            subtitle: Text(
              NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(periodo.valor),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          ),
        );
      }).toList(),
    );
  }
}
