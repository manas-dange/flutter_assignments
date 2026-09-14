import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_assignments/main.dart';
import 'package:flutter_assignments/widgets/product_card.dart';

void main() {
  testWidgets('Renders product catalog with ListView.builder', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const DynamicProductCatalogApp());
    await tester.pumpAndSettle();

    // Check App title
    expect(find.text('Product Catalog'), findsOneWidget);

    // Check ListView is present
    expect(find.byType(ListView), findsWidgets);

    // Check initial products rendered via ProductCard
    expect(find.byType(ProductCard), findsWidgets);
    expect(find.text('Wireless Noise-Canceling Headphones'), findsOneWidget);
  });

  testWidgets('Search filters products in real time with setState', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const DynamicProductCatalogApp());
    await tester.pumpAndSettle();

    // Type "Camera" in search field
    await tester.enterText(find.byType(TextField), 'Camera');
    await tester.pumpAndSettle();

    // Verify camera product is shown
    expect(find.text('4K Ultra HD Action Camera'), findsOneWidget);

    // Verify unrelated products are filtered out
    expect(find.text('Wireless Noise-Canceling Headphones'), findsNothing);

    // Clear search using clear button
    await tester.tap(find.byIcon(Icons.clear_rounded));
    await tester.pumpAndSettle();

    // Verify initial products return
    expect(find.text('Wireless Noise-Canceling Headphones'), findsOneWidget);
  });

  testWidgets('Category chip filters products with setState', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const DynamicProductCatalogApp());
    await tester.pumpAndSettle();

    // Tap 'Footwear' category chip
    final footwearChip = find.widgetWithText(ChoiceChip, 'Footwear (2)');
    expect(footwearChip, findsOneWidget);
    await tester.tap(footwearChip);
    await tester.pumpAndSettle();

    // Verify footwear items are shown
    expect(find.text('Ultra-Light Running Shoes'), findsOneWidget);
    expect(find.text('Classic Canvas Sneakers'), findsOneWidget);

    // Verify other categories are filtered out
    expect(find.text('Fitness Smartwatch Pro'), findsNothing);
  });

  testWidgets('Empty search shows friendly empty state with reset button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const DynamicProductCatalogApp());
    await tester.pumpAndSettle();

    // Enter non-matching query
    await tester.enterText(find.byType(TextField), 'NonExistentProductXYZ');
    await tester.pumpAndSettle();

    // Empty state should be visible
    expect(find.text('No matching products'), findsOneWidget);
    expect(find.text('Reset All Filters'), findsOneWidget);

    // Tap reset button
    await tester.tap(find.text('Reset All Filters'));
    await tester.pumpAndSettle();

    // Full product list restored
    expect(find.text('Wireless Noise-Canceling Headphones'), findsOneWidget);
  });

  testWidgets('Tapping product opens detail bottom sheet', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const DynamicProductCatalogApp());
    await tester.pumpAndSettle();

    // Tap first product card
    await tester.tap(find.text('Wireless Noise-Canceling Headphones'));
    await tester.pumpAndSettle();

    // Verify bottom sheet appears with description and Add to Cart button
    expect(find.text('Description'), findsOneWidget);
    expect(find.text('Add to Cart'), findsOneWidget);
  });
}
