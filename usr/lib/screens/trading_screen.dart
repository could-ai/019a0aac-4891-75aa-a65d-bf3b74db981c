import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/mock_data_service.dart';
import '../widgets/price_chart.dart';
import '../widgets/order_form.dart';
import '../models/stock.dart';

class TradingScreen extends StatefulWidget {
  const TradingScreen({super.key});

  @override
  State<TradingScreen> createState() => _TradingScreenState();
}

class _TradingScreenState extends State<TradingScreen> {
  Stock? _selectedStock;

  @override
  Widget build(BuildContext context) {
    final mockData = Provider.of<MockDataService>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Trading Interface',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<Stock>(
            value: _selectedStock,
            hint: const Text('Select Stock'),
            items: mockData.stocks.map((stock) {
              return DropdownMenuItem(
                value: stock,
                child: Text('${stock.symbol} - ${stock.name}'),
              );
            }).toList(),
            onChanged: (stock) {
              setState(() {
                _selectedStock = stock;
              });
            },
          ),
          const SizedBox(height: 20),
          if (_selectedStock != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_selectedStock!.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('Symbol: ${_selectedStock!.symbol}'),
                    Text('Price: \$${_selectedStock!.price.toStringAsFixed(2)}'),
                    Text('Change: ${_selectedStock!.changePercent.toStringAsFixed(2)}%', style: TextStyle(color: _selectedStock!.changePercent >= 0 ? Colors.green : Colors.red)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              child: PriceChart(stock: _selectedStock!),
            ),
            const SizedBox(height: 20),
            OrderForm(stock: _selectedStock!),
          ],
        ],
      ),
    );
  }
}
