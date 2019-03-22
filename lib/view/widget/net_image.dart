import 'package:flutter_weather/commom_import.dart';

/// 加载网络图片
class NetImage extends StatelessWidget {
  /// 图片url地址
  final String url;

  /// 图片宽高
  final double height;
  final double width;

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
      fit: BoxFit.cover,
      placeholder: placeholder ??
          Container(
            height: height,
            width: width,
            color: AppColor.colorHolder,
          ),
    );

    return isCircle ? ClipOval(child: img) : img;
  }
}
