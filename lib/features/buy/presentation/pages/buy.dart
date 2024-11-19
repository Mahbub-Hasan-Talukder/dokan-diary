import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../cubits/fetch_items/fetch_item_cubit.dart';
import '../widgets/add_record_view_widget.dart';

class Buy extends StatefulWidget {
  const Buy({super.key});

  @override
  State<Buy> createState() => _BuyState();
}

class _BuyState extends State<Buy> {
  final FetchItemCubit _fetchItemCubit = getIt.get<FetchItemCubit>();

  @override
  void initState() {
    _fetchItemCubit.fetchItems();
    super.initState();
  }

  @override
  void dispose() {
    _fetchItemCubit;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(child: Icon(Icons.search_outlined), onPressed: (){}),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: BlocBuilder<FetchItemCubit, FetchItemState>(
            bloc: _fetchItemCubit,
            builder: (context, state) {
              print('hrr: ${state.runtimeType}');
              if (state is FetchItemSuccess) {
                if (state.items.isEmpty) return const Text('N/a');
                return Column(
                  children: [
                    buildListView(state),
                    AddRecordView(
                      items: state.items,
                      fetchItemCubit: _fetchItemCubit,
                    ),
                  ],
                );
              }
              if (state is FetchItemLoading) {
                return const CircularProgressIndicator();
              }
              if (state is FetchItemError) {
                return Center(child: Text(state.error));
              }
              if (state is AddItemSuccess) {
                _fetchItemCubit.fetchItems();
              }
              if (state is AddItemError) {
                return Center(child: Text(state.error));
              }
              if (state is DeleteItemSuccess) {
                _fetchItemCubit.fetchItems();
              }
              if (state is DeleteItemError) {
                return Center(child: Text(state.error));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Expanded buildListView(FetchItemSuccess state) {
    final items = state.items.reversed.toList();
    return Expanded(
      child: ListView.separated(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            tileColor: Colors.grey.shade300,
            leading: const Icon(Icons.hardware),
            title: Text(item.itemName ?? 'N/A'),
            subtitle: Text('Price: ${item.unitPrice} tk'),
            trailing: Text(
              '${item.quantity}\n${item.unitType}',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            onLongPress: () {
              Scaffold.of(context).showBottomSheet(
                (context) {
                  return modalSheetView(
                    context,
                    item.itemName ?? 'N/A',
                    item.unitPrice.toString(),
                  );
                },
              );
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 5);
        },
      ),
    );
  }

  Container modalSheetView(
    BuildContext context,
    String itemName,
    String price,
  ) {
    return Container(
      color: Theme.of(context).colorScheme.shadow,
      height: 100,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              const Spacer(),
              const Text(
                'Delete this record?',
                style: TextStyle(color: Colors.white),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.cancel_outlined,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              _fetchItemCubit.deleteItem(itemName: itemName, price: price);
              Navigator.of(context).pop();
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
