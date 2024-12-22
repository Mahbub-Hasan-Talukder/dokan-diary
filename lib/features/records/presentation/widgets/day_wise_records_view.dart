import 'package:diary/core/services/date_time_format.dart';
import 'package:diary/features/records/domain/entities/day_wise_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../core/di/di.dart';
import '../../domain/entities/filter_entity.dart';
import '../bloc/day_wise_records/day_wise_cubit.dart';

class DayWiseRecordsView extends StatefulWidget {
  const DayWiseRecordsView({super.key, required this.filterEntity});

  final FilterEntity filterEntity;

  @override
  State<DayWiseRecordsView> createState() => _DayWiseRecordsViewState();
}

class _DayWiseRecordsViewState extends State<DayWiseRecordsView> {
  final DayWiseCubit _dayWiseCubit = getIt.get<DayWiseCubit>();

  @override
  void initState() {
    _dayWiseCubit.fetchDateWiseRecords();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DayWiseCubit, DayWiseState>(
      bloc: _dayWiseCubit,
      builder: (context, state) {
        if (state is DayWiseLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is DayWiseError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          });
        }
        if (state is DayWiseSuccess) {
          if (state.records.isEmpty) {
            return const Center(child: Text('No data found'));
          }

          return buildListView(state.records);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget buildListView(List<DayWiseEntity> records) {
    records = _getSortedRecord(records: records);
    return Expanded(
      child: ListView.builder(
        itemCount: records.length,
        itemBuilder: (context, index) {
          if (records[index].date == '' || records[index].date == null) {
            return const SizedBox.shrink();
          }
          String date = records[index].date!;
          double totalSell = records[index].totalSell ?? 0;
          double totalPurchase = records[index].purchaseCost ?? 0;
          double percentage = records[index].percentage ?? 0;

          return ListTile(
            title: Text(
              DateTimeFormat.getPrettyDate(
                DateTime.parse(
                  date,
                ),
              ),
            ),
            leading: const Icon(Icons.date_range),
            subtitle: Text(
              'T Buy: ${totalPurchase.toStringAsFixed(2)} tk',
              style: const TextStyle(fontSize: 14),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'T sell: ${totalSell.toStringAsFixed(2)} tk',
                  style: TextStyle(
                    fontSize: 16,
                    color: (totalPurchase > totalSell)
                        ? Colors.red.shade800
                        : Colors.green.shade800,
                  ),
                ),
                Text(
                  'Profit: ${(totalSell - totalPurchase).toStringAsFixed(2)} (${percentage.toStringAsFixed(2)}%)',
                  style: TextStyle(
                    fontSize: 14,
                    color: (totalPurchase > totalSell)
                        ? Colors.red.shade800
                        : Colors.green.shade800,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<DayWiseEntity> _getSortedRecord({
    required List<DayWiseEntity> records,
  }) {
    if (widget.filterEntity.sortingOrder == SortingOrder.ascending) {
      if ((widget.filterEntity.targetAttribute ?? TargetAttribute.percentage) ==
          TargetAttribute.percentage) {
        records.sort(
          (a, b) => (a.percentage ?? 0).compareTo(
            b.percentage ?? 0,
          ),
        );
      }
      if ((widget.filterEntity.targetAttribute ?? TargetAttribute.sell) ==
          TargetAttribute.sell) {
        records.sort(
          (a, b) => (a.totalSell ?? 0).compareTo(
            b.totalSell ?? 0,
          ),
        );
      }
      if ((widget.filterEntity.targetAttribute ?? TargetAttribute.purchase) ==
          TargetAttribute.purchase) {
        records.sort(
          (a, b) => (a.purchaseCost ?? 0).compareTo(
            b.purchaseCost ?? 0,
          ),
        );
      }
    } else {
      if ((widget.filterEntity.targetAttribute ?? TargetAttribute.percentage) ==
          TargetAttribute.percentage) {
        records.sort(
          (a, b) => (b.percentage ?? 0).compareTo(
            a.percentage ?? 0,
          ),
        );
      }
      if ((widget.filterEntity.targetAttribute ?? TargetAttribute.sell) ==
          TargetAttribute.sell) {
        records.sort(
          (a, b) => (b.totalSell ?? 0).compareTo(
            a.totalSell ?? 0,
          ),
        );
      }
      if ((widget.filterEntity.targetAttribute ?? TargetAttribute.purchase) ==
          TargetAttribute.purchase) {
        records.sort(
          (a, b) => (b.purchaseCost ?? 0).compareTo(
            a.purchaseCost ?? 0,
          ),
        );
      }
    }
    return records;
  }
}
