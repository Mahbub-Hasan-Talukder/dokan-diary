import 'package:diary/features/records/presentation/widgets/day_wise_records_view.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/entities/filter_entity.dart';
import '../widgets/item_wise_records_view.dart';

class Records extends StatefulWidget {
  const Records({super.key});

  @override
  State<Records> createState() => _RecordsState();
}

class _RecordsState extends State<Records> {
  final _filteringBehavior = BehaviorSubject<FilterEntity>.seeded(FilterEntity(
    queryType: QueryTypes.calender,
    sortingOrder: SortingOrder.descending,
    targetAttribute: TargetAttribute.date,
  ));

  @override
  void dispose() {
    _filteringBehavior.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: StreamBuilder(
        stream: _filteringBehavior,
        builder: (context, snapshot) {
          return buildFloatingActionButton(snapshot);
        },
      ),
      body: StreamBuilder(
        stream: _filteringBehavior,
        builder: (context, snapshot) {
          return Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildFilterButton(
                      queryInput: QueryTypes.calender,
                      label: 'By Date',
                      context: context,
                      isActive: QueryTypes.calender ==
                          (snapshot.data?.queryType ?? QueryTypes.calender),
                    ),
                    buildFilterButton(
                      queryInput: QueryTypes.item,
                      label: 'By Product',
                      context: context,
                      isActive: QueryTypes.item ==
                          (snapshot.data?.queryType ?? QueryTypes.item),
                    ),
                  ],
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                filterButton(
                  TargetAttribute.percentage,
                  'By Profit',
                  (snapshot.data?.targetAttribute ??
                          TargetAttribute.percentage) ==
                      TargetAttribute.percentage,
                  snapshot.data,
                ),
                filterButton(
                  TargetAttribute.sell,
                  'By Sell',
                  (snapshot.data?.targetAttribute ?? TargetAttribute.sell) ==
                      TargetAttribute.sell,
                  snapshot.data,
                ),
                filterButton(
                  TargetAttribute.purchase,
                  'By Purchase',
                  (snapshot.data?.targetAttribute ??
                          TargetAttribute.purchase) ==
                      TargetAttribute.purchase,
                  snapshot.data,
                ),
              ]),
              if ((snapshot.data?.queryType ?? QueryTypes.calender) ==
                  QueryTypes.calender)
                DayWiseRecordsView(
                  filterEntity: snapshot.data ?? FilterEntity(),
                ),
              if ((snapshot.data?.queryType ?? QueryTypes.calender) ==
                  QueryTypes.item)
                ItemWiseRecordsView(
                  filterEntity: snapshot.data ?? FilterEntity(),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget buildFloatingActionButton(AsyncSnapshot<FilterEntity> snapshot) {
    return FloatingActionButton(
      onPressed: () {
        final targetOrder =
            ((snapshot.data?.sortingOrder ?? SortingOrder.descending) ==
                    SortingOrder.descending)
                ? SortingOrder.ascending
                : SortingOrder.descending;
        _filteringBehavior.add(FilterEntity.copyWith(
          sortingOrder: targetOrder,
          queryType: snapshot.data?.queryType ?? QueryTypes.calender,
          targetAttribute:
              snapshot.data?.targetAttribute ?? TargetAttribute.date,
        ));
      },
      child: ((snapshot.data?.sortingOrder ?? SortingOrder.descending) ==
              SortingOrder.descending)
          ? const Icon(Icons.arrow_downward)
          : const Icon(Icons.arrow_upward),
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
          FilterEntity en = FilterEntity.copyWith(queryType: queryInput);
          _filteringBehavior.add(FilterEntity.copyWith(queryType: queryInput));
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

  Widget filterButton(TargetAttribute targetAttribute, String label,
      bool isActive, FilterEntity? filterEntity) {
    return ElevatedButton(
      onPressed: () {
        _filteringBehavior.add(
            // FilterEntity.copyWith(targetAttribute: targetAttribute),
            FilterEntity.copyWith(
          sortingOrder: filterEntity?.sortingOrder ?? SortingOrder.descending,
          queryType: filterEntity?.queryType ?? QueryTypes.calender,
          targetAttribute: targetAttribute,
        ));
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
    );
  }
}
