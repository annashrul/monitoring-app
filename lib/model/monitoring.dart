// To parse this JSON data, do
//
//     final monitoring = monitoringFromJson(jsonString);

import 'dart:convert';

Monitoring monitoringFromJson(String str) => Monitoring.fromJson(json.decode(str));

String monitoringToJson(Monitoring data) => json.encode(data.toJson());

class Monitoring {
    String omset;
    String orders;
    String avg;
    String member;
    String charts;

    Monitoring({
        this.omset,
        this.orders,
        this.avg,
        this.member,
        this.charts,
    });

    factory Monitoring.fromJson(Map<String, dynamic> json) => Monitoring(
        omset: json["omset"],
        orders: json["orders"],
        avg: json["avg"],
        member: json["member"],
        charts: json["charts"],
    );

    Map<String, dynamic> toJson() => {
        "omset": omset,
        "orders": orders,
        "avg": avg,
        "member": member,
        "charts": charts,
    };
}
