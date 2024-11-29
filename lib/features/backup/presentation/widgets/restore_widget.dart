import 'package:diary/features/backup/presentation/cubit/backup_data_cubit.dart';
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
          return const SizedBox(
            height: 10,
            width: 10,
            child: CircularProgressIndicator(),
          );
        }
        if (state is RestoreDataSuccess) {
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
        return ElevatedButton(
          onPressed: () {
            _backupDataCubit.restoreData();
          },
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              Theme.of(context).colorScheme.primary,
            ),
            foregroundColor: WidgetStatePropertyAll(
              Theme.of(context).colorScheme.surface,
            ),
          ),
          child: Text('Restore'),
        );
      },
    );
  }
}
