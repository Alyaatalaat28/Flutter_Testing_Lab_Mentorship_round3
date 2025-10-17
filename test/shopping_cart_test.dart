// import 'package:flutter_test/flutter_test.dart';

// // Import the file containing the ShoppingCart code
// // Make sure to replace 'your_app_name' with your actual project name
// import 'package:flutter_testing_lab/widgets/shopping_cart.dart'; 

// void main() {
//   // We test the State class directly, as it holds all the business logic.
//   late ShoppingCartState cart;

//   // setUp is called before each test, ensuring a fresh cart every time.
//   setUp(() {
//     cart = ShoppingCartState();
//   });

//   group('Shopping Cart Business Logic', () {
//     test('Initial cart should be empty', () {
//       expect(cart.items.isEmpty, isTrue);
//       expect(cart.totalItems, 0);
//       expect(cart.subtotal, 0.0);
//       expect(cart.totalDiscount, 0.0);
//       expect(cart.totalAmount, 0.0);
//     });

//     test('Adding a new item increases cart length and updates totals', () {
//       cart.addItem('1', 'Apple', 10.0, discount: 0.1); // 10% discount

//       expect(cart.items.length, 1);
//       expect(cart.items.first.quantity, 1);
//       expect(cart.totalItems, 1);
//       expect(cart.subtotal, 10.0);
//       expect(cart.totalDiscount, 1.0); // 10.0 * 0.1
//       expect(cart.totalAmount, 9.0);   // 10.0 - 1.0
//     });

//     test('Adding a duplicate item should update quantity, not add a new item', () {
//       // Add the first Apple
//       cart.addItem('1', 'Apple', 10.0, discount: 0.1);
//       expect(cart.items.length, 1);
//       expect(cart.items.first.quantity, 1);

//       // Add the second Apple
//       cart.addItem('1', 'Apple', 10.0, discount: 0.1);

//       // Assertions
//       expect(cart.items.length, 1); // Length should NOT change
//       expect(cart.items.first.quantity, 2); // Quantity should increase
//       expect(cart.totalItems, 2);
//       expect(cart.subtotal, 20.0);       // 10.0 * 2
//       expect(cart.totalDiscount, 2.0);   // (10.0 * 2) * 0.1
//       expect(cart.totalAmount, 18.0);      // 20.0 - 2.0
//     });

//     test('Removing an item should update cart correctly', () {
//       cart.addItem('1', 'Apple', 10.0);
//       cart.addItem('2', 'Banana', 5.0);

//       expect(cart.items.length, 2);
//       expect(cart.totalItems, 2);

//       cart.removeItem('1'); // Remove Apple

//       expect(cart.items.length, 1);
//       expect(cart.totalItems, 1);
//       expect(cart.items.first.name, 'Banana');
//       expect(cart.totalAmount, 5.0);
//     });

//     test('Updating quantity to a positive number works', () {
//       cart.addItem('1', 'Apple', 10.0);
//       cart.updateQuantity('1', 5);

//       expect(cart.items.first.quantity, 5);
//       expect(cart.totalItems, 5);
//       expect(cart.totalAmount, 50.0);
//     });

//     test('Updating quantity to zero or less should remove the item', () {
//       cart.addItem('1', 'Apple', 10.0);
//       cart.addItem('2', 'Banana', 5.0);

//       expect(cart.items.length, 2);

//       cart.updateQuantity('1', 0); // Update to zero

//       expect(cart.items.length, 1);
//       expect(cart.items.first.id, '2'); // Only Banana should remain

//       cart.updateQuantity('2', -1); // Update to a negative number

//       expect(cart.items.isEmpty, isTrue);
//     });
    
//     test('Clearing the cart removes all items and resets totals', () {
//       cart.addItem('1', 'Apple', 10.0);
//       cart.addItem('2', 'Banana', 5.0);

//       expect(cart.items.isNotEmpty, isTrue);

//       cart.clearCart();

//       expect(cart.items.isEmpty, isTrue);
//       expect(cart.totalItems, 0);
//       expect(cart.totalAmount, 0.0);
//     });

//     // --- Edge Case Testing ---
//     group('Edge Cases', () {
//       test('Calculations are correct for multiple, different items', () {
//         cart.addItem('1', 'Phone', 1000.0, discount: 0.1); // 10% off
//         cart.addItem('2', 'Case', 50.0); // No discount
//         cart.addItem('1', 'Phone', 1000.0, discount: 0.1); // Add another phone

//         // Totals should be:
//         // Phone: 2 * 1000 = 2000 subtotal, 200 discount
//         // Case: 1 * 50 = 50 subtotal, 0 discount
//         expect(cart.totalItems, 3);
//         expect(cart.subtotal, 2050.0);
//         expect(cart.totalDiscount, 200.0);
//         expect(cart.totalAmount, 1850.0); // 2050 - 200
//       });

//       test('A 100% discount should make the total amount zero for that item', () {
//         cart.addItem('1', 'Freebie', 100.0, discount: 1.0); // 100% discount
//         cart.addItem('2', 'Paid Item', 50.0);

//         expect(cart.subtotal, 150.0);
//         expect(cart.totalDiscount, 100.0);
//         expect(cart.totalAmount, 50.0);
//       });
//        test('Item with no discount is handled correctly', () {
//         cart.addItem('1', 'Full Price Item', 75.0); // No discount specified
        
//         expect(cart.items.first.discount, 0.0);
//         expect(cart.totalDiscount, 0.0);
//         expect(cart.totalAmount, 75.0);
//       });
//     });
//   });
// }