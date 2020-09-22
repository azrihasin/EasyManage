import 'package:cloud_firestore/cloud_firestore.dart';

class Expenses {
  String id;
  String userid;
  String name;
  String category;
  String image;
  List price = [];
  List subIngredients = [];
  Timestamp createdAt;
  Timestamp updatedAt;

  Expenses();

  Expenses.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    userid = data['userid'];
    name = data['name'];
    category = data['category'];
    image = data['image'];
    subIngredients = data['subIngredients'];
    price = data['price'];
    createdAt = data['createdAt'];
    updatedAt = data['updatedAt'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userid': userid,
      'name': name,
      'category': category,
      'image': image,
      'subIngredients': subIngredients,
      'price': price,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }
}
