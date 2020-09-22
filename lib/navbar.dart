import 'package:easymanage/screens/expenses_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:easymanage/api/food_api.dart';
import 'package:easymanage/notifier/auth_notifier.dart';
import 'package:easymanage/notifier/food_notifier.dart';
import 'package:easymanage/screens/feed.dart';
import 'package:easymanage/screens/food_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:easymanage/screens/expensesfeed.dart';
import 'package:easymanage/screens/overview.dart';

class Navbar extends StatefulWidget {
  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int currentIndex;

  @override
  void initState() {
    super.initState();

    currentIndex = 0;
  }

  final List<Widget> _children = [
    Feed(),
    Expenses(),
    Overview(),
  ];

  changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    FoodNotifier foodNotifier = Provider.of<FoodNotifier>(context);

    return new Scaffold(
      backgroundColor: Colors.grey[100],
      body: _children[currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (currentIndex == 0) {
            foodNotifier.currentFood = null;
            Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) {
                return FoodForm(
                  isUpdating: false,
                );
              }),
            );
          } else if (currentIndex == 1) {
            foodNotifier.currentExpenses = null;
            Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) {
                return ExpensesForm(
                  isUpdating: false,
                );
              }),
            );
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BubbleBottomBar(
        opacity: 0.2,
        backgroundColor: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
        currentIndex: currentIndex,
        hasInk: true,
        inkColor: Colors.black12,
        hasNotch: true,
        fabLocation: BubbleBottomBarFabLocation.end,
        onTap: changePage,
        items: [
          BubbleBottomBarItem(
            backgroundColor: Colors.red,
            icon: Icon(
              Icons.dashboard,
              color: Colors.black,
            ),
            activeIcon: Icon(
              Icons.dashboard,
              color: Colors.red,
            ),
            title: Text('Home'),
          ),
          BubbleBottomBarItem(
            backgroundColor: Colors.indigo,
            icon: Icon(
              Icons.folder_open,
              color: Colors.black,
            ),
            activeIcon: Icon(
              Icons.folder_open,
              color: Colors.indigo,
            ),
            title: Text('Folders'),
          ),
          BubbleBottomBarItem(
            backgroundColor: Colors.deepPurple,
            icon: Icon(
              Icons.access_time,
              color: Colors.black,
            ),
            activeIcon: Icon(
              Icons.access_time,
              color: Colors.deepPurple,
            ),
            title: Text('Log'),
          ),
        ],
      ),
    );
  }
}
