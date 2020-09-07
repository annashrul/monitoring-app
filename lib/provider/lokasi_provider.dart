import 'dart:async';
import 'package:http/http.dart' show Client, Response;
import 'package:monitoring_apps/config/config.dart';
import 'package:monitoring_apps/model/lokasi.dart';
import 'package:monitoring_apps/utils/user_repository.dart';

class LokasiProvider {
  Client client = Client();
  final userRepository = UserRepository();
  Map<String, String> get headers => {
    "Content-Type": "application/json",
    "username": Config().username,
    "password": Config().username,
    "Authorization": Config().token,
  };
  Future<Lokasi> getLokasi() async {
    final url = await userRepository.isServerAddress();
    final response =await client.get("$url/lokasi?page=1&ispos=true");
    if (response.statusCode == 200) {
      return lokasiFromJson(response.body);
    } else {
      throw Exception('Failed to load product');
    }
  }

}
