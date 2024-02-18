import 'dart:convert';

import 'package:api_fakestore_app/model/product.dart';
import 'package:api_fakestore_app/widgets/product_container.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  Future<List<Product>> getAllProducts() async {
    final List<Product> productList = [];

    String url = 'https://fakestoreapi.com/products/';

    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // response.body is treated as String
      // Then Decoded, it is treated as JSON
      var jsonResponse = jsonDecode(response.body);

      for (var jsonItem in jsonResponse) {
        Product product;
        try {
          product = Product.fromJson(jsonItem);
          productList.add(product);
        } catch (error) {
          print(
              'Error catched (during JSON Object to Product Object conversion):');
          print('ERROR: $error');
        }
      }
    } //else {
    //   throw Exception('Something went wrong!');
    // }

    return productList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.orange,
        title: const Text(
          'Products List from API',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder(
          future: getAllProducts(),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    'No Data Found!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                );
              }

              List<Product> productList = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: GridView.builder(
                    itemCount: productList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: 300,
                      crossAxisCount: 2,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                    ),
                    itemBuilder: ((context, index) {
                      Product? productData = productList[index];

                      return ProductContainer(product: productData);
                    })),
              );
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'Something went wrong!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              );
            }
            return const SpinKitFadingCircle(color: Colors.white70);
          })),
    );
  }
}
