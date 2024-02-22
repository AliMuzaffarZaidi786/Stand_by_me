
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stand_by_me/pages/App%20Manager/editible_text_widget.dart';
import 'package:stand_by_me/pages/App%20Manager/enum.dart';
import 'package:stand_by_me/pages/notes_list.dart';
import 'package:stand_by_me/pages/provider/provider.dart';
import 'App Manager/colors.dart';

class NoteView extends StatefulWidget {
  final String item;
  final int? index;
  const NoteView({Key? key, required this.item, this.index}) : super(key: key);

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  @override
  Widget build(BuildContext context) {
    ListeningProvider listenVM =
        Provider.of<ListeningProvider>(context, listen: true);
    return WillPopScope(
      onWillPop: () async {
        listenVM.isListening = Pages.listening;
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    CustomColor.newPurple,
                    CustomColor.newPurple2
                  ]),
            ),
          ),
          title: const Text('Edit Note'),
        ),
        floatingActionButton: InkWell(
          onTap: () {
            if (widget.index != null) {
              if (listenVM.isChanged == false) {
                if (kDebugMode) {
                  print('${listenVM.isChanged} changed');
                }
              } else {
                listenVM.notes[widget.index ?? 0] = listenVM.collectedNoteText;
                listenVM.saveList();
                setState(() {
                  listenVM.collectedNoteText = '';
                });
              }
            } else {
              if (listenVM.collectedNoteText.isNotEmpty &&
                  listenVM.collectedNoteText != '') {
                listenVM.notes.add(listenVM.collectedNoteText);
                listenVM.saveList();
                setState(() {
                  listenVM.collectedNoteText = '';
                });
              }
            }
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context2) => const NotesList(),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: CustomColor.newPurple2,
              borderRadius: BorderRadius.circular(10),
            ),
            height: 70,
            width: 150,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Done',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
                Icon(
                  Icons.add_circle,
                  color: Colors.white,
                  size: 35,
                ),
              ],
            ),
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          color: CustomColor.background,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  EditableTextWidget(note: widget.item),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}