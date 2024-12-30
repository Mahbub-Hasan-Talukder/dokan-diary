import 'package:diary/features/buy/data/data_source/data_source_imp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../cubits/fetch_items/fetch_item_cubit.dart';
import '../../domain/entities/item_entity.dart';

class AddRecordView extends StatefulWidget {
  final List<ItemEntity> items;
  final FetchItemCubit fetchItemCubit;

  const AddRecordView({
    super.key,
    required this.items,
    required this.fetchItemCubit,
  });

  @override
  AddRecordViewState createState() => AddRecordViewState();
}

class AddRecordViewState extends State<AddRecordView> {
  final _formKey = GlobalKey<FormState>();
  final _itemNameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _totalPriceCrontroller = TextEditingController();
  String? _selectedUnit;
  String? _selectedItem;
  String? _selectedId;
  double quantityHintValue = 0;
  double priceHintValue = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      height: MediaQuery.of(context).size.height * .22,
      width: MediaQuery.of(context).size.width,
      child: Form(
        key: _formKey,
        child: formElements(context),
      ),
    );
  }

  Widget formElements(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                flex: 2,
                child: itemNameInput(),
              ),
              const SizedBox(height: 10),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Flexible(
                flex: 1,
                child: numericTextField(
                    _quantityController,
                    quantityHintValue == 0
                        ? 'Quantity'
                        : quantityHintValue.toString(),
                    'Quantity'),
              ),
              Flexible(
                flex: 1,
                child: numericTextField(
                    _totalPriceCrontroller,
                    priceHintValue == 0
                        ? 'Total price'
                        : 'unit price: $priceHintValue',
                    'Total Price'),
              ),
              // Flexible(
              //   flex: 1,
              //   child: dropdownField(),
              // ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _delete(context),
              _add(context),
              _edit(context),
            ],
          )
        ],
      ),
    );
  }

  SizedBox _add(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate() &&
              (double.tryParse(_quantityController.text) ?? 0) > 0) {
            double totalPrice =
                (double.tryParse(_totalPriceCrontroller.text) ?? 0);
            double? itemQuantity = double.tryParse(_quantityController.text);
            widget.fetchItemCubit.addItems(
              itemName: _itemNameController.text,
              unitType: 'kg',
              unitPrice: totalPrice / (itemQuantity ?? 1),
              itemQuantity: itemQuantity ?? 0,
            );
          }
        },
        child: Text(
          'Add',
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
    );
  }

  SizedBox _edit(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate() &&
              (double.tryParse(_quantityController.text) ?? 0) > 0 &&
              _selectedId != null) {
            double totalPrice =
                (double.tryParse(_totalPriceCrontroller.text) ?? 0);
            double? itemQuantity = double.tryParse(_quantityController.text);
            double unitPrice = totalPrice / (itemQuantity ?? 1);
            Future(() async {
              // await FetchItemDataSourceImpl().updateItem(
              //   itemId: _selectedId ?? '',
              //   unitPrice: unitPrice,
              //   quantity: itemQuantity ?? 0,
              // );
              widget.fetchItemCubit.deleteItem(itemId: _selectedId ?? '');
              widget.fetchItemCubit.addItems(
                itemName: _itemNameController.text,
                unitType: 'kg',
                unitPrice: unitPrice,
                itemQuantity: itemQuantity ?? 0,
              );
              widget.fetchItemCubit.fetchItems();
            });
          } else {}
        },
        child: Text(
          'Edit',
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
    );
  }

  SizedBox _delete(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          _showAlertDialog(context);
        },
        child: Text(
          'delete',
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
    );
  }

  Widget numericTextField(
    TextEditingController controller,
    String hintText,
    String label,
  ) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(10),
        ),
        hintText: hintText,
        labelText: label,
      ),
      keyboardType: TextInputType.number,
      // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (value) =>
          value == null || value.isEmpty ? "Please enter value" : null,
    );
  }

  Widget dropdownField() {
    return Container(
      padding: const EdgeInsets.only(left: 5),
      child: DropdownButtonFormField<String>(
        value: _selectedUnit,
        decoration: const InputDecoration(labelText: "Unit Type"),
        items: ['kg', 'piece', 'other']
            .map((unit) => DropdownMenuItem(value: unit, child: Text(unit)))
            .toList(),
        onChanged: (value) {
          setState(() {
            _selectedUnit = value;
          });
        },
        validator: (value) =>
            value == null ? "Please select a unit type" : null,
      ),
    );
  }

  Widget itemNameInput() {
    return Autocomplete<ItemEntity>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<ItemEntity>.empty();
        }
        return widget.items.where((item) => (item.itemName ?? '')
            .toLowerCase()
            .contains(textEditingValue.text.toLowerCase()));
      },
      displayStringForOption: (ItemEntity option) => option.id ?? '',
      onSelected: (ItemEntity selection) {
        setState(() {
          _selectedItem = selection.itemName ?? '';
          _selectedId = selection.id ?? '';
          _itemNameController.text = selection.itemName ?? '';
          _quantityController.text = selection.quantity.toString();
          _totalPriceCrontroller.text =
              ((selection.unitPrice ?? 0) * (selection.quantity ?? 0))
                  .toString();
          _selectedUnit = selection.unitType ?? '';
          quantityHintValue = selection.quantity ?? 0;
          priceHintValue = selection.unitPrice ?? 0;
        });
      },
      fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
        _itemNameController.addListener(() {
          controller.text = _itemNameController.text;
        });
        return TextFormField(
          controller: _itemNameController,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: "Item Name",
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

  Future<dynamic> _showAlertDialog(
    BuildContext context,
  ) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Item'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Are you sure you want delete your data?'),
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
                widget.fetchItemCubit
                    .deleteItem(itemId: _selectedId ?? '', price: '');
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
