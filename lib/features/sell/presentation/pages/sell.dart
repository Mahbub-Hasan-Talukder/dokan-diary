import 'package:diary/core/services/date_time_format.dart';
import 'package:diary/features/sell/presentation/widgets/add_sell_data_view_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../core/di/di.dart';
import '../../domain/entities/sell_data_entity.dart';
import '../cubits/sell_data_cubit.dart';
import 'package:flutter/material.dart';

class Sell extends StatefulWidget {
  const Sell({super.key});

  @override
  State<Sell> createState() => _SellState();
}

class _SellState extends State<Sell> {
  final SellDataCubit _sellDataCubit = getIt.get<SellDataCubit>();
  final BehaviorSubject<DateTime> date = BehaviorSubject.seeded(DateTime.now());

  @override
  void dispose() {
    _sellDataCubit.close();
    super.dispose();
  }

  @override
  void initState() {
    _sellDataCubit.fetchSellData(date: date.value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(child: Icon(Icons.search_outlined), onPressed: (){}),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: BlocBuilder<SellDataCubit, SellDataState>(
            bloc: _sellDataCubit,
            builder: (context, state) {
              print('hrr: ${state.runtimeType}');
              if (state is SellDataSuccess) {
                // if (state.items.isEmpty) return const Text('N/a');
                return Column(
                  children: [
                    Text("${date.value}"),
                    Expanded(child: listView(state.items)),
                    AddSellView(
                      items: state.items,
                      sellDataCubit: _sellDataCubit,
                    ),
                  ],
                );
              }
              // if (state is FetchItemLoading) {
              //   return const CircularProgressIndicator();
              // }
              // if (state is FetchItemError) {
              //   return Center(child: Text(state.error));
              // }
              // if (state is AddItemSuccess) {
              //   _fetchItemCubit.fetchItems();
              // }
              // if (state is AddItemError) {
              //   return Center(child: Text(state.error));
              // }
              // if (state is DeleteItemSuccess) {
              //   _fetchItemCubit.fetchItems();
              // }
              // if (state is DeleteItemError) {
              //   return Center(child: Text(state.error));
              // }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget listView(List<SellDataEntity> items) {
    // final items = state.items;
    if(items.isEmpty){
      return Text('no data');
    }
    return ListView.separated(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          tileColor: Colors.grey.shade300,
          leading: const Icon(Icons.hardware),
          title: Text(item.itemName ?? 'N/A'),
          subtitle: Text('Price: ${item.sellDate} tk'),
          trailing: Text(
            '${item.quantitySold}\n${item.totalPrice}',
            style: Theme.of(context).textTheme.labelLarge,
          ),

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
}

/*
print(state.runtimeType);
            if (state is SellDataLoading) {
              return const CircularProgressIndicator();
            }
            if (state is SellDataSuccess) {
              return Column(
                children: [
                  SingleChildScrollView(
                    child: ListView.builder(
                        itemCount: state.items.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Text(state.items[index].itemName ?? 'n/a'),
                          );
                        }),
                  ),
                  AddSellView(
                      items: state.items, sellDataCubit: _sellDataCubit),
                ],
              );
            }
            if (state is SellDataError) {
              return Center(child: Text(state.error));
            }
            
 */