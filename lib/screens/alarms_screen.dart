import 'package:flutter/material.dart';
import 'package:homepage_ffw_rennertehausen_cms/widgets/alarm_detail_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/serverData.dart';

class AlarmsScreen extends StatelessWidget {
  AlarmsScreen(this.restorationId);

  final String? restorationId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Einsätze bearbeiten"),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Consumer<ServerData>(
              builder: alarmsBuilder,
            ),
            const VerticalDivider(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: addButtonPressed, child: const Icon(Icons.add)),
    );
  }

  Widget alarmsBuilder(BuildContext context, ServerData data, Widget? child) {
    if (data.dataLoaded) {
      return Flexible(
        flex: 1,
        child: Column(
          children: [
            const Text("Einsätze", style: TextStyle(fontSize: 24)),
            Expanded(
              child: ListView.builder(
                itemCount: data.alarms.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (_, index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Card(
                    child: ListTile(
                      key: Key(data.alarms[index].id),
                      title: Text(data.alarms[index].id),
                      subtitle: Text(data.alarms[index].word),
                      onTap: () {
                        Navigator.pushNamed(context, "/alarmDetail",
                            arguments: index);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  void addButtonPressed() {}
}
