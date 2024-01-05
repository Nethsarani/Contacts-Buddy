import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:contacts_buddy/HomePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
debugShowCheckedModeBanner: false,
      title: 'Contact Buddy',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Contact Buddy'),
      //routes: <String, WidgetBuilder> {
      //  '/Add': (BuildContext context) => const AddContactPage(),
       // '/Update': (BuildContext context) => const AddContactPage(),

     // },
    );
  }
}

