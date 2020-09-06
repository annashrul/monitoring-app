import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelperWidget{
  /// Display date picker.
  Future showDatePickerQ(BuildContext context,tanggal) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _format = 'yyyy-MM-dd';
    const String MIN_DATETIME = '2010-05-12';
    const String MAX_DATETIME = '2021-11-25';
    const String INIT_DATETIME = '2019-05-17';
    DateTime _dateTime = DateTime.parse(INIT_DATETIME);
    DateTimePickerLocale _locale = DateTimePickerLocale.id;
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
        _dateTime = dateTime;
      },
      onConfirm: (dateTime, List<int> index) {
        _dateTime = dateTime;
        String tgl = '${_dateTime.year}-${_dateTime.month.toString().padLeft(2, '0')}-${_dateTime.day.toString().padLeft(2, '0')}';
        prefs.setString('tanggal1',tgl);
        tanggal = tgl;
      },
    );
    return tanggal;
  }

  defaultFont(BuildContext context){
    return TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black,fontFamily: 'Rubik');
  }

  myTextStyle(BuildContext context,String txt,TextAlign textAlign,double fontSize,FontWeight fontWeight, Color color){
    return Text(txt,
        style:TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: color,fontFamily: 'Rubik')
    );
  }
  void showInSnackBar(_scaffoldKey,BuildContext context,String value,param) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value,textAlign: TextAlign.center,style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold, fontFamily: 'Rubik')),
      backgroundColor: param=='failed' ? Color(0xFFd50000) : Color(0xFF30cc23),
      duration: Duration(seconds: 3),
    ));
    return;
  }
  void fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
    return;
  }
  entryField(BuildContext context,TextInputAction textInputAction,Function() isSubmit, TextEditingController txtCtrl,FocusNode focusNode, String title,Widget iconq,{bool isPassword = false, String hint = '', bool read=false, Function onIcon}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          HelperWidget().myTextStyle(context, title,TextAlign.center, 15.0, FontWeight.bold,Colors.black),
          SizedBox(height: 10),
          TextFormField(
            readOnly:read ,
            controller: txtCtrl,
            focusNode: focusNode,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black,fontFamily: 'Rubik'),
            obscureText: isPassword,
            decoration: InputDecoration(
                border: InputBorder.none,fillColor: Color(0xfff3f3f4),filled: true,
                suffixIcon: IconButton(
                  onPressed: onIcon,
                  icon: iconq,
                  color: Colors.grey,
                ),
                hintText: hint
            ),

            onFieldSubmitted: (term){
              isSubmit();
            },
            textInputAction: textInputAction,
          ),
        ],
      ),
    );
  }
  void normalNavigator(BuildContext context,Widget xWidget){
    Navigator.of(context, rootNavigator: true).push(
      new CupertinoPageRoute(builder: (context) => xWidget),
    );
    return;
  }
  void returnDataNavigator(BuildContext context,Widget xWidget,Function xFunction){
    Navigator.of(context, rootNavigator: true).push(
      new CupertinoPageRoute(builder: (context) => xWidget),
    ).then((val){
      xFunction();
    });
    return;
  }
  void removeNavigator(BuildContext context,Widget Function(BuildContext context) xFunction){
    Navigator.of(context).pushAndRemoveUntil(CupertinoPageRoute(builder: xFunction), (Route<dynamic> route) => false);
    return;
  }

}


class BezierContainer extends StatelessWidget {
  const BezierContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Transform.rotate(
          angle: -pi / 3.5,
          child: ClipPath(
            clipper: ClipPainter(),
            child: Container(
              height: MediaQuery.of(context).size.height *.5,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xfffbb448),Color(0xffe46b10)]
                  )
              ),
            ),
          ),
        )
    );
  }
}

class ClipPainter extends CustomClipper<Path>{
  @override

  Path getClip(Size size) {
    var height = size.height;
    var width = size.width;
    var path = new Path();

    path.lineTo(0, size.height );
    path.lineTo(size.width , height);
    path.lineTo(size.width , 0);

    /// [Top Left corner]
    var secondControlPoint =  Offset(0  ,0);
    var secondEndPoint = Offset(width * .2  , height *.3);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);



    /// [Left Middle]
    var fifthControlPoint =  Offset(width * .3  ,height * .5);
    var fiftEndPoint = Offset(  width * .23, height *.6);
    path.quadraticBezierTo(fifthControlPoint.dx, fifthControlPoint.dy, fiftEndPoint.dx, fiftEndPoint.dy);


    /// [Bottom Left corner]
    var thirdControlPoint =  Offset(0  ,height);
    var thirdEndPoint = Offset(width , height  );
    path.quadraticBezierTo(thirdControlPoint.dx, thirdControlPoint.dy, thirdEndPoint.dx, thirdEndPoint.dy);



    path.lineTo(0, size.height  );
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }


}

class NoConnectionWidget extends StatefulWidget {
  @override
  _NoConnectionWidgetState createState() => _NoConnectionWidgetState();
}

class _NoConnectionWidgetState extends State<NoConnectionWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Image.asset('res/no_internet.jpg',height: 100),
              ),
              SizedBox(height: 20.0),
              Center(
                child: Text("Tidak Ada Koneksi Internet",style: TextStyle(fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
