import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:monitoring_apps/model/laporanPenjualan.dart';
import 'package:monitoring_apps/pages/helper/loadMoreQ.dart';
import 'package:monitoring_apps/pages/laporan_page_detail.dart';
import 'package:monitoring_apps/provider/lokasi_provider.dart';
import 'package:monitoring_apps/provider/penjualan_provider.dart';
import 'package:monitoring_apps/utils/user_repository.dart';
import 'package:http/http.dart' as http;

class LaporanPage extends StatefulWidget
{
  @override
  _LaporanPageState createState() => _LaporanPageState();
}
const String MIN_DATETIME = '2010-05-12';
const String MAX_DATETIME = '2021-11-25';
const String INIT_DATETIME = '2019-05-17';
class _LaporanPageState extends State<LaporanPage>
{

  final GlobalKey<RefreshIndicatorState> _refresh = GlobalKey<RefreshIndicatorState>();
  Map<String, String> get headers => {
    "Content-Type": "application/json",
    "username": "netindo",
    "password": "\$2b\$08\$hLMU6rEvNILCMaQbthARK.iCmDRO7jNbUB8CcvyRStqsHD4UQxjDO",
    "Authorization": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIxIiwiaWF0IjoxNTk3MTM0NzM3LCJleHAiOjE1OTk3MjY3Mzd9.Dy6OCNL9BhUgUTPcQMlEXTbw5Dyv3UnG_Kyvs3WHicE",
  };
  LaporanPenjualan laporanPenjualan;
  bool isLoading=false;
  int perpage=10;
  TextEditingController _tgl_pertama = TextEditingController();
  TextEditingController _tgl_kedua = TextEditingController();
  String _valType = 'Pilih Lokasi';
  List _type = [{"kode": "Pilih Lokasi", "nama": "Pilih Lokasi"}];
  final userRepository = UserRepository();
  Future getData() async {
    await LokasiProvider().getLokasi().then((value) {
      if (value.result.data.length > 0) {
        for (var x = 0; x < value.result.data.length; x++) {
          _type.add({
            "kode": value.result.data[x].kode,
            "nama": value.result.data[x].nama,
          });
        }
        setState(() {
          _valType = _type[1]['kode'];
        });
      }
    });
    loadData();
  }

  Future<void> loadData() async {
    final server = await userRepository.isServerAddress();
    String url = "$server/report/arsip_penjualan?page=1&perpage=$perpage";
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
    print('URL LAPORAN STOCK UTAMA $url');
    try {
      setState(() {
        isLoading = true;
      });
      final jsonString =
      await http.get(url, headers: headers).timeout(Duration(seconds: 20));
      if (jsonString.statusCode == 200) {
        final jsonResponse = json.decode(jsonString.body);
        laporanPenjualan = new LaporanPenjualan.fromJson(jsonResponse);
        setState(() {
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load photos');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }
  DateTimePickerLocale _locale = DateTimePickerLocale.id;
  List<DateTimePickerLocale> _locales = DateTimePickerLocale.values;
  DateTime _dateTime;
  String _format = 'yyyy-MM-dd';

  /// Display date picker.
  void _showDatePicker(var param) {
    DatePicker.showDatePicker(
      context,
      onMonthChangeStartWithFirstDate: true,
      pickerTheme: DateTimePickerTheme(
        showTitle: true,
        confirm: Text('custom Done', style: TextStyle(color: Colors.red)),
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
        setState(() {
          _dateTime = dateTime;
          if (param == '1') {
            _tgl_pertama.text =
            '${_dateTime.year}-${_dateTime.month.toString().padLeft(2, '0')}-${_dateTime.day.toString().padLeft(2, '0')}';
            loadData();
          } else {
            _tgl_kedua.text =
            '${_dateTime.year}-${_dateTime.month.toString().padLeft(2, '0')}-${_dateTime.day.toString().padLeft(2, '0')}';
            loadData();
          }
        });
      },
    );
  }
  Future<bool> _loadMore() async {
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    setState(() {
      perpage = perpage += 10;
    });
    loadData();
    return true;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
    getData();
    _tgl_pertama.text = _format;
    _tgl_kedua.text = _format;
    _dateTime = DateTime.parse(INIT_DATETIME);
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          color: Colors.black,
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Text('Laporan Penjualan', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700)),

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
                            labelText: 'Dari',
                            hintText: 'yyyy-MM-dd',
                            hintStyle: TextStyle(color: Colors.black26, fontWeight: FontWeight.bold, fontFamily: 'Rubik'),
                          ),
                          onTap: () {
                            _showDatePicker('1');
                          },
                          onChanged: (value) {
                            setState(() {
                              _tgl_pertama.text =
                              '${_dateTime.year}-${_dateTime.month.toString().padLeft(2, '0')}-${_dateTime.day.toString().padLeft(2, '0')}';
                            });
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
                            labelText: 'Sampai',
                            hintText: 'yyyy-MM-dd',
                            hintStyle: TextStyle(color: Colors.black26, fontWeight: FontWeight.bold, fontFamily: 'Rubik'),
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
                      Text("Lokasi", style: TextStyle(fontFamily: 'Rubik'),),
                      SizedBox(height: 5.0,),
                      DropdownButton(
                        isDense: true,
                        isExpanded: true,
                        hint: Text("Pilih", style: TextStyle(fontFamily: 'Rubik'),),
                        value: _valType,
                        items: _type.map((value) {
                          return DropdownMenuItem<String>(
                            child: Text(value['nama'], style: TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold)),
                            value: "${value['kode']}",
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _valType = value;
                          });
                          if (_valType != 'Pilih Lokasi') {
                            loadData();
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: RefreshIndicator(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: isLoading?Container(
                  child: Center(
                    child: CircularProgressIndicator(strokeWidth: 5.0, valueColor: new AlwaysStoppedAnimation<Color>(Colors.black)),
                  ),
                ):_buildItem(context) ,
              ),
              onRefresh: loadData,
              key: _refresh,
            )
          ),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context){
    return LoadMoreQ(
      child: ListView.builder(
        itemCount: laporanPenjualan.result.data.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              child:Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox.fromSize(
                      size: Size.fromHeight(200.0),
                      child: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 24.0),
                            child: Material(
                              elevation: 14.0,
                              borderRadius: BorderRadius.circular(12.0),
                              shadowColor: Color(0x802196F3),
                              color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.all(24.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text('${laporanPenjualan.result.data[index].kdTrx} (${laporanPenjualan.result.data[index].jenisTrx})', style: TextStyle(color: Colors.blueAccent)),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              width: MediaQuery.of(context).size.width*0.5,
                                              child: Text('${laporanPenjualan.result.data[index].nama}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20.0)),
                                            ),

                                            Container(
                                              margin: const EdgeInsets.only(top: 2.0),
                                              child: Text('${laporanPenjualan.result.data[index].lokasi}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 17.0)),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(top: 0.0),
                                              child: Text('${laporanPenjualan.result.data[index].tgl}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15.0)),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(top: 4.0),
                                              child: Text('Subtotal: ${laporanPenjualan.result.data[index].st}0', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15.0)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    /// Infos
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text('Total: ', style: TextStyle()),
                                              Text(laporanPenjualan.result.data[index].gt, style: TextStyle()),
                                            ]
                                        ),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text('Status: ', style: TextStyle()),
                                              Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 4.0),
                                                child: Material(
                                                  borderRadius: BorderRadius.circular(8.0),
                                                  color: Colors.green,
                                                  child: Padding(
                                                    padding: EdgeInsets.all(4.0),
                                                    child: Text('${laporanPenjualan.result.data[index].status}', style: TextStyle(color: Colors.white)),
                                                  ),
                                                ),
                                              ),
                                            ]
                                        )
                                      ],
                                    ),


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
                                size: Size.fromRadius(54.0),
                                child: Material(
                                  elevation: 20.0,
                                  shadowColor: Color(0x802196F3),
                                  shape: CircleBorder(),
                                  child: Image.asset('res/shoes1.png'),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                ),
              ),
              onTap: () => Navigator.of(context).push(new CupertinoPageRoute(builder: (_) =>  LaporanPageDetail('${laporanPenjualan.result.data[index].kdTrx}')))
          );
        },
      ),
      whenEmptyLoad: true,
      delegate: DefaultLoadMoreDelegate(),
      textBuilder: DefaultLoadMoreTextBuilder.english,
      isFinish: laporanPenjualan.result.data.length < perpage,
      onLoadMore: _loadMore,
    );
  }
}
