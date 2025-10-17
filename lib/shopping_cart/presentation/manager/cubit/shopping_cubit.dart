import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_testing_lab/shopping_cart/data/cart_item_model.dart';

part 'shopping_state.dart';

class ShoppingCubit extends Cubit<ShoppingState> {
  ShoppingCubit() : super(ShoppingInitial());
  final List<CartItem> items = [];

  void addItem(String id, String name, double price, {double discount = 0.0}) {
    for (var item in items) {
      if (item.id == id) {
        item.quantity++;
        emit(ShoppingUpdated());
        return;
      }
    }

    items.add(CartItem(id: id, name: name, price: price, discount: discount));
    emit(ShoppingUpdated());
  }

  void removeItem(String id) {
    items.removeWhere((item) => item.id == id);
    emit(ShoppingUpdated());
  }

  void updateQuantity(String id, int newQuantity) {
    final index = items.indexWhere((item) => item.id == id);
    if (index != -1) {
      if (newQuantity <= 0) {
        items.removeAt(index);
      } else {
        items[index].quantity = newQuantity;
      }
    }
    emit(ShoppingUpdated());
  }

  void clearCart() {
    items.clear();
    emit(ShoppingUpdated());
  }

  double get subtotal {
    double total = 0;
    for (var item in items) {
      total += item.price * item.quantity;
    }
    return total;
  }

  double get totalDiscount {
    double discount = 0;
    for (var item in items) {
      final totalAfterDiscount =
          (item.price - (item.price * item.discount)) * item.quantity;
      discount += (item.price * item.quantity) - totalAfterDiscount;
    }
    return discount;
  }

  double get totalAmount {
    final total = subtotal - totalDiscount;

    return total;
  }

  int get totalItems {
    return items.fold(0, (sum, item) {
      return sum + item.quantity;
    });
  }
}
