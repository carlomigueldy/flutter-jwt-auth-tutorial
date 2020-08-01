import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked/stacked.dart';
import 'package:dio/dio.dart';

import '../app/http_client.dart';
import '../datamodels/auth_response.dart';
import '../datamodels/user.dart';

@lazySingleton
class AuthenticationService with ReactiveServiceMixin {
  Future<SharedPreferences> _localStorage = SharedPreferences.getInstance();

  AuthenticationService() {
    listenToReactiveValues([_token]);
  }

  /// @return [String] token
  RxValue<String> _token = RxValue<String>(initial: "");
  String get token => _token.value;
  bool get loggedIn => _token.value.isNotEmpty ? true : false;

  /// @return [User] user
  RxValue<User> _user = RxValue<User>(initial: null);
  User get user => _user.value;

  static const authTokenKey = 'auth.token';

  /// Login with email and password.
  ///
  /// @param [EmailCredential] credentials A map containing email and password
  /// @return void
  Future loginWithEmail({
    @required String email,
    @required String password,
  }) async {
    try {
      print('[AuthService] Logging in...');

      Response response = await dio.post(
        '/api/auth/login',
        data: {
          "email": email,
          "password": password,
        },
      );

      AuthenticationResponse data =
          AuthenticationResponse.fromJson(response.data);
      _token.value = data.accessToken;
      setToken(data.accessToken);
      await fetchUser();

      print('[AuthService] Logged in');

      return response;
    } on DioError catch (e) {
      handleError(e);
    }
  }

  /// Fetch the current authenticated user.
  ///
  /// @return void
  Future fetchUser() async {
    try {
      Response response = await dio.get(
        '/api/auth/user',
        options: authorizationHeader,
      );

      User data = User.fromJson(response.data);
      _user.value = data;
    } on DioError catch (e) {
      handleError(e);
    }
  }

  /// Logs out the user.
  ///
  /// @return void
  Future logout() async {
    try {
      await dio.get(
        '/api/auth/logout',
        options: authorizationHeader,
      );

      deleteToken();
      _user.value = User(id: 0);
    } on DioError catch (e) {
      handleError(e);
    }
  }

  /// Use the authorization header with Bearer token.
  ///
  /// @return [Options]
  Options get authorizationHeader {
    return Options(
      headers: {
        "Authorization": "Bearer ${_token.value}",
        "accept": "application/json",
      },
    );
  }

  /// Sets the authentication token in the state and also locally
  /// using [SharedPreferences]
  ///
  /// @param string [token]
  /// @return void
  void setToken(String token) async {
    final SharedPreferences localStorage = await _localStorage;
    _token.value = token;
    localStorage.setString(authTokenKey, token);
  }

  /// Destroy the auth token from state and in [SharedPreferences]
  ///
  /// @return void
  void deleteToken() async {
    final SharedPreferences localStorage = await _localStorage;
    _token.value = "";
    localStorage.remove(authTokenKey);
  }

  /// A callback function receiving [DioError] as first parameter
  /// then handles the error based on status code given from response.
  ///
  /// @return void
  void handleError(DioError error) {
    switch (error.response.statusCode) {
      case 403:
        print("You do not have the right privileges to access this resource.");
        break;
      case 422:
        print("The data you have provided is invalid.");
        break;
      case 401:
        print("Incorrect credentials.");
        break;
      case 404:
        print("Request not found.");
        break;
      case 500:
        print(
            "There is something wrong with our servers, please report to the admin so it gets fixed.");
        break;
      default:
        print("Something went wrong.");
    }
  }
}
