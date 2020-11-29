import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ItemPage extends StatefulWidget {
  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  Map<String, dynamic> _formData = Map<String, dynamic>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isDeposit = true;
  DateTime _dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item'),
        actions: [
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                if (!_formKey.currentState.validate()) {
                  return;
                }
                _formKey.currentState.save();
                Navigator.of(context).pop();
              })
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Required';
                  }
                },
                onSaved: (String value) {
                  _formData['description'] = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Amount'),
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Required';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Invalid Number';
                  }
                },
                onSaved: (String value) {
                  _formData['amount'] = double.parse(value);
                },
              ),
              Row(
                children: <Widget>[
                  const Text('IsDeposit:'),
                  Checkbox(
                      activeColor: Colors.amber,
                      value: _isDeposit,
                      onChanged: (bool value) {
                        setState(() {
                          _isDeposit = value;
                        });
                      })
                ],
              ),
              Row(
                children: <Widget>[
                  Text(DateFormat('MM/dd/yyyy').format(_dateTime)),
                  IconButton(
                      icon: Icon(Icons.date_range),
                      onPressed: () async {
                        var date = await showDatePicker(
                            context: context,
                            initialDate: _dateTime,
                            firstDate: DateTime.now().add(Duration(days: -365)),
                            lastDate: DateTime.now().add(Duration(days: 365)));
                        if (date != null) {
                          setState(() {
                            _dateTime = date;
                          });
                        }
                      })
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
