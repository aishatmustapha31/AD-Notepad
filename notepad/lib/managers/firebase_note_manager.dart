import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseNoteManager{

  //Basic CRUD operation with firestore database.

  var db = FirebaseFirestore.instance;
  var firestore = FirebaseAuth.instance;

  Future<String> getUserId() async{
    var userId = "";
    if(firestore.currentUser != null){
      userId = firestore.currentUser!.uid;
    }else{
      userId = "no_id";
    }
    return userId;
  }


  var user = <String, dynamic>{
    "name": "Aisha",
    "surname": "Bello Aishta",
    "age": 30,
    "profession": "Barrister"
  };

  saveUserData() async {
    var userId = await getUserId();
    var doc = db.collection("users").doc(userId).set(user);
  }

  readData() async {
    var userId = await getUserId();
    var myData = await db.collection("users").doc(userId).get();
    if(myData.exists){
      print("True");
      print(myData['age']);
      print(myData['profession']);
      print(myData['surname']);
      print(myData['name']);
    }else{
      print("False");
    }
  }

  update() async {
    var newData = <String, dynamic>{
      "profession": "Mobile App Developer",
      "gender": "Female"
    };
    var userId = await getUserId();
    await db.collection("users").doc(userId).update(newData);
  }

  delete() async {
    var userId = await getUserId();
    await db.collection("users").doc(userId).delete();
  }
}