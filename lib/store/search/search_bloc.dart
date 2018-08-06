import 'dart:async';
import 'package:rxdart/subjects.dart';
import 'package:virga_shop/models/search_result.dart';
import 'package:virga_shop/network/api.dart';

class SearchBloc {
  Stream<List<SearchResult>> _results = Stream.empty();
  BehaviorSubject<String> _query = new BehaviorSubject();

  SearchBloc() {
    _results = _query
        .distinct()
        .debounce(Duration(milliseconds: 200))
        .asyncMap(API.search)
        .asBroadcastStream();
  }

  Sink<String> get query => _query;

  Stream<List<SearchResult>> get results => _results;

  void dispose() {
    _query.close();
  }
}
