import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../repositories/user_repository.dart';
import '../models/user_model.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

final farmersProvider = StreamProvider<List<UserModel>>((ref) {
  return ref.watch(userRepositoryProvider).getUsersByRole('farmer');
});

final buyersProvider = StreamProvider<List<UserModel>>((ref) {
  return ref.watch(userRepositoryProvider).getUsersByRole('buyer');
});

class UserController extends StateNotifier<AsyncValue<void>> {
  final UserRepository _userRepository;

  UserController(this._userRepository) : super(const AsyncValue.data(null));

  Future<void> updateUserStatus(String userId, String status) async {
    state = const AsyncValue.loading();
    try {
      await _userRepository.updateUserStatus(userId, status);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      await _userRepository.updateUserProfile(userId, data);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> toggleSavedProduct(UserModel user, String productId) async {
    state = const AsyncValue.loading();
    try {
      final List<String> currentSaved = List<String>.from(user.savedProducts);
      if (currentSaved.contains(productId)) {
        currentSaved.remove(productId);
      } else {
        currentSaved.add(productId);
      }
      await _userRepository.updateUserProfile(user.id, {'savedProducts': currentSaved});
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final userControllerProvider =
    StateNotifierProvider<UserController, AsyncValue<void>>((ref) {
      return UserController(ref.watch(userRepositoryProvider));
    });
