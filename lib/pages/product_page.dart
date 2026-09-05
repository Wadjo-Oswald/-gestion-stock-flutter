// lib/pages/product_page.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wandastock/generated/app_localizations.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();

  String _searchQuery = '';
  List<Map<String, dynamic>> products = [];
  final List<Map<String, dynamic>> _currentSale = [];

  static const int stockThreshold = 10;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('products')
        .get();

    setState(() {
      products = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'docId': doc.id,
          'nom': data['nom'],
          'quantite': data['quantite'],
          'prix': data['prix'],
        };
      }).toList();
    });
  }

  List<Map<String, dynamic>> get _filteredProducts {
    if (_searchQuery.isEmpty) return products;
    return products
        .where((p) => p['nom'].toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  List<Map<String, dynamic>> get _lowStockProducts {
    return products.where((p) => p['quantite'] <= stockThreshold).toList();
  }

  Future<void> _addProduct() async {
    final t = AppLocalizations.of(context)!;
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text.trim();
      bool exists = products.any((p) => p['nom'].toLowerCase() == name.toLowerCase());

      if (exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.productExists)),
        );
        return;
      }

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      int qty = int.parse(_quantityController.text);
      int price = int.parse(_priceController.text);

      final docRef = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('products')
          .add({
        'nom': name,
        'quantite': qty,
        'prix': price,
      });

      setState(() {
        products.add({
          'docId': docRef.id,
          'nom': name,
          'quantite': qty,
          'prix': price,
        });
        _nameController.clear();
        _quantityController.clear();
        _priceController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.productAdded)),
      );
    }
  }

  void _editProduct(int index) {
    final t = AppLocalizations.of(context)!;
    final produit = products[index];

    _nameController.text = produit['nom'];
    _quantityController.text = produit['quantite'].toString();
    _priceController.text = produit['prix'].toString();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('${t.edit} - ${produit['nom']}'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: t.name),
                  validator: (value) => value!.isEmpty ? t.requiredField : null,
                ),
                TextFormField(
                  controller: _quantityController,
                  decoration: InputDecoration(labelText: t.quantity),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? t.requiredField : null,
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(labelText: t.price),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? t.requiredField : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text(t.cancel),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: Text(t.save),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(t.userNotLoggedIn)),
                    );
                    return;
                  }

                  int oldQty = produit['quantite'];
                  int newQty = int.parse(_quantityController.text);

                  if (newQty != oldQty) {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .collection('restocks')
                        .add({
                      'nom': produit['nom'],
                      'ancienneQuantite': oldQty,
                      'nouvelleQuantite': newQty,
                      'date': Timestamp.now(),
                    });
                  }

                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .collection('products')
                      .doc(produit['docId'])
                      .update({
                    'nom': _nameController.text.trim(),
                    'quantite': newQty,
                    'prix': int.parse(_priceController.text),
                  });

                  setState(() {
                    produit['nom'] = _nameController.text.trim();
                    produit['quantite'] = newQty;
                    produit['prix'] = int.parse(_priceController.text);
                  });

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(t.productModified)),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteProduct(int index) {
    final t = AppLocalizations.of(context)!;
    final produit = products[index];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.confirmDeletion),
        content: Text('${t.confirmDeleteQuestion} ${produit['nom']} ?'),
        actions: [
          TextButton(
            child: Text(t.cancel),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(t.delete),
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              if (user == null) return;

              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .collection('products')
                  .doc(produit['docId'])
                  .delete();

              setState(() {
                products.removeAt(index);
              });

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(t.productDeleted)),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showAddToSaleDialog(Map<String, dynamic> produit) {
    final t = AppLocalizations.of(context)!;
    int qty = 1;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${t.addToSale} - ${produit['nom']}'),
        content: TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: t.quantity),
          onChanged: (val) {
            qty = int.tryParse(val) ?? 1;
          },
        ),
        actions: [
          TextButton(
            child: Text(t.cancel),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text(t.add),
            onPressed: () {
              Navigator.pop(context);
              _addToCurrentSale(produit, qty);
            },
          ),
        ],
      ),
    );
  }

  void _addToCurrentSale(Map<String, dynamic> produit, int qty) {
    final t = AppLocalizations.of(context)!;
    if (qty > produit['quantite']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.insufficientStock)),
      );
      return;
    }

    setState(() {
      final existingIndex =
          _currentSale.indexWhere((p) => p['nom'] == produit['nom']);
      if (existingIndex != -1) {
        _currentSale[existingIndex]['quantite'] += qty;
      } else {
        _currentSale.add({
          'nom': produit['nom'],
          'quantite': qty,
          'prix': produit['prix'],
        });
      }
    });
  }

  void _showCurrentSalePopup() {
    final t = AppLocalizations.of(context)!;
    final total = _currentSale.fold<num>(
      0,
      (sum, item) => sum + (item['quantite'] * item['prix']),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.currentSale),
        content: SizedBox(
          width: double.maxFinite,
          height: 250,
          child: ListView.builder(
            itemCount: _currentSale.length,
            itemBuilder: (context, index) {
              final item = _currentSale[index];
              return ListTile(
                title: Text(item['nom']),
                subtitle:
                    Text('${t.qty}: ${item['quantite']} - ${t.price}: ${item['prix']} FCFA'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      _currentSale.removeAt(index);
                    });
                    Navigator.pop(context);
                    _showCurrentSalePopup();
                  },
                ),
              );
            },
          ),
        ),
        actions: [
          Text('${t.total}: $total FCFA',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          TextButton(
            child: Text(t.cancel),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text(t.validateSale),
            onPressed: () {
              Navigator.pop(context);
              _validateCurrentSale();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _validateCurrentSale() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    num total = 0;

    for (var item in _currentSale) {
      final index = products.indexWhere((p) => p['nom'] == item['nom']);
      if (index != -1) {
        int oldQty = products[index]['quantite'];
        int qtySold = item['quantite'];
        int newQty = oldQty - qtySold;
        if (newQty < 0) newQty = 0;

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('products')
            .doc(products[index]['docId'])
            .update({'quantite': newQty});

        setState(() {
          products[index]['quantite'] = newQty;
        });

        total += qtySold * item['prix'];
      }
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('sales')
        .add({
      'items': _currentSale,
      'total': total,
      'date': Timestamp.now(),
    });

    setState(() {
      _currentSale.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.saleValidated)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    int lowStockCount = _lowStockProducts.length;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          if (lowStockCount > 0)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              color: Colors.red.shade100,
              child: Text(
                '⚠️ $lowStockCount ${t.productsLowStock}',
                style: TextStyle(color: Colors.red.shade900),
              ),
            ),
          const SizedBox(height: 8),
          Text(t.addProduct, style: const TextStyle(fontWeight: FontWeight.bold)),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: t.name),
                  validator: (value) => value!.isEmpty ? t.requiredField : null,
                ),
                TextFormField(
                  controller: _quantityController,
                  decoration: InputDecoration(labelText: t.quantity),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? t.requiredField : null,
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(labelText: t.price),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? t.requiredField : null,
                ),
                ElevatedButton(
                  onPressed: _addProduct,
                  child: Text(t.add),
                ),
              ],
            ),
          ),
          const Divider(),
          TextField(
            decoration: InputDecoration(
              labelText: t.search,
              prefixIcon: const Icon(Icons.search),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                final p = _filteredProducts[index];
                final realIndex = products.indexWhere((prod) => prod['docId'] == p['docId']);
                return ListTile(
                  title: Text(p['nom']),
                  subtitle:
                      Text('${t.quantity}: ${p['quantite']} - ${t.price}: ${p['prix']} FCFA'),
                  trailing: Wrap(
                    spacing: 6,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.add_shopping_cart),
                        onPressed: () => _showAddToSaleDialog(p),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editProduct(realIndex),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteProduct(realIndex),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          if (_currentSale.isNotEmpty)
            ElevatedButton(
              onPressed: _showCurrentSalePopup,
              child: Text('${t.currentSale} (${_currentSale.length} ${t.items})'),
            ),
        ],
      ),
    );
  }
}
