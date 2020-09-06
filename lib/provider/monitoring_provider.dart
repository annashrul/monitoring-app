import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' show Client, Response;
import 'package:monitoring_apps/model/auth.dart';
import 'package:monitoring_apps/model/monitoring.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MonitoringProvider {
  Client client = Client();
  Future<Monitoring> getDashboard() async {
    // final prefs = await SharedPreferences.getInstance();
    // final url = prefs.getString("serverAddress");
    // return await client.get("http://192.168.100.74:3000/site/monitoring").then((Response response) {
    //   return monitoringFromJson(response.body);
    // });

    final response =await client.get("http://ptnetindo.com:6692/site/monitoring");
      print(response.body);
    if (response.statusCode == 200) {
      return monitoringFromJson(response.body);
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load product');
    }
  }

  Future<Auth> login(String username, String password) async{
    final prefs = await SharedPreferences.getInstance();
    final url = prefs.getString("serverAddress");
    return await client.post("$url/login_monitoring",
      body: {
      'username': '$username',
      'password': '$password',
    }).then((Response response) {
      var results = Auth.fromJson(json.decode(response.body));
      return results;
    });
  }



}
