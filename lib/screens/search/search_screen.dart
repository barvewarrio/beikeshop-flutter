import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:beikeshop_flutter/l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../widgets/product_card.dart';
import '../../models/models.dart';
import '../../api/api_service.dart';
import '../product/product_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  final String? initialQuery;

  const SearchScreen({super.key, this.initialQuery});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;
  List<Product> _searchResults = [];
  bool _isLoading = false;
  bool _hasSearched = false;

  // Mock history for now
  final List<String> _recentSearches = ['iPhone', 'Shoes', 'Dress', 'Watch'];
  final List<String> _trending = [
    'Wireless Earbuds',
    'Smart Watch',
    'Running Shoes',
    'Summer Dress',
    'Gaming Laptop',
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      _performSearch(widget.initialQuery!);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _hasSearched = true;
    });

    try {
      // Call API with keyword
      final results = await ApiService().getProducts(keyword: query);

      // Simulate network delay if needed (optional)
      // await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        setState(() {
          _searchResults = results;
          _isLoading = false;

          // Add to history if not exists
          if (!_recentSearches.contains(query)) {
            _recentSearches.insert(0, query);
            if (_recentSearches.length > 10) _recentSearches.removeLast();
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _searchResults = [];
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Search failed: $e')));
      }
    }
  }

  void _clearHistory() {
    setState(() {
      _recentSearches.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              isDense: true,
              hintText: l10n.searchHint,
              hintStyle: const TextStyle(
                color: AppColors.textHint,
                fontSize: 14,
              ),
              border: InputBorder.none,
              prefixIcon: const Icon(
                Icons.search,
                color: AppColors.textHint,
                size: 22,
              ),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_searchController.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(
                        Icons.clear,
                        color: AppColors.textHint,
                        size: 18,
                      ),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _hasSearched = false;
                          _searchResults = [];
                        });
                      },
                    ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.camera_alt_outlined,
                    color: AppColors.textHint,
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                ],
              ),
              contentPadding: EdgeInsets.zero,
            ),
            textInputAction: TextInputAction.search,
            onSubmitted: _performSearch,
            onChanged: (value) {
              if (value.isEmpty) {
                setState(() {
                  _hasSearched = false;
                });
              } else {
                // Force rebuild to show/hide clear icon
                setState(() {});
              }
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => _performSearch(_searchController.text),
            child: Text(
              l10n.search,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasSearched
          ? _buildResults(l10n)
          : _buildSuggestions(l10n),
    );
  }

  Widget _buildSuggestions(AppLocalizations l10n) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (_recentSearches.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.recentSearches,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              GestureDetector(
                onTap: _clearHistory,
                child: const Icon(
                  Icons.delete_outline,
                  size: 18,
                  color: AppColors.textHint,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _recentSearches.map((query) {
              return GestureDetector(
                onTap: () {
                  _searchController.text = query;
                  _performSearch(query);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    query,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
        ],
        Text(
          l10n.trending,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 12),
        // Trending List with Rankings
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _trending.length,
          itemBuilder: (context, index) {
            final query = _trending[index];
            final rank = index + 1;
            Color rankColor;
            if (rank == 1) {
              rankColor = const Color(0xFFFF0000); // Red
            } else if (rank == 2) {
              rankColor = const Color(0xFFFF5000); // Orange
            } else if (rank == 3) {
              rankColor = const Color(0xFFFFA500); // Yellow/Orange
            } else {
              rankColor = Colors.grey;
            }

            return InkWell(
              onTap: () {
                _searchController.text = query;
                _performSearch(query);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      alignment: Alignment.center,
                      child: Text(
                        '$rank',
                        style: TextStyle(
                          color: rankColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          fontStyle: rank <= 3
                              ? FontStyle.italic
                              : FontStyle.normal,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        query,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    if (rank <= 3)
                      const Icon(
                        Icons.local_fire_department,
                        color: Colors.red,
                        size: 16,
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildResults(AppLocalizations l10n) {
    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off,
                size: 48,
                color: AppColors.textHint,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.noResults,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try checking your spelling or use different keywords',
              style: TextStyle(color: AppColors.textHint, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return MasonryGridView.count(
      padding: const EdgeInsets.all(8),
      crossAxisCount: 2,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final product = _searchResults[index];
        return ProductCard(
          product: product,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailScreen(productId: product.id),
              ),
            );
          },
        );
      },
    );
  }
}
