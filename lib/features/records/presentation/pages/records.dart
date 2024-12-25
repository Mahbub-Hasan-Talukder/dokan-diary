import 'package:diary/core/services/date_time_format.dart';
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
    dateRange: DateRange(
      startDate: DateTime.now().subtract(const Duration(days: 366)),
      endDate: DateTime.now(),
    ),
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
          print('dbg build startDate: ${snapshot.data?.dateRange?.startDate}');
          print('dbg build endDate: ${snapshot.data?.dateRange?.endDate}');
          return Column(
            children: [
              _dateRange(context, snapshot),
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
                      filterEntity: snapshot.data,
                    ),
                    buildFilterButton(
                      queryInput: QueryTypes.item,
                      label: 'By Product',
                      context: context,
                      isActive: QueryTypes.item ==
                          (snapshot.data?.queryType ?? QueryTypes.item),
                      filterEntity: snapshot.data,
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
                  filterEntity: snapshot.data ?? _filteringBehavior.value,
                ),
              if ((snapshot.data?.queryType ?? QueryTypes.calender) ==
                  QueryTypes.item)
                ItemWiseRecordsView(
                  filterEntity: snapshot.data ?? _filteringBehavior.value,
                ),
            ],
          );
        },
      ),
    );
  }

  SingleChildScrollView _dateRange(
      BuildContext context, AsyncSnapshot<FilterEntity> snapshot) {
    return SingleChildScrollView(
      //show date range
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.surface,
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${DateTimeFormat.getPrettyDate(snapshot.data?.dateRange?.startDate ?? DateTime.now())} - ${DateTimeFormat.getPrettyDate(snapshot.data?.dateRange?.endDate ?? DateTime.now())}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () async {
                    final DateTimeRange? picked = await showDateRangePicker(
                      context: context,
                      firstDate:
                          DateTime.now().subtract(const Duration(days: 366)),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      _filteringBehavior.add(
                        FilterEntity.copyWith(
                          queryType: QueryTypes.calender,
                          dateRange: DateRange(
                            startDate: picked.start,
                            endDate: picked.end,
                          ),
                        ),
                      );
                    }
                  },
                  icon: Icon(
                    Icons.calendar_month,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
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
    FilterEntity? filterEntity,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      width: MediaQuery.sizeOf(context).width * .48,
      child: Material(
        elevation: isActive ? 2 : 0,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            _filteringBehavior.add(FilterEntity.copyWith(
              queryType: queryInput,
              dateRange: filterEntity?.dateRange,
            ));
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: isActive
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surface,
              border: Border.all(
                color: isActive
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline.withOpacity(0.5),
              ),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isActive
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget filterButton(
    TargetAttribute targetAttribute,
    String label,
    bool isActive,
    FilterEntity? filterEntity,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Material(
        elevation: isActive ? 2 : 0,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            _filteringBehavior.add(FilterEntity.copyWith(
              sortingOrder:
                  filterEntity?.sortingOrder ?? SortingOrder.descending,
              queryType: filterEntity?.queryType ?? QueryTypes.calender,
              targetAttribute: targetAttribute,
              dateRange: filterEntity?.dateRange,
            ));
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: isActive
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surface,
              border: Border.all(
                color: isActive
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline.withOpacity(0.5),
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: isActive
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
