import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/mock_data_service.dart';
import '../models/order.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mockData = Provider.of<MockDataService>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Portfolio',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Account Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text('Total Value: $${mockData.portfolioValue.toStringAsFixed(2)}'),
                  Text('Cash: $${mockData.cashBalance.toStringAsFixed(2)}'),
                  Text('Total P&L: $${mockData.totalPnL.toStringAsFixed(2)} (${mockData.totalPnLPercent.toStringAsFixed(2)}%)', style: TextStyle(color: mockData.totalPnL >= 0 ? Colors.green : Colors.red)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Holdings',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: mockData.portfolioHoldings.length,
            itemBuilder: (context, index) {
              final holding = mockData.portfolioHoldings[index];
              return Card(
                child: ListTile(
                  title: Text(holding.stock.symbol),
                  subtitle: Text('${holding.quantity} shares @ $${holding.averagePrice.toStringAsFixed(2)}'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Value: $${holding.currentValue.toStringAsFixed(2)}'),
                      Text('${holding.pnlPercent.toStringAsFixed(2)}%', style: TextStyle(color: holding.pnlPercent >= 0 ? Colors.green : Colors.red)),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          const Text(
            'Recent Transactions',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: mockData.recentOrders.length,
            itemBuilder: (context, index) {
              final order = mockData.recentOrders[index];
              return Card(
                child: ListTile(
                  title: Text('${order.type} ${order.quantity} ${order.stock.symbol}'),
                  subtitle: Text('${order.timestamp} @ $${order.price.toStringAsFixed(2)}'),
                  trailing: Text(order.status, style: TextStyle(color: order.status == 'Filled' ? Colors.green : Colors.orange)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}