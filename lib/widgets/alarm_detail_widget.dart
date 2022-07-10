import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/alarm.dart';
import '../models/serverData.dart';

class AlarmDetail extends StatefulWidget {
  final String? restorationId;
  final int selectedIndex;

  AlarmDetail(this.restorationId, this.selectedIndex);

  @override
  State<StatefulWidget> createState() => _AlarmDetailState();
}

class _AlarmDetailState extends State<AlarmDetail> with RestorationMixin {
  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormatter = DateFormat('dd.MM.yyyy HH:mm');

    final DateTime selectedDateTime = DateTime(
        _selectedDate.value.year,
        _selectedDate.value.month,
        _selectedDate.value.day,
        _selectedTime.value.hour,
        _selectedTime.value.minute);

    return Consumer<ServerData>(
      builder: (context, data, child) {
        var alarm = data.alarms[widget.selectedIndex];

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    createTextField("Id", alarm.id),
                    createTextField("Titel", alarm.title),
                    createTextField("Einsatzstichwort", alarm.word),
                    createTextField("Einsatzort", alarm.location),
                    createTextField(
                      "Einsatzzeit",
                      dateFormatter.format(alarm.time),
                      onTap: () {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        _restorableDatePickerRouteFuture.present();
                      },
                    ),
                    createTextField("Fahrzeuge", alarm.vehicles),
                    createTextField(
                        "Einsatzkräfte", alarm.participants.toString())
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Column(children: [
                  Padding(
                      padding: EdgeInsets.all(10.0),
                      child: alarm.image != null
                          ? Image.network(
                              "https://feuerwehr-rennertehausen.de${alarm.image!}")
                          : null),
                ]),
              ),
            ],
          ),
        );
      },
    );
  }

  TextFormField createTextField(String title, String? initialText,
          {void Function(String?)? onSaved,
          void Function()? onTap,
          String? Function(String?)? validator}) =>
      TextFormField(
        decoration: InputDecoration(
          labelText: title,
        ),
        initialValue: initialText,
        onSaved: onSaved,
        onTap: onTap,
        validator: validator,
      );

  final RestorableDateTime _selectedDate = RestorableDateTime(DateTime.now());
  final RestorableTimeOfDay _selectedTime =
      RestorableTimeOfDay(TimeOfDay.now());

  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
      RestorableRouteFuture<DateTime?>(
          onPresent: (NavigatorState navigator, Object? arguments) {
    return navigator.restorablePush(_datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch);
  }, onComplete: (DateTime? date) {
    _restorableTimePickerRouteFuture.present(date!.millisecondsSinceEpoch);
    _selectDate(date);
  });

  late final RestorableRouteFuture<TimeOfDay?>
      _restorableTimePickerRouteFuture = RestorableRouteFuture<TimeOfDay?>(
          onPresent: (NavigatorState navigator, Object? arguments) {
            return navigator.restorablePush(_timePickerRoute,
                arguments: arguments);
          },
          onComplete: _selectTime);

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(_selectedTime, 'selected_time');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
    registerForRestoration(
        _restorableTimePickerRouteFuture, 'time_picker_route_future');
  }

  _selectDate(DateTime? date) {
    if (date != null) {
      setState(() {
        _selectedDate.value = date;
      });
    }
  }

  void _selectTime(TimeOfDay? time) {
    if (time != null) {
      setState(() {
        _selectedTime.value = time;
      });
    }
  }

  static Route<DateTime> _datePickerRoute(
      BuildContext context, Object? arguments) {
    return DialogRoute(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          firstDate: DateTime.fromMillisecondsSinceEpoch(0),
          lastDate: DateTime.now(),
        );
      },
    );
  }

  static Route<TimeOfDay> _timePickerRoute(
      BuildContext context, Object? arguments) {
    return DialogRoute(
      context: context,
      builder: (BuildContext context) {
        return TimePickerDialog(
          restorationId: 'time_picker_dialog',
          initialTime: TimeOfDay.fromDateTime(
            DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          ),
        );
      },
    );
  }
}
