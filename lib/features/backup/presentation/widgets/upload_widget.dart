import 'package:diary/features/backup/presentation/cubit/backup_data_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';

class UploadWidget extends StatefulWidget {
  const UploadWidget({super.key});

  @override
  State<UploadWidget> createState() => _UploadWidgetState();
}

class _UploadWidgetState extends State<UploadWidget> {
  final BackupDataCubit _backupDataCubit = getIt.get<BackupDataCubit>();
  // @override
  // void dispose() {
  //   _backupDataCubit.close();
  //   super.dispose();
  // }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<BackupDataCubit, BackupDataState>(
        bloc: _backupDataCubit,
        builder: (context, state) {
          if (state is UploadDataLoading) {
            return const CircularProgressIndicator();
          }
          if (state is UploadDataSuccess) {
            WidgetsBinding.instance.addPostFrameCallback((t) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.successMsg),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
              );
            });
          }
          if (state is UploadDataFailed) {
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
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Upload Data'),
                      content:
                          const Text('Are you sure you want to upload data?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('No'),
                        ),
                        TextButton(
                          onPressed: () {
                            _backupDataCubit.uploadData();
                            Navigator.of(context).pop();
                          },
                          child: const Text('Yes'),
                        ),
                      ],
                    );
                  });
            },
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                Theme.of(context).colorScheme.primary,
              ),
              foregroundColor: WidgetStatePropertyAll(
                Theme.of(context).colorScheme.surface,
              ),
            ),
            child: Text('Upload'),
          );
        },
      ),
    );
  }
}
