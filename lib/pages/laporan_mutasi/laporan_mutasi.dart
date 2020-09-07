import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monitoring_apps/config/config.dart';
import 'package:monitoring_apps/model/laporanMutasiModel.dart';
import 'package:monitoring_apps/model/lokasi.dart';
import 'package:monitoring_apps/pages/helper/loadMoreQ.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:monitoring_apps/pages/laporan_mutasi/laporan_mutasi_detail.dart';
import 'package:monitoring_apps/provider/lokasi_provider.dart';
import 'package:monitoring_apps/utils/user_repository.dart';
import 'package:monitoring_apps/pages/helper/helper_widget.dart';

class LaporanMutasi extends StatefulWidget {
  @override
  _LaporanMutasiState createState() => _LaporanMutasiState();
}

class _LaporanMutasiState extends State<LaporanMutasi> {
  int perpage = 10;
  LaporanMutasiModel laporanMutasiModel;
  bool isLoading = false, isRetry = false, isConnected = false;
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();
  final userRepository = UserRepository();

  Map<String, String> get headers => {
        "Content-Type": "application/json",
        "username": Config().username,
        "password": Config().username,
        "Authorization": Config().token,
      };
  String _format = 'yyyy-MM-dd';
  TextEditingController _tgl_pertama = TextEditingController();
  TextEditingController _tgl_kedua = TextEditingController();
  DateTime _dateTime;
  String datefrom = '2020-01-01';
  String dateto = '2020-09-04';
  String _valType = 'Pilih Lokasi'; //Ini untuk menyimpan value data friend
  List _type = [
    {"kode": "Pilih Lokasi", "nama": "Pilih Lokasi"}
  ];
  Future getData() async {
    await LokasiProvider().getLokasi().then((value) {
      if (value.result.data.length > 0) {
        for (var x = 0; x < value.result.data.length; x++) {
          _type.add({
            "kode": value.result.data[x].kode,
            "nama": value.result.data[x].nama,
          });
        }
        _valType = _type[1].kode;
      }
    });
  }

  Future<void> loadData() async {
    final server = await userRepository.isServerAddress();
    String url = "$server/mutasi/report?page=1&perpage=$perpage";
    var date = new DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    var formattedDate = "${dateParse.year}-${dateParse.month.toString().padLeft(2, '0')}-${dateParse.day.toString().padLeft(2, '0')}";
    String dateto=formattedDate,datefrom=formattedDate,lokasi='';
    if (_valType != 'Pilih Lokasi') {
      url += '&lokasi=$_valType';
    }
    if (_tgl_pertama.text == 'yyyy-MM-dd') {
      _tgl_pertama.text = formattedDate;
      url += '&datefrom=${_tgl_pertama.text}';
    }else{
      url += '&datefrom=${_tgl_pertama.text}';
    }
    if (_tgl_kedua.text == 'yyyy-MM-dd') {
      _tgl_kedua.text = formattedDate;
      url += '&dateto=${_tgl_kedua.text}';
    }else{
      url += '&dateto=${_tgl_kedua.text}';
    }
    print("URL LAPORAN STOCK $url");
    try {
      setState(() {
        isLoading = true;
        isConnected = false;
      });
      final jsonString =
          await http.get(url, headers: headers).timeout(Duration(seconds: 20));

      if (jsonString.statusCode == 200) {
        final jsonResponse = json.decode(jsonString.body);
        laporanMutasiModel = new LaporanMutasiModel.fromJson(jsonResponse);
        setState(() {
          isLoading = false;
          isRetry = false;
        });
      } else {
        throw Exception('Failed to load photos');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        isConnected = false;
        isRetry = true;
      });
    }
  }

  Future<bool> _loadMore() async {
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    setState(() {
      perpage = perpage += 10;
    });
    loadData();
    return true;
  }

  DateTimePickerLocale _locale = DateTimePickerLocale.id;
  List<DateTimePickerLocale> _locales = DateTimePickerLocale.values;

  /// Display date picker.
  void _showDatePicker(var param) {
    DatePicker.showDatePicker(
      context,
      onMonthChangeStartWithFirstDate: true,
      pickerTheme: DateTimePickerTheme(
        showTitle: true,
        confirm: Text('Selesai', style: TextStyle(color: Colors.red,fontFamily: 'Rubik',fontWeight:FontWeight.bold)),
      ),
      minDateTime: DateTime.parse(MIN_DATETIME),
      maxDateTime: DateTime.parse(MAX_DATETIME),
      initialDateTime: _dateTime,
      dateFormat: _format,
      locale: _locale,
      onClose: () => print("----- onClose -----"),
      onCancel: () => print('onCancel'),
      onChange: (dateTime, List<int> index) {
        setState(() {
          _dateTime = dateTime;
        });
      },
      onConfirm: (dateTime, List<int> index) {
        print("INDEX $index");
        setState(() {
          _dateTime = dateTime;
          if (param == '1') {
            _tgl_pertama.text =
                '${_dateTime.year}-${_dateTime.month.toString().padLeft(2, '0')}-${_dateTime.day.toString().padLeft(2, '0')}';
          } else {
            _tgl_kedua.text =
                '${_dateTime.year}-${_dateTime.month.toString().padLeft(2, '0')}-${_dateTime.day.toString().padLeft(2, '0')}';
          }
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    loadData();
    getData();
    _tgl_pertama.text = _format;
    _tgl_kedua.text = _format;
    _dateTime = DateTime.parse(INIT_DATETIME);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          color: Colors.black,
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Text('Laporan Mutasi', style: TextStyle(fontFamily:'Rubik',color: Colors.black, fontWeight: FontWeight.w700)),
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              new Flexible(
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0, top: 10.0),
                  child: GestureDetector(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextField(
                          readOnly: true,
                          controller: _tgl_pertama,
                          keyboardType: TextInputType.url,
                          decoration: InputDecoration(
                            labelText: 'Tanggal Pertama',
                            hintText: 'yyyy-MM-dd',
                            hintStyle: TextStyle(
                                color: Colors.black26,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Rubik'),
                          ),
                          onTap: () {
                            _showDatePicker('1');
                          },
                          onChanged: (value) {
                            setState(() {
                              _tgl_pertama.text =
                                  '${_dateTime.year}-${_dateTime.month.toString().padLeft(2, '0')}-${_dateTime.day.toString().padLeft(2, '0')}';
                            });
                            print(
                                'TANGGAL PERTAMA = ${_dateTime.year}-${_dateTime.month.toString().padLeft(2, '0')}-${_dateTime.day.toString().padLeft(2, '0')}');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              new Flexible(
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0, top: 10.0),
                  child: GestureDetector(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextField(
                          readOnly: true,
                          controller: _tgl_kedua,
                          keyboardType: TextInputType.url,
                          decoration: InputDecoration(
                            labelText: 'Tanggal Kedua',
                            hintText: 'yyyy-MM-dd',
                            hintStyle: TextStyle(
                                color: Colors.black26,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Rubik'),
                          ),
                          onTap: () {
                            _showDatePicker('2');
                          },
                          onChanged: (value) {},
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              new Flexible(
                child: Padding(
                  padding: EdgeInsets.only(right: 8.0, left: 8.0, top: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Lokasi',
                          style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.black26,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Rubik')),
                      SizedBox(height: 5.0),
                      DropdownButton(
                        isDense: true,
                        isExpanded: true,
                        hint: Text(
                          "Pilih",
                          style: TextStyle(fontFamily: 'Rubik'),
                        ),
                        value: _valType,
                        items: _type.map((value) {
                          print(value['kode']);
                          return DropdownMenuItem(
                            child: Text(value['nama'],
                                style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.bold)),
                            value: value['kode'],
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _valType = value;
                          });

                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                loadData();
              },
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.grey.shade200,
                            offset: Offset(2, 4),
                            blurRadius: 5,
                            spreadRadius: 2)
                      ],
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Color(0xfffbb448), Color(0xfff7892b)])),
                  child: HelperWidget().myTextStyle(
                      context,
                      "CARI",
                      TextAlign.center,
                      20.0,
                      FontWeight.bold,
                      Colors.white)),
            ),
          ),
          Expanded(
              child: RefreshIndicator(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: isRetry == true
                  ? Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              "Mohon Maaf, Server Kami Sedang Dalam Perbaikan",
                              style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Center(
                            child: Text(
                              "Silahkan Coba Beberapa Saat Lagi",
                              style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    )
                  : isLoading
                      ? Container(
                          child: Center(
                            child: CircularProgressIndicator(
                                strokeWidth: 5.0,
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.black)),
                          ),
                        )
                      // : _buildItem(context),
                      : _buildItem(context),
            ),
            onRefresh: loadData,
            key: _refresh,
          )),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context) {
    return LoadMoreQ(
      child: ListView.builder(
        itemCount: laporanMutasiModel.result.data.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              child: Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox.fromSize(
                      size: Size.fromHeight(150.0),
                      child: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          /// Item description inside a material
                          Container(
                            margin: EdgeInsets.only(top: 24.0),
                            child: Material(
                              elevation: 14.0,
                              borderRadius: BorderRadius.circular(0.0),
                              shadowColor: Colors.transparent,
                              color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.all(24.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    /// Title and rating
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                            '${laporanMutasiModel.result.data[index].noFakturMutasi}',
                                            style: TextStyle(
                                                fontFamily: 'Rubik',
                                                color: Colors.blueAccent)),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            // Container(
                                            //   margin: const EdgeInsets.only(
                                            //       top: 2.0),
                                            //   child: Text(
                                            //       '${laporanMutasiModel.result.data[index].}',
                                            //       style: TextStyle(
                                            //           fontFamily: 'Rubik',
                                            //           color: Colors.black,
                                            //           fontWeight:
                                            //               FontWeight.bold,
                                            //           fontSize: 16.0)),
                                            // ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 0.0),
                                              child: Text(
                                                  'Asal: ${laporanMutasiModel.result.data[index].lokasiAsal}',
                                                  style: TextStyle(
                                                      fontFamily: 'Rubik',
                                                      color: Colors.black38,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14.0)),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 0.0),
                                              child: Text(
                                                  'Tujuan: ${laporanMutasiModel.result.data[index].lokasiTujuan}',
                                                  style: TextStyle(
                                                      fontFamily: 'Rubik',
                                                      color: Colors.black38,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14.0)),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 0.0),
                                              child: Text(
                                                  'Keterangan: ${laporanMutasiModel.result.data[index].keterangan}',
                                                  style: TextStyle(
                                                      fontFamily: 'Rubik',
                                                      color: Colors.black38,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14.0)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Text('Status: ', style: TextStyle()),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 4.0),
                                            child: int.parse(laporanMutasiModel
                                                        .result
                                                        .data[index]
                                                        .status) ==
                                                    1
                                                ? Material(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    color: Colors.green,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(4.0),
                                                      child: Text('Diterima',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                    ),
                                                  )
                                                : Material(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    color: Colors.red,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(4.0),
                                                      child: Text(
                                                          'Belum diterima',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                    ),
                                                  ),
                                          ),
                                        ])
                                  ],
                                ),
                              ),
                            ),
                          ),

                          /// Item image
                          Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: EdgeInsets.only(right: 16.0),
                              child: SizedBox.fromSize(
                                size: Size.fromRadius(40.0),
                                child: Material(
                                  elevation: 20.0,
                                  shadowColor: Colors.transparent,
                                  shape: CircleBorder(),
                                  child: Image.asset('res/shoes1.png'),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              ),
              onTap: () {
                Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (_) => LaporanMutasiDetail(
                        '${laporanMutasiModel.result.data[index].noFakturMutasi}')));
              });
        },
      ),
      whenEmptyLoad: true,
      delegate: DefaultLoadMoreDelegate(),
      textBuilder: DefaultLoadMoreTextBuilder.english,
      isFinish: laporanMutasiModel.result.data.length < perpage,
      onLoadMore: _loadMore,
    );
  }
}

const String MIN_DATETIME = '2010-05-12';
const String MAX_DATETIME = '2021-11-25';
const String INIT_DATETIME = '2019-05-17';
