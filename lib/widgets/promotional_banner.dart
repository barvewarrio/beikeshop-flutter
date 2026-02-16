import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class PromotionalBanner extends StatelessWidget {
  final List<String> imageUrls;

  const PromotionalBanner({super.key, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    if (imageUrls.isEmpty) return const SizedBox.shrink();

    return CarouselSlider(
      options: CarouselOptions(
        height: 140.0,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.92,
        aspectRatio: 16 / 9,
        autoPlayCurve: Curves.fastOutSlowIn,
      ),
      items: imageUrls.map((url) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: NetworkImage(url),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
