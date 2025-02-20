class Winnings {
  final int rank;
  final int price;

  Winnings({required this.rank, required this.price});

  // Factory method to create a Winnings object from JSON
  factory Winnings.fromJson(Map<String, dynamic> json) {
    return Winnings(
      rank: json['rank'],
      price: json['price'],
    );
  }

  // Method to convert Winnings object to JSON
  Map<String, dynamic> toJson() {
    return {
      'rank': rank,
      'price': price,
    };
  }
}
