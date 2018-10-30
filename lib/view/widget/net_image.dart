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

  NetImage(
      {Key key,
      @required this.url,
      @required this.height,
      @required this.width,
      this.isCircle = false,
      this.headers})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final img = CachedNetworkImage(
      httpHeaders: headers,
      imageUrl: url,
      height: height,
      width: width,
      fit: BoxFit.cover,
      placeholder: Container(
        height: height,
        width: width,
        color: AppColor.colorHolder,
      ),
    );

    return isCircle ? ClipOval(child: img) : img;
  }
}
