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
  int _toggleValue = 0;

  @override
  void initState() {
    super.initState();
    motels = apiService.fetchMotels();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {},
        ),
        centerTitle: true, // Centraliza o toggle
        title: CustomToggleButton(
          onToggle: (value) {
            setState(() {
              _toggleValue = value;
            });
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white,),
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
                  return Center(child: Text('Erro: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Nenhum motel encontrado.'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return MotelCard(motel: snapshot.data![index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Chip(
                label: Row(
                  children: [
                    Icon(Icons.tune, size: 15,),
                    SizedBox(width: 10,),
                    Text("Filtros"),
                  ],
                ),
                backgroundColor: Colors.white,
              ),
            ),
            _buildFilterChip("Café da Manhã"),
            _buildFilterChip("Decoração / Experiências"),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Chip(
        label: Text(label),
        backgroundColor: Colors.white,
      ),
    );
  }
}
