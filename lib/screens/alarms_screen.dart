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
        actions: [
          IconButton(
              onPressed: () => syncButtonPressed(context),
              icon: Icon(Icons.sync))
        ],
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
          onPressed: () => addButtonPressed(context),
          child: const Icon(Icons.add)),
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
                  itemBuilder: (_, index) {
                    final alarmId = data.alarms.keys.elementAt(index);

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Card(
                        child: Row(
                          children: [
                            Expanded(
                              child: ListTile(
                                key: Key(alarmId),
                                title: Text(data.alarms[alarmId]!.title),
                                subtitle: Text(data.alarms[alarmId]!.word),
                                onTap: () {
                                  Navigator.pushNamed(context, "/alarmDetail",
                                      arguments: alarmId);
                                },
                                trailing: data.changedAlarms.contains(alarmId)
                                    ? const Icon(Icons.cached)
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  void addButtonPressed(BuildContext context) {
    // create new alarm
    final newAlarm =
        Provider.of<ServerData>(context, listen: false).createAlarm();

    Navigator.pushNamed(context, '/alarmDetail', arguments: newAlarm.id);
  }

  void syncButtonPressed(BuildContext context) async {
    Provider.of<ServerData>(context, listen: false).syncAlarms();
  }
}
