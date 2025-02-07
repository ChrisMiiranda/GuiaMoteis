import 'package:flutter/material.dart';
import 'package:guia_moteis/services/api_services.dart';
import 'package:guia_moteis/view/motel_card.dart';
import 'package:guia_moteis/widgets/toogle_widget.dart';
import '../models/motel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  late Future<List<Motel>> motels;
  List<Motel> allMotels = [];
  List<String> selectedFilters = [];
  List<String> allFilters = [];

  @override
  void initState() {
    super.initState();
    _loadMotels();
  }

  void _loadMotels() {
    motels = apiService.fetchMotels().then((data) {
      final Set<String> filterSet = {};
      for (var motel in data) {
        for (var suite in motel.suites) {
          for (var categoria in suite.categorias) {
            filterSet.add(categoria.nome.toLowerCase());
          }
        }
      }
      setState(() {
        allMotels = data;
        allFilters = filterSet.toList();
      });
      return data;
    });
  }

  void _applyFilters() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red,
        toolbarHeight: 80,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {},
        ),
        centerTitle: true,
        title: Column(
          children: [
            CustomToggleButton(onToggle: (value) {}),
            const SizedBox(height: 5),
            _buildLocationButton(),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: FutureBuilder<List<Motel>>(
              future: motels,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro: \${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Nenhum motel encontrado.'));
                }

                final filteredMotels = allMotels.where((motel) {
                  if (selectedFilters.isEmpty) return true;
                  return motel.suites.any((suite) =>
                      suite.categorias.any((categoria) => selectedFilters.contains(categoria.nome.toLowerCase())));
                }).toList();

                return ListView.builder(
                  itemCount: filteredMotels.length,
                  itemBuilder: (context, index) {
                    return MotelCard(motel: filteredMotels[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationButton() {
    return GestureDetector(
      onTap: () {
        // Adicione aqui a ação ao clicar no botão
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.location_on, color: Colors.white, size: 14),
            const SizedBox(width: 3),
            const Text(
              "minha localização",
              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.white, size: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      child: Row(
        children: [
          ElevatedButton(
            onPressed: () {
              _showFilterModal();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: const BorderSide(color: Colors.grey),
              ),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            child: Row(
              children: const [
                Icon(Icons.tune, color: Colors.black),
                SizedBox(width: 5),
                Text("filtros", style: TextStyle(color: Colors.black)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Selecione os filtros", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Wrap(
                    spacing: 8.0,
                    children: allFilters.map((filter) {
                      final isSelected = selectedFilters.contains(filter);
                      return FilterChip(
                        label: Text(filter),
                        selected: isSelected,
                        onSelected: (selected) {
                          setModalState(() {
                            if (selected) {
                              selectedFilters.add(filter);
                            } else {
                              selectedFilters.remove(filter);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _applyFilters();
                    },
                    child: const Text("Aplicar Filtros"),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
