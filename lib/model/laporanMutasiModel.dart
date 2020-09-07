// To parse this JSON data, do
//
//     final laporanMutasiModel = laporanMutasiModelFromJson(jsonString);

import 'dart:convert';

LaporanMutasiModel laporanMutasiModelFromJson(String str) =>
    LaporanMutasiModel.fromJson(json.decode(str));

String laporanMutasiModelToJson(LaporanMutasiModel data) =>
    json.encode(data.toJson());

class LaporanMutasiModel {
  LaporanMutasiModel({
    this.result,
    this.msg,
    this.status,
  });

  Result result;
  String msg;
  String status;

  factory LaporanMutasiModel.fromJson(Map<String, dynamic> json) =>
      LaporanMutasiModel(
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

  String total;
  int lastPage;
  int perPage;
  String currentPage;
  int from;
  int to;
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
    this.tglMutasi,
    this.noFakturMutasi,
    this.lokasiAsal,
    this.lokasiTujuan,
    this.kdKasir,
    this.status,
    this.noFakturBeli,
    this.keterangan,
  });

  DateTime tglMutasi;
  String noFakturMutasi;
  String lokasiAsal;
  String lokasiTujuan;
  String kdKasir;
  String status;
  String noFakturBeli;
  String keterangan;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        tglMutasi: DateTime.parse(json["tgl_mutasi"]),
        noFakturMutasi: json["no_faktur_mutasi"],
        lokasiAsal: json["lokasi_asal"],
        lokasiTujuan: json["lokasi_tujuan"],
        kdKasir: json["kd_kasir"],
        status: json["status"],
        noFakturBeli: json["no_faktur_beli"],
        keterangan: json["keterangan"],
      );

  Map<String, dynamic> toJson() => {
        "tgl_mutasi": tglMutasi.toIso8601String(),
        "no_faktur_mutasi": noFakturMutasi,
        "lokasi_asal": lokasiAsal,
        "lokasi_tujuan": lokasiTujuan,
        "kd_kasir": kdKasir,
        "status": status,
        "no_faktur_beli": noFakturBeli,
        "keterangan": keterangan,
      };
}
