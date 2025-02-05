import 'dart:convert';
import 'dart:io';
import '../models/motel.dart';

class ApiService {
  Future<List<Motel>> fetchMotels() async {
    HttpClient client = HttpClient();
    client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;

    try {
      final request = await client.getUrl(Uri.parse("https://jsonkeeper.com/b/1IXK"));
      final response = await request.close();

      // ✅ Verifica se o status da resposta é 200 antes de continuar
      if (response.statusCode != 200) {
        throw HttpException('Erro na requisição: Status ${response.statusCode}');
      }

      final jsonString = await response.transform(utf8.decoder).join();
      final decodedJson = json.decode(jsonString);

      // ✅ Verifica se a estrutura do JSON contém os dados esperados
      if (decodedJson is Map<String, dynamic> && decodedJson.containsKey("data")) {
        final data = decodedJson["data"];
        if (data is Map<String, dynamic> && data.containsKey("moteis")) {
          final List<dynamic> moteisList = data["moteis"];
          return moteisList.map((json) => Motel.fromJson(json)).toList();
        }
      }

      throw Exception('Erro ao processar JSON: estrutura inesperada');
    } on SocketException {
      throw Exception('Erro de conexão: Verifique sua internet');
    } on HttpException catch (e) {
      throw Exception('Erro HTTP: ${e.message}');
    } on FormatException {
      throw Exception('Erro ao decodificar JSON: Formato inválido');
    } finally {
      client.close();
    }
  }
}
