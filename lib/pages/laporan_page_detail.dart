import 'package:flutter/material.dart';
import 'package:monitoring_apps/model/laporanPenjualanDetail.dart';
import 'package:monitoring_apps/provider/penjualan_provider.dart';

// ignore: must_be_immutable
class LaporanPageDetail extends StatefulWidget
{
  String nota;
  LaporanPageDetail(this.nota);
  @override
  _LaporanPageDetailState createState() => _LaporanPageDetailState();
}

class _LaporanPageDetailState extends State<LaporanPageDetail>
{
  var perpage=3;
  Future<LaporanPenjualanDetail> getData() async {
    return await PenjualanProvider().getLaporanDetail(widget.nota);
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
        title: Text('Detail Laporan Penjualan', style: TextStyle(fontFamily:'Rubik',color: Colors.black, fontWeight: FontWeight.w700)),

      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: getData(),
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
    var values = snap.data.result;
    var details = snap.data.result.detail;
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text("Kode Transaksi: ", style: TextStyle(fontSize: 18.0,)),
            Container(
                margin: EdgeInsets.all(2.0),
                child: Text('${values.kdTrx}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18.0)),
              ),
          ]
        ),
        Row(
          children: <Widget>[
            Text("Operator: ", style: TextStyle(fontSize: 18.0,)),
            Container(
                margin: EdgeInsets.all(2.0),
                child: Text('${values.resultOperator}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18.0)),
              ),
          ]
        ),
        Row(
          children: <Widget>[
            Text("Lokasi: ", style: TextStyle(fontSize: 18.0,)),
            Container(
                margin: EdgeInsets.all(2.0),
                child: Text('${values.lokasi}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18.0)),
              ),
          ]
        ),
        Row(
          children: <Widget>[
            Text("Tanggal Transaksi: ", style: TextStyle(fontSize: 18.0,)),
            Container(
                margin: EdgeInsets.all(2.0),
                child: Text('${values.tgl}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18.0)),
              ),
          ]
        ),
        new Expanded(
          child: ListView.builder(
            itemCount: details.length,
            itemBuilder: (context, i) {
              return Padding(
                    padding: EdgeInsets.only(left:10.0,right:10.0,bottom: 5.0),
                    child: Align
                    (
                      alignment: Alignment.topCenter,
                      child: SizedBox.fromSize
                      (
                        size: Size.fromHeight(160),
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
                                      Row(
                                        children: [
                                          Container(
                                          margin:EdgeInsets.only(right:20.0),
                                        child: Image.network(
                                          details[i].gambar,
                                          width: 90.0,
                                        )

                                      ),
                                          Column
                                          (
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            
                                            children: <Widget>
                                            [
                                              Container(
                                                margin: EdgeInsets.all(2.0),
                                                    child: Text('${details[i].sku}', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w700, fontSize: 13.0
                                                    )),
                                                  ),
                                                Container(
                                                margin: EdgeInsets.all(2.0),

                                                    child: Text('${details[i].nmBrg}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18.0
                                                    )),
                                                  ),
                                              
                                               Row(
                                                 children: [
                                                   Column
                                                   (
                                                     mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                     children: [
                                                       Container(
                                                        margin: EdgeInsets.all(2.0),

                                                            child: Text('Harga Jual: ${details[i].hrgJual}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 13.0)),
                                                          ),
                                                          Container(
                                                    margin: EdgeInsets.all(2.0),

                                                        child: Text('Diskon: ${details[i].disPersen}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 13.0)),
                                                      ),
                                                     ],
                                                   ),
                                              Column
                                              (
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.all(2.0),

                                                        child: Text('Qty: ${details[i].qty} ${details[i].satuan}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 13.0)),
                                                      ),
                                              Container(
                                                margin: EdgeInsets.all(2.0),

                                                    child: Text('Subtotal: ${details[i].subtotal}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 13.0)),
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
                        )
                      ),
                    ),
                  );
            },
          )
        )
      ]
    );
  }

}
