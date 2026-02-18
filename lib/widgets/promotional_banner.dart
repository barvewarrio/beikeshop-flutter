import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class PromotionalBanner extends StatefulWidget {
  final List<String> imageUrls;

  const PromotionalBanner({super.key, required this.imageUrls});

  @override
  State<PromotionalBanner> createState() => _PromotionalBannerState();
}

class _PromotionalBannerState extends State<PromotionalBanner> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrls.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 140.0,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.92,
            aspectRatio: 16 / 9,
            autoPlayCurve: Curves.fastOutSlowIn,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: widget.imageUrls.map((url) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    image: DecorationImage(
                      image: NetworkImage(url),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.imageUrls.asMap().entries.map((entry) {
            return Container(
              width: 8.0,
              height: 8.0,
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black)
                    .withValues(alpha: _currentIndex == entry.key ? 0.9 : 0.2),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
