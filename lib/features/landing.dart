import 'package:diary/features/backup/presentation/widgets/delete_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

import 'add_note/presentation/page/notes_list_page.dart';
import 'backup/presentation/widgets/restore_widget.dart';
import 'backup/presentation/widgets/upload_widget.dart';
import 'sell/presentation/pages/sell.dart';
import 'records/presentation/pages/records.dart';
import 'buy/presentation/pages/buy.dart';
import 'dashboard/presentation/pages/dashboard.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final bs = BehaviorSubject<int>.seeded(0);

  Future<bool?> _showBackDialog() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text(
            'Are you sure to exit?',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Exit'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
        final bool shouldPop = await _showBackDialog() ?? false;
        if (context.mounted && shouldPop) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Diary'),
          centerTitle: true,
        ),
        drawer: buildDrawer(context),
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
                    } else if (snapshot.data == 2) {
                      return const Records();
                    } else if (snapshot.data == 3) {
                      return const Dashboard();
                    }
                    return const Records();
                  },
                ),
              ),
              Container(
                //work as bottom nav bar
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
                    navButton(
                      text: 'Dashboard',
                      icon: Icons.dashboard_rounded,
                      index: 3,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Drawer buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotesListPage(),
                ),
              );
            },
            child: const Text('Notes', style: TextStyle(color: Colors.white)),
          ),
          const Expanded(child: SizedBox()),
          const UploadWidget(),
          const RestoreWidget(),
          const DeleteWidget(),
          const SizedBox(height: 20),
        ],
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
        color = (snapshot.data == index)
            ? Theme.of(context).colorScheme.primary
            : Colors.grey;
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
