import 'package:flutter/material.dart';
import 'package:notepad/models/note_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<NoteModel> allNotes = [];

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
            setState(() {
              allNotes.add(NoteModel(
                  noteId: 0,
                  noteTitle: 'New note',
                  noteDescription:
                      'The default placeholder is an empty box (LimitedBox) - although if a height or width is specified on the SvgPicture, a SizedBox will be used instead (which ensures better layout experience). There is currently no way to show an Error visually, however errors will get properly logged to the console in debug mode.'));
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
      onTap: (){
        setState(() {
          allNotes.removeAt(noteIndex);
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
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
        ),
      ),
    );
  }
}
