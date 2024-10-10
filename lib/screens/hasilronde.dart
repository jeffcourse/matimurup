import 'package:flutter/material.dart';

class HasilRonde extends StatefulWidget {
  final int round;
  final String kesulitan;
  final String pemain1;
  final String pemain2;
  final String rondeResult;
  final ValueChanged<int> onNextRonde;

  HasilRonde({
    required this.round,
    required this.kesulitan,
    required this.pemain1,
    required this.pemain2,
    required this.rondeResult,
    required this.onNextRonde,
  });

  @override
  State<StatefulWidget> createState() {
      return _HasilRonde();
  }
}
class _HasilRonde extends State<HasilRonde> {
 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
    title: Text('Hasil Ronde'),
    automaticallyImplyLeading: false,
   ),
   body: Center(child:Column(
              children:[
              SizedBox(height:30),
              Text(
                'Hasil Ronde ${widget.round} (Level: ${widget.kesulitan})',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              SizedBox(height:10),
              Text(
                "${widget.pemain1} vs ${widget.pemain2}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              SizedBox(height:150),
              Text(widget.rondeResult,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              SizedBox(height:200),
              ElevatedButton(
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(5),
              ),
              onPressed: () async {
                widget.onNextRonde(widget.round + 1);
                Navigator.pop(context);
              },
              child: Text('LANJUT RONDE ${widget.round+1}'),
              ),    
   ]),
  ));
 }
}