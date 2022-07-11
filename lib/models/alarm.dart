import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'alarm.g.dart';

@JsonSerializable()
class Alarm {
  Alarm.createNew(this.id)
      : title = "",
        word = "",
        time = DateTime.now(),
        location = "",
        description = "";

  Alarm(this.id, this.location, this.time, this.title, this.vehicles, this.word,
      this.participants, this.description, this.image);

  String id;
  String title;
  String word;

  @JsonKey(toJson: _timeToJson)
  DateTime time;
  String location;

  String? vehicles;
  int? participants;
  String description;
  String? image;

  factory Alarm.fromJson(Map<String, dynamic> json) => _$AlarmFromJson(json);

  Map<String, dynamic> toJson() => _$AlarmToJson(this);

  static String? _timeToJson(DateTime? time) {
    if (time != null) {
      final DateFormat formatter = DateFormat('yyyy-MM-ddTHH:mm');
      return formatter.format(time);
    } else {
      return '';
    }
  }

  bool hasChanges(Alarm alarm) {
    if (id != alarm.id) {
      throw Exception("The given alarm has an other id!");
    }

    return title != alarm.title ||
        word != alarm.word ||
        time != alarm.time ||
        location != alarm.location ||
        vehicles != alarm.vehicles ||
        participants != alarm.participants ||
        description != alarm.description ||
        image != alarm.image;
  }
}
