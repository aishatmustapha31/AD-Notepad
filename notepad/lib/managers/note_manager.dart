import 'dart:convert';

import 'package:notepad/models/note_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoteManager{

  saveNote(NoteModel noteModel) async {
    final pref = await SharedPreferences.getInstance();
    final noteJson = noteModel.toJson();
    pref.setString('note_${noteModel.noteId}', json.encode(noteJson));
  }

  deleteNote(String noteId) async {
    final pref = await SharedPreferences.getInstance();
    pref.remove('note_$noteId');
  }

  Future<List<NoteModel>> fetchAllNotes() async {
    final pref = await SharedPreferences.getInstance();
    final keys = pref.getKeys();
    final notes = <NoteModel>[];
    for(final key in keys){
      if(key.startsWith('note_')){
        final noteJson = pref.getString(key);
        if(noteJson != null){ 
          notes.add(NoteModel.fromJson(json.decode(noteJson)));
        }
      }
    }
    return notes;
  }
}