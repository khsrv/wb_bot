import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:wb_bot_2/providers/order_provider.dart';
import 'package:wb_bot_2/screens/order_screen.dart';
import 'package:wb_bot_2/widgets/buttons/main_button.dart';
import 'package:provider/provider.dart';
import 'package:wb_bot_2/widgets/loader/dark_loader.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Гум маркет",
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: 300,
                height: 50,
                child: MinButton(
                  onTap: () {
                    context.read<OrderProvider>().getNewOrders();
                    context.read<OrderProvider>().getSuppliesList();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OrderScreen(),
                      ),
                    );
                  },
                  title: const Text(
                    "Сборочные задания",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: 300,
                height: 50,
                child: MinButton(
                  onTap: () {},
                  title: const Text(
                    "Товары и остатки",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
