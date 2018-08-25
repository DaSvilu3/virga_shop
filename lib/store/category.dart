import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:virga_shop/models/product_category.dart';
import 'package:virga_shop/network/api.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:virga_shop/store/product.dart';

class CategoryPage extends StatefulWidget {
  final String categoryID;

  CategoryPage(this.categoryID);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CategoryPageState();
  }
}

class _CategoryPageState extends State<CategoryPage> {
  String _categoryName = "Category";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(_categoryName),
      ),
      body: FutureBuilder<http.Response>(
        future: API.getCategory(widget.categoryID),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            try {
              ProductCategory category =
                  ProductCategory.fromJson(jsonDecode(snapshot.data.body));
              _categoryName = category.name;

              return new CategoryPageBody(
                products: category.products,
              );
            } catch (exception) {
              print(exception);
            }
          }

          //before the data has been recieved
          return Flex(direction: Axis.horizontal, children: [
            new Expanded(
              child: Center(child: new CircularProgressIndicator()),
            ),
          ]);
        },
      ),
    );
  }
}

class CategoryPageBody extends StatefulWidget {
  final List<dynamic> products;

  CategoryPageBody({this.products});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CategoryPageBodyState();
  }
}

class _CategoryPageBodyState extends State<CategoryPageBody> {
  Widget productTile(dynamic product) {
    return GestureDetector(
      child: Card(
        margin: new EdgeInsets.all(10.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.15,
          margin: new EdgeInsets.symmetric(vertical: 10.0),
          child: new ListTile(
            leading: Container(
              margin: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, .0),
              width: MediaQuery.of(context).size.height * 0.15,
              child: CachedNetworkImage(
                fit: BoxFit.contain,
                imageUrl: product["image_url"],
              ),
            ),
            title: new Text(
              product["name"],
              style: Theme.of(context).textTheme.title,
            ),
            subtitle: Text(product["description"]),
          ),
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => new ProductScreen(productID: product["id"])));
      },
    );
  }

  @override 
  Widget build(BuildContext context) {
    return ListView(
        shrinkWrap: true,
        children: widget.products.map((item) => productTile(item)).toList());
  }
}
