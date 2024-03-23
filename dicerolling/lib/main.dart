import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromRGBO(170, 171, 184, 100),
        appBar: AppBar(
          title: Text('Dicee Rolling'),
          backgroundColor: Color.fromRGBO(236, 236, 236, 100),
        ),
        body: DicePage(),
      ),
    ),
  );
}

class DicePage extends StatefulWidget {
  const DicePage({Key? key}) : super(key: key);

  @override
  State<DicePage> createState() => _DicePageState();
}

class _DicePageState extends State<DicePage> {
  int leftDiceNum = 2;
  int rightDiceNum = 2;
  String result = '';

  void changeDiceFace() {
    setState(() {
      leftDiceNum = Random().nextInt(6) + 1;
      rightDiceNum = Random().nextInt(6) + 1;
      calculateResult();
    });
  }

  void calculateResult() {
    if (leftDiceNum > rightDiceNum) {
      result = 'Left player wins!';
    } else if (rightDiceNum > leftDiceNum) {
      result = 'Right player wins!';
    } else {
      result = 'It\'s a tie!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Press to roll the dice!',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.0),
          Row(
            children: <Widget>[
              Expanded(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      changeDiceFace();
                    });
                  },
                  child: Image.asset('images/dice$leftDiceNum.png'),
                ),
              ),
              //SizedBox(width: 10,),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      changeDiceFace();
                    });
                  },
                  child: Image.asset('images/dice$rightDiceNum.png'),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),
          Text(
            result,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.bold
            ),
          ),
        ],
      ),
    );
  }
}
