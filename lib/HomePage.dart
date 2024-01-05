import 'package:flutter/material.dart';
import 'package:contacts_buddy/DatabaseOp.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> _allData=[];


  void _refreshData() async{
    final data=await SQL.getAllData();
    setState(() {
      _allData=data;
    });
  }

  @override
  void initState(){
    super.initState();
    _refreshData();

  }

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

  List<Map<String, dynamic>> searchResults = [];

  void onQueryChanged(String query) {
    setState(() {
      searchResults = _allData
          .where((item) => item['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
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
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Name",
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _numberControl,
                decoration: const InputDecoration(
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
                    padding: const EdgeInsets.all(18),
                    child: Text(id==null?"Add Data":"Update",
                    style: const TextStyle(
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

      body: Column(
        children: [
          SearchBar(
              //onQueryChanged: onQueryChanged
          ),

          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(searchResults[index]['name']),
                );
                },
            ),
          ),

          Expanded(
            child: Center(
              child: ListView.builder(
                itemCount: _allData.length,
                itemBuilder: (context,index)=>Card(
                    margin: const EdgeInsets.all(20),
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
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
                            icon: const Icon(
                              Icons.edit,
                            ),
                          ),
                          IconButton(
                            onPressed: (){
                              _deleteData(_allData[index]['id']);
                            },
                            icon: const Icon(
                              Icons.delete,
                            ),
                          ),
                        ],
                      ),
                    )
                ),
              ),
            ),
          ),

        ],
      ),




      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            showBottomSheet(null),
          //Navigator.pushNamed(context, '/Add'),

        tooltip: 'add',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class SearchBar extends StatefulWidget {
@override
_SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  String query = '';

  void onQueryChanged(String newQuery) {
    setState(() {
      query = newQuery;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        onChanged: onQueryChanged,
        decoration: const InputDecoration(
          labelText: 'Search',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }
}