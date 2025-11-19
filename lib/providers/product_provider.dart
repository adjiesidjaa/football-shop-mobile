import 'package:flutter/foundation.dart';
import 'package:football_news/models/product.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'dart:convert';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = false;
  String? _error;
  CookieRequest? _request;

  List<Product> get products => _products;
  List<Product> get filteredProducts => _filteredProducts.isEmpty ? _products : _filteredProducts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void setRequest(CookieRequest request) {
    _request = request;
  }

  Future<void> fetchProducts(String baseUrl, {String filter = "all"}) async {
    if (_request == null) {
      _error = 'CookieRequest not initialized';
      _isLoading = false;
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Menggunakan CookieRequest untuk mengirim cookie session
      // Endpoint: /api/flutter/products/?filter=all atau filter=mine
      final response = await _request!.get(
        '$baseUrl/api/flutter/products/?filter=$filter',
      );

      if (response['status'] == 'success') {
        final List<dynamic> data = response['data'];
        // Convert dari format product_to_dict ke format Product model
        _products = data.map((json) {
          final item = json as Map<String, dynamic>;
          // Convert format flat ke format model/pk/fields
          // Handle user field yang bisa int atau string (username)
          int userId = 0;
          if (item['user'] != null) {
            if (item['user'] is int) {
              userId = item['user'] as int;
            } else if (item['user'] is String) {
              // Jika user adalah string (username), set ke 0 atau bisa diambil dari context
              userId = 0;
            }
          }
          
          return Product(
            model: "main.product",
            pk: (item['id'] is int) ? item['id'] as int : int.tryParse(item['id'].toString()) ?? 0,
            fields: Fields(
              user: userId,
              name: item['name']?.toString() ?? '',
              price: (item['price'] is int) ? item['price'] as int : int.tryParse(item['price'].toString()) ?? 0,
              description: item['description']?.toString() ?? '',
              thumbnail: item['thumbnail']?.toString() ?? '',
              category: item['category']?.toString() ?? '',
              isFeatured: (item['is_featured'] is bool) ? item['is_featured'] as bool : (item['is_featured'] == true || item['is_featured'] == 'true'),
              stock: (item['stock'] is int) ? item['stock'] as int : int.tryParse(item['stock'].toString()) ?? 0,
              brand: item['brand']?.toString() ?? '',
            ),
          );
        }).toList();
        _filteredProducts = [];
        _error = null;
      } else {
        _error = response['message'] ?? 'Failed to load products';
      }
    } catch (e) {
      _error = 'Error fetching products: $e';
      print('Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Product?> fetchProductDetail(String baseUrl, int id) async {
    if (_request == null) {
      return null;
    }

    try {
      final response = await _request!.get(
        '$baseUrl/json/$id/',
      );

      // Handle response dari product_json_by_id (array format)
      if (response is List && response.isNotEmpty) {
        return Product.fromJson(response[0] as Map<String, dynamic>);
      } else if (response is Map) {
        // Jika response dari flutter_product_detail (object format)
        if (response.containsKey('status') && response['status'] == 'success') {
          final decoded = response['data'] as Map<String, dynamic>;
          return Product.fromJson(decoded);
        } else {
          // Jika langsung object Product
          return Product.fromJson(response as Map<String, dynamic>);
        }
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching product detail: $e');
      return null;
    }
  }

  // Method untuk filter di frontend (opsional, untuk filtering tambahan)
  void applyFrontendFilters({
    String? category,
    String? brand,
    String? searchQuery,
    bool? isFeatured,
  }) {
    _filteredProducts = _products.where((product) {
      if (category != null && product.fields.category != category) {
        return false;
      }
      if (brand != null && product.fields.brand != brand) {
        return false;
      }
      if (searchQuery != null && searchQuery.isNotEmpty) {
        if (!product.fields.name.toLowerCase().contains(searchQuery.toLowerCase())) {
          return false;
        }
      }
      if (isFeatured != null && product.fields.isFeatured != isFeatured) {
        return false;
      }
      return true;
    }).toList();
    notifyListeners();
  }

  void clearFrontendFilters() {
    _filteredProducts = [];
    notifyListeners();
  }

  // Get unique categories
  List<String> get categories {
    return _products.map((p) => p.fields.category).toSet().toList();
  }

  // Get unique brands
  List<String> get brands {
    return _products.map((p) => p.fields.brand).where((b) => b.isNotEmpty).toSet().toList();
  }
}
