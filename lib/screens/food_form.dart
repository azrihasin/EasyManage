import 'dart:io';
import 'package:easymanage/notifier/auth_notifier.dart';
import 'package:easymanage/screens/textinputformatter.dart';
import 'package:easymanage/api/food_api.dart';
import 'package:easymanage/model/food.dart';
import 'package:easymanage/notifier/food_notifier.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class FoodForm extends StatefulWidget {
  final bool isUpdating;

  FoodForm({@required this.isUpdating});

  @override
  _FoodFormState createState() => _FoodFormState();
}

class _FoodFormState extends State<FoodForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String userid;
  List _subingredients = [];
  List _price = [];
  List _sales = [];
  List _date = [];
  Food _currentFood;
  String _imageUrl;
  File _imageFile;
  TextEditingController subingredientController = new TextEditingController();
  TextEditingController priceController = new TextEditingController();

  @override
  void initState() {
    super.initState();

    FoodNotifier foodNotifier =
        Provider.of<FoodNotifier>(context, listen: false);

    if (foodNotifier.currentFood != null) {
      _currentFood = foodNotifier.currentFood;
    } else {
      _currentFood = Food();
    }

    userid = _currentFood.userid;
    _subingredients.addAll(_currentFood.subIngredients);
    _price.addAll(_currentFood.price);
    _sales.addAll(_currentFood.sales);
    _date.addAll(_currentFood.date);
    _imageUrl = _currentFood.image;
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
      initialValue: _currentFood.name,
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
        _currentFood.name = value;
      },
    );
  }

  Widget _buildCategoryField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Category'),
      initialValue: _currentFood.category,
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
        _currentFood.category = value;
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

  _onFoodUploaded(Food food) {
    FoodNotifier foodNotifier =
        Provider.of<FoodNotifier>(context, listen: false);

    foodNotifier.addFood(food);

    Navigator.pop(context);
  }

  _onFoodUploaded2(Food food) {
    FoodNotifier foodNotifier =
        Provider.of<FoodNotifier>(context, listen: false);

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
        _sales.add(text);
      });
      priceController.clear();
    }
  }

  _addSalesandDate(String text) {
    setState(() {
      _date.add(DateTime.now());
    });
  }

  _saveFood() {
    print('saveFood Called');
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    print('form saved');

    _currentFood.userid = userid;

    print('User id :' + userid);
    _currentFood.subIngredients = _subingredients;
    _currentFood.price = _price;
    _currentFood.sales = _sales;
    _currentFood.date = _date;

    if (widget.isUpdating) {
      uploadFoodAndImage(
          _currentFood, widget.isUpdating, _imageFile, _onFoodUploaded2);
    } else {
      uploadFoodAndImage(
          _currentFood, widget.isUpdating, _imageFile, _onFoodUploaded);
    }
    ;

    print("name: ${_currentFood.name}");
    print("category: ${_currentFood.category}");
    print("subingredients: ${_currentFood.subIngredients.toString()}");
    print("price: ${_currentFood.price.toString()}");
    print("_imageFile ${_imageFile.toString()}");
    print("_imageUrl $_imageUrl");
  }

  TextEditingController paymentController = TextEditingController();

  @override
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
                            _addSalesandDate(priceController.text);
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
                                      child: Column(
                                        children: [
                                          Text('Balance    ' +
                                              '\nRM ' +
                                              _sales[index].toString()),
                                          Text('Price          ' +
                                              '\nRM ' +
                                              _price[index].toString()),
                                        ],
                                      ),
                                    ),
                                    isThreeLine: true,
                                    trailing: Wrap(
                                      children: <Widget>[
                                        FlatButton(
                                          minWidth: 20,
                                          onPressed: null,
                                          child: Column(
                                            // Replace with a Row for horizontal icon + text
                                            children: <Widget>[
                                              Icon(
                                                  Icons.account_balance_wallet),
                                              Text("Pay")
                                            ],
                                          ),
                                        ),
                                        FlatButton(
                                          minWidth: 20,
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text('Payment'),
                                                    content: TextField(
                                                      controller:
                                                          paymentController,
                                                      inputFormatters: [
                                                        DecimalTextInputFormatter(
                                                            decimalRange: 2)
                                                      ],
                                                      keyboardType: TextInputType
                                                          .numberWithOptions(
                                                              decimal: true),
                                                    ),
                                                    actions: <Widget>[
                                                      MaterialButton(
                                                        elevation: 5.0,
                                                        child: Text('Submit'),
                                                        onPressed: () {
                                                          double balance;
                                                          var a = double.parse(
                                                              _sales[index]
                                                                  .toString());

                                                          var b = double.parse(
                                                              paymentController
                                                                  .text);

                                                          balance = a - b;

                                                          print(balance);

                                                          if (balance < 0) {
                                                            paymentController
                                                                .text = '';
                                                            print(
                                                                'cannot be subtracted');
                                                          } else {
                                                            setState(() {
                                                              _sales[index] =
                                                                  balance;
                                                            });

                                                            print(
                                                                _sales[index]);

                                                            Navigator.of(
                                                                    context)
                                                                .pop(paymentController
                                                                    .text
                                                                    .toString());
                                                          }

                                                          //to close the dialog
                                                        },
                                                      )
                                                    ],
                                                  );
                                                });
                                          },
                                          child: Column(
                                            // Replace with a Row for horizontal icon + text
                                            children: <Widget>[
                                              Icon(
                                                  Icons.account_balance_wallet),
                                              Text("Pay All")
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
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
          _saveFood();
        },
        child: Icon(Icons.save),
        foregroundColor: Colors.white,
      ),
    );
  }
}
