import 'package:flutter/cupertino.dart';
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
  late ScrollController _scrollController;
  final List<IconData> _icons = [
    Icons.hardware_outlined,
    Icons.pin_invoke_outlined,
    Icons.iron_outlined,
    Icons.color_lens_outlined,
    Icons.tungsten_outlined,
  ];
  final List<Color> _colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
  ];

  @override
  void initState() {
    _fetchItemCubit.fetchItems();
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    if (!mounted) {
      _fetchItemCubit.close();
    }
    _scrollController.dispose();
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
              if (state is FetchItemSuccess) {
                return Column(
                  children: [
                    Center(child: Text("Total items: ${state.items.length}")),
                    const Divider(color: Colors.grey),
                    Expanded(
                      child: buildListView(state),
                    ),
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

  Widget buildListView(FetchItemSuccess state) {
    final items = state.items.reversed.toList();

    if (items.isEmpty) {
      return const Text('No data');
    }

    items.sort((a, b) => a.itemName!.compareTo(b.itemName ?? ''));

    return RawScrollbar(
      controller: _scrollController,
      thickness: 10,
      thumbColor: Colors.grey.shade700,
      thumbVisibility: true,
      interactive: true,
      child: ListView.separated(
        controller: _scrollController,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final iconIndex = index % _icons.length;
          final colorIndex = index % _colors.length;
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: ListTile(
              leading: Icon(
                _icons[iconIndex],
                color: _colors[colorIndex],
              ),
              title: Text(
                item.itemName ?? 'N/A',
                // style: TextStyle(color: _colors[colorIndex]),
              ),
              subtitle: Text(
                'Unit P: ${item.unitPrice?.toStringAsFixed(2)} tk',
                // style: TextStyle(color: _colors[colorIndex]),
              ),
              trailing: Text(
                '${item.quantity?.toStringAsFixed(2)}\n units',
                style: Theme.of(context).textTheme.labelMedium,
                // style: TextStyle(color: _colors[colorIndex]),
              ),
              onLongPress: () {
                Scaffold.of(context).showBottomSheet(
                  (context) {
                    return modalSheetView(
                      context,
                      item.id ?? 'N/A',
                      item.unitPrice.toString(),
                    );
                  },
                );
              },
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 4);
        },
      ),
    );
  }

  Container modalSheetView(
    BuildContext context,
    String itemId,
    String price,
  ) {
    return Container(
      color: Theme.of(context).colorScheme.shadow,
      height: 100,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Delete this record?',
                style: TextStyle(color: Colors.white),
              ),
              ElevatedButton(
                onPressed: () {
                  _fetchItemCubit.deleteItem(itemId: itemId, price: price);
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
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
    );
  }
}
