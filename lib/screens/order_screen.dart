import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:wb_bot_2/providers/order_provider.dart';
import 'package:wb_bot_2/screens/supply_detaill_screen.dart';
import 'package:wb_bot_2/widgets/buttons/main_button.dart';
import 'package:provider/provider.dart';
import 'package:wb_bot_2/widgets/containers/order_container.dart';
import 'package:wb_bot_2/widgets/containers/supply_continer.dart';
import 'package:wb_bot_2/widgets/loader/dark_loader.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int groupValue = 0;
  OrderProvider orderProvider = OrderProvider();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      orderProvider = Provider.of<OrderProvider>(context, listen: false);
      orderProvider.getSuppliesList();
      orderProvider.getNewOrders().then((value) {
        setState(() {});
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(32.0),
        child: SizedBox(
          width: 100,
          child: groupValue == 1 || groupValue == 0
              ? MinButton(
                  onTap: () {},
                  title: Text(
                    groupValue == 1
                        ? "Создать новый Лист"
                        : "Добавить все задания в поставку",
                    style: const TextStyle(color: Colors.white),
                  ),
                )
              : const SizedBox(),
        ),
      ),
      appBar: AppBar(
        title: const Text(
          "Заказы",
        ),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () async {
              await orderProvider.getNewOrders();
              orderProvider.getSuppliesList().then((value) {
                setState(() {});
              });
            },
            child: const Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
              child: Icon(
                Icons.update,
              ),
            ),
          ),
          const SizedBox(
            width: 50,
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: buildSegmentSlider(),
            ),
            orderProvider.isLoading
                ? Column(
                    children: const [
                      Center(
                        child: DarkLoader(),
                      ),
                    ],
                  )
                : buildEvents(orderProvider: orderProvider),
          ],
        ),
      ),
    );
  }

  Widget buildEvents({required OrderProvider orderProvider}) {
    if (orderProvider.isLoading) {
      return const Center(child: DarkLoader());
    }
    switch (groupValue) {
      case 0:
        return buildNewOrders(orderProvider: orderProvider);
      case 1:
        return buildSupplyList(orderProvider: orderProvider);
      // case 2:
      //   return builOnDelivery(orderProvider: orderProvider);
    }
    return Container();
  }

  Widget buildNewOrders({required OrderProvider orderProvider}) {
    if (orderProvider.orderModel.orders != null) {
      return Expanded(
          child: ListView.builder(
              itemBuilder: ((context, index) => OrderContainer(
                    onTap: () {},
                    order: orderProvider.orderModel.orders![index],
                  )),
              itemCount: orderProvider.orderModel.orders!.length));
    }
    return Container();
  }

  Widget buildSupplyList({required OrderProvider orderProvider}) {
    return Expanded(
      child: ListView.builder(
        itemBuilder: ((context, index) => SuppliesContainer(
              onTap: () {
                if (orderProvider.supplies[index].id != null) {
                  orderProvider.getOrdersBySupply(
                    supplyId: orderProvider.supplies[index].id ?? '',
                  );
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SupplyDetailScreen(
                      supplyModel: orderProvider.supplies[index],
                    ),
                  ),
                );
              },
              supplies: orderProvider.supplies[index],
              onTapPrinter: () {},
            )),
        itemCount: orderProvider.supplies.length,
      ),
    );
  }

  Widget builOnDelivery({required OrderProvider orderProvider}) {
    return Container();
  }

  Widget buildSegmentSlider() {
    return CupertinoSlidingSegmentedControl<int>(
      groupValue: groupValue,
      backgroundColor: Colors.grey.withOpacity(0.2),
      thumbColor: Colors.white,
      children: {
        0: buildSegment("Новые"),
        1: buildSegment("На сборке"),
        // 2: buildSegment("В доставке"),
      },
      padding: EdgeInsets.zero,
      onValueChanged: (value) {
        setState(() {
          groupValue = value!;
          // provider.changeEventType(value);
        });
      },
    );
  }

  Widget buildSegment(String text) {
    return Container(
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 10,
      ),
      child: Text(
        text,
      ),
    );
  }
}
