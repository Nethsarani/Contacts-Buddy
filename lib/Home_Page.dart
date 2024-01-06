import 'package:flutter/material.dart';
import 'package:contacts_buddy/DatabaseOp.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

List<Map<String, dynamic>> _allData=[];
class _MyHomePageState extends State<MyHomePage> {

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
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Contact added"),
      backgroundColor: Colors.green,duration: Duration(seconds: 1),));
    _refreshData();
  }

  Future <void> _updateData(int id) async{
    await SQL.updateData(id,_nameControl.text,_numberControl.text);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Contact updated"),
        backgroundColor: Colors.orange,duration: Duration(seconds: 1),));
    _refreshData();
  }

  Future <void> _deleteData(int id) async{
    await SQL.deleteData(id);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(
      content: Text("Contact deleted"),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 1),)
    );
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
            left: 30,
            right: 30,
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
              const SizedBox(height: 20),
              TextField(
                controller: _numberControl,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Number",
                ),
              ),
              const SizedBox(height: 20),
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
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(id==null?"Add contact":"Update",
                        style: const TextStyle(
                          fontSize: 19, fontWeight: FontWeight.w700,
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
        title: Text(widget.title),
          actions: [
          IconButton(
          onPressed: () {
    showSearch(
    context: context,
    delegate: CustomSearchDelegate(),
    );
    },
      icon: const Icon(Icons.search),
    ),// IconButton
          ],
        ),


        body: ListView.builder(
            itemCount: _allData.length,
            itemBuilder: (context,index) {
              return Card(
                margin: const EdgeInsets.all(20),
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      _allData[index]['name'],style: TextStyle(fontSize: 18),
                    ),
                  ),
                  subtitle: Text(_allData[index]['number'],style: TextStyle(fontSize: 16),),
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
                ),
              );
            },
          ),



      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            showBottomSheet(null),
        tooltip: 'add',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {

  @override
  List<Widget> buildActions (BuildContext context)
  {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: (){
          query='';
        },
      ),
    ];
  }

  @override
  Widget buildLeading (BuildContext context)
  {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context)
  {
    List<Map<String, dynamic>> matchquery=[];
    matchquery = _allData
        .where((item) => item['name'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: matchquery.length,
      itemBuilder: (context, index){
        var result =matchquery[index];
        return ListTile(
          title: Text(result['name']),
          subtitle: Text(result['number']),
        );
      },
    );
  }

  @override
  Widget buildSuggestions (BuildContext context)
  {
    List<Map<String, dynamic>> matchquery=[];
    matchquery = _allData
        .where((item) => item['name'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: matchquery.length,
      itemBuilder: (context, index){
        var result =matchquery[index];
        return ListTile(
          title: Text(result['name']),
          subtitle: Text(result['number']),
        );
      },
    );
  }
}