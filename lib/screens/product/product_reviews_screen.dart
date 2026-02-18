import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
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

  @override
  void initState() {
    super.initState();
    _fetchReviews();
  }

  Future<void> _fetchReviews({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _reviews.clear();
      _hasMore = true;
    }

    if (!_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ApiService().getReviews(
        widget.productId,
        page: _currentPage,
      );
      
      final List<dynamic> data = response['data'] ?? [];
      final List<Review> newReviews = data.map((json) => Review.fromJson(json)).toList();
      
      // Pagination meta data from Laravel
      final int lastPage = response['last_page'] ?? 1;
      
      if (mounted) {
        setState(() {
          _reviews.addAll(newReviews);
          _lastPage = lastPage;
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
          SnackBar(content: Text('Failed to load reviews: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WriteReviewScreen(productId: widget.productId),
            ),
          );
          if (result == true) {
            _fetchReviews(refresh: true);
          }
        },
        label: const Text('Write a Review'),
        icon: const Icon(Icons.rate_review),
        backgroundColor: AppColors.primary,
      ),
      body: RefreshIndicator(
        onRefresh: () => _fetchReviews(refresh: true),
        child: _reviews.isEmpty && !_isLoading
            ? ListView(
                children: const [
                  SizedBox(height: 100),
                  Center(child: Text('No reviews yet. Be the first to review!')),
                ],
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _reviews.length + (_hasMore ? 1 : 0),
                separatorBuilder: (_, __) => const Divider(height: 32),
                itemBuilder: (context, index) {
                  if (index == _reviews.length) {
                    return Center(
                      child: TextButton(
                        onPressed: () => _fetchReviews(),
                        child: _isLoading 
                          ? const CircularProgressIndicator() 
                          : const Text('Load More'),
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
                            radius: 20,
                            backgroundColor: Colors.grey[200],
                            child: Text(
                              (review.customerName.isNotEmpty ? review.customerName[0] : '?').toUpperCase(),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                review.customerName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                review.createdAt.toString().split(' ')[0],
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Row(
                            children: List.generate(5, (i) {
                              return Icon(
                                i < review.rating ? Icons.star : Icons.star_border,
                                size: 16,
                                color: Colors.amber,
                              );
                            }),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (review.comment != null && review.comment!.isNotEmpty)
                        Text(
                          review.comment!,
                          style: const TextStyle(fontSize: 14, height: 1.5),
                        ),
                      if (review.images.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: SizedBox(
                            height: 80,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: review.images.length,
                              separatorBuilder: (_, __) => const SizedBox(width: 8),
                              itemBuilder: (context, imgIndex) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CachedNetworkImage(
                                    imageUrl: review.images[imgIndex],
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    placeholder: (_, __) => Container(color: Colors.grey[200]),
                                    errorWidget: (_, __, ___) => const Icon(Icons.error),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
