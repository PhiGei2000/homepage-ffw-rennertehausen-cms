enum ImageSourceType { file, network }

class ImageSource {
  String src;

  ImageSourceType type;

  ImageSource(this.src, this.type);
}
