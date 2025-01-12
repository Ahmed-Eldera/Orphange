class Donation {
  final String id;
  final String donorName;
  final String donorEmail;
  final double amount;
  final String method;
  final String date;

  Donation({
    required this.id,
    required this.donorName,
    required this.donorEmail,
    required this.amount,
    required this.method,
    required this.date,
  });

  factory Donation.fromJson(Map<String, dynamic> data, String id) {
    return Donation(
      id: id,
      donorName: data['donorName'] as String,
      donorEmail: data['donorEmail'] as String,
      amount: (data['amount'] is int)
          ? (data['amount'] as int).toDouble()
          : data['amount'] as double,
      method: data['method'] as String,
      date: data['date'] as String,
    );
  }
}
