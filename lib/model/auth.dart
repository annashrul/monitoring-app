// To parse this JSON data, do
//
//     final auth = authFromJson(jsonString);

import 'dart:convert';

Auth authFromJson(String str) => Auth.fromJson(json.decode(str));

String authToJson(Auth data) => json.encode(data.toJson());

class Auth {
    Auth({
        this.maxKode,
        this.maxKasMasuk,
        this.maxKasKeluar,
        this.selectLokasi,
        this.data,
        this.status,
        this.pesan,
    });

    bool maxKode;
    bool maxKasMasuk;
    bool maxKasKeluar;
    bool selectLokasi;
    Data data;
    bool status;
    String pesan;

    factory Auth.fromJson(Map<String, dynamic> json) => Auth(
        maxKode: json["max_kode"],
        maxKasMasuk: json["max_kas_masuk"],
        maxKasKeluar: json["max_kas_keluar"],
        selectLokasi: json["select_lokasi"],
        data: Data.fromJson(json["data"]),
        status: json["status"],
        pesan: json["pesan"],
    );

    Map<String, dynamic> toJson() => {
        "max_kode": maxKode,
        "max_kas_masuk": maxKasMasuk,
        "max_kas_keluar": maxKasKeluar,
        "select_lokasi": selectLokasi,
        "data": data.toJson(),
        "status": status,
        "pesan": pesan,
    };
}

class Data {
    Data({
        this.userId,
        this.token,
        this.lokasi,
        this.username,
        this.status,
        this.lvl,
        this.access,
        this.userLvl,
        this.passwordOtorisasi,
        this.nama,
        this.alamat,
        this.email,
        this.nohp,
        this.tglLahir,
        this.foto,
        this.createdAt,
        this.setoran,
        this.harga,
    });

    String userId;
    String token;
    List<Lokasi> lokasi;
    String username;
    String status;
    String lvl;
    List<Access> access;
    int userLvl;
    String passwordOtorisasi;
    String nama;
    String alamat;
    String email;
    String nohp;
    DateTime tglLahir;
    String foto;
    DateTime createdAt;
    String setoran;
    Harga harga;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["user_id"],
        token: json["token"],
        lokasi: List<Lokasi>.from(json["lokasi"].map((x) => Lokasi.fromJson(x))),
        username: json["username"],
        status: json["status"],
        lvl: json["lvl"],
        access: List<Access>.from(json["access"].map((x) => Access.fromJson(x))),
        userLvl: json["user_lvl"],
        passwordOtorisasi: json["password_otorisasi"],
        nama: json["nama"],
        alamat: json["alamat"],
        email: json["email"],
        nohp: json["nohp"],
        tglLahir: DateTime.parse(json["tgl_lahir"]),
        foto: json["foto"],
        createdAt: DateTime.parse(json["created_at"]),
        setoran: json["setoran"],
        harga: Harga.fromJson(json["harga"]),
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "token": token,
        "lokasi": List<dynamic>.from(lokasi.map((x) => x.toJson())),
        "username": username,
        "status": status,
        "lvl": lvl,
        "access": List<dynamic>.from(access.map((x) => x.toJson())),
        "user_lvl": userLvl,
        "password_otorisasi": passwordOtorisasi,
        "nama": nama,
        "alamat": alamat,
        "email": email,
        "nohp": nohp,
        "tgl_lahir": tglLahir.toIso8601String(),
        "foto": foto,
        "created_at": createdAt.toIso8601String(),
        "setoran": setoran,
        "harga": harga.toJson(),
    };
}

class Access {
    Access({
        this.id,
        this.label,
        this.name,
    });

    int id;
    String label;
    String name;

    factory Access.fromJson(Map<String, dynamic> json) => Access(
        id: json["id"],
        label: json["label"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "label": label,
        "name": name,
    };
}

class Harga {
    Harga({
        this.harga1,
        this.harga2,
        this.harga3,
        this.harga4,
    });

    String harga1;
    String harga2;
    String harga3;
    String harga4;

    factory Harga.fromJson(Map<String, dynamic> json) => Harga(
        harga1: json["harga1"],
        harga2: json["harga2"],
        harga3: json["harga3"],
        harga4: json["harga4"],
    );

    Map<String, dynamic> toJson() => {
        "harga1": harga1,
        "harga2": harga2,
        "harga3": harga3,
        "harga4": harga4,
    };
}

class Lokasi {
    Lokasi({
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

    factory Lokasi.fromJson(Map<String, dynamic> json) => Lokasi(
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
