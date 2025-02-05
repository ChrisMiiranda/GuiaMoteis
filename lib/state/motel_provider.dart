import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guia_moteis/services/api_services.dart';
import '../models/motel.dart';

final apiServiceProvider = Provider((ref) => ApiService());

final motelsProvider = FutureProvider<List<Motel>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.fetchMotels();
});
