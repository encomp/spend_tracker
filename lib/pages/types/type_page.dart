import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spend_tracker/database/db_provider.dart';
import 'package:spend_tracker/models/item_type.dart';
import 'package:spend_tracker/pages/icons/icon_holder.dart';
import 'package:spend_tracker/support/icon_helper.dart';

class TypePage extends StatefulWidget {
  final ItemType itemType;

  TypePage({this.itemType});

  @override
  _TypePageState createState() => _TypePageState();
}

class _TypePageState extends State<TypePage> {
  Map<String, dynamic> _data;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.itemType != null) {
      _data = widget.itemType.toMap();
    } else {
      _data = Map<String, dynamic>();
      _data['codePoint'] = Icons.add.codePoint;
    }
  }

  @override
  Widget build(BuildContext context) {
    var dbProvider = Provider.of<DbProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Type'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () async {
                if (!_formKey.currentState.validate()) return;
                _formKey.currentState.save();
                var itemType = ItemType.fromMap(_data);
                if (itemType.id == null) {
                  await dbProvider.createItemType(itemType);
                } else {
                  await dbProvider.updateItemType(itemType);
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
                    widget.itemType != null ? widget.itemType.name : '',
                decoration: InputDecoration(labelText: 'Name'),
                validator: (String value) {
                  if (value.isEmpty) return 'Required';
                },
                onSaved: (String value) => _data['name'] = value,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
