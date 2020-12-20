import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spend_tracker/database/db_provider.dart';
import 'package:spend_tracker/models/item_type.dart';
import 'package:spend_tracker/pages/types/type_page.dart';

class TypesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var dbProvider = Provider.of<DbProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Types'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => TypePage(),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<ItemType>>(
        future: dbProvider.getAllItemTypes(),
        builder: (_, AsyncSnapshot<List<ItemType>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          var itemTypes = snapshot.data;
          if (itemTypes.length == 0) {
            return Center(child: Text('No Records.'));
          }
          return ListView.builder(
            itemCount: itemTypes.length,
            itemBuilder: (_, index) {
              var itemType = itemTypes[index];
              return ListTile(
                leading: Icon(itemType.iconData),
                title: Text(itemType.name),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TypePage(itemType: itemType),
                      ));
                },
              );
            },
          );
        },
      ),
    );
  }
}
