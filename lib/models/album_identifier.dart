import 'package:flutter/rendering.dart';

enum ImageType { alarms, exercises /*, news */ }

class AlbumIdentifier {
  // static final _pattern = RegExp(r'/img/()')
  String id;
  ImageType type;

  AlbumIdentifier(this.id, this.type);

  String getImageFolderPath() => '/img/${type.name}/$id';

  static AlbumIdentifier fromPath(String path) {
    final parts = path.split('/');

    if (parts.length == 4 && parts[1] == 'img') {
      switch (parts[2]) {
        case 'alarms':
          return AlbumIdentifier(parts[3], ImageType.alarms);
        case 'exercises':
          return AlbumIdentifier(parts[3], ImageType.exercises);
      }
    }

    throw const FormatException();
  }

  @override
  int get hashCode => hashValues(id.hashCode, type.hashCode);

  @override
  bool operator ==(Object other) =>
      other is AlbumIdentifier && other.id == id && other.type == type;
}
