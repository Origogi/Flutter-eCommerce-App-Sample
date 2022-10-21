import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EmailPasswordSignInController
    extends StateNotifier<EmailPasswordSignInState> {
  EmailPasswordSignInController({required EmailPasswordSignInFormType formType,
    required this.authRepository})
      : super(EmailPasswordSignInState(formType: formType));

  final AuthRepository authRepository;

  Future<bool> submit(String email, String password) async {
    state = state.copyWith(value: const AsyncValue.loading());
    final value = await AsyncValue.guard(() => _authenticate(email, password));
    state = state.copyWith(value: value);

    return value.hasError == false;
  }

  Future<void> _authenticate(String email, String password) async {
    switch (state.formType) {
      case EmailPasswordSignInFormType.signIn:
        return authRepository.signInWithEmailAndPassword(email, password);
      case EmailPasswordSignInFormType.register:
        return authRepository.createUserWithEmailAndPassword(email, password);
    }
  }

  void updateFormType(EmailPasswordSignInFormType formType) {
    state = state.copyWith(formType: formType);
  }
}

final emailPasswordSignInControllerProvider = StateNotifierProvider.family<
    EmailPasswordSignInController,
    EmailPasswordSignInState,
    EmailPasswordSignInFormType>((ref, formType) {
  final authRepo = ref.watch(authRepositoryProvider);
  return EmailPasswordSignInController(
      formType: formType, authRepository: authRepo);
});
