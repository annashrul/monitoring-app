// To parse this JSON data, do
//
//     final laporanMutasiDetailModel = laporanMutasiDetailModelFromJson(jsonString);

import 'dart:convert';

LaporanMutasiDetailModel laporanMutasiDetailModelFromJson(String str) =>
    LaporanMutasiDetailModel.fromJson(json.decode(str));

String laporanMutasiDetailModelToJson(LaporanMutasiDetailModel data) =>
    json.encode(data.toJson());

class LaporanMutasiDetailModel {
  LaporanMutasiDetailModel({
    this.result,
    this.msg,
    this.status,
  });

  Result result;
  String msg;
  String status;

  factory LaporanMutasiDetailModel.fromJson(Map<String, dynamic> json) =>
      LaporanMutasiDetailModel(
        result: Result.fromJson(json["result"]),
        msg: json["msg"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "result": result.toJson(),
        "msg": msg,
        "status": status,
      };
}

class Result {
  Result({
    this.total,
    this.lastPage,
    this.perPage,
    this.currentPage,
    this.from,
    this.to,
    this.data,
  });

  var total;
  var lastPage;
  var perPage;
  var currentPage;
  var from;
  var to;
  List<Datum> data;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        total: json["total"],
        lastPage: json["last_page"],
        perPage: json["per_page"],
        currentPage: json["current_page"],
        from: json["from"],
        to: json["to"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "last_page": lastPage,
        "per_page": perPage,
        "current_page": currentPage,
        "from": from,
        "to": to,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.noFakturMutasi,
    this.kdBrg,
    this.qty,
    this.hrgBeli,
    this.hrgJual,
    this.barcode,
    this.satuan,
    this.nmBrg,
    this.gambar,
  });

  String noFakturMutasi;
  String kdBrg;
  String qty;
  String hrgBeli;
  String hrgJual;
  String barcode;
  String satuan;
  String nmBrg;
  String gambar;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        noFakturMutasi: json["no_faktur_mutasi"],
        kdBrg: json["kd_brg"],
        qty: json["qty"],
        hrgBeli: json["hrg_beli"],
        hrgJual: json["hrg_jual"],
        barcode: json["barcode"],
        satuan: json["satuan"],
        nmBrg: json["nm_brg"],
        gambar: json["gambar"],
      );

  Map<String, dynamic> toJson() => {
        "no_faktur_mutasi": noFakturMutasi,
        "kd_brg": kdBrg,
        "qty": qty,
        "hrg_beli": hrgBeli,
        "hrg_jual": hrgJual,
        "barcode": barcode,
        "satuan": satuan,
        "nm_brg": nmBrg,
        "gambar": gambar,
      };
}
