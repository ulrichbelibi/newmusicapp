import "package:flutter/material.dart";
class CounterPage extends StatefulWidget {
     CounterPage({super.key});
 @override
  State<CounterPage> createState() => _CounterPageState();
}
   class _CounterPageState extends State<CounterPage> {
   int _counter = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Compteur')),
      body: Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text('$_counter', style: TextStyle(fontSize: 40)),
      ElevatedButton(
        onPressed: () { setState(() { _counter++; });},
        child: Text('+1'),
      ),
    ],
  ),
),
    );
  }
}
