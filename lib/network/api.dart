import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:virga_shop/models/search_result.dart';
import 'package:virga_shop/globals.dart' as Globals;
import 'dart:convert';

class API {
  static Future<List<SearchResult>> search(String query) async {
    List<SearchResult> searchResults = new List();

    http.Response response =
        await http.get(Globals.Api.searchUrl + "/" + query);

    try {
      Map<String, dynamic> items = jsonDecode(response.body);

      items.forEach((s, f) {
        searchResults.add(SearchResult.fromJson(f));
      });
    } catch (exception) {
      print(exception);
    }

    return searchResults;
  }
}
