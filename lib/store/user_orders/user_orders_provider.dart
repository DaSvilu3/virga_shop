import 'package:flutter/widgets.dart';
import 'package:virga_shop/store/user_orders/user_orders_bloc.dart';

class UserOrdersProvider extends InheritedWidget {
  final UserOrdersBloc bloc;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  UserOrdersProvider({Key key, UserOrdersBloc bloc, Widget child})
      : bloc = bloc ?? new UserOrdersBloc(),
        super(key: key, child: child);

  static UserOrdersBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(UserOrdersProvider)
              as UserOrdersProvider)
          .bloc;
}
