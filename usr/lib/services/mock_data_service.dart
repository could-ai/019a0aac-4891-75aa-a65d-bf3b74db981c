import 'dart:async';
import 'package:flutter/material.dart';
import '../models/stock.dart';
import '../models/order.dart';

class MockDataService extends ChangeNotifier {
  final Map<String, double> _marketIndices = {
    'SP500': 4200.50,
    'NASDAQ': 12800.75,
  };

  final List<Stock> _stocks = [
    Stock(
      symbol: 'AAPL',
      name: 'Apple Inc.',
      price: 175.43,
      changePercent: 2.1,
      historicalPrices: [170, 172, 168, 175, 178, 175],
    ),
    Stock(
      symbol: 'GOOGL',
      name: 'Alphabet Inc.',
      price: 142.67,
      changePercent: -0.5,
      historicalPrices: [145, 143, 141, 140, 142, 142],
    ),
    Stock(
      symbol: 'MSFT',
      name: 'Microsoft Corporation',
      price: 335.50,
      changePercent: 1.8,
      historicalPrices: [330, 332, 328, 335, 338, 335],
    ),
    Stock(
      symbol: 'TSLA',
      name: 'Tesla Inc.',
      price: 248.42,
      changePercent: 3.2,
      historicalPrices: [240, 245, 242, 248, 250, 248],
    ),
    Stock(
      symbol: 'AMZN',
      name: 'Amazon.com Inc.',
      price: 145.23,
      changePercent: -1.2,
      historicalPrices: [148, 146, 144, 143, 145, 145],
    ),
  ];

  final List<Order> _recentOrders = [
    Order(
      id: '1',
      type: 'Buy',
      stock: Stock(symbol: 'AAPL', name: 'Apple Inc.', price: 175.43, changePercent: 2.1, historicalPrices: []),
      quantity: 10,
      price: 175.00,
      status: 'Filled',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Order(
      id: '2',
      type: 'Sell',
      stock: Stock(symbol: 'GOOGL', name: 'Alphabet Inc.', price: 142.67, changePercent: -0.5, historicalPrices: []),
      quantity: 5,
      price: 143.00,
      status: 'Filled',
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
    ),
  ];

  final List<PortfolioHolding> _portfolioHoldings = [
    PortfolioHolding(
      stock: Stock(symbol: 'AAPL', name: 'Apple Inc.', price: 175.43, changePercent: 2.1, historicalPrices: []),
      quantity: 20,
      averagePrice: 170.00,
      currentValue: 3508.60,
      pnlPercent: 3.3,
    ),
    PortfolioHolding(
      stock: Stock(symbol: 'MSFT', name: 'Microsoft Corporation', price: 335.50, changePercent: 1.8, historicalPrices: []),
      quantity: 15,
      averagePrice: 330.00,
      currentValue: 5032.50,
      pnlPercent: 1.7,
    ),
  ];

  double _cashBalance = 50000.00;

  MockDataService() {
    _startPriceUpdates();
  }

  Map<String, double> get marketIndices => _marketIndices;
  List<Stock> get stocks => _stocks;
  List<Order> get recentOrders => _recentOrders;
  List<PortfolioHolding> get portfolioHoldings => _portfolioHoldings;
  double get cashBalance => _cashBalance;

  double get portfolioValue => _portfolioHoldings.fold(0.0, (sum, holding) => sum + holding.currentValue) + _cashBalance;
  double get totalPnL => _portfolioHoldings.fold(0, (sum, holding) => sum + ((holding.stock.price - holding.averagePrice) * holding.quantity));
  double get totalPnLPercent => portfolioValue > 0 ? (totalPnL / (portfolioValue - totalPnL - _cashBalance + totalPnL)) * 100 : 0;

  void _startPriceUpdates() {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      for (var stock in _stocks) {
        final change = (stock.price * 0.01) * (0.5 - (0.5 * (DateTime.now().millisecondsSinceEpoch % 100) / 50));
        stock.historicalPrices.add(stock.price + change);
        if (stock.historicalPrices.length > 20) {
          stock.historicalPrices.removeAt(0);
        }
      }
      notifyListeners();
    });
  }

  void placeOrder(String type, Stock stock, int quantity) {
    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: type,
      stock: stock,
      quantity: quantity,
      price: stock.price,
      status: 'Filled',
      timestamp: DateTime.now(),
    );
    _recentOrders.insert(0, order);
    if (type == 'Buy') {
      _cashBalance -= stock.price * quantity;
      final existingHolding = _portfolioHoldings.where((h) => h.stock.symbol == stock.symbol).toList();
      if (existingHolding.isNotEmpty) {
        final holding = existingHolding.first;
        final newQuantity = holding.quantity + quantity;
        final newAveragePrice = ((holding.averagePrice * holding.quantity) + (stock.price * quantity)) / newQuantity;
        _portfolioHoldings.remove(holding);
        _portfolioHoldings.add(PortfolioHolding(
          stock: stock,
          quantity: newQuantity,
          averagePrice: newAveragePrice,
          currentValue: stock.price * newQuantity,
          pnlPercent: ((stock.price - newAveragePrice) / newAveragePrice) * 100,
        ));
      } else {
        _portfolioHoldings.add(PortfolioHolding(
          stock: stock,
          quantity: quantity,
          averagePrice: stock.price,
          currentValue: stock.price * quantity,
          pnlPercent: 0,
        ));
      }
    } else if (type == 'Sell') {
      _cashBalance += stock.price * quantity;
      final holding = _portfolioHoldings.where((h) => h.stock.symbol == stock.symbol).first;
      if (holding.quantity > quantity) {
        final newQuantity = holding.quantity - quantity;
        _portfolioHoldings.remove(holding);
        _portfolioHoldings.add(PortfolioHolding(
          stock: stock,
          quantity: newQuantity,
          averagePrice: holding.averagePrice,
          currentValue: stock.price * newQuantity,
          pnlPercent: ((stock.price - holding.averagePrice) / holding.averagePrice) * 100,
        ));
      } else {
        _portfolioHoldings.remove(holding);
      }
    }
    notifyListeners();
  }
}
