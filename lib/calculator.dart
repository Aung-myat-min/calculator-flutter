import 'package:calculator/number_button.dart';
import 'package:flutter/material.dart';

class CalcuatorContainer extends StatefulWidget {
  const CalcuatorContainer({super.key});

  @override
  State<CalcuatorContainer> createState() => _CalcuatorContainerState();
}

class _CalcuatorContainerState extends State<CalcuatorContainer> {
  String progress = '';
  double result = 0;
  bool firstNum = true;
  List<String> state = ['number']; //number, operator, special

  numberClick(int number) {
    if (state.contains('number')) {
      setState(() {
        progress += number.toString();
        //number -> operator , special
        if (!state.contains('operator')) {
          state.add('operator');
        }
        if (!state.contains('special')) {
          state.add('special');
        }
      });
    }
  }

  functionClick(String operator) {
    if (state.contains('operator')) {
      setState(() {
        progress += ' $operator ';
        state.remove('operator');
        firstNum = false;
      });
    }
  }

  outputResult() {
    List<double> numbers = [];
    List<String> operators = [];
    List<String> spiltedP = progress.split(' ');
    double? sum;

    //fill the numbers and operators
    for (var i in spiltedP) {
      if (double.tryParse(i) != null) {
        numbers.add(double.parse(i));
      } else {
        if (i.split('')[i.split('').length - 1] == "%") {
          //actual percentage value
          List<String> spiltedPercentage = i.split('');
          spiltedPercentage.remove('%'); //[2, 2] -> %                0, 1,
          double percent =
              double.parse(spiltedPercentage.join()); //[2, 2, 0, 0] -> 2 - 1
          double percentValue = percent * numbers[numbers.length - 1] / 100;
          numbers.add(percentValue);
        } else {
          operators.add(i);
        }
      }
    }

    for (var i = 0; i < operators.length; i++) {
      double temN = 0;
      String operator = operators[i];

      switch (operator) {
        case 'x':
          if (sum == null) {
            temN = numbers[i] * numbers[i + 1];
            sum = 0;
          } else {
            temN = sum * numbers[i + 1];
          }
          break;
        case '/':
          if (sum == null) {
            temN = numbers[i] / numbers[i + 1];
            sum = 0;
          } else {
            temN = sum / numbers[i + 1];
          }
          break;
        case '+':
          if (sum == null) {
            temN = numbers[i] + numbers[i + 1];
            sum = 0;
          } else {
            temN = sum + numbers[i + 1];
          }
          break;
        case '-':
          if (sum == null) {
            temN = numbers[i] - numbers[i + 1];
            sum = 0;
          } else {
            temN = sum - numbers[i + 1];
          }
          break;
      }

      sum = temN;
    }

    setState(() {
      result = sum!;
    });
  }

  clearFunction() {
    setState(() {
      progress = '';
      result = 0;
    });
  }

  specialAdd(String special) {
    if (special == '.') {
      if (state.contains('number')) {
        //['number', 'operator', 'special']
        if (state.contains('operator')) {
          if (state.contains('special')) {
            setState(() {
              progress += special;
            });
            state.remove('special');
          }
        }
      }
    } else {
      if (!firstNum) {
        if (state.contains('number')) {
          //['number', 'operator', 'special']
          if (state.contains('operator')) {
            if (state.contains('special')) {
              setState(() {
                progress += special;
              });
              state.remove('special');
            }
          }
        }
      }
    }
  }

  deleteFunction() {
    List<String> spiltedP = progress.split('');
    if (spiltedP[spiltedP.length - 1] != ' ') {
      spiltedP.removeLast();
    } else {
      spiltedP.removeLast();
      spiltedP.removeLast();
      spiltedP.removeLast();
    }

    setState(() {
      progress = spiltedP.join();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          backgroundColor: Colors.amber,
          leading: const Icon(
            Icons.calculate,
            color: Colors.green,
          ),
          title: const Text('Calculator App'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.history),
            ),
          ],
        ),

        //body start <div style=""><p></p></div> div(style: style, child: p())

        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          progress,
                          style: const TextStyle(fontSize: 30),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          result.toString(),
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              height: 1,
            ),
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(color: Colors.black12),
                width: double.infinity,
                child: GridView.count(
                  crossAxisCount: 4,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  children: [
                    NumberButton(
                      text: "C",
                      function: clearFunction,
                      isFunction: true,
                    ),
                    NumberButton(
                      text: 'DEL',
                      isFunction: true,
                      function: deleteFunction,
                    ),
                    NumberButton(
                      text: '%',
                      isFunction: true,
                      function: () {
                        specialAdd('%');
                      },
                    ),
                    NumberButton(
                      text: '/',
                      function: () {
                        functionClick('/');
                      },
                      isFunction: true,
                    ),

                    //second line

                    NumberButton(
                      text: "7",
                      function: () {
                        numberClick(7);
                      },
                    ),
                    NumberButton(
                      text: '8',
                      function: () {
                        numberClick(8);
                      },
                    ),
                    NumberButton(
                      text: '9',
                      function: () {
                        numberClick(9);
                      },
                    ),
                    NumberButton(
                      text: 'x',
                      isFunction: true,
                      function: () {
                        functionClick('x');
                      },
                    ),

                    //third row

                    NumberButton(
                      text: "4",
                      function: () {
                        numberClick(4);
                      },
                    ),
                    NumberButton(
                      text: '5',
                      function: () {
                        numberClick(5);
                      },
                    ),
                    NumberButton(
                      text: '6',
                      function: () {
                        numberClick(6);
                      },
                    ),
                    NumberButton(
                      text: '+',
                      isFunction: true,
                      function: () {
                        functionClick('+');
                      },
                    ),
                    //fourth row
                    NumberButton(
                      text: "3",
                      function: () {
                        numberClick(3);
                      },
                    ),
                    NumberButton(
                      text: '2',
                      function: () {
                        numberClick(2);
                      },
                    ),
                    NumberButton(
                      text: '1',
                      function: () {
                        numberClick(1);
                      },
                    ),
                    NumberButton(
                      text: '-',
                      isFunction: true,
                      function: () {
                        functionClick('-');
                      },
                    ),
                    NumberButton(
                      text: '^2',

                      function: () {}, //TODO
                    ),
                    NumberButton(
                      text: '0',
                      function: () {
                        numberClick(0);
                      },
                    ),
                    NumberButton(
                      text: '.',
                      function: () {
                        specialAdd('.');
                      }, //TODO
                    ),
                    NumberButton(
                      text: '=',
                      isEquel: true,
                      function: () {
                        outputResult();
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
