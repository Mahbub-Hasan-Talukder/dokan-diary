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
  final _unitPriceController = TextEditingController();
  String? _selectedUnit;
  String? _selectedItem;

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
              Flexible(
                flex: 1,
                child: numericTextField(_quantityController, 'quantity'),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Flexible(
                flex: 2,
                child: numericTextField(_unitPriceController, 'total price'),
              ),
              Flexible(
                flex: 1,
                child: dropdownField(),
              ),
            ],
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate() &&
                    (double.tryParse(_quantityController.text) ?? 0) > 0) {
                  double unitPrice =
                      (double.tryParse(_unitPriceController.text) ?? 0) /
                          (double.tryParse(_quantityController.text) ?? 1);
                  widget.fetchItemCubit.addItems(
                    itemName: _selectedItem ?? _itemNameController.text,
                    unitType: _selectedUnit ?? '',
                    unitPrice: unitPrice,
                    itemQuantity:
                        double.tryParse(_quantityController.text) ?? 0,
                  );
                }
              },
              child: Text(
                'Add',
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget numericTextField(
    TextEditingController controller,
    String hintText,
  ) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(10),
        ),
        hintText: hintText,
        labelText: hintText,
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
          _itemNameController.text = selection.itemName ?? '';
          _quantityController.text = selection.quantity.toString();
          _unitPriceController.text = selection.unitPrice.toString();
          _selectedUnit = selection.unitType ?? '';
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
}
