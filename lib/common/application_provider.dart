import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/single_child_widget.dart';
import 'package:provider/provider.dart';
import 'package:wb_bot_2/providers/order_provider.dart';
import 'package:wb_bot_2/screens/main_screen.dart';

class ApplicationProvider extends StatefulWidget {
  const ApplicationProvider({super.key});

  @override
  State<ApplicationProvider> createState() => _ApplicationProviderState();
}

class _ApplicationProviderState extends State<ApplicationProvider> {
  final List<SingleChildWidget> providers = [
    ChangeNotifierProvider<OrderProvider>(create: (_) => OrderProvider()),
  ];
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: MultiProvider(
        providers: providers,
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: MainScreen(),
        ),
      ),
    );
  }
}
