import 'package:flutter/material.dart';

class StrategiesScreen extends StatelessWidget {
  const StrategiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Trading Strategies',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const Text(
            'Build and backtest algorithmic trading strategies',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Simple Moving Average Crossover', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  const Text('Buy when short-term MA crosses above long-term MA'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(labelText: 'Short MA Period'),
                          initialValue: '50',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(labelText: 'Long MA Period'),
                          initialValue: '200',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Implement backtesting logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Backtesting not yet implemented - this is a demo')),
                      );
                    },
                    child: const Text('Run Backtest'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Available Strategies',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ListView(
            shrinkWrap: true,
            children: const [
              ListTile(
                title: Text('Mean Reversion'),
                subtitle: Text('Buy low, sell high based on deviations from mean price'),
              ),
              ListTile(
                title: Text('Momentum'),
                subtitle: Text('Follow trending stocks with high momentum'),
              ),
              ListTile(
                title: Text('Pairs Trading'),
                subtitle: Text('Trade correlated asset pairs'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}