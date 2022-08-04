import 'package:fingerprint_app/note.dart';
import 'package:fingerprint_app/saved_note.dart';
import 'package:fingerprint_app/storage.dart';
import 'package:flutter/material.dart';

class PassResetPage extends StatefulWidget{
  @override
  _PassResetPage createState() {
    return _PassResetPage();
  }

}

class _PassResetPage extends State<PassResetPage>{
  final _passwordResetController = TextEditingController();
  final SecureStorage secureStorage = SecureStorage();
  late String oldpass;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Reset password'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("YOU CAN RESET YOUR PASSWORD",
                    style: TextStyle(height: 5, fontSize: 10),),
                  Container(height: 3,),
                  TextField(
                    controller: _passwordResetController,
                    decoration: InputDecoration(
                      hintText: "NEW PASSWORD",
                    ),
                  ),
                  Container(height: 10.0,),
                  _PassResetButton("CHANGE", Colors.green, () {
                    secureStorage.readSecureData('password').then((value) {
                      oldpass = value;
                      secureStorage.deleteSecureData('password');
                      secureStorage.writeSecureData(
                          'password', _passwordResetController.text);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("PASSWORD RESET"),
                        duration: const Duration(milliseconds: 1000),
                      ));
                      Navigator.pop(context);
                    });
                  })]
            )
        )
    );
  }
}

class _PassResetButton extends StatelessWidget {

  final String _text;
  final Color _color;
  final Function() _onPressed;


  _PassResetButton(this._text, this._color, this._onPressed);

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