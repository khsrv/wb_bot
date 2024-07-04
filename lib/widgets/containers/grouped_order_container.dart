import 'package:flutter/material.dart';
import 'package:wb_bot_2/models/order_model.dart';
import 'package:wb_bot_2/models/supplies_model.dart';

class GroupedOrderContainer extends StatefulWidget {
  const GroupedOrderContainer(
      {super.key,
      required this.onTap,
      required this.articule,
      required this.count});
  final String articule;
  final String count;
  final Function() onTap;

  @override
  State<GroupedOrderContainer> createState() => _GroupedOrderContainerState();
}

class _GroupedOrderContainerState extends State<GroupedOrderContainer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        width: 200,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Center(
            child: Padding(
          padding: const EdgeInsets.only(left: 32, right: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.articule,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Text(
                    widget.count + "шт.",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Icon(
                      Icons.arrow_forward,
                    ),
                  )
                ],
              ),
            ],
          ),
        )),
      ),
    );
  }
}
