import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:contacts_buddy/DatabaseOp.dart';
import 'package:sqflite/sqflite.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
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
    SQL.db();
    _refreshData();

  }
  //SQL.createData('asdfgh','14725')

  Future<void> _addData() async{
  await SQL.createData(_nameControl.text,_numberControl.text);
  _refreshData();
  }

  Future <void> _updateData(int id) async{
    await SQL.updateData(id,_nameControl.text,_numberControl.text);
    _refreshData();
  }

  Future <void> _deleteData(int id) async{
    await SQL.deleteData(id);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Data deleted")));
    _refreshData();
  }



  final TextEditingController _nameControl=TextEditingController();
  final TextEditingController _numberControl=TextEditingController();

  void showBottomSheet(int? id) async{
    if(id!=null){
      final existinData=_allData.firstWhere((element) => element['id']==id);
      _nameControl.text=existinData['name'];
      _numberControl.text=existinData['number'];
    }
    showModalBottomSheet(
      elevation: 5,
        isScrollControlled: true,
        context: context,
        builder: (_)=>Container(
          padding: EdgeInsets.only(
            top: 30,
            left: 15,
            right: 15,
            bottom: MediaQuery.of(context).viewInsets.bottom+50,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: _nameControl,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Name",
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _numberControl,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Number",
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (id == null) {
                      await _addData();
                    }
                    if(id!=null){
                      await _updateData(id);
                    }
                    _nameControl.text="";
                    _numberControl.text="";
                    Navigator.of(context).pop();
                    print("Data added");
                  },
                  child: Padding(
                    padding: EdgeInsets.all(18),
                    child: Text(id==null?"Add Data":"Update",
                    style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500,
                    ),
                    ),
                  ),
                )
              )
            ],
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Center(
              child: Text(widget.title))
      ),

      body: _isLoading
      ?Center(
        child: CircularProgressIndicator(),
      )
          :ListView.builder(
        itemCount: _allData.length,
        itemBuilder: (context,index)=>Card(
          margin: EdgeInsets.all(15),
          child: ListTile(
            title: Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Text(
                _allData[index]['name'],
              ),
            ),
            subtitle: Text(_allData[index]['number']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: (){
                      showBottomSheet(_allData[index]['id']);
                    },
                    icon: Icon(
                      Icons.edit,
                    ),
                ),
                IconButton(
                    onPressed: (){
                      _deleteData(_allData[index]['id']);
                    },
                    icon: Icon(
                    Icons.delete,
                ),
                ),
              ],
            ),
          )
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>showBottomSheet(null),
          //Navigator.pushNamed(context, '/Add');

        tooltip: 'add',
        child: const Icon(Icons.add),
      ),
    );
  }
}

