import 'package:flutter/material.dart';
import 'package:notepad/models/note_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<NoteModel> allNotes = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  // This is the first function called when a class is added to the widget tree
  // ie when a class is created
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  //This is called when a class is destroyed or removed from the widget tree
  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(20.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text(
              'Everything notes',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 20,
            ),
            allNotes.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                        itemCount: allNotes.length,
                        itemBuilder: (BuildContext context, int index) {
                          return noteItem(allNotes[index], index);
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
                  ),
          ]),
        )),
        floatingActionButton: GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text(
                      'New\nnote',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    content: Column(
                      children: [
                        TextField(
                          controller: titleController,
                          decoration: const InputDecoration(hintText: 'Title'),
                          style: const TextStyle(color: Colors.black),
                        ),
                        TextField(
                          controller: descriptionController,
                          decoration: const InputDecoration(hintText: 'Description'),
                          style: const TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                    actions: [
                      ElevatedButton(onPressed: () {
                        Navigator.pop(context);
                      }, child: const Text('Cancel')),
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              allNotes.add(NoteModel(
                                  noteId: allNotes.length+1,
                                  noteTitle: titleController.text,
                                  noteDescription: descriptionController.text));
                            });
                            titleController.clear();
                            descriptionController.clear();
                            Navigator.pop(context);
                          },
                          child: const Text('Submit')),
                    ],
                  );
                });
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

  Widget noteItem(NoteModel noteItem, int noteIndex) {
    return GestureDetector(
      onLongPress: (){
        setState(() {
          allNotes.remove(noteItem);
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.1),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                noteItem.noteId.toString(),
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    noteItem.noteTitle,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
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
                        fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
