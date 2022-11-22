// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_screen_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// ignore_for_file: avoid_private_typedef_functions, non_constant_identifier_names, subtype_of_sealed_class, invalid_use_of_internal_member, unused_element, constant_identifier_names, unnecessary_raw_strings, library_private_types_in_public_api

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

String $AccountScreenControllerHash() =>
    r'57875550aaf3a0905bf2353f42ff24500446cc5b';

/// See also [AccountScreenController].
class AccountScreenControllerProvider
    extends AutoDisposeAsyncNotifierProviderImpl<AccountScreenController,
        void> {
  AccountScreenControllerProvider(
    this.name,
  ) : super(
          () => AccountScreenController()..name = name,
          from: accountScreenControllerProvider,
          name: r'accountScreenControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : $AccountScreenControllerHash,
        );

  final String name;

  @override
  bool operator ==(Object other) {
    return other is AccountScreenControllerProvider && other.name == name;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, name.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  FutureOr<void> runNotifierBuild(
    covariant _$AccountScreenController notifier,
  ) {
    return notifier.build(
      name,
    );
  }
}

typedef AccountScreenControllerRef = AutoDisposeAsyncNotifierProviderRef<void>;

/// See also [AccountScreenController].
final accountScreenControllerProvider = AccountScreenControllerFamily();

class AccountScreenControllerFamily extends Family<AsyncValue<void>> {
  AccountScreenControllerFamily();

  AccountScreenControllerProvider call(
    String name,
  ) {
    return AccountScreenControllerProvider(
      name,
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderImpl<AccountScreenController, void>
      getProviderOverride(
    covariant AccountScreenControllerProvider provider,
  ) {
    return call(
      provider.name,
    );
  }

  @override
  List<ProviderOrFamily>? get allTransitiveDependencies => null;

  @override
  List<ProviderOrFamily>? get dependencies => null;

  @override
  String? get name => r'accountScreenControllerProvider';
}

abstract class _$AccountScreenController
    extends BuildlessAutoDisposeAsyncNotifier<void> {
  late final String name;

  FutureOr<void> build(
    String name,
  );
}
