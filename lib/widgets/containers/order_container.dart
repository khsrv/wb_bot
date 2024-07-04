import 'package:flutter/material.dart';
import 'package:wb_bot_2/models/order_model.dart';
import 'package:wb_bot_2/models/supplies_model.dart';

class OrderContainer extends StatefulWidget {
  const OrderContainer({super.key, required this.onTap, required this.order});
  final Function() onTap;
  final Orders order;

  @override
  State<OrderContainer> createState() => _OrderContainerState();
}

class _OrderContainerState extends State<OrderContainer> {
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
                "№ ${widget.order.id.toString()}",
              ),
              Row(
                children: [
                  Text(
                    widget.order.article.toString(),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Icon(Icons.more_vert),
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
