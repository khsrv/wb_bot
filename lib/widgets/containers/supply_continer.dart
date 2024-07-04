import 'package:flutter/material.dart';
import 'package:wb_bot_2/models/supplies_model.dart';

class SuppliesContainer extends StatefulWidget {
  const SuppliesContainer(
      {super.key,
      required this.onTap,
      required this.supplies,
      required this.onTapPrinter});
  final Function() onTap;
  final Function() onTapPrinter;

  final Supplies supplies;

  @override
  State<SuppliesContainer> createState() => _SuppliesContainerState();
}

class _SuppliesContainerState extends State<SuppliesContainer> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTap();
      },
      child: Padding(
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
                    widget.supplies.id ?? '',
                  ),
                  Row(
                    children: [
                      Text(
                        widget.supplies.name ?? '',
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      const Icon(Icons.print),
                      const SizedBox(
                        width: 20,
                      ),
                      const Icon(Icons.list),
                      const SizedBox(
                        width: 20,
                      ),
                      const Icon(Icons.more_vert),
                      const SizedBox(
                        width: 20,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
