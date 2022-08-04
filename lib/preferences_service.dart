import 'package:flutter/material.dart';

import 'package:fingerprint_app/saved_note.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService{

  Future saveNoteFunction(SavedNote savedNote) async{
    final preferences = await SharedPreferences.getInstance();
    
   // await preferences.setString('note', savedNote.noteText);
    await preferences.setString('encodedNote', savedNote.encodedNote);
   // await preferences.setString('keyPass', savedNote.keyPass);
  }

  Future<SavedNote> getNoteFunction() async {
    final preferences = await SharedPreferences.getInstance();

    //final note = preferences.getString('note');
    final encodedNote = preferences.getString('encodedNote');
    //final keyPass = preferences.getString('keyPass');

    return SavedNote(/*note!, */encodedNote!, /*keyPass!*/);
  }

  Future savePassFunction(SavedPass savedPass) async{
    final preferences = await SharedPreferences.getInstance();

    await preferences.setString('password', savedPass.pass);
  }

  Future<SavedPass> getPassFunction() async {
    final preferences = await SharedPreferences.getInstance();

    final pass = preferences.getString('password');


    return SavedPass(pass!);
  }
}