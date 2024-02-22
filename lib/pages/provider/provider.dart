
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:stand_by_me/pages/App%20Manager/enum.dart';

class ListeningProvider extends ChangeNotifier {

  bool hasSpeech = false;
  bool logEvents = false;
  bool onDevice = false;
  double level = 0.0;
  double minSoundLevel = 5000;
  double maxSoundLevel = -5000;
  String lastWords = '';
  String lastError = '';
  String lastStatus = '';
  String currentLocaleId = '';
  bool isChanged = false;
  String collectedNoteText = '';
  double value = 1;



  List<String> notes = [];
  List<String> get getNotes => notes;
  set updateNotes(List<String> val) {
    notes = val;
  }


  final SpeechToText speech = SpeechToText();
  ScrollController scrollController = ScrollController();


  saveList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('notes', getNotes);
  }

  getSavedList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    updateNotes = prefs.getStringList('notes') ?? [];
  }


  void resultListener(SpeechRecognitionResult result) {
    _logEvent(
        'Result listener final: ${result.finalResult}, words: ${result.recognizedWords}');

    lastWords = result.recognizedWords;
    if (result.finalResult == true) {
      collectedNoteText = '$collectedNoteText\n• $lastWords';
      scrollToBottom();
    }
    notifyListeners();
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    level = level;
    value = level + 10;
    notifyListeners();
  }

  void errorListener(SpeechRecognitionError error) {
    _logEvent('Received error status: $error, listening: ${speech.isListening}');
    lastError = '${error.errorMsg} - ${error.permanent}';
    notifyListeners();
  }

  void statusListener(String status) {
    _logEvent('Received listener status: $status, listening: ${speech.isListening}');
    lastStatus = status;

    notifyListeners();
  }

  void _logEvent(String eventDescription) {
    if (logEvents) {
      var eventTime = DateTime.now().toIso8601String();
      debugPrint('$eventTime $eventDescription');
    }
  }

  late Timer timer;

  var isListening;

  get(context) async {
    await initSpeechState(context);
    timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if(Pages.listening==isListening){
        startListening();
      }else{

      }
    });
    getSavedList();
  }

  Future<void> initSpeechState(context) async {
    _logEvent('Initialize');
    try {
      var hasSpeech = await speech.initialize(
        onError: errorListener,
        onStatus: statusListener,
        debugLogging: logEvents,
      );
      if (hasSpeech) {
        var systemLocale = await speech.systemLocale();
        currentLocaleId = systemLocale?.localeId ?? '';
      }
      hasSpeech = hasSpeech;
      notifyListeners();
    } catch (e) {
      lastError = 'Speech recognition failed: ${e.toString()}';
      hasSpeech = false;
      notifyListeners();
    }
  }

  void startListening() {
    _logEvent('start listening');
    lastWords = '';
    lastError = '';
    speech.listen(
      onResult: resultListener,
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 10),
      partialResults: true,
      localeId: currentLocaleId,
      cancelOnError: true,
      listenMode: ListenMode.confirmation,
      onDevice: onDevice,
    );
    notifyListeners();
  }

  void stopListening() {
    _logEvent('stop');
    speech.stop();
    speech.cancel();
    level = 0.0;
    notifyListeners();
  }

  scrollToBottom(){
    SchedulerBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.decelerate);
    });
  }
}
