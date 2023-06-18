class CategoriesModel {
  final int? id;
  final String? type;
  final double? budget;

  CategoriesModel({
    this.budget,
    this.id,
    this.type,
  });

  CategoriesModel fromJson(Map<String, dynamic> json) => CategoriesModel(
      id: json['id'], type: json['type'], budget: json['budget']);

  Map<String, dynamic> toMap() => {'id': id, 'type': type, 'budget': budget};
}
