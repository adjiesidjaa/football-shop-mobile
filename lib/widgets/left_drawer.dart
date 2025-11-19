import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:football_news/screens/menu.dart';
import 'package:football_news/screens/product_form.dart';
import 'package:football_news/screens/product_list.dart';
import 'package:football_news/screens/login.dart';


class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              children: [
                Text(
                  'Football Shop',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Padding(padding: EdgeInsets.all(10)),
                Text(
                  "Seluruh produk sepak bola terkini di sini!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ListTile(
        leading: const Icon(Icons.home_outlined),
        title: const Text('Halaman Utama'),
        // Bagian redirection ke MyHomePage
        onTap: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                builder: (context) => MyHomePage(),
                ));
        },
        ),
        ListTile(
        leading: const Icon(Icons.add_shopping_cart),
        title: const Text('Tambah Produk'),
        // Bagian redirection ke ProductFormPage
        onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProductFormPage()),
            );
        },
        ),
        ListTile(
          leading: const Icon(Icons.list),
          title: const Text('Lihat Produk'),
          // Bagian redirection ke ProductListPage
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProductListPage()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Logout'),
          // Bagian logout
          onTap: () async {
            // TODO: Replace the URL with your app's URL and don't forget to add a trailing slash (/)!
            // To connect Android emulator with Django on localhost, use URL http://10.0.2.2/
            // If you using chrome, use URL http://localhost:8000/
            final response = await request.logout(
                "http://localhost:8000/auth/logout/");
            String message = response["message"];
            if (context.mounted) {
              if (response['status']) {
                String uname = response["username"];
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("$message Sampai jumpa lagi, $uname."),
                ));
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                  ),
                );
              }
            }
          },
        ),
        ],
      ),
    );
  }
}