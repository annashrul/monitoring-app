import 'dart:async';
import 'package:http/http.dart' show Client, Response;
import 'package:monitoring_apps/config/config.dart';
import 'package:monitoring_apps/model/laporanPenjualan.dart';
import 'package:monitoring_apps/model/laporanPenjualanDetail.dart';
import 'package:monitoring_apps/utils/user_repository.dart';
class PenjualanProvider {
  Client client = Client();
  final userRepository = UserRepository();
  Map<String, String> get headers => {
    "Content-Type": "application/json",
    "username": Config().username,
    "password": Config().username,
    "Authorization": Config().token,
  };

  Future<LaporanPenjualan> getLaporan(var limit, String datefrom, String dateto) async {
    final url = await userRepository.isServerAddress();
    final response =await client.get("$url/report/arsip_penjualan?page=1&datefrom=$datefrom&dateto=$dateto&limit=$limit", headers: headers);
    if (response.statusCode == 200) {
      return laporanFromJson(response.body);
    } else {
      throw Exception('Failed to load product');
    }
  }

  Future<LaporanPenjualanDetail> getLaporanDetail(var kdtrx) async {
    final url = await userRepository.isServerAddress();
    final response =await client.get("$url/report/arsip_penjualan/$kdtrx", headers: headers);
    if (response.statusCode == 200) {
      return laporanPenjualanDetailFromJson(response.body);
    } else {
      throw Exception('Failed to load product');
    }
  }

}
