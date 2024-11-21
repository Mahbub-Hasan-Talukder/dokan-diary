import 'package:diary/features/backup/presentation/widgets/restore_widget.dart';
import 'package:diary/features/backup/presentation/widgets/upload_widget.dart';
import 'package:flutter/material.dart';

class Records extends StatelessWidget {
  const Records({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            UploadWidget(),
            RestoreWidget()
          ],
        ),
        Text('Records'),
      ],
    );
  }
}
