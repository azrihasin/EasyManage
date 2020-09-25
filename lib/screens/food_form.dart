import 'dart:io';
import 'dart:math';
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

  images() {
    Random rnd;
    int min = 1;
    int max = 11;
    rnd = new Random();
    var r = min + rnd.nextInt(max - min);
    print("$r is in the range of $min and $max");

    switch (r) {
      case 1:
        {
          return 'assets/images/Asset 1.png';
        }
        break;

      case 2:
        {
          return 'assets/images/Asset 2.png';
        }
        break;

      case 3:
        {
          return 'assets/images/Asset 3.png';
        }
        break;

      case 4:
        {
          return 'assets/images/Asset 4.png';
        }
        break;

      case 5:
        {
          return 'assets/images/Asset 5.png';
        }
        break;

      case 6:
        {
          return 'assets/images/Asset 6.png';
        }
        break;

      case 7:
        {
          return 'assets/images/Asset 7.png';
        }
        break;

      case 8:
        {
          return 'assets/images/Asset 8.png';
        }
        break;

      case 9:
        {
          return 'assets/images/Asset 9.png';
        }
        break;

      case 10:
        {
          return 'assets/images/Asset 10.png';
        }
        break;

      case 11:
        {
          return 'assets/images/Asset 11.png';
        }
        break;
    }
  }

  _showImage(bool update) {
    if (_imageFile == null && _imageUrl == null) {
      print('IMAGE :' + _currentFood.image.toString());
      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  topLeft: Radius.circular(15)),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/Asset 9.png')),
              color: Colors.white,
            ),
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
    } else if (_imageFile != null) {
      print('showing image from local file');

      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.file(
              _imageFile,
              fit: BoxFit.cover,
              height: 100,
              width: 100,
            ),
          ),
          FlatButton(
            padding: EdgeInsets.all(5),
            color: Colors.black26,
            child: Text(
              'Change Image',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
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
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              _imageUrl,
              fit: BoxFit.cover,
              height: 100,
              width: 100,
            ),
          ),
          FlatButton(
            padding: EdgeInsets.all(5),
            color: Colors.black26,
            child: Text(
              'Change Image',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
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
      extendBodyBehindAppBar: true,
      backgroundColor: Color(0xfffbf5f5),
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Item',
            style: TextStyle(
                fontFamily: 'Roboto',
                color: Colors.black,
                fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xfffbf5f5),
        elevation: 0.0,
      ),
      body: Container(
        margin: EdgeInsets.only(top: 100),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            autovalidate: true,
            child: Column(children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 15, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Text(
                          widget.isUpdating
                              ? "Edit \n" + "Item"
                              : "Create \n" + "Item",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 30,
                              fontWeight: FontWeight.bold)),
                    ),
                    _showImage(widget.isUpdating),
                  ],
                ),
              ),
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
                    EdgeInsets.only(left: 15.0, right: 15, top: 0, bottom: 0),
                margin: EdgeInsets.only(top: 30, bottom: 0),
                decoration: BoxDecoration(
                  // border: Border.all(//color: Colors.blue,) ,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(children: [
                  _buildNameField(),
                  SizedBox(height: 20),
                  _buildCategoryField(),
                ]),
              ),
              Container(
                padding: const EdgeInsets.all(15.0),
                alignment: Alignment.centerLeft,
                child: Text('Add item',
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 30,
                        fontWeight: FontWeight.bold)),
              ),
              Container(
                padding:
                    EdgeInsets.only(left: 16.0, right: 15, top: 10, bottom: 20),
                margin: EdgeInsets.only(left: 5, right: 5, bottom: 30.0),
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
                      spreadRadius: 3,
                      blurRadius: 5,
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
                child: Container(
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
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: null,
                                    title: Text(_subingredients[index]),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Balance ' +
                                            'RM ' +
                                            _sales[index].toString()),
                                        Text('Price ' +
                                            'RM ' +
                                            _price[index].toString()),
                                      ],
                                    ),
                                    isThreeLine: true,
                                    trailing: Wrap(
                                      children: <Widget>[
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
                                              Text("Pay")
                                            ],
                                          ),
                                        ),
                                        FlatButton(
                                          padding: EdgeInsets.all(0),
                                          minWidth: 20,
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text('Pay All'),
                                                    actions: <Widget>[
                                                      MaterialButton(
                                                        elevation: 5.0,
                                                        child: Text('Confirm'),
                                                        onPressed: () {
                                                          double balance;
                                                          var a = double.parse(
                                                              _sales[index]
                                                                  .toString());

                                                          var b = double.parse(
                                                              _sales[index]
                                                                  .toString());

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
                          key: UniqueKey(),
                          direction: DismissDirection.endToStart,
                        );
                      }),
                ),
              )
            ]),
          ),
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
