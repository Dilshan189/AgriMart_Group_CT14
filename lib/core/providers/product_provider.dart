import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../repositories/product_repository.dart';
import '../models/product_model.dart';
import 'auth_provider.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository();
});

final allProductsProvider = StreamProvider<List<ProductModel>>((ref) {
  return ref.watch(productRepositoryProvider).getProducts();
});

final farmerProductsProvider = StreamProvider.autoDispose<List<ProductModel>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user != null) {
    return ref.watch(productRepositoryProvider).getProductsByFarmer(user.uid);
  }
  return const Stream.empty();
});

class ProductController extends StateNotifier<AsyncValue<void>> {
  final ProductRepository _productRepository;

  ProductController(this._productRepository) : super(const AsyncValue.data(null));

  Future<void> addProduct(ProductModel product) async {
    state = const AsyncValue.loading();
    try {
      await _productRepository.addProduct(product);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateProduct(ProductModel product) async {
    state = const AsyncValue.loading();
    try {
      await _productRepository.updateProduct(product);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteProduct(String productId) async {
    state = const AsyncValue.loading();
    try {
      await _productRepository.deleteProduct(productId);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final productControllerProvider = StateNotifierProvider<ProductController, AsyncValue<void>>((ref) {
  return ProductController(ref.watch(productRepositoryProvider));
});
