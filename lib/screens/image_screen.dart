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
          title: const Text("Bilder hochladen"),
          actions: [
            IconButton(
                onPressed: () {
                  Provider.of<ServerData>(context, listen: false)
                      .uploadImages();
                },
                icon: Icon(Icons.upload)),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
            ),
            itemBuilder: (context, index) {
              final image = _images[index];

              return Padding(
                  padding: EdgeInsets.all(8),
                  child: Card(
                      child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      getImage(image),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(image.src),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.arrow_left),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.delete),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.arrow_right),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )));
            },
            itemCount: _images.length,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: addImages,
          child: const Icon(Icons.add),
        ));
  }

  Image getImage(ImageSource source) {
    switch (source.type) {
      case ImageSourceType.file:
        return Image.file(File(source.src));
      case ImageSourceType.network:
        return Image.network(
            "https://feuerwehr-rennertehausen.de/${widget.identifier.getImageFolderPath()}/${source.src}");
    }
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
          Provider.of<ServerData>(context, listen: false)
              .addImage(source, widget.identifier.type, widget.identifier.id);
        }
      });
    }
  }
}
