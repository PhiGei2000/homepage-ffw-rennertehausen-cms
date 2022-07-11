import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/alarm.dart';
import '../models/serverData.dart';

class AlarmDetail extends StatefulWidget {
  final String? restorationId;
  final String selectedIndex;

  AlarmDetail(this.restorationId, this.selectedIndex);

  @override
  State<StatefulWidget> createState() => AlarmDetailState();
}

class AlarmDetailState extends State<AlarmDetail> with RestorationMixin {
  static final DateFormat _dateFormatter = DateFormat();

  final _formKey = GlobalKey<FormState>();
  late Alarm _currentAlarm;

  @override
  void initState() {
    super.initState();

    setState(() {
      _currentAlarm = Alarm.createNew(widget.selectedIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    final DateTime selectedDateTime = DateTime(
        _selectedDate.value.year,
        _selectedDate.value.month,
        _selectedDate.value.day,
        _selectedTime.value.hour,
        _selectedTime.value.minute);

    String? notEmptyValidator(String? value) {
      if (value == null || value.isEmpty) {
        return "Dieses Feld darf nicht leer sein!";
      }
      return null;
    }

    return Consumer<ServerData>(
      builder: (context, data, child) {
        Alarm? alarm = data.alarms[widget.selectedIndex]!;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        createTextField(
                          "Id",
                          alarm.id,
                          validator: (id) {
                            if (!RegExp(r"^\d{4}_\d{2}$").hasMatch(id!)) {
                              return "Falsches Format für die Einsatz ID";
                            }

                            return null;
                          },
                          onSaved: (id) => _currentAlarm.id = id!,
                        ),
                        createTextField(
                          "Titel",
                          alarm.title,
                          validator: (title) {
                            if (!RegExp(r"Einsatz \d{2}\/\d{4}")
                                .hasMatch(title!)) {
                              return "Flasches Format";
                            }

                            return null;
                          },
                          onSaved: (title) => _currentAlarm.title = title!,
                        ),
                        createTextField(
                          "Einsatzstichwort",
                          alarm.word,
                          validator: notEmptyValidator,
                          onSaved: (word) => _currentAlarm.word = word!,
                        ),
                        createTextField(
                          "Einsatzort",
                          alarm.location,
                          validator: notEmptyValidator,
                          onSaved: (location) =>
                              _currentAlarm.location = location!,
                        ),
                        createTextField(
                            "Einsatzzeit", _dateFormatter.format(alarm.time),
                            onTap: () {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              _restorableDatePickerRouteFuture.present();
                            },
                            validator: notEmptyValidator,
                            onSaved: (timeString) {
                              final time =
                                  _dateFormatter.parseStrict(timeString!);
                              _currentAlarm.time = time;
                            }),
                        createTextField(
                          "Fahrzeuge",
                          alarm.vehicles,
                          onSaved: (vehicles) =>
                              _currentAlarm.vehicles = vehicles,
                        ),
                        createTextField(
                          "Einsatzkräfte",
                          alarm.participants?.toString(),
                          onSaved: (participants) =>
                              _currentAlarm.participants =
                                  participants != null && !participants.isEmpty
                                      ? int.parse(participants)
                                      : null,
                        ),
                        createTextField(
                          "Beschreibung",
                          alarm.description,
                          maxLines: null,
                          validator: notEmptyValidator,
                          onSaved: (description) =>
                              _currentAlarm.description = description!,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                _formKey.currentState!.save();

                                data.addAlarm(_currentAlarm);
                                Navigator.pop(context);
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Übernehmen"),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 2,
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
          String? Function(String?)? validator,
          int? maxLines = 1}) =>
      TextFormField(
        decoration: InputDecoration(
          labelText: title,
        ),
        initialValue: initialText,
        onSaved: onSaved,
        onTap: onTap,
        validator: validator,
        maxLines: maxLines,
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
