// To parse this JSON data, do
//
//     final lokasi = lokasiFromJson(jsonString);

import 'dart:convert';

Lokasi lokasiFromJson(String str) => Lokasi.fromJson(json.decode(str));

String lokasiToJson(Lokasi data) => json.encode(data.toJson());

class Lokasi {
  Lokasi({
    this.result,
    this.msg,
    this.status,
  });

  Result result;
  String msg;
  String status;

  factory Lokasi.fromJson(Map<String, dynamic> json) => Lokasi(
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
    this.kode,
    this.nama,
    this.custDisp,
    this.alamat,
    this.serial,
    this.headerFooter,
  });

  String kode;
  String nama;
  String custDisp;
  String alamat;
  String serial;
  HeaderFooter headerFooter;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    kode: json["kode"],
    nama: json["nama"],
    custDisp: json["cust_disp"],
    alamat: json["alamat"],
    serial: json["serial"],
    headerFooter: HeaderFooter.fromJson(json["header_footer"]),
  );

  Map<String, dynamic> toJson() => {
    "kode": kode,
    "nama": nama,
    "cust_disp": custDisp,
    "alamat": alamat,
    "serial": serial,
    "header_footer": headerFooter.toJson(),
  };
}

class HeaderFooter {
  HeaderFooter({
    this.header1,
    this.header2,
    this.header3,
    this.header4,
    this.footer1,
    this.footer2,
    this.footer3,
    this.footer4,
  });

  String header1;
  String header2;
  String header3;
  String header4;
  String footer1;
  String footer2;
  String footer3;
  String footer4;

  factory HeaderFooter.fromJson(Map<String, dynamic> json) => HeaderFooter(
    header1: json["header1"],
    header2: json["header2"],
    header3: json["header3"],
    header4: json["header4"],
    footer1: json["footer1"],
    footer2: json["footer2"],
    footer3: json["footer3"],
    footer4: json["footer4"],
  );

  Map<String, dynamic> toJson() => {
    "header1": header1,
    "header2": header2,
    "header3": header3,
    "header4": header4,
    "footer1": footer1,
    "footer2": footer2,
    "footer3": footer3,
    "footer4": footer4,
  };
}
