import 'package:fingerprint_app/change_password.dart';
import 'package:fingerprint_app/my_encryption.dart';
import 'package:fingerprint_app/preferences_service.dart';
import 'package:fingerprint_app/reset_password.dart';
import 'package:fingerprint_app/saved_note.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class Note extends StatefulWidget {
  @override
  _NoteState createState() {
    return new _NoteState();
  }
}

class _NoteState extends State<Note>{
  final _preferencesService = PreferencesService();
  final  _textController = TextEditingController();
  final _encController = TextEditingController();
  final _answerController = TextEditingController();
  var encryptedText;
  var plainText, plainText2;
  var answer;
  bool usedPass = false;

  @override
  void initState() {
    super.initState();
    _populateNote();

    print(usedPass);
  }
  void _populateNote() async{
    final note = await _preferencesService.getNoteFunction();
    setState((){
      //_textController.text = note.noteText;
      /*_encController.text */encryptedText = note.encodedNote;
      //encryptedText = note.keyPass;
     _answerController.text = answer;
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
            Column(
              children: [
                Text(encryptedText == null ? "" : encryptedText is encrypt.Encrypted ? encryptedText.base64 : encryptedText),
              ],
            ),
            Container(height: 5,),
            TextField(
              controller: _encController,
              decoration: InputDecoration(
                hintText: "",
              ),
            ),
            TextField(
              controller: _answerController,
              decoration: InputDecoration(
                hintText: "",
              ),
            ),
            Container(height: 5,),

            _NoteButton("ENCRYPT", Colors.red, (){
              plainText = _textController.text;
              setState(() {
                encryptedText = MyEncryptionDecryption.encryptAES(plainText);
                //_textController.text = "";
                _answerController.text = MyEncryptionDecryption.pass;
                answer = _answerController.text;
                print(encryptedText);
              });
            }),
            _NoteButton("DECRYPT", Colors.blueAccent, (){
              if (usedPass == false){
              setState(() {
                _encController.text = MyEncryptionDecryption.decryptAES(encryptedText);
              });
              } /*else if (usedPass == true){
                setState(() {
                  _encController.text = MyEncryptionDecryption.decryptAES(_textController.text);
                });
              }*/
            }),
            _NoteButton("SAVE", Colors.greenAccent, _saveNote),
/*            Text(_keyController.text),
           Container(height: 10),*/
            //Text(_encController.text),
          ],
        ),
      ),

     /* floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
        FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => PassChangePage()));
        },
        child: Icon(Icons.settings),
      ),
        FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => PassChangePage()));
        },
        child: Icon(Icons.password),
      )],
     ),*/
    );
  }

  void _saveNote(){
    final newNote = SavedNote(/*_textController.text,*/ /*_encController.text,*/ MyEncryptionDecryption.pass/*answer,*/);

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