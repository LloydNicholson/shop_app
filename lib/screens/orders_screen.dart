import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    print('building orders');
    // final orderData = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.error != null) {
              return Center(
                child: Text('An error occured'),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderData, child) {
                  return ListView.builder(
                    itemCount: orderData.orders.length,
                    itemBuilder: (ctx, index) {
                      return OrderItem(orderData.orders[index]);
                    },
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
