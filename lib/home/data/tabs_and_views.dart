import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_testing_lab/shopping_cart/presentation/manager/cubit/shopping_cubit.dart';
import 'package:flutter_testing_lab/shopping_cart/presentation/widgets/shopping_cart.dart';
import 'package:flutter_testing_lab/registration/presentation/widgets/user_registration_form.dart';
import 'package:flutter_testing_lab/widgets/weather_display.dart';

final List<Tab> tabs = [
  const Tab(icon: Icon(Icons.person_add), text: 'Registration'),
  const Tab(icon: Icon(Icons.shopping_cart), text: 'Shopping Cart'),
  const Tab(icon: Icon(Icons.wb_sunny), text: 'Weather'),
];

final List<Widget> tabViews = [
  const UserRegistrationForm(),
  BlocProvider(
    create: (context) => ShoppingCubit(),
    child: const ShoppingCart(),
  ),
  const WeatherDisplay(),
];
