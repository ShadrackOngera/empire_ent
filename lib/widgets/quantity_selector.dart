import 'package:empire_ent/controllers/database_controller.dart';
import 'package:empire_ent/widgets/primary_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuantitySelector extends StatefulWidget {
  final int initialValue;
  final int minValue;
  final int maxValue;
  final ValueChanged<int> onChanged;

  const QuantitySelector({
    super.key,
    this.initialValue = 1,
    this.minValue = 1,
    this.maxValue = 10,
    required this.onChanged,
  });

  @override
  _QuantitySelectorState createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  // int _quantity = 1;
  final DatabaseController databaseController = Get.put(DatabaseController());

  @override
  void initState() {
    super.initState();
    databaseController.currentQuantity.value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: () {
            if (databaseController.currentQuantity.value > widget.minValue) {
              databaseController.currentQuantity.value--;
              widget.onChanged(databaseController.currentQuantity.value);
            }
          },
        ),
        SizedBox(
          width: 20,
          child: Center(
            child: Obx(
              () => PrimaryText(
                text: databaseController.currentQuantity.value.toString(),
                color: Theme.of(context).colorScheme.inversePrimary,
                fontSize: 17,
              ),
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            if (databaseController.currentQuantity.value < widget.maxValue) {
              databaseController.currentQuantity.value++;
              widget.onChanged(databaseController.currentQuantity.value);
            }
          },
        ),
      ],
    );
  }
}
