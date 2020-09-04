import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monitoring_apps/model/laporan_stock/laporanStockUtamaModel.dart';
import 'package:monitoring_apps/pages/laporan_page_detail.dart';
import 'package:monitoring_apps/provider/stock_provider.dart';

class LaporanStockUtama extends StatefulWidget {
  @override
  _LaporanStockUtamaState createState() => _LaporanStockUtamaState();
}

class _LaporanStockUtamaState extends State<LaporanStockUtama> {
  var perpage=3;
  Future<LaporanStockUtamaModel> getData(var limit) async {
    return await StockProvider().getLaporanStock(limit,'2020-01-01','2020-09-04');
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
    print(values);
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
                          child: Text('acuy')
                        ),
                        /// Item image

                      ],
                    )
                ),
              ),
            ),
            onTap: (){}
        );
      },
    );
  }
}
