// To parse this JSON data, do
//
//     final laporanPenjualanDetail = laporanPenjualanDetailFromJson(jsonString);

import 'dart:convert';

LaporanPenjualanDetail laporanPenjualanDetailFromJson(String str) => LaporanPenjualanDetail.fromJson(json.decode(str));

String laporanPenjualanDetailToJson(LaporanPenjualanDetail data) => json.encode(data.toJson());

class LaporanPenjualanDetail {
    LaporanPenjualanDetail({
        this.result,
        this.msg,
        this.status,
    });

    Result result;
    String msg;
    String status;

    factory LaporanPenjualanDetail.fromJson(Map<String, dynamic> json) => LaporanPenjualanDetail(
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
        this.tgl,
        this.resultOperator,
        this.kdTrx,
        this.lokasi,
        this.detail,
    });

    DateTime tgl;
    String resultOperator;
    String kdTrx;
    String lokasi;
    List<Detail> detail;

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        tgl: DateTime.parse(json["tgl"]),
        resultOperator: json["operator"],
        kdTrx: json["kd_trx"],
        lokasi: json["lokasi"],
        detail: List<Detail>.from(json["detail"].map((x) => Detail.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "tgl": tgl.toIso8601String(),
        "operator": resultOperator,
        "kd_trx": kdTrx,
        "lokasi": lokasi,
        "detail": List<dynamic>.from(detail.map((x) => x.toJson())),
    };
}

class Detail {
    Detail({
        this.kdTrx,
        this.sku,
        this.qty,
        this.hrgJual,
        this.hrgBeli,
        this.disPersen,
        this.subtotal,
        this.kategori,
        this.ketDiskon,
        this.openPrice,
        this.service,
        this.tax,
        this.id,
        this.nmBrg,
        this.satuan,
    });

    String kdTrx;
    String sku;
    String qty;
    String hrgJual;
    String hrgBeli;
    String disPersen;
    String subtotal;
    String kategori;
    dynamic ketDiskon;
    String openPrice;
    String service;
    String tax;
    String id;
    String nmBrg;
    String satuan;

    factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        kdTrx: json["kd_trx"],
        sku: json["sku"],
        qty: json["qty"],
        hrgJual: json["hrg_jual"],
        hrgBeli: json["hrg_beli"],
        disPersen: json["dis_persen"],
        subtotal: json["subtotal"],
        kategori: json["kategori"],
        ketDiskon: json["ket_diskon"],
        openPrice: json["open_price"],
        service: json["service"],
        tax: json["tax"],
        id: json["id"],
        nmBrg: json["nm_brg"],
        satuan: json["satuan"],
    );

    Map<String, dynamic> toJson() => {
        "kd_trx": kdTrx,
        "sku": sku,
        "qty": qty,
        "hrg_jual": hrgJual,
        "hrg_beli": hrgBeli,
        "dis_persen": disPersen,
        "subtotal": subtotal,
        "kategori": kategori,
        "ket_diskon": ketDiskon,
        "open_price": openPrice,
        "service": service,
        "tax": tax,
        "id": id,
        "nm_brg": nmBrg,
        "satuan": satuan,
    };
}
