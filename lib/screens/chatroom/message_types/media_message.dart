import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class MediaMessageWidget extends HookWidget {
  const MediaMessageWidget(this.chatMessagelModel, {Key? key})
      : super(key: key);

  final ChatMesssageModel chatMessagelModel;

  @override
  Widget build(BuildContext context) {
    final fileStream =
        useStream(useMemoized(() => downloadFiles(chatMessagelModel)));

     final storageRef = FirebaseStorage.instance;

     getMetaData(url) async {
      final metadata = await storageRef.refFromURL(url).getMetadata();
      metadata.contentType;
     }



    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            GalleryWidget(imageFileList: chatMessagelModel.resUrls!),
      )),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.45,
        child: Stack(
          alignment: Alignment.center,
          children: const [
           Text("Hello"),
          ],
        ),
      ),
    );
  }

  mediaType(ChatMesssageModel chatMesssageModel) {
    if (chatMessagelModel.resUrls!.length >= 2) {
      return MultimediaWidget(chatMesssageModel: chatMesssageModel);
    }
  }

    

  Stream<List<File>> downloadFiles(ChatMesssageModel model) async* {
    final id = model.id;
    List<File> fileList = [];

    if (model.resUrls == null) throw "Your list is null";

    for (var i = 0; i < model.resUrls!.length; i++) {
      
      yield fileList;
    }
  }
}

class SingleImageWidget extends StatelessWidget {
  final ChatMesssageModel chatMesssageModel;
  const SingleImageWidget({Key? key, required this.chatMesssageModel})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class SingleVideoWidget extends StatelessWidget {
  final ChatMesssageModel chatMesssageModel;
  const SingleVideoWidget({Key? key, required this.chatMesssageModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class MultimediaWidget extends StatelessWidget {
  final ChatMesssageModel chatMesssageModel;
  const MultimediaWidget({Key? key, required this.chatMesssageModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class GalleryWidget extends StatelessWidget {
  const GalleryWidget({Key? key, required this.imageFileList})
      : super(key: key);

  final List<String> imageFileList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: PhotoViewGallery.builder(
              backgroundDecoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor),
              itemCount: imageFileList.length,
              builder: (_, index) {
                return PhotoViewGalleryPageOptions(
                  initialScale: PhotoViewComputedScale.contained * 0.8,
                  minScale: PhotoViewComputedScale.contained * 0.8,
                  maxScale: PhotoViewComputedScale.covered * 1.1,
                  imageProvider: NetworkImage(imageFileList[index]),
                );
              },
              loadingBuilder: (_, __) => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
