import 'package:flutter/material.dart';
import 'package:uts_flutter/screens/gameplay.dart';
import 'package:uts_flutter/main.dart';

class HasilAkhir extends StatelessWidget {
 final List<FinalResult> finalResults;
 final String pemain1;
 final String pemain2;

 HasilAkhir(this.finalResults, this.pemain1, this.pemain2);

 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
    title: Text('Hasil Akhir'),
    automaticallyImplyLeading: false,
   ),
   body: SingleChildScrollView(child:Column(
        children: [
          SizedBox(height:30),
          Text(
            'Hasil Permainan',
            style: TextStyle(
              fontSize: 22,
            ),
          ),
          SizedBox(height:10),
          Text(
            "${pemain1} vs ${pemain2}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          SizedBox(height:50),
          Card(
              elevation: 5,
              margin: EdgeInsets.all(4),
              child: Container(
                width: 310,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Ronde',
                    textAlign: TextAlign.center)),
                    DataColumn(label: Text('Hasil',
                    textAlign: TextAlign.center)),
                  ],
                  rows: finalResults.map((result){
                    return DataRow(cells: [
                      DataCell(Text(result.ronde.toString(),
                      textAlign: TextAlign.center)),
                      DataCell(Text(result.hasil,
                      textAlign: TextAlign.center)),
                    ]);
                  }).toList(),
                ))),
              ),
          SizedBox(height:50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  //Play again with same setting
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Gameplay(),
                    ),
                  );
                },
                child: Text('Main Lagi'),
              ),
              ElevatedButton(
                onPressed: () {
                  //Back to main menu
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyApp(),
                    ),
                    (route) => false,
                  );
                },
                child: Text('Menu Utama'),
              ),
            ],
          ),
          SizedBox(height:50),
        ],
      ),
   ));
 }
}

class FinalResult {
  final int ronde;
  final String hasil;

  FinalResult(this.ronde, this.hasil);
}