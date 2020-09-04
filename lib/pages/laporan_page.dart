import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monitoring_apps/model/laporanPenjualan.dart';
import 'package:monitoring_apps/pages/laporan_page_detail.dart';
import 'package:monitoring_apps/provider/penjualan_provider.dart';

class LaporanPage extends StatefulWidget
{
  @override
  _LaporanPageState createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage>
{
  var perpage=3;
  Future<LaporanPenjualan> getData(var limit) async {
    return await PenjualanProvider().getLaporan(limit,'2020-01-01','2020-09-04');
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
        title: Text('Laporan Penjualan', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700)),

      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: getData(perpage),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return  Align(alignment: Alignment.center,
                  child:  CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.lightBlue
                  ) ,),);
              default:
                if (snapshot.hasError){
                  print(snapshot.data);

                  return new Text('Error: ${snapshot.error}');
               } else
                  return _buildItem(context, snapshot);
            }
          },
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, AsyncSnapshot snap){
    var values = snap.data.result.data;
    return ListView.builder(
        itemCount: values.length+1,
        itemBuilder: (BuildContext context, int index) {
          return (index == values.length ) ?
            Container(
                color: Colors.white12,
                child: FlatButton(
                    child: Text("Load More"),
                    onPressed: () {
                      perpage+=perpage;
                      setState(() {
                        
                      });
                    },
                ),
            ):GestureDetector(
                child:Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: Align
                    (
                      alignment: Alignment.topCenter,
                      child: SizedBox.fromSize
                      (
                        size: Size.fromHeight(200.0),
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
                                borderRadius: BorderRadius.circular(12.0),
                                shadowColor: Color(0x802196F3),
                                color: Colors.white,
                                child: Padding
                                (
                                  padding: EdgeInsets.all(24.0),
                                  child: Column
                                  (
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          Text('${values[index].kdTrx} (${values[index].jenisTrx})', style: TextStyle(color: Colors.blueAccent)),
                                          Column
                                          (
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>
                                            [
                                              Container(
                                                width: MediaQuery.of(context).size.width*0.5,
                                                child: Text('${values[index].nama}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20.0)),
                                              ),
                                              
                                              Container(
                                                margin: const EdgeInsets.only(top: 2.0),
                                                child: Text('${values[index].lokasi}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 17.0)),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(top: 0.0),
                                                child: Text('${values[index].tgl}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15.0)),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(top: 4.0),
                                                child: Text('Subtotal: ${values[index].st}0', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15.0)),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      /// Infos
                                      Row
                                      (
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                        children: <Widget>
                                        [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>
                                            [
                                              Text('Total: ', style: TextStyle()),
                                              Text(values[index].gt, style: TextStyle()),
                                             
                                            ]
                                          ),
                                          
                                          
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>
                                            [
                                              Text('Status: ', style: TextStyle()),
                                              Padding
                                              (
                                                padding: EdgeInsets.symmetric(horizontal: 4.0),
                                                child: Material
                                                (
                                                  borderRadius: BorderRadius.circular(8.0),
                                                  color: Colors.green,
                                                  child: Padding
                                                  (
                                                    padding: EdgeInsets.all(4.0),
                                                    child: Text('${values[index].status}', style: TextStyle(color: Colors.white)),
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
                            Align
                            (
                              alignment: Alignment.topRight,
                              child: Padding
                              (
                                padding: EdgeInsets.only(right: 16.0),
                                child: SizedBox.fromSize
                                (
                                  size: Size.fromRadius(54.0),
                                  child: Material
                                  (
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
                  onTap: () => Navigator.of(context).push(new CupertinoPageRoute(builder: (_) =>  LaporanPageDetail('${values[index].kdTrx}')))
              );
            },
    );
  }
}
