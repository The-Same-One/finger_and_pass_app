import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:fingerprint_app/storage.dart';
import 'package:flutter/material.dart';
import 'package:fingerprint_app/login_page.dart';

class PassChangePage extends StatefulWidget{
  @override
  _PassChangePage createState() {
    return _PassChangePage();
  }
}

class _PassChangePage extends State<PassChangePage>{
  final _passwordChangeController = TextEditingController();
  final _oldPasswordController = TextEditingController();
  final SecureStorage secureStorage = SecureStorage();
  late String oldpass;
  String newPass = '';

  final Map<Algorithm, String> _algorithmMap = {
    Algorithm.SHA1: 'SHA-1',
  };

  @override
  void initState() {
    _passwordChangeController.text = newPass;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Changing password'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("YOU CAN CHANGE YOUR PASSWORD",
                    style: TextStyle(height: 5, fontSize: 10),),
                  Container(height: 3,),
                  TextField(
                    controller: _oldPasswordController,
                    decoration: InputDecoration(
                      hintText: "OLD PASSWORD",
                    ),
                  ),
                  Container(height: 3,),
                  TextField(
                    controller: _passwordChangeController,
                    decoration: InputDecoration(
                      hintText: "NEW PASSWORD",
                    ),
                    onChanged: (value) => {
                      setState(() {}),
                    },
                  ),
                  Container(height: 10.0,),
                  _PassChnageButton("CHANGE", Colors.green, () {
                    secureStorage.readSecureData('password').then((value) {
                      oldpass = value;
                      if (_hashValue(Algorithm.SHA1, _oldPasswordController.text).toString() == oldpass) {
                        secureStorage.deleteSecureData('password');
                        secureStorage.writeSecureData(
                            'password', _hashValue(Algorithm.SHA1, _passwordChangeController.text).toString());
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("PASSWORD CHANGED"),
                          duration: const Duration(milliseconds: 1000),
                        ));
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("INCORECT OLD PASSWORD"),
                          duration: const Duration(milliseconds: 1000),
                        ));
                      }
                    });
                  }),
            Column(
              children: [
                for (MapEntry algorithm in _algorithmMap.entries)
                  SizedBox(
                    child: Card(
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                      ),
                        child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                        title: Text(algorithm.value!),
                        subtitle:
                        Text(_hashValue(algorithm.key, _passwordChangeController.text).toString()),
                              ),
                          ),
                            ),
                          ),
                  ],
                )
            ]
          ),
        )
      );
  }
  Digest _hashValue(Algorithm algorithm, text) {
    var bytes = utf8.encode(text); // data being hashed
    switch (algorithm) {
      case Algorithm.SHA1:
        return sha1.convert(bytes);
      default:
        return Digest(bytes);
    }
  }
}

class _PassChnageButton extends StatelessWidget {

  final String _text;
  final Color _color;
  final Function() _onPressed;


  _PassChnageButton(this._text, this._color, this._onPressed);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: _onPressed,
      child: Text(
        _text,
        style: TextStyle(color: Colors.white),
      ),
      height: 30,
      minWidth: 80,
      color: _color,
    );
  }
}
enum Algorithm {
  SHA1,
}