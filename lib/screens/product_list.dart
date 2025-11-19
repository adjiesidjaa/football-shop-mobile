import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:football_news/models/product.dart';
import 'package:football_news/providers/product_provider.dart';
import 'package:football_news/screens/product_detail.dart';
import 'package:football_news/widgets/left_drawer.dart';

class ProductListPage extends StatefulWidget {
  final String initialFilter;
  
  const ProductListPage({super.key, this.initialFilter = "all"});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  late String _currentFilter; // "all" atau "mine"
  
  @override
  void initState() {
    super.initState();
    _currentFilter = widget.initialFilter;
    _loadProducts();
  }

  void _loadProducts() {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    productProvider.fetchProducts("http://localhost:8000", filter: _currentFilter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Produk',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          // Filter Toggle Button
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() {
                _currentFilter = value;
              });
              _loadProducts();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: "all",
                child: Row(
                  children: [
                    Icon(Icons.list, size: 20),
                    SizedBox(width: 8),
                    Text('Semua Produk'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: "mine",
                child: Row(
                  children: [
                    Icon(Icons.person, size: 20),
                    SizedBox(width: 8),
                    Text('Produk Saya'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      drawer: const LeftDrawer(),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          if (productProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (productProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${productProvider.error}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _loadProducts();
                    },
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          final products = productProvider.products;

          if (products.isEmpty) {
            return Column(
              children: [
                // Filter Info
                Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.grey[200],
                  child: Row(
                    children: [
                      Icon(
                        _currentFilter == "all" ? Icons.list : Icons.person,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _currentFilter == "all" ? "Menampilkan: Semua Produk" : "Menampilkan: Produk Saya",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const Expanded(
                  child: Center(
                    child: Text('Tidak ada produk tersedia'),
                  ),
                ),
              ],
            );
          }

          return Column(
            children: [
              // Filter Info
              Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.grey[200],
                child: Row(
                  children: [
                    Icon(
                      _currentFilter == "all" ? Icons.list : Icons.person,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _currentFilter == "all" ? "Menampilkan: Semua Produk" : "Menampilkan: Produk Saya",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Text(
                      '${products.length} produk',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              // Product List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    Product product = products[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        leading: product.fields.thumbnail.isNotEmpty
                            ? Image.network(
                                product.fields.thumbnail,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.image, size: 60);
                                },
                              )
                            : const Icon(Icons.shopping_bag, size: 60),
                        title: Text(
                          product.fields.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Rp ${product.fields.price.toString()}'),
                            Text('Brand: ${product.fields.brand}'),
                            Text('Kategori: ${product.fields.category}'),
                            Text('Stok: ${product.fields.stock} unit'),
                            if (product.fields.isFeatured == true)
                              const Chip(
                                label: Text('Unggulan'),
                                backgroundColor: Colors.amber,
                              ),
                          ],
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // Menggunakan pk sebagai productId
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailPage(productId: product.pk),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
