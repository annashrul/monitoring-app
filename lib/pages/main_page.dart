import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:monitoring_apps/pages/laporan_page.dart';
import 'package:monitoring_apps/pages/login_page.dart';
import 'package:monitoring_apps/provider/monitoring_provider.dart';
import 'package:monitoring_apps/utils/user_repository.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class MainPage extends StatefulWidget
{
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
{


  List<List<double>> charts=[[0.1000]];
  static final List<String> chartDropdownItems = [ 'Bulan ini', 'Semua Periode'];
  String actualDropdown = chartDropdownItems[0];
  int actualChart = 0;
  String omzet="0";
  String avg="0";
  String mem="0";
  String pen="0";
  var result = MonitoringProvider().getDashboard();
  
  @override
  void initState() {
    super.initState();
    OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
    var settings = {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.promptBeforeOpeningPushUrl: true
    };
    OneSignal.shared.init("9a74b710-c5f3-441c-b3d5-de924945e5f9", iOSSettings: settings);
    OneSignal.shared.setNotificationOpenedHandler((notification) {
      // var notify = notification.notification.payload.additionalData;
    });
    result.then((val){
      omzet=val.omset;
      avg=val.avg;
      mem=val.member;
      pen=val.orders;
      final input =val.charts.replaceAll('"', '');
      var cht = jsonDecode(input);
      charts=List<List<double>>.from(cht.map((x) => List<double>.from(x.map((x) => x.toDouble()))));
      setState(() {});
    });

  }
  @override
  Widget build(BuildContext context)
  {
    return WillPopScope(
      onWillPop: _onWillPop,
      child:
        Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            automaticallyImplyLeading: false, // Used for removing back buttoon. 
            elevation: 2.0,
            backgroundColor: Colors.white,
            title: Text('Monitoring E-commerce', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 23.0)),
            actions: <Widget>
            [
              PopupMenuButton<String>(
                onSelected: handleClick,
                itemBuilder: (BuildContext context) {
                  return {"Logout"}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
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

              //member
              _buildTile(
                Padding
                (
                  padding: const EdgeInsets.all(24.0),
                  child: Row
                  (
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>
                    [
                      Column
                      (
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>
                        [
                          Text('Gross Sales', style: TextStyle(color: Colors.blueAccent)),
                          Text('$mem', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 34.0))
                        ],
                      ),
                      Material
                      (
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(24.0),
                        child: Center
                        (
                          child: Padding
                          (
                            padding: const EdgeInsets.all(16.0),
                            child: Icon(Icons.supervised_user_circle, color: Colors.white, size: 30.0),
                          )
                        )
                      )
                    ]
                  ),
                ),
              ),

              // penjualan
              _buildTile(
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column
                  (
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>
                    [
                      Material
                      (
                        color: Colors.teal,
                        shape: CircleBorder(),
                        child: Padding
                        (
                          padding: const EdgeInsets.all(16.0),
                          child: Icon(Icons.shopping_cart, color: Colors.white, size: 30.0),
                        )
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 16.0)),
                      Text('Transaction', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 24.0)),
                      Text('$pen', style: TextStyle(color: Colors.black45, fontSize: 18.0)),
                    ]
                  ),
                ),
              ),

              // rata-rata
              _buildTile(
                Padding
                (
                  padding: const EdgeInsets.all(24.0),
                  child: Column
                  (
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>
                    [
                      Material
                      (
                        color: Colors.amber,
                        shape: CircleBorder(),
                        child: Padding
                        (
                          padding: EdgeInsets.all(16.0),
                          child: Icon(Icons.account_balance, color: Colors.white, size: 30.0),
                        )
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 16.0)),
                      Text('Net Sales', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 24.0)),
                      Text('$avg', style: TextStyle(color: Colors.black45, fontSize: 18.0)),
                    ]
                  ),
                ),
              ),

              //omset
              _buildTile(
                Padding
                    (
                      padding: const EdgeInsets.all(24.0),
                      child: Column
                      (
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>
                        [
                          Row
                          (
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>
                            [
                              Column
                              (
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>
                                [
                                  Text('Omset', style: TextStyle(color: Colors.green)),
                                  Text('$omzet', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 25.0)),
                                ],
                              ),
                              DropdownButton
                              (
                                isDense: true,
                                value: actualDropdown,
                                onChanged: (String value) => setState(()
                                {
                                  actualDropdown = value;
                                  actualChart = chartDropdownItems.indexOf(value);
                                }),
                                items: chartDropdownItems.map((String title)
                                {
                                  return DropdownMenuItem
                                  (
                                    value: title,
                                    child: Text(title, style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w400, fontSize: 14.0)),
                                  );
                                }).toList()
                              )
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(bottom: 4.0)),
                          Sparkline
                          (
                            data: charts[actualChart],
                            lineWidth: 5.0,
                            lineColor: Colors.greenAccent,
                          )
                        ],
                      )
                    ),
              ),
              
              //laporan penjualan
              _buildTile(
                Padding
                (
                  padding: const EdgeInsets.all(24.0),
                  child: Row
                  (
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>
                    [
                      Column
                      (
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>
                        [
                          Text('Laporan Penjualan', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w700, fontSize: 20.0))
                        ],
                      ),
                      Material
                      (
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(24.0),
                        child: Center
                        (
                          child: Padding
                          (
                            padding: EdgeInsets.all(16.0),
                            child: Icon(Icons.store, color: Colors.white, size: 30.0),
                          )
                        )
                      )
                    ]
                  ),
                ),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => LaporanPage())),
              )
            ],
            staggeredTiles: [
              StaggeredTile.extent(2, 110.0),
              StaggeredTile.extent(1, 180.0),
              StaggeredTile.extent(1, 180.0),
              StaggeredTile.extent(2, 220.0),
              StaggeredTile.extent(2, 110.0),
            ],
          )
        )
      );
  }

  Widget _buildTile(Widget child, {Function() onTap}) {
    return Material(
      elevation: 14.0,
      borderRadius: BorderRadius.circular(12.0),
      shadowColor: Color(0x802196F3),
      child: InkWell
      (
        // Do onTap() if it isn't null, otherwise do print()
        onTap: onTap != null ? () => onTap() : () { print('Not set yet'); },
        child: child
      )
    );
  }

  void handleClick(String value) {
      switch (value) {
        case 'Logout':
          UserRepository().destroy();
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => LoginPage()));
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
    )) ?? false;
  }

}