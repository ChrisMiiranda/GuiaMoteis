import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guia_moteis/services/api_services.dart';

final apiServiceProvider = Provider((ref) => ApiService());
final motelsProvider = FutureProvider((ref) async {
  return ref.watch(apiServiceProvider).fetchMotels();
});
