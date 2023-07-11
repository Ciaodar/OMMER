import 'package:flutter/foundation.dart';

class User with ChangeNotifier {
  User();

  String? _qrUid;
  String? _uid;
  String? _roomid;



  String? _name;
  String? _mail;
  String? _password;
  int? _role;
  bool _checkedIn=false;






  //User.name(this._uid,this._qrUid, this._name, this._mail, this._password, this._role,this.checkedIn);


  String? get roomid => _roomid;

  set roomid(String? value) {
    _roomid = value;
  }

  bool get checkedIn => _checkedIn;
  set checkedIn(bool value) {
    _checkedIn = value;
    notifyListeners();
  }

  String? get qrUid => _qrUid;
  set qrUid(String? value) {
    _qrUid = value;
    notifyListeners();
  }

  String? get uid => _uid;
  set uid(String? value) {
    _uid = value;
    notifyListeners();
  }

  String? get name => _name;
  set name(String? value) {
    _name = value;
    notifyListeners();
  }

  String? get mail => _mail;
  set mail(String? value) {
    _mail = value;
    notifyListeners();
  }

  String? get password => _password;
  set password(String? value) {
    _password = value;
    notifyListeners();
  }

  int? get role => _role;
  set role(int? value) {
    _role = value;
    notifyListeners();
  }

  // Other methods and functionalities
  void resetUser(){
    _qrUid=null;
    _uid=null;
    _name=null;
    _mail=null;
    _password=null;
    _role=null;
    _checkedIn=false;
    _roomid=null;
    notifyListeners();
  }

  void updateUserInfo({String? roomid,String? uid,String? qrUid, String? name, String? mail, String? password, int? role, bool? checkedIn}) {
    if (roomid != null) {
      _roomid = roomid;
    }
    if (qrUid != null) {
      _qrUid = qrUid;
    }
    if (uid != null) {
      _uid = uid;
    }
    if (name != null) {
      _name = name;
    }
    if (mail != null) {
      _mail = mail;
    }
    if (password != null) {
      _password = password;
    }
    if (role != null) {
      _role = role;
    }
    if (checkedIn != null) {
      _checkedIn = checkedIn;
    }
    notifyListeners();
  }
}