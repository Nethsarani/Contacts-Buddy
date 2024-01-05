import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:contacts_buddy/DatabaseOp.dart';

class AddContactPage extends StatefulWidget {
  const AddContactPage({super.key});

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

final TextEditingController _nameControl=TextEditingController();
final TextEditingController _numberControl=TextEditingController();

Future<void> _addData() async{
  await SQL.createData(_nameControl.text, _numberControl.text);
}

class _AddContactPageState extends State<AddContactPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> _allData=[];
  bool _isLoading=true;
  void _refreshData() async{
    final data=await SQL.getAllData();
    setState(() {
      _allData=data;
      _isLoading=false;
    });
  }

  @override
  void initState(){
    super.initState();
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme
                .of(context)
                .colorScheme
                .inversePrimary,
            title: Center(
                child: Text("widget.title"))
        ),

        body: Center(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: _nameControl,
                    decoration: const InputDecoration(
                      hintText: 'Enter your name',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _numberControl,
                    decoration: const InputDecoration(
                      hintText: 'Enter mobile number',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the mobile number';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        // Validate will return true if the form is valid, or false if
                        // the form is invalid.
                        if (_formKey.currentState!.validate()) {
                          // Process data.
                          //if(id==null){
                          await _addData();
                          Navigator.of(context).pop();
                          _refreshData();
                          //}
                        }

                      },
                      child: const Text('Add'),
                    ),
                  ),
                ],
              ),
            )
        )
    );
  }
}
