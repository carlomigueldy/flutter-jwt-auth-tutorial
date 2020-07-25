import 'package:flutter/material.dart';
import 'package:jwt_auth_tut/ui/views/home/home_viewmodel.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Home View'),
          ),
          body: Center(
            child: Text('Home View'),
          ),
        ),
      ),
    );
  }
}
