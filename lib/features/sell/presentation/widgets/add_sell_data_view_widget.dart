import 'package:diary/core/services/date_time_format.dart';
import 'package:diary/features/buy/presentation/cubits/fetch_items/fetch_item_cubit.dart';
import 'package:diary/features/sell/domain/entities/sell_data_entity.dart';
import 'package:diary/features/sell/domain/entities/sell_request_entity.dart';
import 'package:diary/features/sell/presentation/cubits/fetch_items/fetch_bought_items_cubit.dart';
import 'package:diary/features/sell/presentation/cubits/sell_items/sell_data_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../core/di/di.dart';
import '../../domain/entities/fetch_item_entity.dart';

class AddSellView extends StatefulWidget {
  final List<SellDataEntity> items;
  final SellDataCubit sellDataCubit;
  final BehaviorSubject<DateTime> dateTime;

  const AddSellView({
    super.key,
    required this.items,
    required this.sellDataCubit,
    required this.dateTime,
  });

  @override
  AddRecordViewState createState() => AddRecordViewState();
}

class AddRecordViewState extends State<AddSellView> {
  final _formKey = GlobalKey<FormState>();
  final _itemNameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  List<FetchItemEntity> entityList = [];
  final FetchBoughtItemsCubit _fetchBoughtItemsCubit =
      getIt.get<FetchBoughtItemsCubit>();
  String _selectedId = '';
  double dynamicQuantity = 0;

  @override
  void initState() {
    _fetchBoughtItemsCubit.fetchItems();
    super.initState();
  }

  @override
  void dispose() {
    _fetchBoughtItemsCubit.close();
    _itemNameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

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
                child:
                    BlocBuilder<FetchBoughtItemsCubit, FetchBoughtItemsState>(
                  bloc: _fetchBoughtItemsCubit,
                  builder: (context, state) {
                    if (state is FetchItemDone) {
                      entityList = state.entityList;
                    }
                    if (state is FetchItemFailed) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(state.error),
                        ));
                      });
                    }
                    return itemNameInput(entityList);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const SizedBox(height: 10),
              Flexible(
                flex: 1,
                child: numericTextField(
                  _quantityController,
                  (dynamicQuantity == 0)
                      ? 'quantity'
                      : dynamicQuantity.toString(),
                ),
              ),
              Flexible(
                flex: 1,
                child: numericTextField(_priceController, 'price'),
              ),
            ],
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: () {
                handleOnPressed();
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

  void handleOnPressed() {
    bool isValid = _formKey.currentState!.validate();
    double quantity = double.tryParse(_quantityController.text) ?? 0;
    double price = double.tryParse(_priceController.text) ?? 0;
    double existingQuantity = 0;
    for (FetchItemEntity item in entityList) {
      if (item.itemId == _selectedId) {
        existingQuantity = item.quantity ?? 0;
      }
    }
    if (isValid &&
        quantity <= existingQuantity &&
        price > 0 &&
        existingQuantity > 0 &&
        _selectedId.isNotEmpty) {
      widget.sellDataCubit.addSellData(
        reqEntity: SellRequestEntity(
          itemId: _selectedId,
          soldQuantity: quantity,
          soldPrice: price,
          date: DateTimeFormat.getYMD(widget.dateTime.value),
          remainingQuantity: existingQuantity - quantity,
        ),
      );
    }
  }

  Widget numericTextField(
    TextEditingController controller,
    String hintText,
  ) {
    controller.text = '';
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

  Widget itemNameInput(List<FetchItemEntity> entityList) {
    return Autocomplete<FetchItemEntity>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<FetchItemEntity>.empty();
        }
        return entityList.where((item) => (item.itemId ?? '')
            .toLowerCase()
            .contains(textEditingValue.text.toLowerCase()));
      },
      displayStringForOption: (FetchItemEntity option) => option.itemId ?? '',
      onSelected: (FetchItemEntity selection) {
        setState(() {
          _itemNameController.text = selection.itemId ?? '';
          _quantityController.text = selection.quantity.toString();
          dynamicQuantity = selection.quantity ?? 0;
          _selectedId = selection.itemId ?? '';
        });
      },
      fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
        _itemNameController.addListener(() {
          controller.text = _itemNameController.text;
        });
        return TextFormField(
          controller: _itemNameController,
          focusNode: focusNode,
          onChanged: (t) {
            _selectedId = '';
          },
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
