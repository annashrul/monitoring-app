import 'package:flutter/material.dart';
import 'package:monitoring_apps/model/laporan.dart';
import 'package:monitoring_apps/provider/monitoring_provider.dart';

class LaporanPage extends StatefulWidget
{
  @override
  _LaporanPageState createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage>
{
  int perpage=3;
  Future<List<Laporan>> getData(int limit) async {
    return await MonitoringProvider().getLaporan(limit);
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
      body: FutureBuilder(
        future: getData(perpage),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          print("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
          print(snapshot.data);
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return  Align(alignment: Alignment.center,
                child:  CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.lightBlue
                ) ,),);
            default:
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              else
                return _buildItem(context, snapshot);
          }
        },
      ),
    );
  }
// ListView
//       (
//         scrollDirection: Axis.vertical,
//         padding: EdgeInsets.symmetric(horizontal: 16.0),
//         children: <Widget>
//         [
//           _buildItem()
//         ],
//       )
//     );
  Widget _buildItem(BuildContext context, AsyncSnapshot snap){
    var values = snap.data;
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
            ):Padding(
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
                                          Text('${values[index].idOrders}', style: TextStyle(color: Colors.blueAccent)),
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
                                                child: Text('${values[index].item} item', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 17.0)),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(top: 0.0),
                                                child: Text('${values[index].kurir}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15.0)),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(top: 4.0),
                                                child: Text('Subtotal: ${values[index].subTotal}0', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15.0)),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(top: 4.0),
                                                child: Text('Ongkir:${values[index].ongkir}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15.0)),
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
                                              Text('Total:', style: TextStyle()),
                                              Padding
                                              (
                                                padding: EdgeInsets.symmetric(horizontal: 4.0),
                                                child: Text('${values[index].total}', style: TextStyle(fontWeight: FontWeight.w700)),
                                              ),
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
                  );
            },
    );
  }
}
