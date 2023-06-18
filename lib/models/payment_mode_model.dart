class CashModel {
  final int? id;
  final String? type;
  final double? budget;

  CashModel({this.id, this.type, this.budget});

  CashModel fromJson(Map<String, dynamic> json) =>
      CashModel(id: json['id'], type: json['type'], budget: json['budget']);

  Map<String, dynamic> toMap() => {'id': id, 'type': type, 'budget': budget};
}
