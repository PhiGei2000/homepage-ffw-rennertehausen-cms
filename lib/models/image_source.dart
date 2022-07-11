enum ImageType { file, network }

class ImageSource {
  String src;

  ImageType type;

  ImageSource(this.src, this.type);
}
