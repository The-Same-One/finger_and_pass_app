import 'package:fingerprint_app/change_password.dart';
import 'package:fingerprint_app/my_encryption.dart';
import 'package:fingerprint_app/preferences_service.dart';
import 'package:fingerprint_app/reset_password.dart';
import 'package:fingerprint_app/saved_note.dart';
import 'package:fingerprint_app/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class Note2 extends StatefulWidget {
  @override
  _Note2State createState() {
    return new _Note2State();
  }
}

class _Note2State extends State<Note2>{
  final _preferencesService = PreferencesService();
  final  _textController = TextEditingController();
  final SecureStorage secureStorage = SecureStorage();
  late String noteText;

  @override
  void initState() {
    super.initState();
    _populateNote();
  }
  void _populateNote() async{
    //final note = await _preferencesService.getNoteFunction();
    secureStorage.readSecureData('note').then((value) {
      noteText = value;
      setState((){
        _textController.text = noteText;
      });
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NOTE'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: "Note text",
              ),
            ),
            Container(height:5,),
/*            Column(
              children: [
                Text(encryptedText == null ? "" : encryptedText is encrypt.Encrypted ? encryptedText.base64 : encryptedText),
              ],
            ),
            Container(height: 5,),
            TextField(
              controller: _answerController, //do zapisania
              decoration: InputDecoration(
                hintText: "",
              ),
            ),
            TextField(
              controller: _encController,
              decoration: InputDecoration(
                hintText: "",
              ),
            ),
            Container(height: 5,),*/

            /*_NoteButton("ENCRYPT", Colors.red, (){
              plainText = _textController.text;
              setState(() {
                encryptedText = MyEncryptionDecryption.encryptAES(plainText);
                _answerController.text = MyEncryptionDecryption.pass;
                answer = _answerController.text;
                print(encryptedText);
              });
            }),
            _NoteButton("DECRYPT", Colors.blueAccent, (){
                setState(() {
                  _encController.text = MyEncryptionDecryption.decryptAES(encryptedText.base64);
                });

            }),
            _NoteButton("SAVE", Colors.greenAccent, _saveNote),*/
            _NoteButton("SAVE", Colors.greenAccent, (){
              secureStorage.readSecureData('note').then((value) {
              noteText = value;
              if(noteText == null){
                  secureStorage.writeSecureData('note', _textController.text);
              } else if (noteText != null){
                secureStorage.deleteSecureData('note');
                secureStorage.writeSecureData('note', _textController.text);
              }
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("NOTE SAVED"),
                duration: const Duration(milliseconds: 1000),
              ));
            }
            );
            })
    ],
        ),
      ),
      floatingActionButton: SpeedDial(
          icon: Icons.share,
          backgroundColor: Colors.greenAccent,
          children: [
            SpeedDialChild(
              child: const Icon(Icons.settings),
              label: 'Change Password',
              backgroundColor: Colors.greenAccent,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => PassChangePage()));
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.password),
              label: 'Reset Password',
              backgroundColor: Colors.greenAccent,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => PassResetPage()));
              },
            ),
          ]),
      /*floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => PassChangePage()));
        },
        child: Icon(Icons.settings),
      ),*/
    );
  }

  void _saveNote(){
    final newNote = SavedNote( MyEncryptionDecryption.pass);

    _preferencesService.saveNoteFunction(newNote);
  }
}

class _NoteButton extends StatelessWidget {

  final String _text;
  final Color _color;
  final Function() _onPressed;


  _NoteButton(this._text, this._color, this._onPressed);

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