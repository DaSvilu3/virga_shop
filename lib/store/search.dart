import "package:flutter/material.dart";
import 'package:virga_shop/models/search_result.dart';
import 'package:virga_shop/network/api.dart';
import 'package:virga_shop/store/search/search_bloc.dart';
import 'package:virga_shop/store/search/search_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

///
/// Search Results list body
///
class SearchResultsList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SearchResultsListState();
  }
}

class _SearchResultsListState extends State<SearchResultsList> {
  @override
  Widget build(BuildContext context) {
    SearchBloc searchBloc = SearchProvider.of(context);
    return Container(
      child: new StreamBuilder<List<SearchResult>>(
        stream: searchBloc.results,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
           
           if(snapshot.data.length > 0){
              return new ListView.builder(
              itemBuilder: (context,index){
                if(index > snapshot.data.length - 1){
                  return null;
                }
                return new ListTile(
                  leading: new SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,                    
                    height: MediaQuery.of(context).size.width * 0.3,                  
                    child: new CachedNetworkImage(
                      placeholder: new CircularProgressIndicator(),
                      imageUrl: snapshot.data[index].imageUrl,
                      fit: BoxFit.contain
                    ),
                  ),
                  title: new Text(snapshot.data[index].name),
                  subtitle: new Text(snapshot.data[index].description),
                );
              },
            );
           }
            
          }
          return new Center(
            child: new CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

///
/// Search body
///

class SearchBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SearchBodyState();
  }
}

class _SearchBodyState extends State<SearchBody> {
  SearchBloc searchBloc;
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();

  Widget searchBar() {
    return new PreferredSize(
      preferredSize: new Size.fromHeight(56.0),
      child: new Container(
        child: new TextField(
          onChanged: (query) {
            searchBloc.query.add(query);
          },
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: InputBorder.none,
              suffixIcon: new IconButton(
                icon: new Icon(FontAwesomeIcons.search),
                onPressed: () {},
              )),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    searchBloc = SearchProvider.of(context);

    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(title: new Text("Search"), bottom: searchBar()),
      body: SearchResultsList(),
    );
  }
}

///Complete page showing the search bar
///and the search results

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return new SearchProvider(child: SearchBody());
  }
}
