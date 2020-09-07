import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monitoring_apps/pages/helper/helper_widget.dart';
import 'package:monitoring_apps/pages/main_page.dart';
import 'package:monitoring_apps/provider/monitoring_provider.dart';
import 'package:monitoring_apps/utils/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLoading = false, isServer = true;
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  var serverAddressController = TextEditingController();
  final FocusNode usernameFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode serverAddressFocus = FocusNode();

  Future _Login() async {
    setState(() {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 100.0),
              child: AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CircularProgressIndicator(
                        strokeWidth: 10.0,
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.black)),
                    SizedBox(height: 5.0),
                    Text("Tunggu Sebentar .....",
                        style: TextStyle(
                            fontFamily: 'Rubik', fontWeight: FontWeight.bold))
                  ],
                ),
              ));
        },
      );
    });

    final prefs = await SharedPreferences.getInstance();

    if (usernameController.text == '' || passwordController.text == '') {
      setState(() {
        Navigator.pop(context);
      });

      return HelperWidget().showInSnackBar(_scaffoldKey, context,
          'username atau password tidak boleh kosong', 'failed');
    } else {
      setState(() {
        Navigator.pop(context);
      });
      var result = MonitoringProvider()
          .login(usernameController.text, passwordController.text);
      result.then((val) {
        if (val.status == true) {
          prefs.setString('nama', val.data.title);
          UserRepository().setLogin(islogin: val.pesan);
          HelperWidget().removeNavigator(context, (context) => MainPage());
        } else {
          return HelperWidget()
              .showInSnackBar(_scaffoldKey, context, val.pesan, 'failed');
        }
        setState(() {});
      });
    }
  }

  Future setServer() async {
    setState(() {
      isLoading = false;
    });
    if (serverAddressController.text == '') {
      return HelperWidget().showInSnackBar(
          _scaffoldKey, context, 'silahkan masukan alamat server', 'failed');
    } else {
      try {
        String url = 'http://' + serverAddressController.text + "/auth/check";

        final jsonString = await http.get(url).timeout(Duration(seconds: 20));
        print(jsonString);
        if (jsonString.statusCode == 200) {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString(
              'serverAddress', 'http://' + serverAddressController.text);
          setState(() {
            isServer = false;
          });
        } else {
          throw Exception('Failed to load photos');
        }
      } catch (e) {
        return HelperWidget().showInSnackBar(_scaffoldKey, context,
            'Tidak dapat tersambung dengan server.', 'failed');
      }
    }
  }

  bool checkServer = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UserRepository().isServerAddress().then((val) {
      checkServer = true;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        body: buildContents(context),
      ),
    );
  }

  Widget buildContents(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: SizedBox(),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Hero(
                        tag: 'Monitoring',
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 50.0,
                          child: Image.asset('res/logo.png'),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                checkServer != true
                    ? isServer ? authServerAddress(context) : authPages(context)
                    : authPages(context),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      isLoading = true;
                    });
                    isServer ? setServer() : _Login();
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.grey.shade200,
                                offset: Offset(2, 4),
                                blurRadius: 5,
                                spreadRadius: 2)
                          ],
                          gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Color(0xfffbb448), Color(0xfff7892b)])),
                      child: HelperWidget().myTextStyle(
                          context,
                          "MASUK",
                          TextAlign.center,
                          20.0,
                          FontWeight.bold,
                          Colors.white)),
                ),
                Expanded(
                  flex: 2,
                  child: SizedBox(),
                ),
              ],
            ),
          ),
          Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer())
        ],
      ),
    ));
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

  Widget authPages(BuildContext context) {
    return Column(
      children: <Widget>[
        HelperWidget().entryField(context, TextInputAction.next, () {
          HelperWidget()
              .fieldFocusChange(context, usernameFocus, passwordFocus);
        }, usernameController, usernameFocus, "Username",
            Icon(Icons.person_pin)),
        HelperWidget().entryField(context, TextInputAction.done, () {},
            passwordController, passwordFocus, "Password", Icon(Icons.lock),
            isPassword: true)
      ],
    );
  }

  Widget authServerAddress(BuildContext context) {
    return Column(
      children: <Widget>[
        HelperWidget().entryField(
            context,
            TextInputAction.done,
            () {},
            serverAddressController,
            serverAddressFocus,
            "Server Address",
            Icon(Icons.link),
            isPassword: false)
      ],
    );
  }
}
