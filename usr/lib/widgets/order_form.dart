import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/mock_data_service.dart';
import '../models/stock.dart';

class OrderForm extends StatefulWidget {
  final Stock stock;

  const OrderForm({super.key, required this.stock});

  @override
  State<OrderForm> createState() => _OrderFormState();
}

class _OrderFormState extends State<OrderForm> {
  final _quantityController = TextEditingController(text: '1');
  String _orderType = 'Buy';

  @override
  Widget build(BuildContext context) {
    final mockData = Provider.of<MockDataService>(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Place Order', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _orderType,
                    items: ['Buy', 'Sell'].map((type) {
                      return DropdownMenuItem(value: type, child: Text(type));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _orderType = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _quantityController,
                    decoration: const InputDecoration(labelText: 'Quantity'),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Estimated Total: $${(int.tryParse(_quantityController.text) ?? 0) * widget.stock.price}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final quantity = int.tryParse(_quantityController.text) ?? 0;
                if (quantity > 0) {
                  mockData.placeOrder(_orderType, widget.stock, quantity);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Order placed: $_orderType $quantity ${widget.stock.symbol}')),
                  );
                  _quantityController.text = '1';
                }
              },
              child: Text('Place $_orderType Order'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }
}