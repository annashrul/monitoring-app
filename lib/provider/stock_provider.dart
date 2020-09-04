import 'dart:async';
import 'package:http/http.dart' show Client, Response;
import 'package:monitoring_apps/model/laporan_stock/laporanStockUtamaModel.dart';

class StockProvider {
  String url ="http://192.168.100.10:3000/";
  Client client = Client();
  Map<String, String> get headers => {
    "Content-Type": "application/json",
    "username": "netindo",
    "password": "\$2b\$08\$hLMU6rEvNILCMaQbthARK.iCmDRO7jNbUB8CcvyRStqsHD4UQxjDO",
    "Authorization": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIxIiwiaWF0IjoxNTk3MTM0NzM3LCJleHAiOjE1OTk3MjY3Mzd9.Dy6OCNL9BhUgUTPcQMlEXTbw5Dyv3UnG_Kyvs3WHicE",
  };

  Future<LaporanStockUtamaModel> getLaporanStock(var limit, String datefrom, String dateto) async {
    final response =await client.get(url+"report/stock?page=1?page=1&datefrom=$datefrom&dateto=$dateto&limit=$limit", headers: headers);
    print("############ RESPON STOCK ${response.body}");
    if (response.statusCode == 200) {
      return laporanStockUtamaModelFromJson(response.body);
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load product');
    }
  }

}
