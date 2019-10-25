import 'package:flutter/material.dart';
import 'package:flutter_weather/language.dart';
import 'package:flutter_weather/model/holder/shared_depository.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_weather/utils/channel_util.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class WatcherPopupBtn extends StatelessWidget {
  final String url;
  final Function(String) onSnackShow;

  WatcherPopupBtn({@required this.url, @required this.onSnackShow});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(
        Icons.more_vert,
        color: Colors.white,
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: "save",
          child: Text(AppText.of(context).imgSave),
        ),
        PopupMenuItem(
          value: "wallpaper",
          child: Text(AppText.of(context).setAsWallpaper),
        ),
      ],
      onSelected: (value) async {
        switch (value) {
          case "save":
            if (url == null) return;

            final savedImgs = SharedDepository().savedImages;
            if (savedImgs.contains(url)) return;

            final file = await DefaultCacheManager().getSingleFile(url);
            if (file != null) {
              await SharedDepository().setSavedImages(savedImgs..add(url));
              await ImageGallerySaver.saveImage(file.readAsBytesSync());
              onSnackShow(AppText.of(context).imgSaveSuccess);
            } else {
              onSnackShow(AppText.of(context).imgSaveFail);
            }

            break;
          case "wallpaper":
            if (url == null) return;

            final savedImgs = SharedDepository().savedImages;
            if (savedImgs.contains(url)) return;

            final file = await DefaultCacheManager().getSingleFile(url);
            if (file != null) {
              await SharedDepository().setSavedImages(savedImgs..add(url));
              await ImageGallerySaver.saveImage(file.readAsBytesSync());
              ChannelUtil.setWallpaper(path: file.absolute.path);
            } else {
              onSnackShow(AppText.of(context).canNotSetWallpaper);
            }

            break;
        }
      },
    );
  }
}
