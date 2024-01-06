import 'package:flutter/material.dart';
import 'package:contacts_buddy/Home_Page.dart';
import 'package:contacts_buddy/DatabaseOp.dart';


void main() async {
  SQL.db();
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Contact Buddy',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Contact Buddy'),
      //initialRoute: '/',
      //routes: <String, WidgetBuilder> {
        //'/': (BuildContext context)=>MyHomePage(title: 'Contact Buddy'),
    );
  }
}

