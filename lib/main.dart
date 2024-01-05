import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:contacts_buddy/HomePage.dart';
import 'package:contacts_buddy/DatabaseOp.dart';
import 'package:contacts_buddy/AddPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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

