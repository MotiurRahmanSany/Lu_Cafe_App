import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lu_cafe/core/utils/utils.dart';
import 'package:lu_cafe/features/auth/presentation/controllers/auth_controller.dart';
import 'package:lu_cafe/features/cart/data/cart_repository.dart';
import 'package:lu_cafe/features/profile/data/user_repository.dart';

import '../../domain/cart.dart';

final cartControllerProvider =
    StateNotifierProvider<CartNotifier, AsyncValue<List<Cart>>>((ref) {
  return CartNotifier(
    ref: ref,
    userRepository: ref.read(userRepositoryProvider),
    cartRepository: ref.read(cartRepositoryProvider),
  );
});

class CartNotifier extends StateNotifier<AsyncValue<List<Cart>>> {
  final Ref _ref;
  final UserRepository _userRepository;
  final CartRepository _cartRepository;

  CartNotifier({
    required Ref ref,
    required UserRepository userRepository,
    required CartRepository cartRepository,
  })  : _ref = ref,
        _userRepository = userRepository,
        _cartRepository = cartRepository,
        super(AsyncValue.loading()) {
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    try {
      final user = _ref.read(authStateNotifierProvider);
      if (user == null) {
        state = AsyncValue.data([]);
        return;
      }
      final userModel = await _userRepository.getUserData(user.user.$id);
      final cartIds = userModel.userCart;
      final carts = await _cartRepository.getCartItemsByIds(cartIds);
      state = AsyncValue.data(carts);
    } catch (err, st) {
      state = AsyncValue.error(err, st);
    }
  }

  // fetchCartItem by id
  Cart fetchCartItemById(String cartId) {
    final cartItems = state.value ?? [];
    final cart = cartItems.firstWhere(
      (element) => element.foodId == cartId,
    );
    return cart;
  }

  Future<void> addCartItem(BuildContext context, {required Cart cart}) async {
    final user = _ref.read(authStateNotifierProvider);
    if (user == null) return; // User not logged in.
    final uid = user.user.$id;

    // checking if item already exists in the cart state
    final currentCartItems = state.value ?? [];
    final existingCart = currentCartItems.firstWhere(
      (element) => element.foodId == cart.foodId,
      orElse: () => Cart(id: '', foodId: '', quantity: 0, price: 0),
    );

    if (existingCart.id.isNotEmpty) {
      final newQuantity = existingCart.quantity + cart.quantity;
      final result = await _cartRepository.updateCartItemQuantity(
        cartId: existingCart.id,
        newQuantity: newQuantity,
      );

      result.fold((failure) {
        showMessageToUser(context, message: 'Error updating item quantity');
      }, (_) {
        _loadCartItems();
      });
    } else {
      final result = await _cartRepository.addToCart(cart: cart);
      result.fold(
        (failure) {
          showMessageToUser(context, message: 'Error adding item to cart');
        },
        (cartId) async {
          await _userRepository.updateUserCart(uid: uid, cartId: cartId);
          await _loadCartItems();
          showMessageToUser(context, message: 'Item added to cart');
        },
      );
    }
  }

  Future<void> incrementItemQuantity(BuildContext context,
      {required Cart cart}) async {
    final result = await _cartRepository.updateCartItemQuantity(
      cartId: cart.id,
      newQuantity: cart.quantity + 1,
    );

    result.fold((failure) {
      showMessageToUser(context, message: 'Error updating item quantity');
    }, (_) {
      _loadCartItems();
    });
  }

  Future<void> decrementItemQuantity(BuildContext context,
      {required Cart cart}) async {
    if (cart.quantity < 2) {
      await removeCartItem(context, cartId: cart.id);
    } else {
      final result = await _cartRepository.updateCartItemQuantity(
        cartId: cart.id,
        newQuantity: cart.quantity - 1,
      );

      result.fold((failure) {
        showMessageToUser(context, message: 'Error updating item quantity');
      }, (_) {
        _loadCartItems();
      });
    }
  }

  Future<void> removeCartItem(BuildContext context,
      {required String cartId}) async {
    final result = await _cartRepository.removeCartItem(cartId: cartId);
    result.fold(
      (failure) {
        showMessageToUser(context, message: 'Error removing item from cart');
      },
      (_) async {
        final user = _ref.read(authStateNotifierProvider);
        if (user == null) return;
        final uid = user.user.$id;
        await _userRepository.removeCartFromUser(uid: uid, cartId: cartId);
        showMessageToUser(context, message: 'Item removed from cart');
        await _loadCartItems();
      },
    );
  }

  // clearCart method
  Future<void> clearCart(BuildContext context) async {
    final user = _ref.read(authStateNotifierProvider);
    if (user == null) return;
    final uid = user.user.$id;
    final currentCartItems = state.value ?? [];
    final cartIds = currentCartItems.map((cartItem) => cartItem.id).toList();

    // First clear all cart documents from the database
    final result = await _cartRepository.clearCartCollection(cartIds: cartIds);
    result.fold(
      (failure) =>
          showMessageToUser(context, message: 'Error clearing cart items'),
      (_) async {
        // Then clear the user's cart field in the profile
        final clearResult = await _userRepository.clearUserCart(uid: uid);
        clearResult.fold(
          (failure) => showMessageToUser(context,
              message: 'Error clearing cart in user profile'),
          (_) =>
              showMessageToUser(context, message: 'Cart cleared successfully!'),
        );
      },
    );
    await _loadCartItems();
  }
}
