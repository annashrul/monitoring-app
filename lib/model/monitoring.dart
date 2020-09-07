// To parse this JSON data, do
//
//     final monitoring = monitoringFromJson(jsonString);

import 'dart:convert';

Monitoring monitoringFromJson(String str) => Monitoring.fromJson(json.decode(str));

String monitoringToJson(Monitoring data) => json.encode(data.toJson());

class Monitoring {
    Monitoring({
        this.result,
        this.msg,
        this.status,
    });

    Result result;
    String msg;
    String status;

    factory Monitoring.fromJson(Map<String, dynamic> json) => Monitoring(
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
        this.hourly,
        this.monthly,
        this.penjualan,
        this.transaksi,
        this.netSales,
        this.avg,
    });

    String hourly;
    Monthly monthly;
    String penjualan;
    String transaksi;
    String netSales;
    String avg;

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        hourly: json["hourly"],
        monthly: Monthly.fromJson(json["monthly"]),
        penjualan: json["penjualan"],
        transaksi: json["transaksi"],
        netSales: json["net_sales"],
        avg: json["avg"],
    );

    Map<String, dynamic> toJson() => {
        "hourly": hourly,
        "monthly": monthly.toJson(),
        "penjualan": penjualan,
        "transaksi": transaksi,
        "net_sales": netSales,
        "avg": avg,
    };
}

class Monthly {
    Monthly({
        this.labelLokasi,
        this.bulanIni,
        this.bulanLalu,
    });

    List<String> labelLokasi;
    List<int> bulanIni;
    List<int> bulanLalu;

    factory Monthly.fromJson(Map<String, dynamic> json) => Monthly(
        labelLokasi: List<String>.from(json["label_lokasi"].map((x) => x)),
        bulanIni: List<int>.from(json["bulan_ini"].map((x) => x)),
        bulanLalu: List<int>.from(json["bulan_lalu"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "label_lokasi": List<dynamic>.from(labelLokasi.map((x) => x)),
        "bulan_ini": List<dynamic>.from(bulanIni.map((x) => x)),
        "bulan_lalu": List<dynamic>.from(bulanLalu.map((x) => x)),
    };
}
