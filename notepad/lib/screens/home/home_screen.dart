import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notepad/managers/firebase_note_manager.dart';
import 'package:notepad/managers/note_manager.dart';
import 'package:notepad/models/note_model.dart';
import 'package:notepad/screens/onboarding/onboarding_screen.dart';
import 'package:notepad/screens/profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  var useGridView = false;

  // This is the first function called when a class is added to the widget tree
  // ie when a class is created

  var noteManager = NoteManager();
  var firebaseNoteManager = FirebaseNoteManager();
  late Future<List<NoteModel>> _notes;

  @override
  void initState() {
    _notes = noteManager.fetchAllNotes();
    super.initState();
  }

  //This is called when a class is destroyed or removed from the widget tree
  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  XFile imageFromPhonePath = XFile('');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(20.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Everything notes',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.w600),
                ),
                InkWell(
                    onTap: () {
                      setState(() {
                        useGridView = !useGridView;
                      });
                    },
                    child: Icon(Icons.swap_horiz_sharp)),
                InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ProfileScreen()));
                    },
                    child: Icon(Icons.account_circle)),
                InkWell(
                    onTap: () async {
                     await FirebaseAuth.instance.signOut();
                     Navigator.of(context).pushReplacement(MaterialPageRoute(
                         builder: (context) => const OnboardingScreen()));
                    },
                    child: Icon(Icons.logout)),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            FutureBuilder<List<NoteModel>>(
                future: _notes,
                builder: (context, snapshot){
                  if(snapshot.hasError){
                    return Center(child: Text('Error ${snapshot.error}'),);
                  }
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(child: Text('Loading.....'),);
                  }
                  return snapshot.data!.isNotEmpty
                      ? !useGridView
                      ? Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      children:
                      List.generate(snapshot.data!.length, (index) {
                        return noteItem(snapshot.data![index], index);
                      }),
                    ),
                  )
                      : Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return noteItem(snapshot.data![index], index);
                        }),
                  )
                      : const Expanded(
                    child: Center(
                      child: Text(
                        'No notes yet!',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  );
                }
            ),

          ]),
        )),
        floatingActionButton: GestureDetector(
          onTap: () {
            // titleController.clear();
            // descriptionController.clear();
            // imageFromPhonePath = XFile("");
            // showDialog(
            //     context: context,
            //     builder: (BuildContext context) {
            //       return AlertDialog(
            //         title: const Text(
            //           'New\nnote',
            //           style: TextStyle(
            //               color: Colors.black, fontWeight: FontWeight.bold),
            //         ),
            //         content: Column(
            //           children: [
            //             TextField(
            //               controller: titleController,
            //               decoration: const InputDecoration(hintText: 'Title'),
            //               style: const TextStyle(color: Colors.black),
            //             ),
            //             TextField(
            //               controller: descriptionController,
            //               decoration:
            //                   const InputDecoration(hintText: 'Description'),
            //               style: const TextStyle(color: Colors.black),
            //             ),
            //             Visibility(
            //                 visible: imageFromPhonePath.path != "",
            //                 child: Image.file(File(imageFromPhonePath.path))),
            //             GestureDetector(
            //                 onTap: (){
            //                   pickImageFromGallery();
            //                 },
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(20.0),
            //                   child: Text('Pick image'),
            //                 ))
            //           ],
            //         ),
            //         actions: [
            //           ElevatedButton(
            //               onPressed: () {
            //                 Navigator.pop(context);
            //               },
            //               child: const Text('Cancel')),
            //           ElevatedButton(
            //               onPressed: () {
            //                 noteManager.saveNote(NoteModel(
            //                   noteImage: imageFromPhonePath.path,
            //                     noteId: DateTime.now().toString(),
            //                     noteTitle: titleController.text,
            //                     noteDescription: descriptionController.text));
            //                 _notes = noteManager.fetchAllNotes();
            //                 setState(() {
            //
            //                 });
            //                 Navigator.pop(context);
            //               },
            //               child: const Text('Submit')),
            //         ],
            //       );
            //     });
            firebaseNoteManager.update();

          },
          child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                  color: Colors.deepPurple, shape: BoxShape.circle),
              child: const Text(
                'New\nnote',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )),
        ));
  }

  pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    var filePath = await picker.pickImage(source: ImageSource.gallery);
    if(filePath != null){
      setState(() {
        imageFromPhonePath = filePath;
      });
    }
  }

  Widget noteItem(NoteModel noteItem, int noteIndex) {
    return GestureDetector(
      onLongPress: () {
        {
          titleController.text = noteItem.noteTitle;
          descriptionController.text = noteItem.noteDescription;
          print(noteItem.noteImage);
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text(
                    'Update note',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  content: Column(
                    children: [
                      Visibility(
                          visible: noteItem.noteImage != "",
                          child: Image.file(File(noteItem.noteImage))),
                      TextField(
                        controller: titleController,
                        decoration: const InputDecoration(hintText: 'Title'),
                        style: const TextStyle(color: Colors.black),
                      ),
                      TextField(
                        controller: descriptionController,
                        decoration:
                        const InputDecoration(hintText: 'Description'),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel')),
                    ElevatedButton(
                        onPressed: () {
                          noteManager.deleteNote(noteItem.noteId);
                          setState(() {
                            _notes = noteManager.fetchAllNotes();
                          });
                          titleController.clear();
                          descriptionController.clear();
                          Navigator.pop(context);
                        },
                        child: const Text('Delete')),
                    ElevatedButton(
                        onPressed: () {
                          noteManager.saveNote(NoteModel(
                            noteImage: noteItem.noteImage,
                              noteId: noteItem.noteId,
                              noteTitle: titleController.text,
                              noteDescription: descriptionController.text));
                          titleController.clear();
                          descriptionController.clear();
                          setState(() {
                            _notes = noteManager.fetchAllNotes();
                          });
                          Navigator.pop(context);
                        },
                        child: const Text('Update')),
                  ],
                );
              });
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15, right: 5, left: 5),
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.1),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                noteItem.noteTitle,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    overflow: TextOverflow.clip,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                noteItem.noteDescription,
                style: TextStyle(
                    color: Colors.black.withOpacity(.4),
                    fontSize: 13,
                    overflow: TextOverflow.clip,
                    fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
