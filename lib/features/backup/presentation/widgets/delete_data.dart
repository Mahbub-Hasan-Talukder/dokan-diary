import 'package:diary/features/backup/data/data_source/local/sqLite_imp.dart';
import 'package:diary/features/backup/presentation/cubit/backup_data_cubit.dart';
import 'package:diary/features/buy/presentation/cubits/fetch_items/fetch_item_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';

class DeleteWidget extends StatefulWidget {
  const DeleteWidget({super.key});

  @override
  State<DeleteWidget> createState() => _DeleteWidgetState();
}

class _DeleteWidgetState extends State<DeleteWidget> {
  final FetchItemCubit _itemCubit = getIt.get<FetchItemCubit>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text(
                    'Delete Data',
                    style: TextStyle(color: Colors.red),
                  ),
                  content:
                      const Text('Are you sure you want to delete your data?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('No'),
                    ),
                    TextButton(
                      onPressed: () {
                        SqLiteImp().instantDelete();
                        _itemCubit.fetchItems();
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Yes',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          style: ButtonStyle(
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            backgroundColor: WidgetStatePropertyAll(
              Theme.of(context).colorScheme.primary,
            ),
            foregroundColor: WidgetStatePropertyAll(
              Theme.of(context).colorScheme.surface,
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.delete_rounded),
              SizedBox(width: 10),
              Text(
                'Delete',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
