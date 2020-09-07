import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:monitoring_apps/model/monitoring.dart';
import 'package:monitoring_apps/pages/laporan_mutasi/laporan_mutasi.dart';
import 'package:monitoring_apps/pages/laporan_page.dart';
import 'package:monitoring_apps/pages/laporan_stock/laporan_stock_utama.dart';
import 'package:monitoring_apps/pages/login_page.dart';
import 'package:monitoring_apps/provider/lokasi_provider.dart';
import 'package:monitoring_apps/provider/monitoring_provider.dart';
import 'package:monitoring_apps/utils/user_repository.dart' show UserRepository;
import 'package:monitoring_apps/widget/GroupedBarChart.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'helper/helper_widget.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<List<double>> charts = [
    [0.0, 0.1000]
  ];
  final GlobalKey<RefreshIndicatorState> _refresh = GlobalKey<RefreshIndicatorState>();
  bool isLoading=false;
  static final List<String> chartDropdownItems = ['Semua Periode', 'Bulan ini'];
  String actualDropdown = chartDropdownItems[0];
  int actualChart = 0;
  String penjualan = "0";
  String transaksi = "0";
  String netSales = "0";
  String avg = "0";
  Monthly monthlyData;
  String nama = 'Netindo';
  DateTimePickerLocale _locale = DateTimePickerLocale.id;
  List<DateTimePickerLocale> _locales = DateTimePickerLocale.values;
  String _format = 'yyyy-MM-dd';
  TextEditingController _tgl_pertama = TextEditingController();
  TextEditingController _tgl_kedua = TextEditingController();
  DateTime _dateTime;
  String _valType = 'Pilih Lokasi';
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
        setState(() {
          _valType = _type[1]['kode'];
        });
      }
    });

  }

  Future<void> loadData() async{
    var date = new DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    var formattedDate = "${dateParse.year}-${dateParse.month.toString().padLeft(2, '0')}-${dateParse.day.toString().padLeft(2, '0')}";
    String dateto=formattedDate,datefrom=formattedDate,lokasi='';
    if(_tgl_pertama.text==''){
      _tgl_pertama.text = formattedDate;
      datefrom = formattedDate;
    }else{
      datefrom = _tgl_pertama.text;
    }
    if(_tgl_kedua.text==''){
      _tgl_kedua.text = formattedDate;
      dateto = formattedDate;
    }else{
      dateto = _tgl_kedua.text;
    }
    if(_valType!='Pilih Lokasi'){
      lokasi = _valType;
    }
    setState(() {
      isLoading=true;
    });
    await MonitoringProvider().getDashboard(datefrom,dateto,lokasi).then((value){
      setState(() {
        isLoading=false;
        penjualan = value.result.penjualan;
        transaksi = value.result.transaksi;
        netSales = value.result.netSales;
        avg = value.result.avg;
        final hourly = jsonDecode(value.result.hourly);
        charts = List<List<double>>.from(hourly.map((x) => List<double>.from(x.map((x) => x.toDouble()))));
        if(value.result.monthly.labelLokasi!=null){
          monthlyData = value.result.monthly;
        }
      });
    });

  }
  @override
  void initState() {
    super.initState();
    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);
    var settings = {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.promptBeforeOpeningPushUrl: true
    };
    OneSignal.shared.init("9a74b710-c5f3-441c-b3d5-de924945e5f9", iOSSettings: settings);
    OneSignal.shared.setNotificationOpenedHandler((notification) {
      // var notify = notification.notification.payload.additionalData;
    });
    loadData();
    getData();
    UserRepository().isName().then((val) {
      nama = val;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.black),
              automaticallyImplyLeading: false, // Used for removing back buttoon.
              elevation: 2.0,
              backgroundColor: Colors.white,
              title: Text('Monitoring $nama', style: TextStyle(fontFamily: 'Rubik', color: Colors.black, fontWeight: FontWeight.w600, fontSize: 23.0)),
              actions: <Widget>[
                PopupMenuButton<String>(
                  onSelected: handleClick,
                  itemBuilder: (BuildContext context) {
                    return {"Logout"}.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice, style: TextStyle(fontFamily: 'Rubik'),),
                      );
                    }).toList();
                  },
                ),
              ],
            ),
            body: isLoading
              ? Container(
            child: Center(
              child: CircularProgressIndicator(strokeWidth: 5.0, valueColor: new AlwaysStoppedAnimation<Color>(Colors.black)),
            ),
          )
              : RefreshIndicator(
              child: StaggeredGridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                          padding:
                          EdgeInsets.only(right: 8.0, left: 8.0, top: 20.0),
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
                                  return DropdownMenuItem<String>(
                                    child: Text(value['nama'], style: TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold)),
                                    value: "${value['kode']}",
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

                  InkWell(
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
                  //GrossSales
                  _buildTile(
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Gross Sales', style: TextStyle(color: Colors.blueAccent,fontFamily: 'Rubik')),
                                Text('$penjualan',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 34.0,fontFamily: 'Rubik'))
                              ],
                            ),
                            Material(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(24.0),
                                child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Icon(Icons.show_chart,
                                          color: Colors.white, size: 30.0),
                                    )))
                          ]),
                    ),
                  ),
                  // TRX
                  _buildTile(
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Material(
                                color: Colors.teal,
                                shape: CircleBorder(),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Icon(Icons.shopping_cart,
                                      color: Colors.white, size: 30.0),
                                )),
                            Padding(padding: EdgeInsets.only(bottom: 16.0)),
                            Text('Transaction',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24.0,fontFamily: 'Rubik')),
                            Text('$transaksi',
                                style: TextStyle(
                                    color: Colors.black45, fontSize: 18.0,fontFamily: 'Rubik')),
                          ]),
                    ),
                  ),
                  // NET SALES
                  _buildTile(
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Material(
                                color: Colors.amber,
                                shape: CircleBorder(),
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Icon(Icons.multiline_chart,
                                      color: Colors.white, size: 30.0),
                                )),
                            Padding(padding: EdgeInsets.only(bottom: 16.0)),
                            Text('Net Sales',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24.0,fontFamily: 'Rubik')),
                            Text('$netSales',
                                style: TextStyle(
                                    color: Colors.black45, fontSize: 18.0,fontFamily: 'Rubik')),
                          ]),
                    ),
                  ),
                  //HOURYLY
                  _buildTile(
                    Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Hourly Gross Sales Amount',
                                        style: TextStyle(
                                            fontFamily: 'Rubik',
                                            color: Colors.green,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18.0)),
                                  ],
                                ),
                              ],
                            ),
                            Padding(padding: EdgeInsets.only(bottom: 4.0)),
                            Expanded(
                              child: Sparkline(
                                data: charts[actualChart],
                                lineWidth: 5.0,
                                lineColor: Colors.greenAccent,
                              ),
                            )
                          ],
                        )),
                  ),
                  //AVGTRX
                  _buildTile(
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Material(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(24.0),
                                child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Icon(Icons.pie_chart,
                                          color: Colors.white, size: 30.0),
                                    ))),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Average Per-Transaction',
                                    style: TextStyle(color: Colors.blueAccent,fontFamily: 'Rubik')),
                                Text('$avg',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 34.0,fontFamily: 'Rubik'))
                              ],
                            ),
                          ]),
                    ),
                  ),
                  //Monthly Sales Amount
                  _buildTile(
                    Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Monthly Sales Amount',
                                        style: TextStyle(
                                            fontFamily: 'Rubik',
                                            color: Colors.green,
                                            fontSize: 18.0)),
                                  ],
                                ),
                              ],
                            ),
                            Padding(padding: EdgeInsets.only(bottom: 4.0)),
                            Expanded(
                                child: new GroupedBarChart.withSampleData(
                                    monthlyData)),
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(width: 10.0),
                                  Container(
                                    margin: EdgeInsets.only(top: 3.5),
                                    color: Colors.blueAccent,
                                    width: 10.0,
                                    height: 5.0,
                                  ),
                                  Container(width: 5.0),
                                  new Text("Bulan lalu",style: TextStyle(fontFamily: 'Rubik'),),
                                ]),
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(width: 10.0),
                                  Container(
                                    margin: EdgeInsets.only(top: 3.5),
                                    color: Colors.blue[200],
                                    width: 10.0,
                                    height: 5.0,
                                  ),
                                  Container(width: 5.0),
                                  new Text("Bulan ini",style: TextStyle(fontFamily: 'Rubik'),),
                                ])
                          ],
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Laporan",
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                  //laporan penjualan
                  _buildTile(
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Material(
                                color: Colors.deepPurple,
                                shape: CircleBorder(),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Icon(Icons.assignment,
                                      color: Colors.white, size: 30.0),
                                )),
                            Text('Laporan Penjualan',
                                style: TextStyle(
                                    fontFamily: 'Rubik',
                                    color: Colors.deepPurple,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20.0))
                          ]),
                    ),
                    onTap: () => Navigator.of(context).push(CupertinoPageRoute(builder: (_) => LaporanPage())).whenComplete(loadData),
                  ),
                  //Laporan Stock
                  _buildTile(
                    Padding(
                      padding: const EdgeInsets.all(29.5),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Material(
                                color: Colors.teal,
                                shape: CircleBorder(),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Icon(Icons.storage,
                                      color: Colors.white, size: 30.0),
                                )),
                            Text('Laporan Stock',
                                style: TextStyle(
                                    fontFamily: 'Rubik',
                                    color: Colors.teal,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20.0))
                          ]),
                    ),
                    onTap: () => Navigator.of(context).push(CupertinoPageRoute(builder: (_) => LaporanStockUtama())).whenComplete(loadData),
                  ),
                  _buildTile(
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Laporan Mutasi',
                                    style: TextStyle(
                                        fontFamily: 'Rubik',
                                        color: Colors.redAccent,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20.0))
                              ],
                            ),
                            Material(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(24.0),
                                child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Icon(Icons.list,
                                          color: Colors.white, size: 30.0),
                                    )))
                          ]),
                    ),
                    onTap: () => Navigator.of(context).push(CupertinoPageRoute(builder: (_) => LaporanMutasi())).whenComplete(loadData),
                  )
                ],
                staggeredTiles: [
                  // StaggeredTile.extent(2, 50.0),
                  StaggeredTile.extent(2, 70.0),
                  StaggeredTile.extent(2, 50.0),
                  StaggeredTile.extent(2, 110.0),
                  StaggeredTile.extent(1, 180.0),
                  StaggeredTile.extent(1, 180.0),
                  StaggeredTile.extent(2, 220.0),
                  StaggeredTile.extent(2, 110.0),
                  StaggeredTile.extent(2, 260.0),
                  StaggeredTile.extent(2, 50.0),
                  StaggeredTile.extent(1, 180.0),
                  StaggeredTile.extent(1, 180.0),
                  StaggeredTile.extent(2, 110.0),
                ],
              ),
              onRefresh: loadData,
              key: _refresh,
            )
        )
    );
  }

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

  Widget _buildTile(Widget child, {Function() onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Colors.white,
        child: InkWell(
            // Do onTap() if it isn't null, otherwise do print()
            onTap: onTap != null
                ? () => onTap()
                : () {
                    print('Not set yet');
                  },
            child: child));
  }

  void handleClick(String value) {
    switch (value) {
      case 'Logout':
        UserRepository().destroy();
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => LoginPage()));
        break;
    }
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => SystemNavigator.pop(),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }
}

const String MIN_DATETIME = '2010-05-12';
const String MAX_DATETIME = '2021-11-25';
const String INIT_DATETIME = '2019-05-17';
