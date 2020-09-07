import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:monitoring_apps/model/laporan_stock/laporanStockDetailModel.dart';
import 'package:http/http.dart' as http;
import 'package:monitoring_apps/pages/helper/loadMoreQ.dart';
import 'package:monitoring_apps/utils/user_repository.dart';

class LaporanStockDetail extends StatefulWidget {
  final datefrom;
  final dateto;
  final lokasi;
  final kdLokasi;
  final kdbrg;
  final nmbrg;
  LaporanStockDetail({this.datefrom,this.dateto,this.lokasi,this.kdLokasi,this.kdbrg,this.nmbrg});
  @override
  _LaporanStockDetailState createState() => _LaporanStockDetailState();
}

class _LaporanStockDetailState extends State<LaporanStockDetail> {
  LaporanStockDetailModel laporanStockDetailModel;
  final userRepository = UserRepository();
  Map<String, String> get headers => {
    "Content-Type": "application/json",
    "username": "netindo",
    "password": "\$2b\$08\$hLMU6rEvNILCMaQbthARK.iCmDRO7jNbUB8CcvyRStqsHD4UQxjDO",
    "Authorization": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIxIiwiaWF0IjoxNTk3MTM0NzM3LCJleHAiOjE1OTk3MjY3Mzd9.Dy6OCNL9BhUgUTPcQMlEXTbw5Dyv3UnG_Kyvs3WHicE",
  };
  bool isLoading=false;
  int perpage=15;
  Future<void> loadData() async {
    final server = await userRepository.isServerAddress();
    String url = "$server/report/stock/${widget.kdbrg}/detail?page=1&perpage=$perpage&datefrom=${widget.datefrom}&lokasi=${widget.kdLokasi}&dateto=${widget.dateto}";
    try {
      setState(() {
        isLoading = true;
      });
      final jsonString = await http.get(url, headers: headers).timeout(Duration(seconds: 20));
      if (jsonString.statusCode == 200) {
        final jsonResponse = json.decode(jsonString.body);
        laporanStockDetailModel = new LaporanStockDetailModel.fromJson(jsonResponse);
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
          title: Text('Laporan Stock Transaksi', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
        ),
      body: isLoading ? Container(
        child: Center(
          child: CircularProgressIndicator(strokeWidth: 5.0, valueColor: new AlwaysStoppedAnimation<Color>(Colors.black)),
        ),
      ):buildContent(context),
    );
  }
  Widget buildContent(BuildContext context){
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width:MediaQuery.of(context).size.width/4,
                    child: Text('PERIODE',style: TextStyle(fontFamily: 'Rubik',fontWeight: FontWeight.bold),),
                  ),
                  Text(": ${widget.datefrom} s/d ${widget.dateto}",style: TextStyle(fontFamily: 'Rubik',fontWeight: FontWeight.bold))
                ],
              ),
              SizedBox(height: 3.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width:MediaQuery.of(context).size.width/4,
                    child: Text('LOKASI',style: TextStyle(fontFamily: 'Rubik',fontWeight: FontWeight.bold),),
                  ),
                  Text(": ${widget.lokasi}",style: TextStyle(fontFamily: 'Rubik',fontWeight: FontWeight.bold))
                ],
              ),
              SizedBox(height: 3.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width:MediaQuery.of(context).size.width/4,
                    child: Text('BARANG',style: TextStyle(fontFamily: 'Rubik',fontWeight: FontWeight.bold),),
                  ),
                  Text(": ${widget.nmbrg} ( ${widget.kdbrg} )",style: TextStyle(fontFamily: 'Rubik',fontWeight: FontWeight.bold))
                ],
              )

              // Text("Lokasi : ${widget.lokasi}"),
              // Text("Nama Barang : ${widget.nmbrg}"),
            ],
          ),
        ),
        Expanded(child: LoadMoreQ(
          child:  ListView.builder(
            itemCount: laporanStockDetailModel.result.data.length,
            itemBuilder: (context, index) {
              var hm = DateFormat.Hm().format(laporanStockDetailModel.result.data[index].tgl.toLocal());
              var ymd = DateFormat.yMMMd().format(laporanStockDetailModel.result.data[index].tgl.toLocal());

              return Padding(
                padding: EdgeInsets.only(left:0, right: 0),
                child: Card(
                    elevation: 0,
                    child: Container(
                        decoration: BoxDecoration(color: (index % 2 == 0) ? Colors.white : Color(0xFFF7F7F9)),
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.center,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(hm, style: TextStyle(fontFamily:'Rubik',fontSize: 12, fontWeight: FontWeight.bold )),
                                    Text(ymd, style: TextStyle(fontFamily:'Rubik',fontSize: 10),)
                                  ],
                                ),
                              ),
                            ),
                            Container(height: 40, width: 1, color: Colors.grey, margin: EdgeInsets.only(left: 5, right: 5),),
                            Expanded(
                              flex: 4,
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(child: Text("${laporanStockDetailModel.result.data[index].kdTrx} \n${laporanStockDetailModel.result.data[index].keterangan}", style: TextStyle(fontFamily:'Rubik',fontSize: 10)),),
                                ],
                              ),
                            ),
                            Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Icon(Icons.add,size: 12,),
                                        Text(laporanStockDetailModel.result.data[index].stockIn, style: TextStyle(fontFamily:'Rubik',color:Colors.green,fontSize: 10, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Icon(const IconData(0xe15b, fontFamily: 'MaterialIcons'),
                                          color: Colors.black,size: 12,
                                        ),
                                        Text(laporanStockDetailModel.result.data[index].stockOut, style: TextStyle(fontFamily:"Rubik",color:Colors.red,fontSize: 10, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ],
                                )
                            )
                          ],
                        )
                    )
                ),
              );
            },
          ),
          whenEmptyLoad: true,
          delegate: DefaultLoadMoreDelegate(),
          textBuilder: DefaultLoadMoreTextBuilder.english,
          isFinish: laporanStockDetailModel.result.data.length<perpage,
          onLoadMore: _loadMore,
        ))
      ],
    );
  }

}
