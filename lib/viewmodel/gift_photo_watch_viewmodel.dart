import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_weather/model/data/mzi_data.dart';
import 'package:flutter_weather/model/holder/fav_holder.dart';
import 'package:flutter_weather/model/holder/shared_depository.dart';
import 'package:flutter_weather/utils/channel_util.dart';
import 'package:flutter_weather/viewmodel/viewmodel.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class GiftPhotoWatchViewModel<T> extends ViewModel {
  final favList = StreamController<List<MziItem>>();
  final data = StreamController<List<MziItem>>();

  GiftPhotoWatchViewModel({@required Stream<List<MziItem>> photoStream}) {
    FavHolder().favMziStream.listen((v) => favList.safeAdd(v)).bindLife(this);

    if (photoStream != null) {
      photoStream.listen((v) => data.safeAdd(v)).bindLife(this);
    }

    favList.safeAdd(FavHolder().favMzis);
  }

  Future<bool> saveImage(String url) async {
    if (url == null) {
      return false;
    }

    final savedImgs = SharedDepository().savedImages;
    if (savedImgs.contains(url)) {
      return false;
    }

    final file = await DefaultCacheManager().getSingleFile(url);
    if (file != null) {
      await SharedDepository().setSavedImages(savedImgs..add(url));
      await ImageGallerySaver.saveImage(file.readAsBytesSync());

      return true;
    } else {
      return false;
    }
  }

  Future<bool> setWallpaper(String url) async {
    if (url == null) {
      return false;
    }

    final file = await DefaultCacheManager().getSingleFile(url);
    if (file != null) {
      final savedImgs = SharedDepository().savedImages;
      if (!savedImgs.contains(url)) {
        SharedDepository()
            .setSavedImages(SharedDepository().savedImages..add(url));
        await ImageGallerySaver.saveImage(file.readAsBytesSync());
      }

      ChannelUtil.setWallpaper(path: file.absolute.path);

      return true;
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    data.close();
    favList.close();

    super.dispose();
  }
}
