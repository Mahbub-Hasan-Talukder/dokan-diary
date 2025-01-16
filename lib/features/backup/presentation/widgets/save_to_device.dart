// import 'package:diary/features/backup/presentation/cubit/backup_data_cubit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../../core/di/di.dart';

// class SaveToDeviceWidget extends StatefulWidget {
//   const SaveToDeviceWidget({super.key});

//   @override
//   State<SaveToDeviceWidget> createState() => _SaveToDeviceWidgetState();
// }

// class _SaveToDeviceWidgetState extends State<SaveToDeviceWidget> {
//   final BackupDataCubit _backupDataCubit = getIt.get<BackupDataCubit>();
//   // @override
//   // void dispose() {
//   //   _backupDataCubit.close();
//   //   super.dispose();
//   // }
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<BackupDataCubit, BackupDataState>(
//       bloc: _backupDataCubit,
//       builder: (context, state) {
//         if (state is SaveToDeviceLoading) {
//           return const SizedBox(
//             height: 10,
//             width: 10,
//             child: CircularProgressIndicator(),
//           );
//         }
//         if (state is SaveToDeviceSuccess) {
//           WidgetsBinding.instance.addPostFrameCallback((t) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.successMsg),
//                 backgroundColor: Theme.of(context).colorScheme.primary,
//               ),
//             );
//           });
//         }
//         if (state is SaveToDeviceFailed) {
//           WidgetsBinding.instance.addPostFrameCallback((t) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.error),
//                 backgroundColor: Theme.of(context).colorScheme.error,
//               ),
//             );
//           });
//         }
//         return ElevatedButton(
//           onPressed: () {
//             _backupDataCubit.saveToDevice();
//           },
//           style: ButtonStyle(
//             backgroundColor: WidgetStatePropertyAll(
//               Theme.of(context).colorScheme.primary,
//             ),
//             foregroundColor: WidgetStatePropertyAll(
//               Theme.of(context).colorScheme.surface,
//             ),
//           ),
//           child: const Text('Save to local'),
//         );
//       },
//     );
//   }
// }
