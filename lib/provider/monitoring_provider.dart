import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' show Client, Response;
import 'package:monitoring_apps/model/auth.dart';
import 'package:monitoring_apps/model/monitoring.dart';
import 'package:monitoring_apps/utils/user_repository.dart';

class MonitoringProvider {
  Client client = Client();
  final userRepository = UserRepository();
  Map<String, String> get headers => {
        "Content-Type": "application/json",
        "username": "netindo",
        "password":
            "\$2b\$08\$hLMU6rEvNILCMaQbthARK.iCmDRO7jNbUB8CcvyRStqsHD4UQxjDO",
        // "Authorization": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIxIiwiaWF0IjoxNTk3MTM0NzM3LCJleHAiOjE1OTk3MjY3Mzd9.Dy6OCNL9BhUgUTPcQMlEXTbw5Dyv3UnG_Kyvs3WHicE",
      };
  Future<Monitoring> getDashboard() async {
    final url = await userRepository.isServerAddress();
    final response = await client.get("$url/site/monitoring");
    if (response.statusCode == 200) {
      return monitoringFromJson(response.body);
    } else {
      throw Exception('Failed to load product');
    }
  }

  Future<Auth> login(String username, String password) async {
    final url = await userRepository.isServerAddress();
    print("$url/auth");
    return await client.post("$url/auth", headers: {
      'username': 'netindo',
      'password':
          "\$2b\$08\$hLMU6rEvNILCMaQbthARK.iCmDRO7jNbUB8CcvyRStqsHD4UQxjDO"
    }, body: {
      'username': '$username',
      'password': '$password',
      'kassa': '',
      'lokasi': ''
    }).then((Response response) {
      var results = Auth.fromJson(json.decode(response.body));
      return results;
    });
  }
}
