// To parse this JSON data, do
//
//     final laporanStockUtamaModel = laporanStockUtamaModelFromJson(jsonString);

import 'dart:convert';

LaporanStockUtamaModel laporanStockUtamaModelFromJson(String str) => LaporanStockUtamaModel.fromJson(json.decode(str));

String laporanStockUtamaModelToJson(LaporanStockUtamaModel data) => json.encode(data.toJson());

class LaporanStockUtamaModel {
  LaporanStockUtamaModel({
    this.result,
    this.msg,
    this.status,
  });

  Result result;
  String msg;
  String status;

  factory LaporanStockUtamaModel.fromJson(Map<String, dynamic> json) => LaporanStockUtamaModel(
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
    this.totalStock,
  });

  var total;
  var perPage;
  var offset;
  var to;
  var lastPage;
  var currentPage;
  var from;
  List<Datum> data;
  TotalStock totalStock;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    total: json["total"],
    perPage: json["per_page"],
    offset: json["offset"],
    to: json["to"],
    lastPage: json["last_page"],
    currentPage: json["current_page"],
    from: json["from"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    totalStock: TotalStock.fromJson(json["total_stock"]),
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
    "total_stock": totalStock.toJson(),
  };
}

class Datum {
  Datum({
    this.totalrecords,
    this.kdBrg,
    this.barcode,
    this.satuan,
    this.artikel,
    this.nmBrg,
    this.inputBarang,
    this.inputSupplier,
    this.supplier,
    this.subDept,
    this.namaKel,
    this.deliveryNote,
    this.stockAwal,
    this.stockMasuk,
    this.stockKeluar,
    this.stockPenjualan,
  });

  String totalrecords;
  String kdBrg;
  String barcode;
  String satuan;
  String artikel;
  String nmBrg;
  DateTime inputBarang;
  dynamic inputSupplier;
  String supplier;
  String subDept;
  String namaKel;
  int deliveryNote;
  String stockAwal;
  String stockMasuk;
  String stockKeluar;
  String stockPenjualan;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    totalrecords: json["totalrecords"],
    kdBrg: json["kd_brg"],
    barcode: json["barcode"],
    satuan: json["satuan"],
    artikel: json["artikel"],
    nmBrg: json["nm_brg"],
    inputBarang: DateTime.parse(json["input_barang"]),
    inputSupplier: json["input_supplier"],
    supplier: json["supplier"],
    subDept: json["sub_dept"],
    namaKel: json["nama_kel"],
    deliveryNote: json["delivery_note"],
    stockAwal: json["stock_awal"],
    stockMasuk: json["stock_masuk"],
    stockKeluar: json["stock_keluar"],
    stockPenjualan: json["stock_penjualan"],
  );

  Map<String, dynamic> toJson() => {
    "totalrecords": totalrecords,
    "kd_brg": kdBrg,
    "barcode": barcode,
    "satuan": satuan,
    "artikel": artikel,
    "nm_brg": nmBrg,
    "input_barang": inputBarang.toIso8601String(),
    "input_supplier": inputSupplier,
    "supplier": supplier,
    "sub_dept": subDept,
    "nama_kel": namaKel,
    "delivery_note": deliveryNote,
    "stock_awal": stockAwal,
    "stock_masuk": stockMasuk,
    "stock_keluar": stockKeluar,
    "stock_penjualan": stockPenjualan,
  };
}

class TotalStock {
  TotalStock({
    this.totalDn,
    this.totalStockAwal,
    this.totalStockMasuk,
    this.totalStockKeluar,
    this.totalStockAkhir,
  });

  int totalDn;
  int totalStockAwal;
  int totalStockMasuk;
  int totalStockKeluar;
  int totalStockAkhir;

  factory TotalStock.fromJson(Map<String, dynamic> json) => TotalStock(
    totalDn: json["total_dn"],
    totalStockAwal: json["total_stock_awal"],
    totalStockMasuk: json["total_stock_masuk"],
    totalStockKeluar: json["total_stock_keluar"],
    totalStockAkhir: json["total_stock_akhir"],
  );

  Map<String, dynamic> toJson() => {
    "total_dn": totalDn,
    "total_stock_awal": totalStockAwal,
    "total_stock_masuk": totalStockMasuk,
    "total_stock_keluar": totalStockKeluar,
    "total_stock_akhir": totalStockAkhir,
  };
}
