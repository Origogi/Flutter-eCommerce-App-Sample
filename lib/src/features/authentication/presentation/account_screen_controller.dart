import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AccountScreenController extends StateNotifier<AsyncValue<void>> {
  Future<bool> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => authRepository.signOut());
    return state.hasError == false;
  }

  AccountScreenController({required this.authRepository})
      : super(const AsyncData(null));

  final AuthRepository authRepository;
}

final accountScreenControllerProvider = StateNotifierProvider.autoDispose<
    AccountScreenController, AsyncValue<void>>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return AccountScreenController(authRepository: authRepo);
});
