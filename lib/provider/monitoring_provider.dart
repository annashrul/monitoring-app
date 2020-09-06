import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' show Client, Response;
import 'package:monitoring_apps/model/auth.dart';
import 'package:monitoring_apps/model/laporanPenjualan.dart';
import 'package:monitoring_apps/model/monitoring.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MonitoringProvider {
  Client client = Client();
  Future<LaporanPenjualan> getLaporan(int limit) async {
    final prefs = await SharedPreferences.getInstance();
    final url = prefs.getString("serverAddress");
    final response =await client.get(url+"/laporan_monitoring?limit=$limit");
    if (response.statusCode == 200) {
      return laporanFromJson(response.body);
    } else {
      throw Exception('Failed to load product');
    }
  }


  Future<Monitoring> getDashboard() async {
    final prefs = await SharedPreferences.getInstance();
    final url = prefs.getString("serverAddress");
    return await client.get(url+"/monitoring").then((Response response) {
      var results = Monitoring.fromJson(json.decode(response.body));
      print(results);
      return results;
    });
  }

  Future<Auth> login(String username, String password) async{
    final prefs = await SharedPreferences.getInstance();
    final url = prefs.getString("serverAddress");
    print("RUNNING SERVER ON http://$url/login_monitoring");
    return await client.post("http://$url/login_monitoring",
      body: {
      'username': '$username',
      'password': '$password',
    }).then((Response response) {
      var results = Auth.fromJson(json.decode(response.body));
      return results;
    });
  }



}
