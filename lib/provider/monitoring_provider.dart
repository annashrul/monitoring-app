import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' show Client, Response;
import 'package:monitoring_apps/model/auth.dart';
import 'package:monitoring_apps/model/laporan.dart';
import 'package:monitoring_apps/model/monitoring.dart';

class MonitoringProvider {
  String url ="http://demo-ecommerce.ptnetindo.com/api/";
  Client client = Client();
  // Future<List<Laporan>> getLaporan() async {
  //   return await client.get(url+"laporan_monitoring").then((Response response) {
  //     Laporan results = Laporan.fromJson(json.decode(response.body));
  //     return results;
  //   });
  // }
  Future<List<Laporan>> getLaporan(int limit) async {
    final response =await client.get(url+"laporan_monitoring?limit=$limit");
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return laporanFromJson(response.body);
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load product');
    }
  }


  Future<Monitoring> getDashboard() async {
    return await client.get(url+"monitoring").then((Response response) {
      var results = Monitoring.fromJson(json.decode(response.body));
      print(results);
      return results;
    });
  }

  Future<Auth> login(String username, String password) async{
    return await client.post(url+"login_monitoring",
      body: {
      'username': '$username',
      'password': '$password',
    }).then((Response response) {
      var results = Auth.fromJson(json.decode(response.body));
      return results;
    });
  }



}
