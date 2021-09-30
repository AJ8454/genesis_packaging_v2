import 'package:flutter/material.dart';

class Employee with ChangeNotifier {
  final String? id;
  final String? name;
  final String? gender;
  final String? startTime;
  final String? endTime;
  final double? wages;
  final String? dateTime;
  final String? overTime;
  final String imageUrl;

  Employee({
    required this.id,
    required this.name,
    required this.gender,
    required this.startTime,
    required this.endTime,
    required this.wages,
    required this.dateTime,
    required this.overTime,
     this.imageUrl =
        'assets/icons/person.svg',
  });
}