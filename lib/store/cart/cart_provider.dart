import 'package:flutter/widgets.dart';
import 'cart_bloc.dart';



class CartProvider extends InheritedWidget{
  
  final CartBloc cartBloc;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  CartProvider({Key key, CartBloc cartBloc, Widget child})
    : cartBloc = cartBloc ?? CartBloc(),
      super(key: key, child: child);

  static CartBloc of(BuildContext context) => 
      (context.inheritFromWidgetOfExactType(CartProvider) as CartProvider).cartBloc;

  

}