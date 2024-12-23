import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../../domain/entities/filter_entity.dart';
import '../../domain/entities/item_wise_entity.dart';
import '../bloc/item_wise_records/item_wise_cubit.dart';

class ItemWiseRecordsView extends StatefulWidget {
  const ItemWiseRecordsView({super.key, required this.filterEntity});
  final FilterEntity filterEntity;

  @override
  State<ItemWiseRecordsView> createState() => _ItemWiseRecordsViewState();
}

class _ItemWiseRecordsViewState extends State<ItemWiseRecordsView> {
  final ItemWiseCubit _dayWiseCubit = getIt.get<ItemWiseCubit>();

  @override
  void initState() {
    _dayWiseCubit.fetchItemWiseRecords();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemWiseCubit, ItemWiseState>(
      bloc: _dayWiseCubit,
      builder: (context, state) {
        if (state is ItemWiseLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ItemWiseError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          });
        }
        if (state is ItemWiseSuccess) {
          if (state.records.isEmpty) {
            return const Center(child: Text('No data found'));
          }

          return buildListView(state.records);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget buildListView(List<ItemWiseEntity> records) {
    records = _getSortedRecord(records: records);
    return Expanded(
      child: ListView.builder(
        itemCount: records.length,
        itemBuilder: (context, index) {
          if (records[index].purchaseCost == 0) {
            return const SizedBox.shrink();
          }
          double totalSell = records[index].totalSell ?? 0;
          double totalPurchase = records[index].purchaseCost ?? 0;
          String itemName = records[index].itemName ?? 'N/A';
          double percentage = records[index].percentage ?? 0;
          return ListTile(
            title: Text(itemName),
            leading: const Icon(Icons.pin_drop_outlined),
            subtitle: Text(
              'T buy: ${totalPurchase.toStringAsFixed(2)} tk',
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

  List<ItemWiseEntity> _getSortedRecord({
    required List<ItemWiseEntity> records,
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
