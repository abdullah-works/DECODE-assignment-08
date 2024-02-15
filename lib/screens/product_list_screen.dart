import 'dart:convert';

import 'package:api_fakestore_app/model/product.dart';
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
      var jsonResponse = jsonDecode(response.body);
      int count = 1;

      for (var jsonItem in jsonResponse) {
        // they were creating some issue
        // they = jsonItem having IDs from below list
        if ([5, 6, 7, 9, 10, 11, 12, 13].contains(count)) {
          continue;
        }
        count++;
        Product product = Product.fromJson(jsonItem);

        productList.add(product);
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
          'Products List',
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
              // will display all the products here
              return const Center(
                child: Text(
                  'Now, we are cooking.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
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
