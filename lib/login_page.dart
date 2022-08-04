import 'dart:convert';

import 'package:fingerprint_app/correct_note_side.dart';
import 'package:fingerprint_app/saved_note.dart';
import 'package:fingerprint_app/storage.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget{
  @override
  _LoginPage createState() {
    return _LoginPage();
  }

}

class _LoginPage extends State<LoginPage>{
  final _passwordController = TextEditingController(); //_secretController
  final SecureStorage secureStorage = SecureStorage();
  //late String finalPass;

  String _secret = 'admin';
  final bool _withHmac = false;
  //final _secretController = TextEditingController();
  final Map<Algorithm, String> _algorithmMap = {
    Algorithm.SHA1: 'SHA-1',
  };

  @override
  void initState() {
    _passwordController.text = _secret;

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text('Login with password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          const Text("PLEASE LOG IN",
          style: TextStyle(height: 5, fontSize: 30),),
          Container(height: 3,),
          TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                hintText: "PASSWORD",
              ),
            onChanged: (value) => {
              setState(() {}),
            },
          ),
            Container(height: 3.0,),
            _LoginButton("LOGIN", Colors.green, () {
              secureStorage.readSecureData('password').then((value) {
                _secret = value;
                print("AAAAAAAAAAAAAAA");
                print(_secret);
                // ignore: unnecessary_null_comparison
                if (_secret == null) {
                  secureStorage.writeSecureData('password', _hashValue(Algorithm.SHA1, _passwordController.text).toString());
                  SavedPass(_secret);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("PASSWORD SAVED"),
                    duration: Duration(milliseconds: 1000),
                  ));
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Note2()));
                }
                else if ( _secret == _hashValue(Algorithm.SHA1, _passwordController.text).toString()) {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Note2()));
                } else if (_secret != _hashValue(Algorithm.SHA1, _passwordController.text).toString()){
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("INCORRECT PASSWORD"),
                    duration: Duration(milliseconds: 1000),
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
                          title: Text(algorithm.value! + ":  " + _hashValue(algorithm.key, _passwordController.text).toString()),
                          ),
                        ),
                      ),
                    ),
                ],
            )
          ]
        )
      )
    );
  }
  Digest _hashValue(Algorithm algorithm, text) {
    var bytes = utf8.encode(text); // data being hashed
    //var key = utf8.encode(_keyController.text); // data being hashed
    switch (algorithm) {
      case Algorithm.SHA1:
        return sha1.convert(bytes);
      default:
        return Digest(bytes);
    }
  }
}

class _LoginButton extends StatelessWidget {

  final String _text;
  final Color _color;
  final Function() _onPressed;


  const _LoginButton(this._text, this._color, this._onPressed);

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