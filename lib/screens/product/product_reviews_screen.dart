import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:beikeshop_flutter/l10n/app_localizations.dart';
import '../../api/api_service.dart';
import '../../models/review_model.dart';
import '../../theme/app_theme.dart';
import 'write_review_screen.dart';

class ProductReviewsScreen extends StatefulWidget {
  final String productId;

  const ProductReviewsScreen({super.key, required this.productId});

  @override
  State<ProductReviewsScreen> createState() => _ProductReviewsScreenState();
}

class _ProductReviewsScreenState extends State<ProductReviewsScreen> {
  final List<Review> _reviews = [];
  bool _isLoading = true;
  int _currentPage = 1;
  int _lastPage = 1;
  bool _hasMore = true;

  final List<String> _tags = [
    'All',
    'With Images (12)',
    'Good Quality (8)',
    'Fast Shipping (5)',
    'Cost Effective (3)'
  ];
  int _selectedTagIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchReviews();
  }

  Future<void> _fetchReviews({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      // Don't clear immediately to avoid flicker, do it in setState later
      _hasMore = true;
    }

    if (!_hasMore) return;

    if (_reviews.isEmpty) {
       setState(() => _isLoading = true);
    }

    try {
      final response = await ApiService().getReviews(
        widget.productId,
        page: _currentPage,
      );

      final List<dynamic> data = response['data'] ?? [];
      final List<Review> newReviews = data
          .map((json) => Review.fromJson(json))
          .toList();

      // Pagination meta data from Laravel
      final int lastPage = response['last_page'] ?? 1;

      if (mounted) {
        setState(() {
          if (refresh) {
            _reviews.clear();
          }
          _reviews.addAll(newReviews);
          _lastPage = lastPage; // Store lastPage but don't depend on it solely if logic is complex
          // If we got fewer items than per_page (usually 15 or 20), we are done.
          // Or strictly use last_page
          _hasMore = _currentPage < _lastPage;
          if (_hasMore) {
            _currentPage++;
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.failedToLoadReviews(e.toString()),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          l10n.reviewsTitle(_reviews.length),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  WriteReviewScreen(productId: widget.productId),
            ),
          );
          if (result == true) {
            _fetchReviews(refresh: true);
          }
        },
        label: Text(
          l10n.writeReview,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        icon: const Icon(Icons.rate_review),
        backgroundColor: AppColors.primary,
        elevation: 4,
      ),
      body: Column(
        children: [
          // Filter Tags
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _tags.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final isSelected = _selectedTagIndex == index;
                return GestureDetector(
                  onTap: () => setState(() => _selectedTagIndex = index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFFFF0E0)
                          : const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(16),
                      border: isSelected
                          ? Border.all(color: AppColors.primary)
                          : null,
                    ),
                    child: Text(
                      _tags[index],
                      style: TextStyle(
                        color: isSelected
                            ? AppColors.primary
                            : const Color(0xFF666666),
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),

          // Review List
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => _fetchReviews(refresh: true),
              color: AppColors.primary,
              child: _reviews.isEmpty && !_isLoading
                  ? ListView(
                      children: [
                        const SizedBox(height: 100),
                        Center(
                          child: Column(
                            children: [
                              const Icon(
                                Icons.rate_review_outlined,
                                size: 64,
                                color: Color(0xFFCCCCCC),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                l10n.noReviewsYet,
                                style: const TextStyle(
                                  color: Color(0xFF999999),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _reviews.length + (_hasMore ? 1 : 0),
                      separatorBuilder: (_, __) => const Divider(
                        height: 32,
                        color: Color(0xFFEEEEEE),
                      ),
                      itemBuilder: (context, index) {
                        if (index == _reviews.length) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.primary,
                                      ),
                                    )
                                  : TextButton(
                                      onPressed: () => _fetchReviews(),
                                      child: Text(
                                        l10n.loadMore,
                                        style: const TextStyle(
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ),
                            ),
                          );
                        }

                        final review = _reviews[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Colors.grey[200],
                                  child: Text(
                                    (review.customerName.isNotEmpty
                                            ? review.customerName[0]
                                            : '?')
                                        .toUpperCase(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        review.customerName.isNotEmpty
                                            ? review.customerName
                                            : l10n.anonymous,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Row(
                                        children: List.generate(5, (i) {
                                          return Icon(
                                            i < review.rating
                                                ? Icons.star
                                                : Icons.star_border,
                                            size: 14,
                                            color: Colors.black,
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  review.createdAt.toString().split(' ')[0],
                                  style: const TextStyle(
                                    color: Color(0xFF999999),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            if (review.comment != null &&
                                review.comment!.isNotEmpty)
                              Text(
                                review.comment!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  height: 1.5,
                                  color: Color(0xFF333333),
                                ),
                              ),
                            if (review.images.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: SizedBox(
                                  height: 80,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: review.images.length,
                                    separatorBuilder: (_, __) =>
                                        const SizedBox(width: 8),
                                    itemBuilder: (context, imgIndex) {
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: CachedNetworkImage(
                                          imageUrl: review.images[imgIndex],
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                          placeholder: (_, __) => Container(
                                            color: Colors.grey[200],
                                          ),
                                          errorWidget: (_, __, ___) =>
                                              const Icon(Icons.error),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            const SizedBox(height: 8),
                            // Mock Variant info
                            const Text(
                              'Color: Default, Size: M',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF999999),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
