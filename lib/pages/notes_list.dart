
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stand_by_me/pages/App%20Manager/colors.dart';
import 'package:stand_by_me/pages/App%20Manager/enum.dart';
import 'package:stand_by_me/pages/notes_view.dart';
import 'package:stand_by_me/pages/provider/provider.dart';

class NotesList extends StatefulWidget {
  const NotesList({Key? key}) : super(key: key);

  @override
  State<NotesList> createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {

  @override
  Widget build(BuildContext context) {
    ListeningProvider listenVM =
        Provider.of<ListeningProvider>(context, listen: false);

    return WillPopScope(
      onWillPop: ()  async{
        listenVM.isListening=Pages.listening;
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration:  const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[CustomColor.newPurple, CustomColor.newPurple2]),
            ),
          ),
          title: const Text('Great Voice Notes'),
        ),
        backgroundColor: Colors.white,
        body: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          itemCount: listenVM.getNotes.length,
          itemBuilder: (BuildContext context, int index) {
            var item = listenVM.getNotes[index];
            return ZoomIn(

              duration: const Duration(milliseconds: 700),
              delay:  Duration(milliseconds: index*100),
              child: FadeIn(
                duration: const Duration(milliseconds: 700),
                delay:  Duration(milliseconds: index*100),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context2) => NoteView(item: item, index: index),),);
                      },
                    child: Stack(
                      children: [
                        Container(
                            height: 200,
                            decoration: BoxDecoration(
                              boxShadow: const <BoxShadow>[
                                BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(-8.0, 8.0),
                                    blurRadius: 4.0),
                              ],
                              gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: <Color>[
                                  CustomColor.newPurple2,
                                  CustomColor.newPurple,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(
                                    item.toString(),
                                    style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w700,
                                        overflow: TextOverflow.fade,
                                        color: Colors.white70),
                                    softWrap: true,
                          ),
                                ))),
                        Positioned(
                          right: 20,
                          bottom: 20,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                alert(context, index);
                              });
                              },
                            child: Container(
                                height: 50,
                                width: 50,

                                decoration: BoxDecoration(
                                    boxShadow: const <BoxShadow>[
                                      BoxShadow(
                                          color: CustomColor.nearlyBlack,
                                          offset: Offset(-8.0, 8.0),
                                          blurRadius: 8.0),
                                    ],
                                color:  CustomColor.red,
                                borderRadius: BorderRadius.circular(10)),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                            )),
                      ),
                    )
                  ],
                ),
          ),
        ),
              ),
            );
        },
      ),
      ),
    );
  }

  alert(context, index) {
    ListeningProvider listenVM =
        Provider.of<ListeningProvider>(context, listen: false);
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            color: CustomColor.dismissibleBackground,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Are you sure you want to delete this note?',
                  style: TextStyle(
                      color: Colors.white70, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColor.red,
                        ),
                        onPressed: () {
                          setState(() {
                            listenVM.notes.removeAt(index);
                            listenVM.saveList();
                            Navigator.pop(context);
                          });
                        },
                        child: const Text('Yes delete'),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:CustomColor.red2),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Close'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
