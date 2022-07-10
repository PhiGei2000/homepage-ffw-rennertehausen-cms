import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'alarm.g.dart';

@JsonSerializable()
class Alarm {
  Alarm(this.id, this.location, this.time, this.title, this.vehicles, this.word,
      this.participants, this.description, this.image);

  String id;
  String location;

  @JsonKey(toJson: _timeToJson)
  DateTime time;
  String title;

  String? vehicles;
  String word;
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
}
