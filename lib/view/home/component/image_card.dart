import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:task_app/utils/size_config.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../../utils/constants.dart';
import '../../../view_model/home_view_model.dart';

class ImageCard extends StatefulWidget {
  const ImageCard({
    Key? key,
    required this.image,
    required this.index,
  }) : super(key: key);

  final String image;
  final int index;

  @override
  State<ImageCard> createState() => _ImageCardState();
}

class _ImageCardState extends State<ImageCard> {
  var value;
  @override
  void initState() {
    super.initState();
    generateThumbnail();
  }

  generateThumbnail() async {
    try {
      var a = await VideoThumbnail.thumbnailFile(
        video: widget.image.toString(),
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.WEBP,
        maxHeight: 64,
        quality: 75,
      ).then((v) {
        setState(() {
          value = v;
        });
      });
    } catch (e) {
      setState(() {
        value = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    HomeViewModel homeProvider = Provider.of<HomeViewModel>(context);

    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: getProportionateScreenWidth(PADING_2XL_SIZE * 8),
          child: value == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : value is String
                  ? Image.file(
                      File(value),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    )
                  : Image.asset('assets/images/image_default.png',
                      fit: BoxFit.cover),
        ),
        SizedBox(
          width: double.infinity,
          height: getProportionateScreenWidth(PADING_2XL_SIZE * 8),
          child: GestureDetector(
            onTap: () {
              homeProvider.setCurrentVideoPlayed(widget.index);
            },
            child: const Center(
              child: Icon(
                Icons.play_circle_fill_outlined,
                size: 40.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}