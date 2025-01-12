class Beneficiary {
  String id;
  String name;
  int age;
  String needs;
  double allocatedBudget;
  double? manualBudget; // Nullable manual budget field

  Beneficiary({
    required this.id,
    required this.name,
    required this.age,
    required this.needs,
    required this.allocatedBudget,
    this.manualBudget,
  });

  double get effectiveBudget => manualBudget ?? allocatedBudget; // Use manualBudget if available

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'needs': needs,
      'allocatedBudget': allocatedBudget,
      'manualBudget': manualBudget,
    };
  }

  factory Beneficiary.fromMap(Map<String, dynamic> map) {
    return Beneficiary(
      id: map['id'],
      name: map['name'],
      age: map['age'],
      needs: map['needs'],
      allocatedBudget: map['allocatedBudget'],
      manualBudget: map['manualBudget'],
    );
  }
}
