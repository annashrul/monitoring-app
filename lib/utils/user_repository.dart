import 'dart:async';

import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {

  Future<String> setLogin({
    @required String islogin,

  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', islogin);
    return islogin;
  }

  Future<void> destroy() async {
    /// delete from keystore/keychain
    // await Future.delayed(Duration(seconds: 1));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
    return;
  }


  Future<bool> isLogin() async {
    /// read from keystore/keychain
    // await Future.delayed(Duration(seconds: 1));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    if(token!=null){
      return true;
    }else{
      return false;
    }
  }
}
