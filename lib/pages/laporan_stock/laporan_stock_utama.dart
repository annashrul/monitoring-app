import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monitoring_apps/model/laporan_stock/laporanStockUtamaModel.dart';
import 'package:monitoring_apps/pages/helper/loadMoreQ.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:monitoring_apps/utils/user_repository.dart';


class LaporanStockUtama extends StatefulWidget {
  @override
  _LaporanStockUtamaState createState() => _LaporanStockUtamaState();
}

class _LaporanStockUtamaState extends State<LaporanStockUtama> {
  int perpage = 10;
  LaporanStockUtamaModel laporanStockUtamaModel;
  bool isLoading=false,isRetry=false,isConnected=false;
  final GlobalKey<RefreshIndicatorState> _refresh = GlobalKey<RefreshIndicatorState>();
  final userRepository = UserRepository();

  Map<String, String> get headers => {
    "Content-Type": "application/json",
    "username": "netindo",
    "password": "\$2b\$08\$hLMU6rEvNILCMaQbthARK.iCmDRO7jNbUB8CcvyRStqsHD4UQxjDO",
    "Authorization": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIxIiwiaWF0IjoxNTk3MTM0NzM3LCJleHAiOjE1OTk3MjY3Mzd9.Dy6OCNL9BhUgUTPcQMlEXTbw5Dyv3UnG_Kyvs3WHicE",
  };
  String datefrom='2020-01-01';
  String dateto='2020-09-04';
  Future<void> loadData() async{
    final url = await userRepository.isServerAddress();
    try{
      setState(() {
        isLoading = true;
        isConnected=false;
      });
      final jsonString = await http.get(url+"report/stock?page=1?page=1&datefrom=$datefrom&dateto=$dateto&perpage=$perpage", headers: headers).timeout(Duration(seconds: 20));
      print(jsonString);
      if (jsonString.statusCode == 200) {
        final jsonResponse = json.decode(jsonString.body);
        laporanStockUtamaModel = new LaporanStockUtamaModel.fromJson(jsonResponse);
        setState(() {
          isLoading = false;
          isRetry = false;
        });
      } else {
        throw Exception('Failed to load photos');
      }
    }catch(e){
      setState(() {
        isLoading = false;
        isConnected = false;
        isRetry=true;
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
  String _format = 'yyyy-MM-dd';
  TextEditingController _tgl_pertama = TextEditingController();
  TextEditingController _tgl_kedua = TextEditingController();
  DateTime _dateTime;
  String _valType ='LK/0001';
  List _type = ["LK/0001","LK/0002"];
  String _radioValue2 = 'whatsapp';
  void _handleRadioValueChange2(String value) {
    _radioValue2 = value;
    switch (_radioValue2) {
      case 'whatsapp':
        setState(() {});
        break;
      case 'sms':
        setState(() {});
        break;
    }

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
          if(param=='1'){
            _tgl_pertama.text = '${_dateTime.year}-${_dateTime.month.toString().padLeft(2, '0')}-${_dateTime.day.toString().padLeft(2, '0')}';
          }else{
            _tgl_kedua.text = '${_dateTime.year}-${_dateTime.month.toString().padLeft(2, '0')}-${_dateTime.day.toString().padLeft(2, '0')}';
          }
        });
      },
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
    _tgl_pertama.text = _format;
    _tgl_kedua.text = _format;
    _dateTime = DateTime.parse(INIT_DATETIME);
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton
          (
          color: Colors.black,
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Text('Laporan Stock', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700)),

      ),

      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              new Flexible(
                child: Padding(
                  padding: EdgeInsets.only(left:8.0,top:10.0),
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
                            hintStyle: TextStyle(color: Colors.black26,fontWeight: FontWeight.bold,fontFamily:'Rubik'),
                          ),
                          onTap:(){ _showDatePicker('1');},
                          onChanged: (value) {
                            setState(() {
                              _tgl_pertama.text = '${_dateTime.year}-${_dateTime.month.toString().padLeft(2, '0')}-${_dateTime.day.toString().padLeft(2, '0')}';
                            });
                            print('TANGGAL PERTAMA = ${_dateTime.year}-${_dateTime.month.toString().padLeft(2, '0')}-${_dateTime.day.toString().padLeft(2, '0')}');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              new Flexible(
                child: Padding(
                  padding: EdgeInsets.only(left:8.0,top:10.0),
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
                            hintStyle: TextStyle(color: Colors.black26,fontWeight: FontWeight.bold,fontFamily:'Rubik'),
                          ),
                          onTap:(){ _showDatePicker('2');},
                          onChanged: (value) {},
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              new Flexible(
                child: Padding(
                  padding: EdgeInsets.only(right:8.0,left:8.0,top:20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Lokasi',style: TextStyle(fontSize:12.0,color: Colors.black26,fontWeight: FontWeight.bold,fontFamily:'Rubik')),
                      SizedBox(height: 5.0),
                      DropdownButton(
                        isDense: true,
                        isExpanded: true,

                        hint: Text("Pilih",style: TextStyle(fontFamily: 'Rubik'),),
                        value: _valType,
                        items: _type.map((value) {
                          return DropdownMenuItem(
                            child: Text(value,style: TextStyle(fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
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

          Expanded(
              child:  RefreshIndicator(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: isRetry==true?Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Text("Mohon Maaf, Server Kami Sedang Dalam Perbaikan",style: TextStyle(fontFamily: 'Rubik',fontWeight: FontWeight.bold),),
                        ),
                        Center(
                          child: Text("Silahkan Coba Beberapa Saat Lagi",style: TextStyle(fontFamily: 'Rubik',fontWeight: FontWeight.bold),),
                        )
                      ],
                    ),
                  ):isLoading ? Container(child: Center(child: CircularProgressIndicator(strokeWidth: 5.0,valueColor: new AlwaysStoppedAnimation<Color>(Colors.black)),),) :_buildItem(context),
                ),
                onRefresh: loadData,
                key: _refresh,
              )
          ),


        ],
      )
      ,
      bottomNavigationBar:isRetry==true||isConnected==true?Text(''):isLoading ?Text(''):_bottomInfo(context),
    );
  }

  Widget _buildItem(BuildContext context){
    return LoadMoreQ(
      child: ListView.builder(
        itemCount: laporanStockUtamaModel.result.data.length,
        itemBuilder: (BuildContext context, int index) {
          var stock_akhir = (double.parse(laporanStockUtamaModel.result.data[index].stockAwal) + double.parse(laporanStockUtamaModel.result.data[index].stockMasuk))-double.parse(laporanStockUtamaModel.result.data[index].stockKeluar);
          return GestureDetector(
              child:Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: Align
                  (
                  alignment: Alignment.topCenter,
                  child: SizedBox.fromSize
                    (
                      size: Size.fromHeight(165.0),
                      child: Stack
                        (
                        fit: StackFit.expand,
                        children: <Widget>
                        [
                          /// Item description inside a material
                          Container
                            (
                            margin: EdgeInsets.only(top: 24.0),
                            child: Material
                              (
                              elevation: 14.0,
                              borderRadius: BorderRadius.circular(0.0),
                              shadowColor: Colors.transparent,
                              color: Colors.white,
                              child: Padding
                                (
                                padding: EdgeInsets.all(24.0),
                                child: Column
                                  (
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>
                                  [
                                    /// Title and rating
                                    Column
                                      (
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,

                                      children: <Widget>
                                      [
                                        Text('${laporanStockUtamaModel.result.data[index].kdBrg} ( ${laporanStockUtamaModel.result.data[index].satuan} )', style: TextStyle(fontFamily:'Rubik',color: Colors.blueAccent)),
                                        Column
                                          (
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>
                                          [
                                            Container(
                                              margin: const EdgeInsets.only(top: 2.0),
                                              child: Text('${laporanStockUtamaModel.result.data[index].nmBrg}', style: TextStyle(fontFamily:'Rubik',color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16.0)),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(top: 0.0),
                                              child: Text('${laporanStockUtamaModel.result.data[index].supplier}', style: TextStyle(fontFamily:'Rubik',color: Colors.black38, fontWeight: FontWeight.bold, fontSize: 14.0)),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(top: 0.0),
                                              child: Text('${laporanStockUtamaModel.result.data[index].subDept} ( ${laporanStockUtamaModel.result.data[index].namaKel} )', style: TextStyle(fontFamily:'Rubik',color: Colors.black38, fontWeight: FontWeight.bold, fontSize: 14.0)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row
                                      (
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                      children: <Widget>
                                      [
                                        Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>
                                            [
                                              Text(
                                                  'Stock Awal : ${laporanStockUtamaModel.result.data[index].stockAwal}',
                                                  style: TextStyle(fontFamily:'Rubik',color: Colors.blueAccent,fontSize: 12.0,fontWeight: FontWeight.bold)
                                              ),

                                              Text(
                                                  'Stock Keluar : ${laporanStockUtamaModel.result.data[index].stockKeluar}',
                                                  style: TextStyle(fontFamily:'Rubik',color: Colors.blueAccent,fontSize: 12.0,fontWeight: FontWeight.bold)
                                              ),
                                            ]
                                        ),
                                        Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>
                                            [
                                              Text(
                                                  'Stock Masuk : ${laporanStockUtamaModel.result.data[index].stockMasuk}',
                                                  style: TextStyle(fontFamily:'Rubik',color: Colors.blueAccent,fontSize: 12.0,fontWeight: FontWeight.bold)
                                              ),
                                              Text(
                                                  'Stock Akhir : $stock_akhir',
                                                  style: TextStyle(fontFamily:'Rubik',color: Colors.blueAccent,fontSize: 12.0,fontWeight: FontWeight.bold)
                                              ),
                                            ]
                                        ),



                                      ],
                                    ),
                                  ],
                                ),

                              ),
                            ),
                          ),
                          /// Item image
                          Align
                            (
                            alignment: Alignment.topRight,
                            child: Padding
                              (
                              padding: EdgeInsets.only(right: 16.0),
                              child: SizedBox.fromSize
                                (
                                size: Size.fromRadius(40.0),
                                child: Material
                                  (
                                  elevation: 20.0,
                                  shadowColor: Colors.transparent,
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
              onTap: (){}
          );
        },
      ),
      whenEmptyLoad: true,
      delegate: DefaultLoadMoreDelegate(),
      textBuilder: DefaultLoadMoreTextBuilder.english,
      isFinish: laporanStockUtamaModel.result.data.length < perpage,
      onLoadMore: _loadMore,

    );
  }


  Widget _bottomInfo(BuildContext context){
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Total Stock Awal : ${laporanStockUtamaModel.result.totalStock.totalStockAwal}", style: TextStyle(color: Colors.black54,fontFamily:'Rubik',fontWeight: FontWeight.bold),),
              Text("Total Stock Akhir : ${laporanStockUtamaModel.result.totalStock.totalStockAkhir}",style:TextStyle(color:Colors.black54,fontFamily:'Rubik',fontWeight: FontWeight.bold))
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Total Stock Masuk : ${laporanStockUtamaModel.result.totalStock.totalStockMasuk}", style: TextStyle(color: Colors.black54,fontFamily:'Rubik',fontWeight: FontWeight.bold),),
              Text("Total Stock Keluar : ${laporanStockUtamaModel.result.totalStock.totalStockKeluar}",style:TextStyle(color:Colors.black54,fontFamily:'Rubik',fontWeight: FontWeight.bold))
            ],
          ),
        ],
      ),
    );
  }

}


const String MIN_DATETIME = '2010-05-12';
const String MAX_DATETIME = '2021-11-25';
const String INIT_DATETIME = '2019-05-17';


