import 'package:diary/features/records/presentation/widgets/day_wise_records_view.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/entities/filter_entity.dart';


class Records extends StatefulWidget {
  const Records({super.key});

  @override
  State<Records> createState() => _RecordsState();
}

class _RecordsState extends State<Records> {
  final _queryType = BehaviorSubject<QueryTypes>.seeded(QueryTypes.date);
  final _sortingType = BehaviorSubject<SortingOrder>.seeded(SortingOrder.descending);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: StreamBuilder(
        stream: _sortingType,
        builder: (context,snapshot) {
          return FloatingActionButton(
            onPressed: () {
              _sortingType.add(
                (snapshot.data == SortingOrder.descending)
                    ? SortingOrder.ascending
                    : SortingOrder.descending,
              );
            },
            child: (snapshot.data == SortingOrder.descending)
                ? const Icon(Icons.arrow_downward)
                : const Icon(Icons.arrow_upward),
          );
        }
      ),
      body: StreamBuilder(
          stream: _queryType,
          builder: (context, snapshot) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildFilterButton(
                      queryInput: QueryTypes.date,
                      label: 'By Date',
                      context: context,
                      isActive: QueryTypes.date == snapshot.data,
                    ),
                    buildFilterButton(
                      queryInput: QueryTypes.item,
                      label: 'By Product',
                      context: context,
                      isActive: QueryTypes.item == snapshot.data,
                    ),
                  ],
                ),
                if (_queryType.value == QueryTypes.date)
                  DayWiseRecordsView(
                    sortingType: _sortingType,
                  ),
              ],
            );
          }),
    );
  }

  Widget buildFilterButton({
    required QueryTypes queryInput,
    required String label,
    required BuildContext context,
    required bool isActive,
  }) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * .48,
      child: TextButton(
        onPressed: () {
          _queryType.add(queryInput);
        },
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(
            (isActive) ? Theme.of(context).colorScheme.primary : Colors.grey,
          ),
          foregroundColor: WidgetStatePropertyAll(
            Theme.of(context).colorScheme.surface,
          ),
        ),
        child: Text(label),
      ),
    );
  }
}
