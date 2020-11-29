import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ItemPage extends StatefulWidget {
  ItemPage({@required this.isDeposit});

  final bool isDeposit;
  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  Map<String, dynamic> _formData = Map<String, dynamic>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime _dateTime = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _formData['isDeposit'] = widget.isDeposit;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              if (!_formKey.currentState.validate()) return;
              _formKey.currentState.save();
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                validator: (String value) => value.isEmpty ? 'Required' : null,
                onSaved: (String value) => _formData['description'] = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Amount'),
                validator: (String value) {
                  if (value.isEmpty) return 'Required';
                  if (double.tryParse(value) == null) return 'Invalid number';
                },
                onSaved: (String value) =>
                    _formData['amount'] = double.parse(value),
              ),
              Row(
                children: <Widget>[
                  Checkbox(
                    value: _formData['isDeposit'],
                    onChanged: (bool value) {
                      setState(() {
                        _formData['isDeposit'] = value;
                      });
                    },
                  ),
                  const Text('Is Deposit'),
                ],
              ),
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.date_range),
                    onPressed: () async {
                      var date = await showDatePicker(
                        context: context,
                        initialDate: _dateTime,
                        firstDate: DateTime.now().add(
                          Duration(days: -365),
                        ),
                        lastDate: DateTime.now().add(Duration(days: 365)),
                      );

                      if (date == null) return;

                      setState(() {
                        _dateTime = date;
                      });
                    },
                  ),
                  Text(DateFormat('MM/dd/yyyy').format(_dateTime)),
                ],
              ),
              DropdownButtonFormField(
                decoration: InputDecoration(labelText: 'Account'),
                items: [
                  DropdownMenuItem<int>(
                    value: 1,
                    child: const Text('Checking'),
                  ),
                  DropdownMenuItem<int>(
                    value: 2,
                    child: const Text('Credit Card'),
                  )
                ],
                onChanged: (int value) {
                  _formData['account'] = value;
                },
                validator: (int value) => value == null ? 'Required' : value,
              ),
              DropdownButtonFormField(
                decoration: InputDecoration(labelText: 'Type'),
                items: [
                  DropdownMenuItem<int>(
                    value: 1,
                    child: const Text('Rent'),
                  ),
                  DropdownMenuItem<int>(
                    value: 2,
                    child: const Text('Dinner'),
                  )
                ],
                onChanged: (int value) {
                  _formData['typeId'] = value;
                },
                validator: (int value) => value == null ? 'Required' : value,
              )
            ],
          ),
        ),
      ),
    );
  }
}
