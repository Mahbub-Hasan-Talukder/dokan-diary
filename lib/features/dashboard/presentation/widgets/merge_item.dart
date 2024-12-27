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
        if (state is DashboardSuccess) {
          List<DashboardEntity> items = state.data;
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
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text(
                        'Merge',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
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
          mergingController.text = selection.itemName ?? '';
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
}
