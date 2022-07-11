import 'package:flutter/material.dart';

class OverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Feuerwehr Rennertehausen"),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Informationen bearbeiten",
                textScaleFactor: 2.0,
                textAlign: TextAlign.justify,
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  _createListTile(context, "Aktuelles", "/news"),
                  _createListTile(context, "Einsätze", "/alarms"),
                  _createListTile(context, "Übungen", "/exercices"),
                  _createListTile(context, "Termine", "/")
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createListTile(BuildContext context, String title, String routeName) {
    return Card(
      child: ListTile(
        key: UniqueKey(),
        title: Text(title),
        onTap: () => Navigator.pushNamed(context, routeName),
      ),
    );
  }
}
