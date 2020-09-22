import 'package:cloud_firestore/cloud_firestore.dart';

class Filter {
  String id;
  String userid;
  String name;
  String category;
  String image;
  List subIngredients = [];
  List price = [];
  List sales = [];
  List date = [];
  Timestamp createdAt;
  Timestamp updatedAt;

  Filter();

  Filter.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    userid = data['userid'];
    name = data['name'];
    category = data['category'];
    image = data['image'];
    subIngredients = data['subIngredients'];
    price = data['price'];
    sales = data['sales'];
    date = data['date'];
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
      'sales': sales,
      'date': date,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }
}
