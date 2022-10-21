import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AccountScreenController extends StateNotifier<AsyncValue> {
  Future<bool> signOut() async {
    // set state to loading
    // sign out
    // if success, set state to data
    // if error, set state to error
    // try {
    //   state = const AsyncValue.loading();
    //   await authRepository.signOut();
    //   state = const AsyncValue.data(null);
    //
    //   return true;
    // } catch (e, stt) {
    //   state = AsyncValue.error(e, stt);
    //   return false;
    // }
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => authRepository.signOut());
    return state.hasError == false;
  }

  AccountScreenController({required this.authRepository})
      : super(const AsyncValue.data(null));

  final AuthRepository authRepository;
}

final accountScreenControllerProvider = StateNotifierProvider.autoDispose<
    AccountScreenController, AsyncValue>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return AccountScreenController(authRepository: authRepo);
});
