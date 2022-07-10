// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Alarm _$AlarmFromJson(Map<String, dynamic> json) => Alarm(
      json['id'] as String,
      json['location'] as String,
      DateTime.parse(json['time'] as String),
      json['title'] as String,
      json['vehicles'] as String?,
      json['word'] as String,
      json['participants'] as int?,
      json['description'] as String,
      json['image'] as String?,
    );

Map<String, dynamic> _$AlarmToJson(Alarm instance) => <String, dynamic>{
      'id': instance.id,
      'location': instance.location,
      'time': Alarm._timeToJson(instance.time),
      'title': instance.title,
      'vehicles': instance.vehicles,
      'word': instance.word,
      'participants': instance.participants,
      'description': instance.description,
      'image': instance.image,
    };
