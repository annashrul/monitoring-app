import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' show Client, Response;
import 'package:monitoring_apps/model/auth.dart';
import 'package:monitoring_apps/model/monitoring.dart';
import 'package:monitoring_apps/utils/user_repository.dart';

class MonitoringProvider {
  Client client = Client();
  final userRepository = UserRepository();
  Future<Monitoring> getDashboard() async {
    final url = "http://192.168.100.10:3000";
    // final url = await userRepository.isServerAddress();
    final response = await client.get("$url/site/monitoring");
    if (response.statusCode == 200) {
      return monitoringFromJson(response.body);
    } else {
      throw Exception('Failed to load product');
    }
  }

  Future<Auth> login(String username, String password) async {
    final url = await userRepository.isServerAddress();
    return await client.post("$url/api/login_monitoring", body: {
      'username': '$username',
      'password': '$password',
    }).then((Response response) {
      var results = Auth.fromJson(json.decode(response.body));
      return results;
    });
  }
}
