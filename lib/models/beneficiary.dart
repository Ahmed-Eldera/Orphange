class Beneficiary {
  String id;
  String name;
  int age;
  String needs;
  double allocatedBudget;

  Beneficiary({
    required this.id,
    required this.name,
    required this.age,
    required this.needs,
    required this.allocatedBudget,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'needs': needs,
      'allocatedBudget': allocatedBudget,
    };
  }

  factory Beneficiary.fromMap(Map<String, dynamic> map) {
    return Beneficiary(
      id: map['id'],
      name: map['name'],
      age: map['age'],
      needs: map['needs'],
      allocatedBudget: map['allocatedBudget'],
    );
  }
}
