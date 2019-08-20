import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './product_item.dart';
import '../providers/products.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavourites;

  ProductsGrid(this.showFavourites);

  @override
  Widget build(BuildContext context) {
    // Get data from Provider
    final productsData = Provider.of<Products>(context);
    final products = showFavourites ? productsData.favouriteItems : productsData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      itemBuilder: (ctx, index) {
        return ChangeNotifierProvider.value(
          value: products[index],
//          builder: (ctx) => products[index],
          child: ProductItem(
//            products[index],
          ),
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
