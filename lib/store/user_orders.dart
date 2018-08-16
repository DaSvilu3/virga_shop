import 'package:flutter/material.dart';
import 'package:virga_shop/store/user_orders/user_orders_bloc.dart';
import 'package:virga_shop/store/user_orders/user_orders_provider.dart';

class UserOrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return UserOrdersProvider(
      bloc: new UserOrdersBloc(),
      child: new Scaffold(
        appBar: AppBar(
          title: new Text("Orders"),
        ),
        body: UserOrdersBody(),
      ),
    );
  }
}

class UserOrdersBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserOrdersBodyState();
  }
}

class _UserOrdersBodyState extends State<UserOrdersBody> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Column();
  }
}
