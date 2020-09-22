import 'dart:collection';
import 'package:easymanage/api/food_api.dart';
import 'package:easymanage/notifier/auth_notifier.dart';
import 'package:easymanage/notifier/food_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class Overview extends StatefulWidget {
  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  @override
  void initState() {
    FoodNotifier foodNotifier =
        Provider.of<FoodNotifier>(context, listen: false);
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    getFoods(foodNotifier, authNotifier);
    getExpenses(foodNotifier, authNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    FoodNotifier foodNotifier = Provider.of<FoodNotifier>(context);

    Future<void> _refreshList() async {
      getFoods(foodNotifier, authNotifier);
    }

    print(foodNotifier.foodList[0].sales);

    print(totalprofit(foodNotifier.foodList.length, foodNotifier));
    print(totalsales(foodNotifier.foodList.length, foodNotifier));
    print(totalbalance(foodNotifier.foodList.length, foodNotifier));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0.0,
        title: Text(
          authNotifier.user != null ? authNotifier.user.uid : "Feed",
        ),
        actions: <Widget>[
          // action button
          FlatButton(
            onPressed: () => signout(authNotifier),
            child: Text(
              "Logout",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ],
      ),
      body: new RefreshIndicator(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: const Color(0xff81e5cd),
                    ),
                    margin: EdgeInsets.all(10.0),
                    padding: const EdgeInsets.all(16),
                    child: Align(
                      alignment: Alignment(-1.0, 1.0),
                      child: Column(
                        children: [
                          Text(
                            'Profit',
                            style: TextStyle(fontSize: 20),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 6, left: 1),
                            // padding: EdgeInsets.all(20),
                            child: Text(
                              totalprofit(
                                  foodNotifier.foodList.length, foodNotifier),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 29),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18.0),
                      color: Colors.red,
                    ),
                    margin: EdgeInsets.all(10.0),
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      children: [
                        //TOTAL PROFIT
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            'All Sales',
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                        //TOTAL SALES
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            totalsales(
                                foodNotifier.foodList.length, foodNotifier),
                            style: TextStyle(fontSize: 26),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 20, top: 20, bottom: 20, right: 10),
                            height: 100,
                            color: Colors.blue,
                            child: Column(
                              children: [
                                Text('Expenses'),
                                Text('RM' +
                                    totalexpenses(foodNotifier.foodList.length,
                                        foodNotifier))
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 10, top: 20, bottom: 20, right: 20),
                            height: 100,
                            color: Colors.yellow,
                            child: Column(
                              children: [
                                Text('Yet to be paid'),
                                Text('RM' +
                                    totalbalance(foodNotifier.foodList.length,
                                        foodNotifier))
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        onRefresh: _refreshList,
      ),
    );
  }
}

String totalsales(int length, FoodNotifier foodNotifier) {
  num totaldata = 0;
  num itemdata = 0;
  for (int i = 0; i < length; i++) {
    for (int j = 0; j < foodNotifier.foodList[i].price.length; j++) {
      itemdata =
          itemdata + double.parse(foodNotifier.foodList[i].price[j].toString());
    }
    totaldata = totaldata + itemdata;
  }
  return totaldata.toStringAsFixed(2);
}

String totalbalance(int length, FoodNotifier foodNotifier) {
  num totaldata = 0;
  num itemdata = 0;
  for (int i = 0; i < length; i++) {
    for (int j = 0; j < foodNotifier.foodList[i].sales.length; j++) {
      itemdata =
          itemdata + double.parse(foodNotifier.foodList[i].sales[j].toString());
    }
    totaldata = totaldata + itemdata;
  }
  return totaldata.toStringAsFixed(2);
}

String totalprofit(int length, FoodNotifier foodNotifier) {
  num profit = 0;
  num totalprofit = 0;
  num expenses = 0;
  num totalexpenses = 0;
  num exacttotal = 0;

  for (int i = 0; i < length; i++) {
    for (int j = 0; j < foodNotifier.expensesList[i].price.length; j++) {
      expenses =
          expenses + (double.parse(foodNotifier.expensesList[i].price[j]));
    }
    totalexpenses = totalexpenses + expenses;
  }

  for (int i = 0; i < length; i++) {
    for (int j = 0; j < foodNotifier.foodList[i].price.length; j++) {
      double price = double.parse(foodNotifier.foodList[i].price[j].toString());
      double sales = double.parse(foodNotifier.foodList[i].sales[j].toString());
      profit = profit + (price - sales);
    }
    totalprofit = totalprofit + profit;
  }

  exacttotal = totalprofit - totalexpenses;

  print(exacttotal);

  return exacttotal.toStringAsFixed(2);
}

String totalexpenses(int length, FoodNotifier foodNotifier) {
  num expenses = 0;
  num totalexpenses = 0;

  for (int i = 0; i < length; i++) {
    for (int j = 0; j < foodNotifier.expensesList[i].price.length; j++) {
      expenses = expenses +
          (double.parse(foodNotifier.expensesList[i].price[j].toString()));
    }
    totalexpenses = totalexpenses + expenses;
  }
  return totalexpenses.toStringAsFixed(2);
}
