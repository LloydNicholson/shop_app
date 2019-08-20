import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';

import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import './cart_screen.dart';
import '../widgets/app_drawer.dart';

enum FilterOptions {
  Favourites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showFavouritesOnly = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Provider.of<Products>(context).fetchAndSetProducts(); // won't work
    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Products>(context).fetchAndSetProducts();
    // });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favourites) {
                  _showFavouritesOnly = true;
                } else {
                  _showFavouritesOnly = false;
                }
              });
            },
            itemBuilder: (_) {
              return [
                PopupMenuItem(
                  child: Text('Only favourites'),
                  value: FilterOptions.Favourites,
                ),
                PopupMenuItem(
                  child: Text('Show all'),
                  value: FilterOptions.All,
                ),
              ];
            },
            child: Icon(
              Icons.more_vert,
            ),
          ),
          Consumer<Cart>(
            builder: (_, cartData, ch) {
              return Badge(
                child: ch,
                value: cartData.itemCount.toString(),
              );
            },
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showFavouritesOnly),
      drawer: AppDrawer(),
    );
  }
}
