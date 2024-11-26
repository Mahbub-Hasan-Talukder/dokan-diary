import 'package:diary/core/services/date_time_format.dart';
import 'package:diary/features/sell/presentation/widgets/add_sell_data_view_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../core/di/di.dart';
import '../../domain/entities/sell_data_entity.dart';
import '../cubits/sell_items/sell_data_cubit.dart';
import 'package:flutter/material.dart';

import '../cubits/undo_record/undo_record_cubit.dart';

class Sell extends StatefulWidget {
  const Sell({super.key});

  @override
  State<Sell> createState() => _SellState();
}

class _SellState extends State<Sell> {
  final SellDataCubit _sellDataCubit = getIt.get<SellDataCubit>();
  UndoRecordCubit _undoRecordCubit = getIt.get<UndoRecordCubit>();
  final BehaviorSubject<DateTime> dateStream =
      BehaviorSubject.seeded(DateTime.now());

  @override
  void dispose() {
    _sellDataCubit.close();
    _undoRecordCubit.close();
    super.dispose();
  }

  @override
  void initState() {
    _sellDataCubit.fetchSellData(date: dateStream.value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: floatingCalenderButton(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: BlocBuilder<SellDataCubit, SellDataState>(
            bloc: _sellDataCubit,
            builder: (context, state) {
              if (state is SellDataSuccess) {
                return Column(
                  children: [
                    Text(
                      DateTimeFormat.getPrettyDate(dateStream.value),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    summaryView(state.items, context),
                    Expanded(child: listView(state.items)),
                    AddSellView(
                      items: state.items,
                      sellDataCubit: _sellDataCubit,
                      dateTime: dateStream,
                    ),
                  ],
                );
              }
              if (state is AddSellDataSuccess) {
                _sellDataCubit.fetchSellData(date: dateStream.value);
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  FloatingActionButton floatingCalenderButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.transparent,
      child: const Icon(Icons.calendar_month),
      onPressed: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        dateStream.add(pickedDate ?? DateTime.now());
        _sellDataCubit.fetchSellData(date: dateStream.value);
      },
    );
  }

  Widget listView(List<SellDataEntity> items) {
    if (items.isEmpty) {
      return const Center(child: Text('No data found'));
    }
    return ListView.separated(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          tileColor: Colors.grey.shade300,
          leading: const Icon(Icons.hardware),
          title: Text(item.itemName ?? 'N/A'),
          subtitle: Text('Profit: ${item.profit?.toStringAsFixed(2)} tk'),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Q: ${item.quantitySold}',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Text(
                'TP: ${item.totalPrice}',
                style: Theme.of(context).textTheme.labelLarge,
              )
            ],
          ),
          onLongPress: () {
            if (item.saleId != null &&
                item.quantitySold != null &&
                item.itemId != null) {
              Scaffold.of(context).showBottomSheet(
                (context) {
                  return modalSheetView(
                    context: context,
                    saleId: item.saleId!,
                    quantitySold: item.quantitySold!,
                    itemId: item.itemId!,
                  );
                },
              );
            }
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 5);
      },
    );
  }

  Container titleView(BuildContext context, AsyncSnapshot<DateTime> snapshot) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 2,
            color: Theme.of(context).colorScheme.primary,
          ),
          top: BorderSide(
            width: 2,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        DateTimeFormat.getPrettyDate(snapshot.data ?? DateTime.now()),
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  Widget summaryView(List<SellDataEntity> items, BuildContext context) {
    double totalProfit = 0;
    double totalSell = 0;
    for (SellDataEntity entity in items) {
      totalSell += entity.totalPrice ?? 0;
      totalProfit += entity.profit ?? 0;
    }
    final colorTheme = Theme.of(context).colorScheme;
    final iconColor =
        (totalProfit >= 0) ? colorTheme.primary : colorTheme.error;
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey),
          top: BorderSide(color: Colors.grey),
        ),
      ),
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Icon(Icons.sell, color: iconColor),
          Text('${totalSell.toStringAsFixed(2)} tk'),
          const Spacer(),
          Icon(Icons.monetization_on_rounded, color: iconColor),
          Text('${totalProfit.toStringAsFixed(2)} tk'),
        ],
      ),
    );
  }

  Container modalSheetView({
    required BuildContext context,
    required int saleId,
    required String itemId,
    required double quantitySold,
  }) {
    return Container(
      color: Theme.of(context).colorScheme.shadow,
      height: 100,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.cancel_outlined,
              color: Colors.white,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Undo this record?',
                style: TextStyle(color: Colors.white),
              ),
              BlocBuilder<UndoRecordCubit, UndoRecordState>(
                bloc: _undoRecordCubit,
                builder: (context, state) {
                  if (state is UndoRecordError) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    });
                  }
                  if(state is UndoRecordSuccess){
                    _sellDataCubit.fetchSellData(date: dateStream.value);
                  }
                  return ElevatedButton(
                    onPressed: () {
                      _undoRecordCubit.undoSell(
                        saleId: saleId,
                        itemId: itemId,
                        quantitySold: quantitySold,
                      );
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Undo',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
              )
            ],
          ),
          const SizedBox(),
        ],
      ),
    );
  }
}
