import 'package:flutter/material.dart';
import 'package:football_news/models/product.dart';
import 'package:football_news/providers/product_provider.dart';
import 'package:football_news/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

class ProductDetailPage extends StatefulWidget {
  final int productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  Product? _product;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchProductDetail();
  }

  Future<void> _fetchProductDetail() async {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    // TODO: Replace the URL with your app's URL
    // To connect Android emulator with Django on localhost, use URL http://10.0.2.2/
    // If you using chrome, use URL http://localhost:8000/
    Product? product = await productProvider.fetchProductDetail(
      "http://localhost:8000",
      widget.productId,
    );

    setState(() {
      if (product != null) {
        _product = product;
        _error = null;
      } else {
        _error = 'Gagal memuat detail produk';
      }
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Produk',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isLoading = true;
                            _error = null;
                          });
                          _fetchProductDetail();
                        },
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                )
              : _product == null
                  ? const Center(child: Text('Produk tidak ditemukan'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_product!.fields.thumbnail.isNotEmpty)
                            Center(
                              child: Image.network(
                                _product!.fields.thumbnail,
                                width: double.infinity,
                                height: 300,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: double.infinity,
                                    height: 300,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.image, size: 100),
                                  );
                                },
                              ),
                            )
                          else
                            Container(
                              width: double.infinity,
                              height: 300,
                              color: Colors.grey[300],
                              child: const Icon(Icons.shopping_bag, size: 100),
                            ),
                          const SizedBox(height: 16),
                          Text(
                            _product!.fields.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Rp ${_product!.fields.price.toString()}',
                            style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Text(
                                'Kategori: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(_product!.fields.category),
                              const Spacer(),
                              if (_product!.fields.isFeatured == true)
                                const Chip(
                                  label: Text('Unggulan'),
                                  backgroundColor: Colors.amber,
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Text(
                                'Brand: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(_product!.fields.brand),
                              const Spacer(),
                              const Text(
                                'Stok: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('${_product!.fields.stock} unit'),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Deskripsi:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _product!.fields.description,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
    );
  }
}

