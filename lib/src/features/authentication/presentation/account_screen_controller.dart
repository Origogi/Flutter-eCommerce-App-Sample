import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AccountScreenController extends StateNotifier<AsyncValue<void>> {
  Future<void> signOut() async {
    // set state to loading
    // sign out
    // if success, set state to data
    // if error, set state to error
    try {
      state = const AsyncValue<void>.loading();
      await authRepository.signOut();
      state = const AsyncValue<void>.data(null);
    } catch (e, stt) {
      state = AsyncValue<void>.error(e, stt);
    }
  }

  AccountScreenController({required this.authRepository})
      : super(const AsyncValue<void>.data(null));

  final AuthRepository authRepository;
}

final accountScreenControllerProvider = StateNotifierProvider((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return AccountScreenController(authRepository: authRepo);
});