import 'package:empire_ent/widgets/primary_text.dart';
import 'package:flutter/material.dart';

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
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _quantity = widget.initialValue;
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
            setState(() {
              if (_quantity > widget.minValue) {
                _quantity--;
                widget.onChanged(_quantity);
              }
            });
          },
        ),
        SizedBox(
          width: 20,
          child: Center(
            child: PrimaryText(
              text: '$_quantity',
              color: Theme.of(context).colorScheme.inversePrimary,
              fontSize: 17,
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            setState(() {
              if (_quantity < widget.maxValue) {
                _quantity++;
                widget.onChanged(_quantity);
              }
            });
          },
        ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('Quantity Selector Example'),
      ),
      body: Center(
        child: QuantitySelector(
          initialValue: 1,
          minValue: 1,
          maxValue: 10,
          onChanged: (value) {
            print('Selected quantity: $value');
          },
        ),
      ),
    ),
  ));
}
