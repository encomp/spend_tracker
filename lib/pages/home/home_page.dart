import 'package:flutter/material.dart';
import 'package:spend_tracker/pages/home/widgets/menu.dart';
import 'package:spend_tracker/pages/index.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var amount = '1,203.00';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            tooltip: 'add',
            onPressed: () => print('click'),
          )
        ],
      ),
      drawer: Menu(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _TotalBudget(amount: amount),
          Container(
              padding: EdgeInsets.only(bottom: 60),
              height: MediaQuery.of(context).size.height - 196,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _BarLine(100, Colors.red, 'Withdraw', 506),
                  _BarLine(375, Colors.green, 'Deposit', 1709)
                ],
              )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => ItemPage()));
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _BarLine extends StatelessWidget {
  const _BarLine(
    this.height,
    this.color,
    this.label,
    this.amount, {
    Key key,
  }) : super(key: key);
  final double height;
  final String label;
  final Color color;
  final int amount;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: height,
          width: 100,
          color: color,
        ),
        Text(label),
        Text('\$$amount'),
      ],
    );
  }
}

class _TotalBudget extends StatelessWidget {
  const _TotalBudget({
    Key key,
    @required this.amount,
  }) : super(key: key);

  final String amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: EdgeInsets.all(10),
      alignment: Alignment.center,
      child: Text(
        '\$$amount',
        style: TextStyle(
          color: Colors.white,
          fontSize: 40,
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.green,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green,
            Colors.white54,
            Colors.blueGrey,
          ],
          stops: [0.85, 0.95, 1.0],
        ),
        boxShadow: [
          BoxShadow(color: Colors.grey, offset: Offset(4, 4)),
        ],
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
    );
  }
}
