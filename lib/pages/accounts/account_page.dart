import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spend_tracker/database/db_provider.dart';
import 'package:spend_tracker/models/account.dart';
import 'package:spend_tracker/pages/icons/icon_holder.dart';
import 'package:spend_tracker/support/icon_helper.dart';

class AccountPage extends StatefulWidget {
  final Account account;

  AccountPage({this.account});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Map<String, dynamic> _data;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.account != null) {
      _data = widget.account.toMap();
    } else {
      _data = new Map<String, dynamic>();
      _data['codePoint'] = Icons.add.codePoint;
    }
  }

  @override
  Widget build(BuildContext context) {
    var dbProvider = Provider.of<DbProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Account'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.save),
                onPressed: () async {
                  if (!_formKey.currentState.validate()) return;
                  _formKey.currentState.save();
                  var account = Account.fromMap(_data);
                  if (account.id == null) {
                    await dbProvider.createAccount(account);
                  } else {
                    await dbProvider.updateAccount(account);
                  }
                  Navigator.of(context).pop();
                }),
          ],
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                IconHolder(
                  newIcon: IconHelper.createIconData(_data['codePoint']),
                  onIconChange: (iconData) {
                    setState(() {
                      _data['codePoint'] = iconData.codePoint;
                    });
                  },
                ),
                TextFormField(
                  initialValue:
                      widget.account != null ? widget.account.name : '',
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (String value) {
                    if (value.isEmpty) return 'Required';
                  },
                  onSaved: (String value) => _data['name'] = value,
                ),
                TextFormField(
                  initialValue: widget.account != null
                      ? widget.account.balance.toString()
                      : '',
                  decoration: InputDecoration(labelText: 'Balance'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (String value) {
                    if (value.isEmpty) return 'Required';
                    if (double.tryParse(value) == null) return 'Invalid number';
                  },
                  onSaved: (String value) =>
                      _data['balance'] = double.parse(value),
                )
              ],
            ),
          ),
        ));
  }
}
