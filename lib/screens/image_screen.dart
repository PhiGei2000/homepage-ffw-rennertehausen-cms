import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/image_source.dart';
import '../models/serverData.dart';

class ImageScreen extends StatefulWidget {
  final String url;

  const ImageScreen(this.url, {super.key});

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
                case ImageType.file:
                  return Image.file(File(image.src));
                case ImageType.network:
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
            .getFolderContent(widget.url))
        .where((element) => element.endsWith(".png"))
        .map((e) => ImageSource(e, ImageType.network))
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
          _images.add(ImageSource(file.path!, ImageType.file));
        }
      });
    }
  }
}
