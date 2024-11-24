import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'sell/presentation/pages/sell.dart';
import 'records.dart';
import 'buy/presentation/pages/buy.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final bs = BehaviorSubject<int>.seeded(0);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Diary'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<int>(
                stream: bs,
                builder: (context, snapshot) {
                  if (snapshot.data == 0) {
                    return const Buy();
                  } else if (snapshot.data == 1) {
                    return const Sell();
                  }
                  return const Records();
                },
              ),
            ),
            Container(
              color: Colors.grey.shade100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  navButton(
                    text: 'Buy',
                    icon: Icons.money_off,
                    index: 0,
                  ),
                  navButton(
                    text: 'Sell',
                    icon: Icons.money_rounded,
                    index: 1,
                  ),
                  navButton(
                    text: 'Records',
                    icon: Icons.list_rounded,
                    index: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget navButton({
    required String text,
    required IconData icon,
    required int index,
  }) {
    Color color;
    return StreamBuilder(
      stream: bs,
      builder: (context, snapshot) {
        color = (snapshot.data == index) ? Theme.of(context).colorScheme.primary : Colors.grey;
        return TextButton(
          onPressed: () {
            bs.add(index);
          },
          style: ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(color),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          child: Column(
            children: [
              Icon(icon),
              Text(text),
            ],
          ),
        );
      },
    );
  }
}
