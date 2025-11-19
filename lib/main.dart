import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:football_news/screens/menu.dart';
import 'package:football_news/screens/login.dart';
import 'package:football_news/providers/product_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
      child: ChangeNotifierProvider(
        create: (context) {
          final productProvider = ProductProvider();
          final request = context.read<CookieRequest>();
          productProvider.setRequest(request);
          return productProvider;
        },
        child: MaterialApp(
          title: 'Football Shop',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
                .copyWith(secondary: Colors.blueAccent[400]),
          ),
          home: const LoginPage(),
        ),
      ),
    );
  }
}

