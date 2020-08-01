import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'home_viewmodel.dart';

class HomeView extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'admin@admin.com');
  final _passwordController = TextEditingController(text: 'password');

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Home View'),
            centerTitle: true,
          ),
          body: Container(
            width: double.infinity,
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: !model.loggedIn
                    ? _loginForm(model)
                    : _loggedInWidget(model),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column _loggedInWidget(HomeViewModel model) {
    return Column(
      children: [
        !model.isBusy
            ? RaisedButton(
                child: Text('Logout'),
                onPressed: () {
                  model.logout();
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
        Text(model.token ?? 'no token'),
      ],
    );
  }

  Column _loginForm(HomeViewModel model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
          ),
          validator: (value) => value.isEmpty ? 'This field is required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          obscureText: true,
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(),
          ),
          validator: (value) => value.isEmpty ? 'This field is required' : null,
        ),
        SizedBox(height: 10),
        !model.isBusy
            ? RaisedButton(
                child: Text('Login'),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    model.login(
                      email: _emailController.text,
                      password: _passwordController.text,
                    );
                  }
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ],
    );
  }
}
