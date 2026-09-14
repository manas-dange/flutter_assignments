import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final double rating;
  final int reviewsCount;
  final String description;
  final bool inStock;
  final IconData icon;
  final Color accentColor;
  final bool isFavorite;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.reviewsCount,
    required this.description,
    required this.inStock,
    required this.icon,
    required this.accentColor,
    this.isFavorite = false,
  });

  Product copyWith({
    String? id,
    String? name,
    String? category,
    double? price,
    double? rating,
    int? reviewsCount,
    String? description,
    bool? inStock,
    IconData? icon,
    Color? accentColor,
    bool? isFavorite,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      description: description ?? this.description,
      inStock: inStock ?? this.inStock,
      icon: icon ?? this.icon,
      accentColor: accentColor ?? this.accentColor,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
