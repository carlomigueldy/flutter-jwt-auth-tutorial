import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../datamodels/user.dart';
import '../../../app/locator.dart';
import '../../../services/authentication_service.dart'
    show AuthenticationService;

class HomeViewModel extends ReactiveViewModel {
  final _authService = locator<AuthenticationService>();

  User get user => _authService.user;
  String get token => _authService.token;
  bool get loggedIn => _authService.loggedIn;

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_authService];

  login({
    @required String email,
    @required String password,
  }) async {
    setBusy(true);

    print(email);
    print(password);

    await _authService.loginWithEmail(
      email: email,
      password: password,
    );

    setBusy(false);
  }

  void logout() async {
    setBusy(true);

    await _authService.logout();

    setBusy(false);
  }
}
