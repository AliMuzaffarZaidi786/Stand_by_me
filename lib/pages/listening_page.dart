
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:stand_by_me/pages/App%20Manager/colors.dart';
import 'package:stand_by_me/pages/App%20Manager/enum.dart';
import 'package:stand_by_me/pages/notes_view.dart';
import 'package:stand_by_me/pages/provider/provider.dart';

class ListeningPage extends StatefulWidget {
  const ListeningPage({Key? key}) : super(key: key);

  @override
  State<ListeningPage> createState() => _ListeningPageState();
}

class _ListeningPageState extends State<ListeningPage> {
  @override
  void initState() {
    ListeningProvider listenVM =
        Provider.of<ListeningProvider>(context, listen: false);
   listenVM.isListening = Pages.listening;
    listenVM.get(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ListeningProvider listenVM =
        Provider.of<ListeningProvider>(context, listen: true);
    return  Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration:  const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[CustomColor.newPurple, CustomColor.newPurple2]),
          ),
        ),
        title: const Text('Voice Notes'),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
          Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
      ),
      backgroundColor: CustomColor.background,
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    color: Colors.white,
                    child: ListView(
                      padding: const EdgeInsets.all(20),
                      controller: listenVM.scrollController,
                      children: [
                        Text(
                          listenVM.collectedNoteText,
                          style: const TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ),

              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                SizedBox(
                  height: 25,
                  child: Text(
                    listenVM.lastWords.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: CustomColor.newPurple2,
                      overflow: TextOverflow.fade
                    ),
                  ),
                ),
                SizedBox(
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LoadingAnimationWidget.staggeredDotsWave(color: CustomColor.newPurple2, size: 100),
                        const Icon(Icons.mic_none_rounded,color: CustomColor.newPurple2, size: 100),
                        LoadingAnimationWidget.staggeredDotsWave(color: CustomColor.newPurple2, size: 100),
                      ],
                    )),
                InkWell(
                  onTap: () {
                    setState(() {
                      listenVM.isListening=Pages.notListening;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context2) =>
                              NoteView(item: listenVM.collectedNoteText),
                        ),
                      );
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(8.0),
                    height: 50,
                    decoration: BoxDecoration(
                      color: CustomColor.newPurple2,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child:   const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Save ',style: TextStyle(color: CustomColor.nearlyWhite,fontWeight: FontWeight.w900,fontSize: 20),),
                        Icon(
                          Icons.save_alt,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    ListeningProvider listenVM =
        Provider.of<ListeningProvider>(context, listen: false);
    super.dispose();
    listenVM.isListening=Pages.notListening;
    listenVM.timer.cancel();
    listenVM.stopListening();
  }
}
