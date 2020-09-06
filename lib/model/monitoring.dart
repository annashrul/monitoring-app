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
    List<Monthly> monthly;
    String penjualan;
    String transaksi;
    String netSales;
    String avg;

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        hourly: json["hourly"],
        monthly: List<Monthly>.from(json["monthly"].map((x) => Monthly.fromJson(x))),
        penjualan: json["penjualan"],
        transaksi: json["transaksi"],
        netSales: json["net_sales"],
        avg: json["avg"],
    );

    Map<String, dynamic> toJson() => {
        "hourly": hourly,
        "monthly": List<dynamic>.from(monthly.map((x) => x.toJson())),
        "penjualan": penjualan,
        "transaksi": transaksi,
        "net_sales": netSales,
        "avg": avg,
    };
}

class Monthly {
    Monthly({
        this.name,
        this.data,
    });

    String name;
    List<int> data;

    factory Monthly.fromJson(Map<String, dynamic> json) => Monthly(
        name: json["name"],
        data: List<int>.from(json["data"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "data": List<dynamic>.from(data.map((x) => x)),
    };
}
