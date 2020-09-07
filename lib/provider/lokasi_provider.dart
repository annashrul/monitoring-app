import 'dart:async';
import 'package:http/http.dart' show Client, Response;
import 'package:monitoring_apps/model/lokasi.dart';
import 'package:monitoring_apps/utils/user_repository.dart';

class LokasiProvider {
  Client client = Client();
  final userRepository = UserRepository();
  Map<String, String> get headers => {
    "Content-Type": "application/json",
    "username": "netindo",
    "password": "\$2b\$08\$hLMU6rEvNILCMaQbthARK.iCmDRO7jNbUB8CcvyRStqsHD4UQxjDO",
    "Authorization": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIxIiwiaWF0IjoxNTk3MTM0NzM3LCJleHAiOjE1OTk3MjY3Mzd9.Dy6OCNL9BhUgUTPcQMlEXTbw5Dyv3UnG_Kyvs3WHicE",
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
