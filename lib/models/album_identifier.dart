enum ImageType { alarms, exercises /*, news */ }

class AlbumIdentifier {
  String id;
  ImageType type;

  AlbumIdentifier(this.id, this.type);

  String getImageFolderPath() => '/img/${type.name}/$id';
}
