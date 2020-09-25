import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easymanage/api/food_api.dart';
import 'package:easymanage/model/food.dart';
import 'package:easymanage/notifier/food_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';
import 'food_form.dart';
import 'package:intl/intl.dart';

class FoodDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FoodNotifier foodNotifier = Provider.of<FoodNotifier>(context);

    images() {
      return 'assets/images/Asset 1.png';
    }

    _onFoodDeleted(Food food) {
      Navigator.pop(context);
      foodNotifier.deleteFood(food);
    }

    String formatTimestamp(Timestamp timestamp) {
      DateTime myDateTime = DateTime.parse(timestamp.toDate().toString());
      String formattedDateTime =
          DateFormat('d MMM, yyyy – kk:mm').format(myDateTime);
      return formattedDateTime;
    }

    String total(FoodNotifier foodNotifier) {
      double total = 0;

      for (int i = 0; i < foodNotifier.currentFood.price.length; i++) {
        total = total + double.parse(foodNotifier.currentFood.price[i]);
      }
      return total.toStringAsFixed(2);
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color(0xffFEC6A9),
      appBar: AppBar(
        title: Text(foodNotifier.currentFood.name),
        backgroundColor: Color(0xffFEC6A9),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.only(top: 100, left: 20),
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: foodNotifier.currentFood.image != null
                                  ? NetworkImage(foodNotifier.currentFood.image
                                      //'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                                      //width: MediaQuery.of(context).size.width,
                                      )
                                  : AssetImage('assets/images/Asset 9.png')),
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 115, left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            //margin: EdgeInsets.only(right: 43),
                            child: Text(
                              foodNotifier.currentFood.name.sentenceCase,
                              style: TextStyle(
                                  fontFamily: 'Acumin',
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            '${foodNotifier.currentFood.category}',
                            style: TextStyle(
                                fontSize: 18, fontStyle: FontStyle.italic),
                          ),
                          SizedBox(height: 5),
                          foodNotifier.currentFood.updatedAt != null
                              ? Text(
                                  'Last Updated :' +
                                      formatTimestamp(
                                          foodNotifier.currentFood.updatedAt),
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.grey),
                                )
                              : Text(
                                  'Last Updated :' +
                                      formatTimestamp(
                                          foodNotifier.currentFood.createdAt),
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.grey),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30)),
                    color: Color(0xffFbf5f5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 30.0),
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Total',
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                            Text('RM ' + total(foodNotifier),
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      ConstrainedBox(
                        constraints: new BoxConstraints(
                          minHeight: 500,
                          maxHeight: 10000.0,
                        ),
                        child: Container(
                          child: ListView.builder(
                            padding: EdgeInsets.only(top: 20.0),
                            reverse: false,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: ListTile(
                                        isThreeLine: true,
                                        leading: null,
                                        title: Text(
                                            foodNotifier.currentFood
                                                .subIngredients[index]
                                                .toString(),
                                            style: TextStyle(fontSize: 20)),
                                        subtitle: Text('Price RM ' +
                                            foodNotifier
                                                .currentFood.price[index]
                                                .toString() +
                                            '\n' +
                                            'Created at ' +
                                            formatTimestamp(foodNotifier
                                                .currentFood.date[index])),
                                        trailing: Text(
                                            'RM' +
                                                foodNotifier
                                                    .currentFood.sales[index]
                                                    .toString(),
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontWeight: FontWeight.bold)),
                                        onTap: () {},
                                      )));
                            },
                            itemCount:
                                foodNotifier.currentFood.subIngredients.length,
                          ),
                        ),
                      ),
                    ],
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
