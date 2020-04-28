// To parse this JSON data, do
//
//     final laporan = laporanFromJson(jsonString);

import 'dart:convert';

List<Laporan> laporanFromJson(String str) => List<Laporan>.from(json.decode(str).map((x) => Laporan.fromJson(x)));

String laporanToJson(List<Laporan> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Laporan {
    String idOrders;
    DateTime tglOrders;
    String item;
    String total;
    String status;
    String nama;
    String kurir;
    String ongkir;
    dynamic noResi;
    String subTotal;
    String diskon;
    dynamic jumlahVoucher;
    dynamic voucher;

    Laporan({
        this.idOrders,
        this.tglOrders,
        this.item,
        this.total,
        this.status,
        this.nama,
        this.kurir,
        this.ongkir,
        this.noResi,
        this.subTotal,
        this.diskon,
        this.jumlahVoucher,
        this.voucher,
    });

    factory Laporan.fromJson(Map<String, dynamic> json) => Laporan(
        idOrders: json["id_orders"],
        tglOrders: DateTime.parse(json["tgl_orders"]),
        item: json["item"],
        total: json["total"],
        status: json["status"],
        nama: json["nama"],
        kurir: json["kurir"],
        ongkir: json["ongkir"],
        noResi: json["no_resi"],
        subTotal: json["sub_total"],
        diskon: json["diskon"],
        jumlahVoucher: json["jumlah_voucher"],
        voucher: json["voucher"],
    );

    Map<String, dynamic> toJson() => {
        "id_orders": idOrders,
        "tgl_orders": tglOrders.toIso8601String(),
        "item": item,
        "total": total,
        "status": status,
        "nama": nama,
        "kurir": kurir,
        "ongkir": ongkir,
        "no_resi": noResi,
        "sub_total": subTotal,
        "diskon": diskon,
        "jumlah_voucher": jumlahVoucher,
        "voucher": voucher,
    };
}
