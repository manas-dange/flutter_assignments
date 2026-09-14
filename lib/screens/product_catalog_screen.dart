import 'package:flutter/material.dart';

import '../data/sample_products.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import '../widgets/product_detail_sheet.dart';

enum SortOption {
  featured('Featured'),
  priceAsc('Price: Low to High'),
  priceDesc('Price: High to Low'),
  highestRated('Highest Rated');

  final String label;
  const SortOption(this.label);
}

class ProductCatalogScreen extends StatefulWidget {
  const ProductCatalogScreen({super.key});

  @override
  State<ProductCatalogScreen> createState() => _ProductCatalogScreenState();
}

class _ProductCatalogScreenState extends State<ProductCatalogScreen> {
  late List<Product> _allProducts;
  late final TextEditingController _searchController;

  String _searchQuery = '';
  String _selectedCategory = 'All';
  bool _inStockOnly = false;
  bool _favoritesOnly = false;
  SortOption _currentSort = SortOption.featured;

  @override
  void initState() {
    super.initState();
    _allProducts = List.from(sampleProducts);
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Get distinct categories from dataset
  List<String> get _categories {
    final set = <String>{'All'};
    for (final p in _allProducts) {
      set.add(p.category);
    }
    return set.toList();
  }

  // Reactive filtered & sorted products list
  List<Product> get _filteredProducts {
    final query = _searchQuery.trim().toLowerCase();

    final list = _allProducts.where((product) {
      // Search filter
      final matchesSearch =
          query.isEmpty ||
          product.name.toLowerCase().contains(query) ||
          product.description.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query);

      // Category filter
      final matchesCategory =
          _selectedCategory == 'All' || product.category == _selectedCategory;

      // In-stock filter
      final matchesStock = !_inStockOnly || product.inStock;

      // Favorites filter
      final matchesFavorite = !_favoritesOnly || product.isFavorite;

      return matchesSearch &&
          matchesCategory &&
          matchesStock &&
          matchesFavorite;
    }).toList();

    // Sort order
    switch (_currentSort) {
      case SortOption.priceAsc:
        list.sort((a, b) => a.price.compareTo(b.price));
      case SortOption.priceDesc:
        list.sort((a, b) => b.price.compareTo(a.price));
      case SortOption.highestRated:
        list.sort((a, b) => b.rating.compareTo(a.rating));
      case SortOption.featured:
        // Keep initial order
        break;
    }

    return list;
  }

  // setState: Update search query
  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  // setState: Clear search query
  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
    });
  }

  // setState: Select category
  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  // setState: Toggle favorite status for a product
  void _toggleFavorite(String productId) {
    setState(() {
      final index = _allProducts.indexWhere((p) => p.id == productId);
      if (index != -1) {
        final current = _allProducts[index];
        _allProducts[index] = current.copyWith(isFavorite: !current.isFavorite);
      }
    });
  }

  // setState: Toggle in-stock filter
  void _toggleInStockOnly(bool value) {
    setState(() {
      _inStockOnly = value;
    });
  }

  // setState: Toggle favorites-only filter
  void _toggleFavoritesOnly(bool value) {
    setState(() {
      _favoritesOnly = value;
    });
  }

  // setState: Set sorting order
  void _setSortOption(SortOption option) {
    setState(() {
      _currentSort = option;
    });
  }

  // setState: Reset all active filters
  void _resetFilters() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _selectedCategory = 'All';
      _inStockOnly = false;
      _favoritesOnly = false;
      _currentSort = SortOption.featured;
    });
  }

  // Open product details modal bottom sheet
  void _showProductDetails(Product product) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            // Retrieve fresh state of product
            final currentProduct = _allProducts.firstWhere(
              (p) => p.id == product.id,
              orElse: () => product,
            );

            return ProductDetailSheet(
              product: currentProduct,
              onToggleFavorite: () {
                _toggleFavorite(currentProduct.id);
                setSheetState(() {});
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filtered = _filteredProducts;
    final hasActiveFilters =
        _searchQuery.isNotEmpty ||
        _selectedCategory != 'All' ||
        _inStockOnly ||
        _favoritesOnly ||
        _currentSort != SortOption.featured;

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Product Catalog',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
              'Dynamic listing with real-time filters',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          // Sort Menu
          PopupMenuButton<SortOption>(
            icon: const Icon(Icons.sort_rounded),
            tooltip: 'Sort by',
            initialValue: _currentSort,
            onSelected: _setSortOption,
            itemBuilder: (context) {
              return SortOption.values.map((option) {
                return PopupMenuItem(
                  value: option,
                  child: Row(
                    children: [
                      Icon(
                        _currentSort == option
                            ? Icons.radio_button_checked_rounded
                            : Icons.radio_button_off_rounded,
                        size: 18,
                        color: _currentSort == option
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline,
                      ),
                      const SizedBox(width: 10),
                      Text(option.label),
                    ],
                  ),
                );
              }).toList();
            },
          ),
          if (hasActiveFilters)
            IconButton(
              icon: const Icon(Icons.refresh_rounded),
              tooltip: 'Reset all filters',
              onPressed: _resetFilters,
            ),
        ],
      ),
      body: Column(
        children: [
          // Search Input Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search products, tags, descriptions...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: _clearSearch,
                      )
                    : null,
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest.withAlpha(
                  120,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Horizontal Category Chips Bar
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;

                // Category items count
                final count = category == 'All'
                    ? _allProducts.length
                    : _allProducts.where((p) => p.category == category).length;

                return ChoiceChip(
                  label: Text('$category ($count)'),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      _onCategorySelected(category);
                    }
                  },
                );
              },
            ),
          ),

          // Quick Filter Toggles & Results Counter Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
            child: Row(
              children: [
                // In Stock Toggle Chip
                FilterChip(
                  label: const Text('In Stock'),
                  avatar: Icon(
                    _inStockOnly
                        ? Icons.check_circle
                        : Icons.check_circle_outline,
                    size: 16,
                  ),
                  selected: _inStockOnly,
                  onSelected: _toggleInStockOnly,
                ),
                const SizedBox(width: 8),

                // Favorites Toggle Chip
                FilterChip(
                  label: const Text('Favorites'),
                  avatar: Icon(
                    _favoritesOnly ? Icons.favorite : Icons.favorite_border,
                    size: 16,
                    color: _favoritesOnly ? Colors.red : null,
                  ),
                  selected: _favoritesOnly,
                  onSelected: _toggleFavoritesOnly,
                ),

                const Spacer(),

                // Results count
                Text(
                  '${filtered.length} ${filtered.length == 1 ? "item" : "items"}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Dynamic Product Listing (ListView.builder)
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 64,
                            color: theme.colorScheme.outline,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No matching products',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try adjusting your search query, selecting another category, or removing active filters.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 16),
                          FilledButton.tonalIcon(
                            onPressed: _resetFilters,
                            icon: const Icon(Icons.filter_alt_off_rounded),
                            label: const Text('Reset All Filters'),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: filtered.length,
                    padding: const EdgeInsets.only(top: 8, bottom: 24),
                    itemBuilder: (context, index) {
                      final product = filtered[index];
                      return ProductCard(
                        key: ValueKey(product.id),
                        product: product,
                        onTap: () => _showProductDetails(product),
                        onToggleFavorite: () => _toggleFavorite(product.id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
