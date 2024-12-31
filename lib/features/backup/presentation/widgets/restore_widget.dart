import 'package:diary/features/backup/presentation/cubit/backup_data_cubit.dart';
import 'package:diary/features/buy/presentation/cubits/fetch_items/fetch_item_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';

class RestoreWidget extends StatefulWidget {
  const RestoreWidget({super.key});

  @override
  State<RestoreWidget> createState() => _RestoreWidgetState();
}

class _RestoreWidgetState extends State<RestoreWidget> {
  final BackupDataCubit _backupDataCubit = getIt.get<BackupDataCubit>();
  // @override
  // void dispose() {
  //   _backupDataCubit.close();
  //   super.dispose();
  // }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BackupDataCubit, BackupDataState>(
      bloc: _backupDataCubit,
      builder: (context, state) {
        if (state is RestoreDataLoading) {
          return const CircularProgressIndicator();
        }
        if (state is RestoreDataSuccess) {
          getIt.get<FetchItemCubit>().fetchItems();
          WidgetsBinding.instance.addPostFrameCallback((t) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMsg),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            );
          });
        }
        if (state is RestoreDataFailed) {
          WidgetsBinding.instance.addPostFrameCallback((t) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          });
        }
        return SizedBox(
          width: double.infinity,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Restore Data'),
                        content: const Text(
                            'Are you sure you want to restore your data?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('No'),
                          ),
                          TextButton(
                            onPressed: () {
                              _backupDataCubit.restoreData();
                              Navigator.of(context).pop();
                            },
                            child: const Text('Yes'),
                          ),
                        ],
                      );
                    });
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
                  Icon(Icons.restore_rounded),
                  SizedBox(width: 10),
                  Text('Restore'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
