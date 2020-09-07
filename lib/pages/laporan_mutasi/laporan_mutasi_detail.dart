import 'package:flutter/material.dart';
import 'package:monitoring_apps/model/laporanMutasiDetailModel.dart';
import 'package:monitoring_apps/provider/penjualan_provider.dart';

// ignore: must_be_immutable
class LaporanMutasiDetail extends StatefulWidget {
  String nota;
  LaporanMutasiDetail(this.nota);
  @override
  _LaporanMutasiDetailState createState() => _LaporanMutasiDetailState();
}

class _LaporanMutasiDetailState extends State<LaporanMutasiDetail> {
  var perpage = 3;
  Future<LaporanMutasiDetailModel> getData() async {
    return await PenjualanProvider().getLaporanDetailMutasi(widget.nota, 20);
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
        title: Text('Detail Laporan Mutasi',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.lightBlue),
                  ),
                );
              default:
                if (snapshot.hasError) {
                  return new Text('Error: ${snapshot.error}');
                } else
                  return _buildItem(context, snapshot);
            }
          },
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, AsyncSnapshot snap) {
    var values = snap.data.result.data;
    return Column(children: <Widget>[
      new Expanded(
          child: ListView.builder(
        itemCount: values.length,
        itemBuilder: (context, i) {
          return Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 5.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: SizedBox.fromSize(
                  size: Size.fromHeight(180),
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      /// Item description inside a material
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
                                /// Title and rating
                                Row(
                                  children: [
                                    Container(
                                        margin: EdgeInsets.only(right: 20.0),
                                        child: Image.network(
                                          values[i].gambar,
                                          width: 90.0,
                                        )),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.all(2.0),
                                          child: Text(
                                              '${values[i].noFakturMutasi}',
                                              style: TextStyle(
                                                  color: Colors.blueAccent,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 13.0)),
                                        ),
                                        Container(
                                          margin: EdgeInsets.all(2.0),
                                          child: Text('${values[i].kdBrg}',
                                              style: TextStyle(
                                                  color: Colors.blueAccent,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 13.0)),
                                        ),
                                        Container(
                                          margin: EdgeInsets.all(2.0),
                                          child: Text('${values[i].nmBrg}',
                                              style: TextStyle(
                                                  color: Colors.blueAccent,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16.0)),
                                        ),
                                        Row(
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.all(2.0),
                                                  child: Text(
                                                      'Harga Beli: ${values[i].hrgBeli}',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 13.0)),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.all(2.0),
                                                  child: Text(
                                                      'Harga Jual: ${values[i].hrgJual}',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 13.0)),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.all(2.0),
                                                  child: Text(
                                                      'Qty: ${values[i].qty} ${values[i].satuan}',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 13.0)),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      /// Item image
                    ],
                  )),
            ),
          );
        },
      ))
    ]);
  }
}
