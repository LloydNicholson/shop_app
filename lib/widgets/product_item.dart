import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../screens/product_detail_screen.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // false stops the widget from rebuilding when listening
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder: AssetImage('assets/images/product_placeholder.png'),
              image: NetworkImage(product.imageUrl),
            ),
          ),
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product,
            );
          },
        ),
        footer: GridTileBar(
          leading: Consumer<Product>(
            builder: (ctx, product, _) {
              return IconButton(
                icon: Icon(
                  product.isFavourite ? Icons.favorite : Icons.favorite_border,
                ),
                onPressed: () async {
                  await product.toggleFavouriteStatus(
                      authData.token, authData.userId);
                },
                color: Theme.of(context).accentColor,
              );
            },
          ),
          backgroundColor: Colors.black87,
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);

              // reaches out to the nearest Scaffold widget in the tree
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('Item added to cart'),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
//                  backgroundColor: Theme.of(context).primaryColor,
                  duration: Duration(seconds: 2),
                ),
              );
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
