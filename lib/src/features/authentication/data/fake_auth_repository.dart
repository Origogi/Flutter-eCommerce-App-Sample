import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:ecommerce_app/src/utils/delay.dart';
import 'package:ecommerce_app/src/utils/in_memory_store.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class AuthRepository {
  Stream<AppUser?> authStateChanges();

  AppUser? get currentUser;

  Future<void> signInWithEmailAndPassword(String email, String password);

  Future<void> createUserWithEmailAndPassword(String email, String password);

  Future<void> signOut();
}

class FirebaseAuthRepository implements AuthRepository {
  @override
  Stream<AppUser?> authStateChanges() {
    // TODO: implement authStateChanges
    throw UnimplementedError();
  }

  @override
  Future<void> createUserWithEmailAndPassword(String email, String password) {
    // TODO: implement createUserWithEmailAndPassword
    throw UnimplementedError();
  }

  @override
  // TODO: implement currentUser
  AppUser? get currentUser => throw UnimplementedError();

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) {
    // TODO: implement signInWithEmailAndPassword
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }
}

class FakeAuthRepository implements AuthRepository {
  final _authState = InMemoryStore<AppUser?>(null);
  final bool addDelay;

  FakeAuthRepository({this.addDelay = false});

  Stream<AppUser?> authStateChange() => _authState.stream;

  @override
  AppUser? get currentUser => _authState.value;

  @override
  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    await delay(addDelay);
    if (currentUser == null) {
      _createUser(email);
    }
  }

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await delay(addDelay);

    if (currentUser == null) {
      _createUser(email);
    }
  }

  @override
  Future<void> signOut() async {
    await delay(addDelay);
    // throw Exception('Connection failed');
    _authState.value = null;
  }

  @override
  Stream<AppUser?> authStateChanges() => _authState.stream;

  void dispose() {
    _authState.close();
  }

  void _createUser(String email) {
    _authState.value =
        AppUser(uid: email.split('').reversed.join(), email: email);
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final auth = FakeAuthRepository();

  ref.onDispose(() {
    auth.dispose();
  });

  return auth;
  // const isFake = String.fromEnvironment('useFakeRepos') == 'true';
  // return isFake ? FakeAuthRepository() : FirebaseAuthRepository();
});

final authStateChangesProvider = StreamProvider<AppUser?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
});
