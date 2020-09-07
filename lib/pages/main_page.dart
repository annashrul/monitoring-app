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
import 'package:monitoring_apps/provider/monitoring_provider.dart';
import 'package:monitoring_apps/utils/user_repository.dart' show UserRepository;
import 'package:monitoring_apps/widget/GroupedBarChart.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<List<double>> charts = [
    [0.0, 0.1000]
  ];
  static final List<String> chartDropdownItems = ['Semua Periode', 'Bulan ini'];
  String actualDropdown = chartDropdownItems[0];
  int actualChart = 0;
  String penjualan = "0";
  String transaksi = "0";
  String netSales = "0";
  String avg = "0";
  Monthly monthlyData;
  String nama = 'Netindo';
  var result = MonitoringProvider().getDashboard();
  DateTimePickerLocale _locale = DateTimePickerLocale.id;
  List<DateTimePickerLocale> _locales = DateTimePickerLocale.values;
  String _format = 'yyyy-MM-dd';
  TextEditingController _tgl_pertama = TextEditingController();
  TextEditingController _tgl_kedua = TextEditingController();
  DateTime _dateTime;
  String _valType = 'LK/0001';
  List _type = ["Semua Lokasi", "LK/0001", "LK/0002"];
  @override
  void initState() {
    super.initState();
    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);
    var settings = {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.promptBeforeOpeningPushUrl: true
    };
    OneSignal.shared
        .init("9a74b710-c5f3-441c-b3d5-de924945e5f9", iOSSettings: settings);
    OneSignal.shared.setNotificationOpenedHandler((notification) {
      // var notify = notification.notification.payload.additionalData;
    });

    result.then((val) {
      penjualan = val.result.penjualan;
      transaksi = val.result.transaksi;
      netSales = val.result.netSales;
      avg = val.result.avg;
      final hourly = jsonDecode(val.result.hourly);
      charts = List<List<double>>.from(
          hourly.map((x) => List<double>.from(x.map((x) => x.toDouble()))));
      monthlyData = val.result.monthly;
      // charts=hourly.cast<List<double>>();
      setState(() {});
    });

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
              automaticallyImplyLeading:
                  false, // Used for removing back buttoon.
              elevation: 2.0,
              backgroundColor: Colors.white,
              title: Text('Monitoring $nama',
                  style: TextStyle(
                      fontFamily: 'Rubik',
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 23.0)),
              actions: <Widget>[
                PopupMenuButton<String>(
                  onSelected: handleClick,
                  itemBuilder: (BuildContext context) {
                    return {"Logout"}.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(
                          choice,
                          style: TextStyle(fontFamily: 'Rubik'),
                        ),
                      );
                    }).toList();
                  },
                ),
              ],
            ),
            body: StaggeredGridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Dashboard",
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
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
                                return DropdownMenuItem(
                                  child: Text(value,
                                      style: TextStyle(
                                          fontFamily: 'Rubik',
                                          fontWeight: FontWeight.bold)),
                                  value: value,
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
                              Text('Gross Sales',
                                  style: TextStyle(color: Colors.blueAccent)),
                              Text('$penjualan',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 34.0))
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
                                  fontSize: 24.0)),
                          Text('$transaksi',
                              style: TextStyle(
                                  color: Colors.black45, fontSize: 18.0)),
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
                                  fontSize: 24.0)),
                          Text('$netSales',
                              style: TextStyle(
                                  color: Colors.black45, fontSize: 18.0)),
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
                                  style: TextStyle(color: Colors.blueAccent)),
                              Text('$avg',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 34.0))
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
                                new Text("Bulan lalu"),
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
                                new Text("Bulan ini"),
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
                                  fontSize: 24.0))
                        ]),
                  ),
                  onTap: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => LaporanPage())),
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
                                  fontSize: 23.0))
                        ]),
                  ),
                  onTap: () => Navigator.of(context).push(
                      CupertinoPageRoute(builder: (_) => LaporanStockUtama())),
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
                  onTap: () => Navigator.of(context).push(
                      CupertinoPageRoute(builder: (_) => LaporanMutasi())),
                )
              ],
              staggeredTiles: [
                StaggeredTile.extent(2, 50.0),
                StaggeredTile.extent(2, 70.0),
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
            )));
  }

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
        shadowColor: Color(0x802196F3),
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
