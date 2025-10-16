  import 'package:flutter/material.dart';
import 'package:flutter_testing_lab/widgets/shopping_cart.dart';
import 'package:flutter_testing_lab/widgets/user_registration_form.dart';
import 'package:flutter_testing_lab/widgets/weather_display.dart';

final List<Tab> tabs = [
    const Tab(icon: Icon(Icons.person_add), text: 'Registration'),
    const Tab(icon: Icon(Icons.shopping_cart), text: 'Shopping Cart'),
    const Tab(icon: Icon(Icons.wb_sunny), text: 'Weather'),
  ];

  final List<Widget> tabViews = [
    const UserRegistrationForm(),
    const ShoppingCart(),
    const WeatherDisplay(),
  ];