import 'package:flutter/widgets.dart';
import 'search_bloc.dart';

class SearchProvider extends InheritedWidget{

  final SearchBloc searchBloc;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
      return true;
  }

  SearchProvider({Key key, SearchBloc searchBloc, Widget child})
    : searchBloc = searchBloc ?? SearchBloc(),
    super(key: key,child: child);

  static SearchBloc of(BuildContext context) =>
    (context.inheritFromWidgetOfExactType(SearchProvider) as SearchProvider).searchBloc;

}