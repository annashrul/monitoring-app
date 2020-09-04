// To parse this JSON data, do
//
//     final laporan = laporanFromJson(jsonString);

import 'dart:convert';

LaporanPenjualan laporanFromJson(String str) => LaporanPenjualan.fromJson(json.decode(str));

String laporanToJson(LaporanPenjualan data) => json.encode(data.toJson());

class LaporanPenjualan {
    LaporanPenjualan({
        this.result,
        this.msg,
        this.status,
    });

    Result result;
    String msg;
    String status;

    factory LaporanPenjualan.fromJson(Map<String, dynamic> json) => LaporanPenjualan(
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
        this.totalrecords,
        this.hrgBeli,
        this.hrgJual,
        this.kdTrx,
        this.tgl,
        this.nama,
        this.omset,
        this.diskonItem,
        this.profit,
        this.kdKasir,
        this.disRp,
        this.disPersen,
        this.st,
        this.tax,
        this.rounding,
        this.voucher,
        this.nmVoucher,
        this.gt,
        this.bayar,
        this.change,
        this.kartu,
        this.jmlKartu,
        this.jnsKartu,
        this.sisa,
        this.tempo,
        this.jam,
        this.status,
        this.hr,
        this.kassa,
        this.regmember,
        this.charge,
        this.noKartu,
        this.pemilikKartu,
        this.kasLain,
        this.ketKasLain,
        this.lokasi,
        this.kdSales,
        this.noPo,
        this.lamaTempo,
        this.jenisTrx,
        this.kodeLokasi,
    });

    String totalrecords;
    String hrgBeli;
    String hrgJual;
    String kdTrx;
    DateTime tgl;
    var nama;
    String omset;
    String diskonItem;
    String profit;
    String kdKasir;
    String disRp;
    String disPersen;
    String st;
    String tax;
    String rounding;
    var voucher;
    var nmVoucher;
    String gt;
    String bayar;
    String change;
    String kartu;
    String jmlKartu;
    var jnsKartu;
    var sisa;
    DateTime tempo;
    DateTime jam;
    var status;
    var hr;
    var kassa;
    var regmember;
    String charge;
    String noKartu;
    String pemilikKartu;
    var kasLain;
    String ketKasLain;
    var lokasi;
    String kdSales;
    var noPo;
    var lamaTempo;
    String jenisTrx;
    var kodeLokasi;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        totalrecords: json["totalrecords"],
        hrgBeli: json["hrg_beli"],
        hrgJual: json["hrg_jual"],
        kdTrx: json["kd_trx"],
        tgl: DateTime.parse(json["tgl"]),
        nama: json["nama"],
        omset: json["omset"],
        diskonItem: json["diskon_item"],
        profit: json["profit"],
        kdKasir: json["kd_kasir"],
        disRp: json["dis_rp"],
        disPersen: json["dis_persen"],
        st: json["st"],
        tax: json["tax"],
        rounding: json["rounding"],
        voucher: json["voucher"],
        nmVoucher: json["nm_voucher"],
        gt: json["gt"],
        bayar: json["bayar"],
        change: json["change"],
        kartu: json["kartu"],
        jmlKartu: json["jml_kartu"],
        jnsKartu: json["jns_kartu"],
        sisa: json["sisa"],
        tempo: DateTime.parse(json["tempo"]),
        jam: DateTime.parse(json["jam"]),
        status: json["status"],
        hr: json["hr"],
        kassa: json["kassa"],
        regmember: json["regmember"],
        charge: json["charge"],
        noKartu: json["no_kartu"],
        pemilikKartu: json["pemilik_kartu"],
        kasLain: json["kas_lain"],
        ketKasLain: json["ket_kas_lain"],
        lokasi:json["lokasi"],
        kdSales: json["kd_sales"],
        noPo: json["no_po"],
        lamaTempo: json["lama_tempo"],
        jenisTrx: json["jenis_trx"],
        kodeLokasi: json["kode_lokasi"],
    );

    Map<String, dynamic> toJson() => {
        "totalrecords": totalrecords,
        "hrg_beli": hrgBeli,
        "hrg_jual": hrgJual,
        "kd_trx": kdTrx,
        "tgl": tgl.toIso8601String(),
        "nama": nama,
        "omset": omset,
        "diskon_item": diskonItem,
        "profit": profit,
        "kd_kasir": kdKasir,
        "dis_rp": disRp,
        "dis_persen": disPersen,
        "st": st,
        "tax": tax,
        "rounding": rounding,
        "voucher": voucher,
        "nm_voucher": nmVoucher,
        "gt": gt,
        "bayar": bayar,
        "change": change,
        "kartu": kartu,
        "jml_kartu": jmlKartu,
        "jns_kartu": jnsKartu,
        "sisa": sisa,
        "tempo": tempo.toIso8601String(),
        "jam": jam.toIso8601String(),
        "status": status,
        "hr": hr,
        "kassa": kassa,
        "regmember": regmember,
        "charge": charge,
        "no_kartu": noKartu,
        "pemilik_kartu": pemilikKartu,
        "kas_lain": kasLain,
        "ket_kas_lain": ketKasLain,
        "lokasi": lokasi,
        "kd_sales": kdSales,
        "no_po": noPo,
        "lama_tempo": lamaTempo,
        "jenis_trx": jenisTrx,
        "kode_lokasi": kodeLokasi,
    };
}