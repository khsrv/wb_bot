import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wb_bot_2/widgets/loader/dark_loader.dart';

class MinButton extends StatefulWidget {
  const MinButton(
      {super.key,
      this.isLoading = false,
      required this.onTap,
      required this.title,
      this.color,
      this.height});
  final bool isLoading;
  final Function() onTap;
  final Widget title;
  final Color? color;
  final double? height;

  @override
  State<MinButton> createState() => _MinButtonState();
}

class _MinButtonState extends State<MinButton> {
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        if (!widget.isLoading) {
          widget.onTap();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: widget.color ?? Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(16),
        ),
        width: MediaQuery.of(context).size.width,
        height: widget.height ?? 64,
        child: widget.isLoading
            ? const Center(child: DarkLoader())
            : Center(
                child: widget.title,
              ),
      ),
    );
  }
}
