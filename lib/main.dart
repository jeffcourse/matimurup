import 'package:flutter/material.dart';
import 'package:uts_flutter/screens/gameplay.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MatiMurup Square',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'MatiMurup Square'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _namapemain1 = TextEditingController();
  final TextEditingController _namapemain2 = TextEditingController();
  final TextEditingController _jumlahronde = TextEditingController();
  String kesulitan = 'Gampang';

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _namapemain1.text = prefs.getString('namaPemain1') ?? '';
      _namapemain2.text = prefs.getString('namaPemain2') ?? '';
      _jumlahronde.text = (prefs.getInt('jumlahRonde') ?? '').toString();
      kesulitan = prefs.getString('kesulitan') ?? 'Gampang';
    });
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Align( 
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          //mainAxisAlignment: MainAxisAlignment.center,
          children:[
            SizedBox(height:100),
            Text(
              'Setup Permainan',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            SizedBox(height:30),

            TextField(
              controller: _namapemain1,
              decoration: InputDecoration(
                labelText: 'Nama Pemain #1',
                border: OutlineInputBorder(),
                constraints: BoxConstraints(
                  maxWidth: 280,
                  maxHeight: 40,
              ),
              ),
            ),
            SizedBox(height:15),
            TextField(
              controller: _namapemain2,
              decoration: InputDecoration(
                labelText: 'Nama Pemain #2',
                border: OutlineInputBorder(),
                constraints: BoxConstraints(
                  maxWidth: 280,
                  maxHeight: 40,
              ),
            )),
            SizedBox(height:15),
            TextField(
              controller: _jumlahronde,
              decoration: InputDecoration(
                labelText: 'Jumlah Ronde',
                border: OutlineInputBorder(),
                constraints: BoxConstraints(
                  maxWidth: 280,
                  maxHeight: 40,
              ),
            )),
            SizedBox(height:15),
            Container(
              width: 280,
              height: 40,
              child: 
            DropdownButton(
              value: kesulitan,
              isExpanded: true,
              items: const [
                DropdownMenuItem(
                  child: Text("Gampang"),
                  value: 'Gampang',
                ),
                DropdownMenuItem(
                  child: Text("Sedang"),
                  value: 'Sedang',
                ),
                DropdownMenuItem(
                  child: Text("Susah"),
                  value: 'Susah',
                ),
              ],
              onChanged: (value) {
                setState(() {
                  kesulitan = value!;
                });
            })),
            SizedBox(height:30),
            ElevatedButton(
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(5),
              ),
              onPressed: () async {
                if(_namapemain1.text.isNotEmpty && _namapemain2.text.isNotEmpty && _jumlahronde.text.isNotEmpty){
                  final int jumlahRonde = int.tryParse(_jumlahronde.text) ?? 0;
                  if(jumlahRonde >= 1 && jumlahRonde <= 10){
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setString('namaPemain1',_namapemain1.text);
                    prefs.setString('namaPemain2',_namapemain2.text);
                    prefs.setInt('jumlahRonde',jumlahRonde);
                    prefs.setString('kesulitan',kesulitan);
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Gameplay()
                    ));
                  } else{
                    showDialog(
                    context: context,
                    builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Invalid Jumlah Ronde'),
                      content: Text('Jumlah ronde diperbolehkan minimal 1 hingga maksimal 10 ronde'),
                      actions: <Widget>[
                        TextButton(
                        child: const Text('OK'),
                        onPressed: () {
                          Navigator.pop(context, 'OK');
                        },
                      ),
                    ],
                  );
                  },
                  );
                  }
                } else{
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Invalid Input'),
                      content: Text('Input field tidak boleh kosong'),
                      actions: <Widget>[
                        TextButton(
                        child: const Text('OK'),
                        onPressed: () {
                          Navigator.pop(context, 'OK');
                        },
                      ),
                    ],
                  );
                  },
                  );
                }        
              },
              child: Text('MULAI'),
            ),    
        ],
        ),
      ),
    );
  }
}
