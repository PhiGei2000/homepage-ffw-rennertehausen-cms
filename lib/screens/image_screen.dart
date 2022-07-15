import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:homepage_ffw_rennertehausen_cms/models/album_identifier.dart';
import 'package:provider/provider.dart';

import '../models/image_source.dart';
import '../models/serverData.dart';

class ImageScreen extends StatefulWidget {
  final AlbumIdentifier identifier;

  const ImageScreen(this.identifier, {super.key});

  @override
  State<StatefulWidget> createState() => ImageScreenState();
}

class ImageScreenState extends State<ImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Bilder auswählen"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisSpacing: 16.0,
            ),
            itemBuilder: (context, index) {
              final image = _images[index];

              switch (image.type) {
                case ImageSourceType.file:
                  return Image.file(File(image.src));
                case ImageSourceType.network:
                  return Image.network(
                      "https://feuerwehr-rennertehausen.de${widget.url}/${image.src}");
              }
            },
            itemCount: _images.length,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: addImages,
          child: const Icon(Icons.add),
        ));
  }

  List<ImageSource> _images = [];

  @override
  void initState() {
    super.initState();

    getImages();
  }

  void getImages() async {
    final images = (await Provider.of<ServerData>(context, listen: false)
            .getFolderContent(widget.identifier.getImageFolderPath()))
        .where((element) => element.endsWith(".png"))
        .map((e) => ImageSource(e, ImageSourceType.network))
        .toList();

    setState(() {
      _images = images;
    });
  }

  void addImages() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        for (final file in result.files) {
          final source = ImageSource(file.path!, ImageSourceType.file);

          _images.add(source);
          Provider.of<ServerData>(context)
              .addImage(source, widget.identifier.type, widget.identifier.id);
        }
      });
    }
  }
}
