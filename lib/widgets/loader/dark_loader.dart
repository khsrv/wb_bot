import 'package:flutter/cupertino.dart';

class DarkLoader extends StatelessWidget {
  const DarkLoader(
      {Key? key, this.radius = 10, this.brightness = Brightness.dark})
      : super(key: key);

  final double radius;
  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    return const Center(child: CupertinoActivityIndicator());
  }
}
