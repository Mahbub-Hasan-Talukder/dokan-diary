import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../../domain/entity/dashboard_entity.dart';
import '../cubit/dashboard_cubit.dart';

class MergeItem extends StatefulWidget {
  const MergeItem({super.key});

  @override
  State<MergeItem> createState() => _MergeItemState();
}

class _MergeItemState extends State<MergeItem> {
  final DashboardCubit dashboardCubit = getIt<DashboardCubit>();
  final TextEditingController _mergingItemNameController =
      TextEditingController();
  final TextEditingController _intoItemNameController = TextEditingController();
  String? mergingId, intoId;
  double? mergingItemQuantity, mergingItemUnitPrice;
  double? intoItemQuantity, intoItemUnitPrice;
  @override
  void initState() {
    dashboardCubit.fetchData();
    super.initState();
  }

  @override
  dispose() {
    _mergingItemNameController.dispose();
    _intoItemNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      bloc: dashboardCubit,
      builder: (context, state) {
        if (state is DashboardLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is DashboardError) {
          return Center(child: Text(state.message));
        }
        if (state is ItemMergeError) {
          return Center(child: Text(state.message));
        }
        if (state is ItemMergeSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            );
          });
        }

        List<DashboardEntity> items = [];
        if (state is DashboardSuccess) {
          items = state.data;
        }
        return Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Flexible(
                      child: itemNameInput(
                        items,
                        _mergingItemNameController,
                        'Merge',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: itemNameInput(
                        items,
                        _intoItemNameController,
                        'Into',
                      ),
                    ),
                  ],
                ),
                if (mergingId != null || intoId != null)
                  _showMergingItemDetails(),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: !isValidToMerge()
                        ? null
                        : () {
                            _showAlertDialog(context, items);
                          },
                    style: TextButton.styleFrom(
                      backgroundColor: !isValidToMerge()
                          ? Colors.grey
                          : Theme.of(context).colorScheme.primary,
                    ),
                    child: (state is ItemMergeLoading)
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Merge',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> _showAlertDialog(
    BuildContext context,
    List<DashboardEntity> items,
  ) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Merge Items'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Are you sure you want to merge your data?'),
              Text('Ensure Network is connected',
                  style: TextStyle(color: Colors.red)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                dashboardCubit.mergeItem(
                  items.firstWhere((e) => e.id == mergingId),
                  items.firstWhere((e) => e.id == intoId),
                );
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Widget itemNameInput(
    List<DashboardEntity> items,
    TextEditingController mergingController,
    String hintText,
  ) {
    return Autocomplete<DashboardEntity>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<DashboardEntity>.empty();
        }
        return items.where((item) => (item.itemName ?? '')
            .toLowerCase()
            .contains(textEditingValue.text.toLowerCase()));
      },
      displayStringForOption: (DashboardEntity option) => option.id ?? '',
      onSelected: (DashboardEntity selection) {
        setState(() {
          if (hintText == 'Merge') {
            mergingId = selection.id;
            _mergingItemNameController.text = selection.itemName ?? '';
            mergingItemQuantity = selection.quantity;
            mergingItemUnitPrice = selection.unitPrice;
          } else {
            intoId = selection.id;
            _intoItemNameController.text = selection.itemName ?? '';
            intoItemQuantity = selection.quantity;
            intoItemUnitPrice = selection.unitPrice;
          }

          // _selectedItem = selection.itemName ?? '';
          // _selectedId = selection.id ?? '';
          // _itemNameController.text = selection.itemName ?? '';
          // _quantityController.text = selection.quantity.toString();
          // _totalPriceCrontroller.text =
          //     ((selection.unitPrice ?? 0) * (selection.quantity ?? 0))
          //         .toString();
          // _selectedUnit = selection.unitType ?? '';
          // quantityHintValue = selection.quantity ?? 0;
          // priceHintValue = selection.unitPrice ?? 0;
        });
      },
      fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
        mergingController.addListener(() {
          controller.text = mergingController.text;
        });
        return TextFormField(
          controller: mergingController,
          focusNode: focusNode,
          onChanged: (value) {
            setState(() {
              if (hintText == 'Merge') {
                mergingId = null;
              } else {
                intoId = null;
              }
            });
          },
          decoration: InputDecoration(
            labelText: hintText,
            hintText: "Type to search and select",
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          validator: (value) =>
              value == null || value.isEmpty ? "Please enter item name" : null,
        );
      },
      optionsViewOpenDirection: OptionsViewOpenDirection.up,
    );
  }

  _showMergingItemDetails() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Column(
            children: [
              Text('Quantity: ${mergingItemQuantity?.toStringAsFixed(2)}'),
              Text('Unit Price: ${mergingItemUnitPrice?.toStringAsFixed(2)}'),
            ],
          ),
        ),
        Flexible(
          child: Column(
            children: [
              Text('Quantity: ${intoItemQuantity?.toStringAsFixed(2)}'),
              Text('Unit Price: ${intoItemUnitPrice?.toStringAsFixed(2)}'),
            ],
          ),
        ),
      ],
    );
  }

  bool isValidToMerge() {
    return (mergingId != null) && (intoId != null);
  }
}
