import 'dart:async';

import 'package:easymanage/api/food_api.dart';
import 'package:easymanage/notifier/food_notifier.dart';
import 'package:easymanage/screens/detailexpenses.dart';
import 'package:flutter/material.dart';
import 'package:easymanage/notifier/auth_notifier.dart';
import 'package:easymanage/screens/detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Expenses extends StatefulWidget {
  @override
  _ExpensesState createState() => _ExpensesState();
}

images() {
  return 'assets/images/download.jpg';
}

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class _ExpensesState extends State<Expenses> {
  final _debouncer = Debouncer(milliseconds: 500);

  TextEditingController searchController = new TextEditingController();

  @override
  void initState() {
    FoodNotifier foodNotifier =
        Provider.of<FoodNotifier>(context, listen: false);
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);

    getExpenses(foodNotifier, authNotifier);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    FoodNotifier foodNotifier = Provider.of<FoodNotifier>(context);

    Future<void> _refreshList() async {
      getExpenses(foodNotifier, authNotifier);
    }

    print("building Feed");
    print('length of list :' + foodNotifier.filteredUsers2.length.toString());
    return Scaffold(
      backgroundColor: Colors.grey[200],
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
            Container(
              color: Colors.blue,
              padding: EdgeInsets.only(
                  top: 30.0, right: 10.0, left: 10.0, bottom: 20.0),
              child: TextField(
                controller: searchController,
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(width: 1, color: Colors.blueGrey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(width: 1, color: Colors.blueGrey),
                  ),
                  fillColor: Colors.blueGrey,
                  filled: true,
                  hintText: 'Filter by name or email',
                ),
                onChanged: (string) {
                  _debouncer.run(() {
                    setState(() {
                      if (searchController.text.isNotEmpty) {
                        print("nice1");
                        foodNotifier.filteredUsers2 = foodNotifier.expensesList
                            .where((u) => (u.name
                                    .toLowerCase()
                                    .contains(string.toLowerCase()) ||
                                u.category
                                    .toLowerCase()
                                    .contains(string.toLowerCase())))
                            .toList();
                        // ignore: unrelated_type_equality_checks
                      } else if (searchController.text.isEmpty) {
                        print("nice");
                        setState(() {
                          foodNotifier.filteredUsers2 =
                              foodNotifier.expensesList;
                        });
                      }
                    });
                  });
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(15.0),
                itemBuilder: (BuildContext context, int index) {
                  print(foodNotifier.expensesList[index].userid);
                  return Card(
                      child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: ListTile(
                            leading: new Container(
                                width: 60.0,
                                height: 60.0,
                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                      fit: BoxFit.fill,
                                      image: foodNotifier.filteredUsers2[index]
                                                  .image !=
                                              null
                                          ? NetworkImage(
                                              foodNotifier
                                                  .filteredUsers2[index].image,
                                            )
                                          : AssetImage(images()),
                                    ))),
                            title:
                                Text(foodNotifier.filteredUsers2[index].name),
                            subtitle: Text(
                                foodNotifier.filteredUsers2[index].category),
                            onTap: () {
                              foodNotifier.currentExpenses =
                                  foodNotifier.filteredUsers2[index];
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return ExpensesDetail();
                              }));
                            },
                          )));
                },
                itemCount: foodNotifier.filteredUsers2.length,
              ),
            ),
          ],
        ),
        onRefresh: _refreshList,
      ),
    );
  }
}
