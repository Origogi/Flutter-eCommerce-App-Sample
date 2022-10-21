import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FakeAuthRepository {
  Stream<AppUser?> authStateChange() => Stream.value(null);

  AppUser? get currentUser => null;

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    // TODO
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {}

  Future<void> signOut() async {}
}

final authRepositoryProvider = Provider<FakeAuthRepository>((ref) {
  return FakeAuthRepository();
});

final authStateChangesProvider = StreamProvider<AppUser?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChange();
});
