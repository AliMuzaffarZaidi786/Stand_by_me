
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
          padding: const EdgeInsets.all(10),
          itemCount: listenVM.getNotes.length,
          itemBuilder: (BuildContext context, int index) {
            var item = listenVM.getNotes[index];
            return FadeIn(
              duration: const Duration(milliseconds: 700),
              delay:  Duration(milliseconds: index*100),
              child: InkWell(
                onTap: () {
                  Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context2) => NoteView(item: item, index: index),),);
                  },
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      padding: const EdgeInsets.only(top: 15,left: 15,right: 15),
                        height: 200,
                        decoration: const BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.black12,
                                offset: Offset(-8.0, 8.0),
                                blurRadius: 10.0)

                          ],
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: <Color>[
                              CustomColor.newPurple2,
                              CustomColor.newPurple,
                            ],
                          ),
                          borderRadius: BorderRadius.only(topRight: Radius.circular(15),topLeft:  Radius.circular(15)),
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      margin:  const EdgeInsets.only(left:15,bottom:  30,right: 15),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(15),bottomLeft:Radius.circular(15)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.black12,
                              offset: Offset(-8.0, 14.0),
                              blurRadius: 10.0)

                        ],
                      ),
                      child:
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  alert(context, index);
                                });
                              },
                              child: const Icon(
                                Icons.delete,
                                color: CustomColor.red,
                                size: 40,
                              ),
                            ),
                            const SizedBox(width: 20,),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.green,
                                size: 40,
                              ),
                            ),
                            const SizedBox(width: 15,)
                          ],
                        ),
                      ),
                    )
                  ],
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
