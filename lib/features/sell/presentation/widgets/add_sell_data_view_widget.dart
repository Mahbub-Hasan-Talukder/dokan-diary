
import 'package:diary/features/sell/domain/entities/sell_data_entity.dart';
import 'package:diary/features/sell/domain/entities/sell_request_entity.dart';
import 'package:diary/features/sell/presentation/cubits/sell_data_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddSellView extends StatefulWidget {
  final List<SellDataEntity> items;
  final SellDataCubit sellDataCubit;

  const AddSellView({
    super.key,
    required this.items,
    required this.sellDataCubit,
  });

  @override
  AddRecordViewState createState() => AddRecordViewState();
}

class AddRecordViewState extends State<AddSellView> {
  final _formKey = GlobalKey<FormState>();
  final _itemNameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  String? _selectedItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      height: MediaQuery.of(context).size.height * .25,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
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

            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Flexible(
                flex: 2,
                child: numericTextField(_priceController, 'price'),
              ),
              const SizedBox(height: 10),
              Flexible(
                flex: 1,
                child: numericTextField(_quantityController, 'quantity'),
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
                      (double.tryParse(_priceController.text) ?? 0) /
                          (double.tryParse(_quantityController.text) ?? 1);
                  widget.sellDataCubit.addSellData(

                    reqEntity: SellRequestEntity(itemId: itemId, soldQuantity: soldQuantity, soldPrice: soldPrice, date: date)
                  );
                }
              },
              child: Text(
                'Sell',
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
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (value) =>
      value == null || value.isEmpty ? "Please enter value" : null,
    );
  }

  Widget itemNameInput() {
    return Autocomplete<SellDataEntity>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<SellDataEntity>.empty();
        }
        return widget.items.where((item) => (item.itemName ?? '')
            .toLowerCase()
            .contains(textEditingValue.text.toLowerCase()));
      },
      displayStringForOption: (SellDataEntity option) => option.itemId ?? '',
      onSelected: (SellDataEntity selection) {
        setState(() {
          _selectedItem = selection.itemName ?? '';
          _itemNameController.text = selection.itemName ?? '';
          _quantityController.text = selection.quantitySold.toString();
          _priceController.text = selection.totalPrice.toString();
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
