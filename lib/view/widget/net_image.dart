import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/common/colors.dart';

/// 加载网络图片
class NetImage extends StatelessWidget {
  /// 图片url地址
  final String url;

  /// 图片宽高
  final double height;
  final double width;

  final BoxFit fit;

  /// 是否为圆形图片
  final bool isCircle;
  final Map<String, String> headers;
  final Widget placeholder;

  NetImage(
      {Key key,
      @required this.url,
      this.height,
      this.width,
      this.isCircle = false,
      this.headers,
      this.fit = BoxFit.cover,
      this.placeholder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final img = CachedNetworkImage(
      httpHeaders: headers,
      imageUrl: url,
      height: height,
      width: width,
      fadeInDuration: const Duration(milliseconds: 300),
      fit: fit,
      placeholder: (context, url) =>
          placeholder ??
          Container(
            height: height,
            width: width,
            color: AppColor.colorHolder,
          ),
      errorWidget: (context, url, error) =>
          placeholder ??
          Container(
            height: height,
            width: width,
            color: AppColor.colorHolder,
          ),
    );

    return isCircle ? ClipOval(child: img) : img;
  }
}
