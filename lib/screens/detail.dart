import 'package:easymanage/api/food_api.dart';
import 'package:easymanage/model/food.dart';
import 'package:easymanage/notifier/food_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'food_form.dart';

class FoodDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FoodNotifier foodNotifier = Provider.of<FoodNotifier>(context);

    _onFoodDeleted(Food food) {
      Navigator.pop(context);
      foodNotifier.deleteFood(food);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(foodNotifier.currentFood.name),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            child: Column(
              children: <Widget>[
                Image.network(
                  foodNotifier.currentFood.image != null
                      ? foodNotifier.currentFood.image
                      : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                  width: MediaQuery.of(context).size.width,
                  height: 250,
                  fit: BoxFit.fitWidth,
                ),
                SizedBox(height: 24),
                Text(
                  foodNotifier.currentFood.name,
                  style: TextStyle(
                    fontSize: 40,
                  ),
                ),
                Text(
                  'Category: ${foodNotifier.currentFood.category}',
                  style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                ),
                SizedBox(height: 20),
                Text(
                  "Ingredients",
                  style: TextStyle(
                      fontSize: 18, decoration: TextDecoration.underline),
                ),
                SizedBox(height: 16),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  height: 600,
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                          child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: ListTile(
                                leading: new Container(
                                  width: 60.0,
                                  height: 60.0,
                                ),
                                title: Text(foodNotifier
                                    .currentFood.subIngredients[index]),
                                subtitle: Text(foodNotifier
                                    .currentFood.price[index]
                                    .toString()),
                                onTap: () {},
                              )));
                    },
                    itemCount: foodNotifier.currentFood.subIngredients.length,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: 'button1',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) {
                  return FoodForm(
                    isUpdating: true,
                  );
                }),
              );
            },
            child: Icon(Icons.edit),
            foregroundColor: Colors.white,
          ),
          SizedBox(height: 20),
          FloatingActionButton(
            heroTag: 'button2',
            onPressed: () =>
                deleteFood(foodNotifier.currentFood, _onFoodDeleted),
            child: Icon(Icons.delete),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
