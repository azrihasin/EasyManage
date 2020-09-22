import 'dart:collection';

import 'package:easymanage/model/expenses.dart';
import 'package:easymanage/model/food.dart';
import 'package:flutter/cupertino.dart';

class FoodNotifier with ChangeNotifier {
  List<Food> _foodList = [];
  List<Food> _filteredUsers = [];
  List<Expenses> _filteredUsers2 = [];
  List<Expenses> _expensesList = [];
  Food _currentFood;
  Expenses _currentExpenses;

//Main
  UnmodifiableListView<Food> get foodList => UnmodifiableListView(_foodList);

  UnmodifiableListView<Food> get filteredUsers =>
      UnmodifiableListView(_filteredUsers);

//Expenses
  UnmodifiableListView<Expenses> get filteredUsers2 =>
      UnmodifiableListView(_filteredUsers2);

  UnmodifiableListView<Expenses> get expensesList =>
      UnmodifiableListView(_expensesList);

  Food get currentFood => _currentFood;

  Expenses get currentExpenses => _currentExpenses;

  set foodList(List<Food> foodList) {
    _foodList = foodList;
    _filteredUsers = foodList;

    notifyListeners();
  }

  set filteredUsers(List<Food> filteredUsers) {
    _filteredUsers = filteredUsers;
    notifyListeners();
  }

  set filteredUsers2(List<Expenses> filteredUsers2) {
    _filteredUsers2 = filteredUsers2;
    notifyListeners();
  }

  set currentFood(Food food) {
    _currentFood = food;
    notifyListeners();
  }

  addFood(Food food) {
    _foodList.insert(0, food);
    notifyListeners();
  }

  deleteFood(Food food) {
    _foodList.removeWhere((_food) => _food.id == food.id);

    notifyListeners();
  }

  set expensesList(List<Expenses> expensesList) {
    _expensesList = expensesList;
    _filteredUsers2 = expensesList;
    notifyListeners();
  }

  set currentExpenses(Expenses expenses) {
    _currentExpenses = expenses;
    notifyListeners();
  }

  addExpenses(Expenses expenses) {
    _expensesList.insert(0, expenses);
    notifyListeners();
  }

  deleteExpenses(Expenses expenses) {
    _expensesList.removeWhere((_expenses) => _expenses.id == expenses.id);
    notifyListeners();
  }
}
