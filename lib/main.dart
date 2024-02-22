
import 'package:flutter/material.dart';
import 'package:stand_by_me/pages/listening_page.dart';
import 'package:provider/provider.dart';
import 'package:stand_by_me/pages/provider/provider.dart';

void main() => runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ListeningProvider()),
      ],
      child: const MyApp(),
    ),


);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ListeningPage());
  }
}
