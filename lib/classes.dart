import 'package:flutter/material.dart';

class Dish {
  Dish({required this.title, required this.time});

  final String title;
  final String time;
  final List<Dish> subDishes = [];

  clone() => Dish(title: title, time: time);
}

class WeekDay {
  WeekDay({
    this.isExpanded = false,
    required this.header,
  });

  bool isExpanded;
  final String header;
  TimeOfDay dinnerTime = TimeOfDay(hour: 19, minute: 0);
  List<Dish> dishes = [];
}