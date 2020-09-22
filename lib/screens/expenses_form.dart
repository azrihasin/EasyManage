import 'dart:io';

import 'package:easymanage/model/expenses.dart';
import 'package:easymanage/notifier/auth_notifier.dart';
import 'package:easymanage/screens/textinputformatter.dart';
import 'package:easymanage/api/food_api.dart';
import 'package:easymanage/notifier/food_notifier.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ExpensesForm extends StatefulWidget {
  final bool isUpdating;

  ExpensesForm({@required this.isUpdating});

  @override
  _ExpensesFormState createState() => _ExpensesFormState();
}

class _ExpensesFormState extends State<ExpensesForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String userid;
  List _subingredients = [];
  List _price = [];
  Expenses _currentExpenses;
  String _imageUrl;
  File _imageFile;
  TextEditingController subingredientController = new TextEditingController();
  TextEditingController priceController = new TextEditingController();

  @override
  void initState() {
    super.initState();

    FoodNotifier foodNotifier =
        Provider.of<FoodNotifier>(context, listen: false);

    if (foodNotifier.currentExpenses != null) {
      _currentExpenses = foodNotifier.currentExpenses;
    } else {
      _currentExpenses = Expenses();
    }

    userid = _currentExpenses.userid;
    _subingredients.addAll(_currentExpenses.subIngredients);
    _price.addAll(_currentExpenses.price);
    _imageUrl = _currentExpenses.image;
  }

  _showImage() {
    if (_imageFile == null && _imageUrl == null) {
      return Text("image placeholder");
    } else if (_imageFile != null) {
      print('showing image from local file');

      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.file(
            _imageFile,
            fit: BoxFit.cover,
            height: 250,
          ),
          FlatButton(
            padding: EdgeInsets.all(16),
            color: Colors.black54,
            child: Text(
              'Change Image',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w400),
            ),
            onPressed: () => _getLocalImage(),
          )
        ],
      );
    } else if (_imageUrl != null) {
      print('showing image from url');

      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.network(
            _imageUrl,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            height: 250,
          ),
          FlatButton(
            padding: EdgeInsets.all(16),
            color: Colors.black54,
            child: Text(
              'Change Image',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w400),
            ),
            onPressed: () => _getLocalImage(),
          )
        ],
      );
    }
  }

  _getLocalImage() async {
    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50, maxWidth: 400);

    if (imageFile != null) {
      setState(() {
        _imageFile = imageFile;
      });
    }
  }

  Widget _buildNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Name'),
      initialValue: _currentExpenses.name,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name is required';
        }

        if (value.length < 3 || value.length > 20) {
          return 'Name must be more than 3 and less than 20';
        }

        return null;
      },
      onSaved: (String value) {
        _currentExpenses.name = value;
      },
    );
  }

  Widget _buildCategoryField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Category'),
      initialValue: _currentExpenses.category,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Category is required';
        }

        if (value.length < 3 || value.length > 20) {
          return 'Category must be more than 3 and less than 20';
        }

        return null;
      },
      onSaved: (String value) {
        _currentExpenses.category = value;
      },
    );
  }

  _buildSubingredientField() {
    return SizedBox(
      width: 200,
      child: TextField(
        controller: subingredientController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(labelText: 'Subingredient'),
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  _buildPriceField() {
    return SizedBox(
      width: 200,
      child: TextField(
        controller: priceController,
        inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(labelText: 'Price'),
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  _onExpensesUploaded(Expenses expenses) {
    FoodNotifier foodNotifier =
        Provider.of<FoodNotifier>(context, listen: false);
    foodNotifier.addExpenses(expenses);
    Navigator.pop(context);
  }

  _onExpensesUploaded2(Expenses expenses) {
    int count = 0;
    Navigator.of(context).popUntil((_) => count++ >= 2);
  }

  _addSubingredient(String text) {
    if (text.isNotEmpty) {
      setState(() {
        _subingredients.add(text);
      });
      subingredientController.clear();
    }
  }

  _addPrice(String text) {
    if (text.isNotEmpty) {
      setState(() {
        _price.add(text);
      });
      priceController.clear();
    }
  }

  _saveExpenses() {
    print('saveExpenses Called');
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    print('form saved');
    _currentExpenses.userid = userid;

    print('User id :' + userid);
    _currentExpenses.subIngredients = _subingredients;
    _currentExpenses.price = _price;

    if (widget.isUpdating) {
      uploadExpensesAndImage(
          _currentExpenses, widget.isUpdating, _imageFile, _onExpensesUploaded);
    } else {
      uploadExpensesAndImage(_currentExpenses, widget.isUpdating, _imageFile,
          _onExpensesUploaded2);
    }
    ;

    print("name: ${_currentExpenses.name}");
    print("category: ${_currentExpenses.category}");
    print("subingredients: ${_currentExpenses.subIngredients.toString()}");
    print("price: ${_currentExpenses.price.toString()}");
    print("_imageFile ${_imageFile.toString()}");
    print("_imageUrl $_imageUrl");
  }

  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);

    userid = authNotifier.user.uid;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Food Form')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          autovalidate: true,
          child: Column(children: <Widget>[
            _showImage(),
            SizedBox(height: 16),
            Text(
              widget.isUpdating ? "Edit " : "Create ",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(height: 16),
            _imageFile == null && _imageUrl == null
                ? ButtonTheme(
                    child: RaisedButton(
                      onPressed: () => _getLocalImage(),
                      child: Text(
                        'Add Image',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                : SizedBox(height: 0),
            Container(
              height: 250,
              padding:
                  EdgeInsets.only(left: 15.0, right: 15, top: 20, bottom: 30),
              margin: EdgeInsets.only(top: 30, bottom: 30.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blue,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(children: [
                _buildNameField(),
                SizedBox(height: 20),
                _buildCategoryField(),
              ]),
            ),
            Container(
              padding:
                  EdgeInsets.only(left: 16.0, right: 15, top: 10, bottom: 20),
              margin: EdgeInsets.only(bottom: 50.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(children: <Widget>[
                    _buildSubingredientField(),
                    _buildPriceField(),
                    SizedBox(height: 40),
                  ]),
                  ButtonTheme(
                    child: RaisedButton(
                        textColor: Colors.white,
                        padding: EdgeInsets.all(16),
                        shape: CircleBorder(),
                        child: Icon(Icons.add),
                        onPressed: () {
                          if (subingredientController.text.isNotEmpty &&
                              priceController.text.isNotEmpty) {
                            _addPrice(priceController.text);
                            _addSubingredient(subingredientController.text);

                            print(priceController.text);
                          } else {
                            subingredientController.text = "";
                            priceController.text = "";
                          }
                        }),
                  ),
                ],
              ),
            ),
            ConstrainedBox(
              constraints: new BoxConstraints(
                minHeight: 35.0,
                maxHeight: 10000.0,
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    itemCount: _subingredients.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Dismissible(
                        onDismissed: (DismissDirection direction) {
                          setState(() {
                            _subingredients.removeAt(index);
                            _price.removeAt(index);
                          });
                        },
                        secondaryBackground: Container(
                          child: Center(
                            child: Text(
                              'Delete',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          color: Colors.red,
                        ),
                        background: Container(),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: null,
                                    title: Text(_subingredients[index]),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, right: 30.0),
                                      child: Text('Price          ' +
                                          '\nRM ' +
                                          _price[index].toString()),
                                    ),
                                    isThreeLine: true,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                      );
                    }),
              ),
            )
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          _saveExpenses();
        },
        child: Icon(Icons.save),
        foregroundColor: Colors.white,
      ),
    );
  }
}
