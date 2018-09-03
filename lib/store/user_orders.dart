import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:virga_shop/models/user_order.dart';
import 'package:virga_shop/store/user_orders/user_orders_bloc.dart';
import 'package:virga_shop/store/user_orders/user_orders_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:virga_shop/globals.dart' as Globals;

class UserOrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return UserOrdersProvider(
      bloc: new UserOrdersBloc(),
      child: new Scaffold(
        appBar: AppBar(
          title: new Text("Orders"),
          backgroundColor: Colors.amber,
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
  Widget userOrderItems(UserOrder userOrder) {
    if (userOrder.disc == 'normal') {
      return Column(
        children: <Widget>[
          new Column(
              children: userOrder.orderItems.map((item) {
            return Column(
              children: <Widget>[
                new ListTile(
                  leading: new CachedNetworkImage(
                    width: MediaQuery.of(context).size.width * 0.2,
                    imageUrl: Globals.Api.productImageThumb +
                        '/' +
                        item.product["imageUrl"],
                    errorWidget: Center(
                      child: new CircularProgressIndicator(),
                    ),
                  ),
                  isThreeLine: true,
                  title: new Text(item.product["name"]),
                  subtitle: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                          padding: new EdgeInsets.all(2.0),
                          child: new Text("Qty: ${item.quantity}")),
                      Padding(
                          padding: new EdgeInsets.all(2.0),
                          child: new Text("₹. ${item.amount}")),
                    ],
                  ),
                ),
                new Divider(),
              ],
            );
          }).toList()),
        ],
      );
    }

    return new Center(
      child: CachedNetworkImage(
        imageUrl: Globals.Api.pictureOrderAssetUrl + '/' + userOrder.imageUrl,
        errorWidget: CircularProgressIndicator(),
      ),
    );
  }

  Widget userOrderListItem(UserOrder order) {
    return new Card(
      margin: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Padding(
        padding: new EdgeInsets.all(10.0),
        child: new Column(children: [
          ////row to hold order id and status
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: new EdgeInsets.all(10.0),
                    child: new Text(
                      "Order: ${order.id}",
                      style: TextStyle(fontSize: 12.0, color: Colors.red),
                    ),
                  ),
                  Padding(
                    padding: new EdgeInsets.all(10.0),
                    child: new Text(
                      "${order.createdTime}",
                      style: TextStyle(fontSize: 12.0, color: Colors.pink),
                    ),
                  ),
                ],
              ),
              new Chip(
                label: new Text("Status: ${order.status}"),
                backgroundColor: Colors.lightGreen.shade200,
              )
            ],
          ),

          Divider(),

          ///show order items or picture
          userOrderItems(order),
        ]),
      ),
    );
  }

  Widget userOrdersList() {
    return new StreamBuilder<List<UserOrder>>(
      stream: UserOrdersProvider.of(context).userOrders,
      builder: (context, AsyncSnapshot<List<UserOrder>> snapshot) {
        if (snapshot.hasData) {
          return new ListView.builder(
            itemBuilder: (context, index) {
              if (index >= snapshot.data.length) return null;
              return userOrderListItem(snapshot.data[index]);
            },
          );
        } else {
          return Center(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  FontAwesomeIcons.clone,
                  size: 100.0,
                ),
                Text(
                  "Nothing to display",
                  style: Theme.of(context).textTheme.display1,
                )
              ],
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    UserOrdersBloc bloc = UserOrdersProvider.of(context);
    return new StreamBuilder(
      stream: bloc.status,
      builder: (context, AsyncSnapshot<int> snapshot) {
        ///if snapshot has data
        if (snapshot.hasData) {
          if (snapshot.data == UserOrdersBloc.done) {
            return userOrdersList();
          }

          ///there has been an error then show it
          ///with retry button
          if (snapshot.data == UserOrdersBloc.error) {
            return MaterialButton(
              onPressed: (){
                bloc.load();
              },
              child: new Container(
                child: new Center(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(FontAwesomeIcons.redo),
                      new Padding(
                          padding: EdgeInsets.all(10.0),
                          child: new Text("Retry"))
                    ],
                  ),
                ),
              ),
            );
          }

          ///if the status is set to loading
          ///then change the whole screen to
          ///a centered circularprogressindicator
          if (snapshot.data == UserOrdersBloc.loading) {
            return new Container(
              child: new Center(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    new Padding(
                        padding: EdgeInsets.all(10.0),
                        child: new Text("Loading"))
                  ],
                ),
              ),
            );
          }
        }

        ////Before anything happens
        return new Container(
          child: new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                new Padding(
                    padding: EdgeInsets.all(10.0), child: new Text("Loading"))
              ],
            ),
          ),
        );
      },
    );
  }
}
