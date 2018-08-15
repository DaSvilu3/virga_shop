import 'package:flutter/widgets.dart';
import 'place_order_bloc.dart';

class PlaceOrderProvider extends InheritedWidget{

  final PlaceOrderBloc providerBloc;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  PlaceOrderProvider({Key key, PlaceOrderBloc providerBloc,Widget child})
    :providerBloc = providerBloc ?? PlaceOrderBloc(),
    super(key: key, child: child);

  static PlaceOrderBloc of(BuildContext context) =>
    (context.inheritFromWidgetOfExactType(PlaceOrderProvider) as PlaceOrderProvider).providerBloc;

}