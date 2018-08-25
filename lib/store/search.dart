import "package:flutter/material.dart";
import 'package:virga_shop/models/search_result.dart';
import 'package:virga_shop/store/product.dart';
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
            if (snapshot.data.length > 0) {
              return new ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  if (index > snapshot.data.length - 1) {
                    return null;
                  }
                  return GestureDetector(
                    child: Card(
                      margin: new EdgeInsets.all(10.0),
                      child: Container(
                        margin: new EdgeInsets.symmetric(vertical: 10.0),
                        height: MediaQuery.of(context).size.height * 0.15,
                        child: new ListTile(
                          leading: Container(
                            margin: EdgeInsets.fromLTRB(.0, 20.0, .0 , .0),
                            width: MediaQuery.of(context).size.height * 0.15,
                            child: CachedNetworkImage(
                              imageUrl: snapshot.data[index].imageUrl,
                            ),
                          ),
                          title: new Text(snapshot.data[index].name,
                              style: Theme.of(context).textTheme.title),
                          subtitle: new Text(snapshot.data[index].description),
                        ),
                      ),
                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute( builder: (context) => new ProductScreen(productID: snapshot.data[index].id,)));
                    },
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
  final String query;

  SearchBody({this.query});

  @override
  State<StatefulWidget> createState() {
    return _SearchBodyState();
  }
}

class _SearchBodyState extends State<SearchBody> {
  SearchBloc searchBloc;
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();

  TextEditingController _searchTEC = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchTEC.text = widget.query.toString();
    _searchTEC.addListener(this._searchQueryChanged);
  }

  void _searchQueryChanged() {
    searchBloc.query.add(_searchTEC?.text ?? '');
  }

  Widget searchBar() {
    return new PreferredSize(
      preferredSize: new Size.fromHeight(48.0),
      child: new Container(
        child: new TextFormField(
          controller: _searchTEC,
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: new EdgeInsets.all(15.0),
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
    if (widget.query.isNotEmpty) searchBloc.query.add(widget.query);
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
  final String query;

  SearchPage({this.query});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return new SearchProvider(
        child: SearchBody(
      query: widget.query,
    ));
  }
}
