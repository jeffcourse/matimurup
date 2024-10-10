import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uts_flutter/screens/hasilakhir.dart';
import 'dart:async';

import 'package:uts_flutter/screens/hasilronde.dart';

class Gameplay extends StatefulWidget {
  @override
    State<StatefulWidget> createState() {
        return _Gameplay();
    }
}
class _Gameplay extends State<Gameplay> {
  List<int> boxIndex = [0,1,2,3,4,5,6,7,8];
  List<int> sequence = [];
  int currIndex = 0;
  int currColorBox = -1;
  int sequenceColorBox = -1;
  Timer? colorTimer;
  bool interact = false;
  String stage = 'Hafalkan Polanya';

  int currRonde = 1;
  String pemain1 = '';
  String pemain2 = '';
  String currPemain = '';
  int totalRonde = 0;
  int scorePemain1 = 0;
  int scorePemain2 = 0;
  String result = "";
  String roundResult = "";
  String kesulitan = "Gampang";

  List<FinalResult> finalResults = [];

  @override
  void initState(){
    super.initState();
    loadGameData();
  }

  Future<void> loadGameData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    pemain1 = prefs.getString('namaPemain1') ?? '';
    pemain2 = prefs.getString('namaPemain2') ?? '';
    totalRonde = prefs.getInt('jumlahRonde') ?? 0;
    kesulitan = prefs.getString('kesulitan') ?? 'Gampang';

    setState(() {
      currPemain = pemain1;
    });
    createRandomSequence();
    startSequence();
  }

  void createRandomSequence(){
      int length;
      sequence.clear();
      if(kesulitan == "Gampang"){
        length = 5;
      }else if(kesulitan == "Sedang"){
        length = 8;
      }else{
        length = 12;
      }
      while(sequence.length < length){
        boxIndex.shuffle();
        sequence.addAll(boxIndex);
      }
      sequence = sequence.sublist(0, length);
  }

  void startSequence() async{
    if(sequence.isNotEmpty){
      disableClick();
      createRandomSequence();
      print("Sequence: $sequence");
      for(int index in sequence){
        await _colorBox(index);
      }
      stage = 'Tekan Tombol Sesuai Urutan';
      enableClick();
    }
  }

  Future<void> _colorBox(int idx) async{
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      currColorBox = idx;
    });

    await Future.delayed(Duration(milliseconds: 300));
    setState((){
      currColorBox = -1;
    });
  }

  void disableClick(){
    setState((){
      interact = false;
    });
  }

  void enableClick(){
    setState((){
      interact = true;
    });
  }

  List<Color> colorBox = List.filled(9, Colors.grey);

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text('Gameplay'),
                automaticallyImplyLeading: false,
            ),
            body: Center(child:Column(
              children:[
              SizedBox(height:30),
              Text(
                'Giliran ${currPemain}',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              SizedBox(height:10),
              Text(
                stage,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              SizedBox(height:30),
              Container(
                width: 300,
                height: 300,
                child:GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                  ),
                  itemCount: 9,
                  itemBuilder: (context, index){
                    return IgnorePointer(
                      ignoring: !interact,
                      child:InkWell(
                        onTap: interact ? () => onBoxTap(index):null,
                        child: Ink(
                          decoration: BoxDecoration(
                            color: currColorBox == index ? Colors.blue : colorBox[index],
                          ),
                          child: Container(),
                        ),
                      ),
                    );  
                  }
            ),
        ),
        SizedBox(height:30),
        Text(
          "Ronde ${currRonde}",
          style: TextStyle(
            fontSize: 22,
          ),
        ),
        SizedBox(height:10),
        Text(
          "Level: ${kesulitan}",
          style: TextStyle(
            fontSize: 22,
          ),
        ),
        ])));
    }

    calculateResult(){
      if(scorePemain1 == scorePemain2){
         result = "Seimbang";
      }else if(scorePemain1 > scorePemain2){
        result = pemain1;
      }else{
        result = pemain2;
      }
      return result;
    }

    void navHasilRonde() async {
      await Navigator.push(
      context,
      MaterialPageRoute(
      builder: (context) => HasilRonde(
        round: currRonde, 
        kesulitan: kesulitan, 
        pemain1: pemain1, 
        pemain2: pemain2, 
        rondeResult: roundResult, 
        onNextRonde: (int newRonde) {
          setState(() {
            currRonde = newRonde;
            currPemain = pemain1;

            currIndex = 0;
            startSequence();
          });
        },
      ),
    ));    
  }

    void onBoxTap(int index) {
      if (sequence[currIndex] == index) {
        currIndex++;
        if (currIndex == sequence.length) {
          if(currPemain == pemain1){
            setState(() {
              scorePemain1 = 1;
            });
          }else{
            setState(() {
              scorePemain2 = 1;
            });
          }
          roundResult = calculateResult();
          currIndex = 0;
          stage = 'Hafalkan Polanya';
          if(currPemain == pemain1){
            currPemain = pemain2;
            startSequence();
          }else{
            if(currRonde < totalRonde){
              finalResults.add(FinalResult(currRonde, roundResult));
              navHasilRonde();
            }else{
              finalResults.add(FinalResult(currRonde, roundResult));
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => HasilAkhir(finalResults,pemain1,pemain2)
              ));
            }
          }
        }
      }  else {
          if(currPemain == pemain1){
            setState(() {
              scorePemain1 = 0;
            });
          }else{
            setState(() {
              scorePemain2 = 0;
            });
          }
          roundResult = calculateResult();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Urutan Salah'),
                content: Text('Sayang sekali ${currPemain}, kamu menekan urutan yang salah'),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      currIndex = 0;
                      stage = 'Hafalkan Polanya';
                      if(currPemain == pemain1){
                        currPemain = pemain2;
                        startSequence();
                      }else{
                        if(currRonde < totalRonde){
                          finalResults.add(FinalResult(currRonde, roundResult));
                          navHasilRonde();
                        }else{
                          finalResults.add(FinalResult(currRonde, roundResult));
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context) => HasilAkhir(finalResults,pemain1,pemain2)
                          ));
                        }
                      }
                    },
                  ),
                ],
              );
            },
          );
        }
    }
}

