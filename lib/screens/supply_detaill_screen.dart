import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wb_bot_2/models/supplies_model.dart';
import 'package:wb_bot_2/providers/order_provider.dart';
import 'package:wb_bot_2/widgets/buttons/main_button.dart';
import 'package:provider/provider.dart';
import 'package:wb_bot_2/widgets/containers/grouped_order_container.dart';
import 'package:wb_bot_2/widgets/containers/order_container.dart';
import 'package:wb_bot_2/widgets/containers/supply_continer.dart';
import 'package:wb_bot_2/widgets/loader/dark_loader.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class SupplyDetailScreen extends StatefulWidget {
  final Supplies supplyModel;
  const SupplyDetailScreen({super.key, required this.supplyModel});

  @override
  State<SupplyDetailScreen> createState() => _SupplyDetailScreenState();
}

class _SupplyDetailScreenState extends State<SupplyDetailScreen> {
  int groupValue = 0;
  OrderProvider orderProvider = OrderProvider();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        orderProvider = Provider.of<OrderProvider>(context, listen: false);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                // width: 100,
                child: MinButton(
                  onTap: () async {
                    orderProvider
                        .printStickers(
                            orders: orderProvider.orderModelBySupply.orders ?? [])
                        .then((value) {
                      setState(() {});
                    });
                  },
                  title: const Text(
                    "Распечатать всех штрихкодов",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: SizedBox(
                // width: 100,
                child: MinButton(
                  onTap: () async {
                    orderProvider
                        .printListOrder(widget.supplyModel.id.toString()+ widget.supplyModel.name.toString())
                        .then((value) {
                      setState(() {});
                    });
                  },
                  title: const Text(
                    "Распечатать лист подбора",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("${widget.supplyModel.id} ${widget.supplyModel.name}"),
        centerTitle: true,
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
            if (orderProvider.stickerfile != null)
              Container(
                width: 100,
                height: 400,
                // child: SfPdfViewer.file(orderProvider.stickerfile!),
              ),
            orderProvider.isLoading
                ? const Center(
                    child: DarkLoader(),
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
        return buildOrderList(orderProvider: orderProvider);
      case 1:
        return buildGroupedList(orderProvider: orderProvider);
    }
    return Container();
  }

  Widget buildOrderList({required OrderProvider orderProvider}) {
    if (orderProvider.orderModel.orders != null) {
      return Expanded(
          child: ListView.builder(
              itemBuilder: ((context, index) => OrderContainer(
                    onTap: () {},
                    order: orderProvider.orderModelBySupply.orders![index],
                  )),
              itemCount: orderProvider.orderModelBySupply.orders!.length));
    }
    return Container();
  }

  Widget buildGroupedList({required OrderProvider orderProvider}) {
    return Expanded(
      child: ListView.builder(
        itemBuilder: ((context, index) => GroupedOrderContainer(
              onTap: () {},
              articule: orderProvider.groupedOrders.keys.elementAt(index),
              count: orderProvider.groupedOrders[
                      orderProvider.groupedOrders.keys.elementAt(index)]
                  .toString(),
            )),
        itemCount: orderProvider.groupedOrders.length,
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
        0: buildSegment("Список заказов"),
        1: buildSegment("Группировка по товарам"),
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
