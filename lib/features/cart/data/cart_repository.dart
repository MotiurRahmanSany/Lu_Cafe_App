import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:lu_cafe/core/common/constants/appwrite_constants.dart';
import 'package:lu_cafe/features/cart/domain/cart.dart';

import '../../../core/failure.dart';
import '../../../core/providers.dart';
import '../../../core/type_defs.dart';

final cartRepositoryProvider = Provider((ref) => CartRepository(
      database: ref.read(appwriteDatabasesProvider),
    ));

class CartRepository {
  final Databases _database;
  CartRepository({required Databases database}) : _database = database;

  // Add to cart
  FutureEither<String> addToCart({
    required Cart cart,
  }) async {
    try {
      final response = await _database.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.cartCollectionId,
        documentId: ID.unique(),
        data: cart.toMap(),
      );
      return right(response.$id);
    } on AppwriteException catch (err, stackTrace) {
      return left(
        Failure(
          message: err.message ?? 'Error creating cart item',
          stackTrace: stackTrace,
        ),
      );
    } catch (err, stackTrace) {
      return left(
        Failure(message: err.toString(), stackTrace: stackTrace),
      );
    }
  }

  // update cart item quantity
  FutureEitherVoid updateCartItemQuantity({
    required String cartId,
    required int newQuantity,
  }) async {
    try {
      await _database.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.cartCollectionId,
        documentId: cartId,
        data: {'quantity': newQuantity},
      );

      return right(null);
    } on AppwriteException catch (err, stackTrace) {
      return left(
        Failure(
          message: err.message ?? 'Error updating cart item quantity',
          stackTrace: stackTrace,
        ),
      );
    } catch (err, stackTrace) {
      return left(
        Failure(message: err.toString(), stackTrace: stackTrace),
      );
    }
  }

  // Remove a single cart item
  FutureEitherVoid removeCartItem({required String cartId}) async {
    try {
      await _database.deleteDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.cartCollectionId,
        documentId: cartId,
      );
      return right(null);
    } on AppwriteException catch (err, stackTrace) {
      return left(
        Failure(
            message: err.message ?? 'Error removing cart item',
            stackTrace: stackTrace),
      );
    } catch (err, stackTrace) {
      return left(
        Failure(message: err.toString(), stackTrace: stackTrace),
      );
    }
  }

  // fetch single cart item by id

//   Future<Cart> fetchCartItemById({required String cartId }) async{
//     try {
//       final response = await _database.getDocument(
//         databaseId: AppwriteConstants.databaseId,
//         collectionId: AppwriteConstants.cartCollectionId,
//         documentId: cartId,
//       );
//       return Cart.fromMap(response.data);
//     } on AppwriteException catch (err, st) {
//       throw Failure(message: err.message ?? 'Error fetching cart item', stackTrace: st);
//     }

//  }


  // Fetch all cart items by their IDs
  Future<List<Cart>> getCartItemsByIds(List<String> cartIds) async {
    List<Cart> carts = [];
    for (String id in cartIds) {
      try {
        final response = await _database.getDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.cartCollectionId,
          documentId: id,
        );
        carts.add(Cart.fromMap(response.data));
      } on AppwriteException catch (err) {
        if (err.code == 404)
          continue;
        else
          rethrow;
      }
    }
    return carts;
  }



  // Clear all cart items from the collection at once
  FutureEitherVoid clearCartCollection({required List<String> cartIds}) async {
    try {
      for (String id in cartIds) {
        await _database.deleteDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.cartCollectionId,
          documentId: id,
        );
      }
      return right(null);
    } on AppwriteException catch (err, stackTrace) {
      return left(Failure(
        message: err.message ?? 'Error clearing cart items',
        stackTrace: stackTrace,
      ));
    } catch (err, stackTrace) {
      return left(Failure(
        message: err.toString(),
        stackTrace: stackTrace,
      ));
    }
  }
}
