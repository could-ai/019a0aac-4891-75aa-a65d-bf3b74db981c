class Order {
  final String id;
  final String type; // 'Buy' or 'Sell'
  final Stock stock;
  final int quantity;
  final double price;
  final String status; // 'Pending', 'Filled', 'Cancelled'
  final DateTime timestamp;

  Order({
    required this.id,
    required this.type,
    required this.stock,
    required this.quantity,
    required this.price,
    required this.status,
    required this.timestamp,
  });
}

class PortfolioHolding {
  final Stock stock;
  final int quantity;
  final double averagePrice;
  final double currentValue;
  final double pnlPercent;

  PortfolioHolding({
    required this.stock,
    required this.quantity,
    required this.averagePrice,
    required this.currentValue,
    required this.pnlPercent,
  });
}