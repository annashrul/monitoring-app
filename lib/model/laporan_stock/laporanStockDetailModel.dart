// To parse this JSON data, do
//
//     final laporanStockDetailModel = laporanStockDetailModelFromJson(jsonString);

import 'dart:convert';

LaporanStockDetailModel laporanStockDetailModelFromJson(String str) => LaporanStockDetailModel.fromJson(json.decode(str));

String laporanStockDetailModelToJson(LaporanStockDetailModel data) => json.encode(data.toJson());

class LaporanStockDetailModel {
  LaporanStockDetailModel({
    this.result,
    this.msg,
    this.status,
  });

  Result result;
  String msg;
  String status;

  factory LaporanStockDetailModel.fromJson(Map<String, dynamic> json) => LaporanStockDetailModel(
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
    this.perPage,
    this.offset,
    this.to,
    this.lastPage,
    this.currentPage,
    this.from,
    this.data,
  });

  int total;
  int perPage;
  int offset;
  int to;
  int lastPage;
  int currentPage;
  int from;
  List<Datum> data;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    total: json["total"],
    perPage: json["per_page"],
    offset: json["offset"],
    to: json["to"],
    lastPage: json["last_page"],
    currentPage: json["current_page"],
    from: json["from"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "per_page": perPage,
    "offset": offset,
    "to": to,
    "last_page": lastPage,
    "current_page": currentPage,
    "from": from,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.totalrecords,
    this.kdTrx,
    this.tgl,
    this.keterangan,
    this.qty,
    this.stockIn,
    this.stockOut,
  });

  String totalrecords;
  String kdTrx;
  DateTime tgl;
  String keterangan;
  int qty;
  String stockIn;
  String stockOut;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    totalrecords: json["totalrecords"],
    kdTrx: json["kd_trx"],
    tgl: DateTime.parse(json["tgl"]),
    keterangan: json["keterangan"],
    qty: json["qty"],
    stockIn: json["stock_in"],
    stockOut: json["stock_out"],
  );

  Map<String, dynamic> toJson() => {
    "totalrecords": totalrecords,
    "kd_trx": kdTrx,
    "tgl": tgl.toIso8601String(),
    "keterangan": keterangan,
    "qty": qty,
    "stock_in": stockIn,
    "stock_out": stockOut,
  };
}
