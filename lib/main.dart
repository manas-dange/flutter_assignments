import 'package:flutter/material.dart';

import 'screens/product_catalog_screen.dart';

void main() {
  runApp(const DynamicProductCatalogApp());
}

class DynamicProductCatalogApp extends StatelessWidget {
  const DynamicProductCatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamic Product Catalog',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A8A),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
          scrolledUnderElevation: 2,
        ),
        cardTheme: const CardThemeData(elevation: 0),
      ),
      home: const ProductCatalogScreen(),
    );
  }
}
