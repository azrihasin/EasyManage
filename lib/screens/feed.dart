import 'dart:async';
import 'package:recase/recase.dart';
import 'package:easymanage/api/food_api.dart';
import 'package:intl/intl.dart';
import 'package:easymanage/notifier/auth_notifier.dart';
import 'package:easymanage/notifier/food_notifier.dart';
import 'package:easymanage/screens/detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
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

class _FeedState extends State<Feed> {
  final _debouncer = Debouncer(milliseconds: 500);

  TextEditingController searchController = new TextEditingController();

  @override
  void initState() {
    FoodNotifier foodNotifier =
        Provider.of<FoodNotifier>(context, listen: false);
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    getFoods(foodNotifier, authNotifier);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    FoodNotifier foodNotifier = Provider.of<FoodNotifier>(context);

    Future<void> _refreshList() async {
      getFoods(foodNotifier, authNotifier);
    }

    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);

    print('a' + '' + foodNotifier.filteredUsers.length.toString());
    print('b' + '' + foodNotifier.foodList.length.toString());

    print("building Feed");
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color(0xfffbf5f5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          authNotifier.user != null ? authNotifier.user.displayName : "Feed",
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
              //TOP BOX
              height: 300,
              padding: EdgeInsets.only(
                  top: 10, right: 10.0, left: 10.0, bottom: 10.0),

              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("./assets/images/background.jpg"),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15)),
                color: Colors.blue,
              ),

              child: Container(
                child: Column(
                  children: [
                    Container(
                        padding: EdgeInsets.only(left: 5.0),
                        margin: EdgeInsets.only(top: 100.0, bottom: 30.0),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: [
                            Text(
                                'Hello ' +
                                    (authNotifier.user != null
                                        ? authNotifier
                                            .user.displayName.sentenceCase
                                        : "User") +
                                    ',',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Acumin',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30)),
                            Padding(
                              padding: const EdgeInsets.only(right: 60),
                              child: Text(
                                  DateFormat('EEEE, d MMM, yyyy')
                                      .format(date)
                                      .toString(),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Acumin',
                                      fontSize: 16)),
                            ),
                          ],
                        )),
                    Container(
                      //SEARCH BOX
                      margin: EdgeInsets.only(top: 40),
                      child: TextField(
                        textAlign: TextAlign.left,
                        controller: searchController,
                        cursorColor: Colors.black,
                        cursorHeight: 25,
                        style: TextStyle(fontSize: 19),

                        //INPUT DECORATION
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.only(left: 13, bottom: 30),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide:
                                BorderSide(width: 1, color: Color(0xfffbf5f5)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide:
                                BorderSide(width: 1, color: Color(0xfffbf5f5)),
                          ),
                          fillColor: Color(0xfffbf5f5),
                          filled: true,
                          hintText: 'Filter by name or category',
                        ),
                        onChanged: (string) {
                          _debouncer.run(() {
                            setState(() {
                              if (searchController.text.isNotEmpty) {
                                print("nice1");
                                foodNotifier.filteredUsers = foodNotifier
                                    .foodList
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
                                  foodNotifier.filteredUsers =
                                      foodNotifier.foodList;
                                });
                              }
                            });
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20, right: 30, left: 20),
              alignment: Alignment.centerLeft,
              child: Text('Customers',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Acumin',
                    fontWeight: FontWeight.bold,
                  )),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: ListTile(
                            leading: new Container(
                                width: 58.0,
                                height: 60.0,
                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                      fit: BoxFit.fill,
                                      image: foodNotifier
                                                  .filteredUsers[index].image !=
                                              null
                                          ? NetworkImage(
                                              foodNotifier
                                                  .filteredUsers[index].image,
                                            )
                                          : AssetImage(images()),
                                    ))),
                            title: Text(
                              foodNotifier
                                  .filteredUsers[index].name.sentenceCase,
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Acumin',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(left: 2.0),
                              child: Text(
                                foodNotifier
                                    .filteredUsers[index].category.sentenceCase,
                                style: TextStyle(fontFamily: 'Acumin'),
                              ),
                            ),
                            onTap: () {
                              foodNotifier.currentFood =
                                  foodNotifier.filteredUsers[index];
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return FoodDetail();
                              }));
                            },
                          )));
                },
                itemCount: foodNotifier.filteredUsers.length,
              ),
            ),
          ],
        ),
        onRefresh: _refreshList,
      ),
    );
  }
}
