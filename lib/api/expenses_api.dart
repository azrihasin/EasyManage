import 'dart:io';

import 'package:easymanage/model/food.dart';
import 'package:easymanage/model/expenses.dart';
import 'package:easymanage/notifier/expenses_notifier.dart';
import 'package:easymanage/notifier/food_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
