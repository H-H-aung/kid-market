import 'package:flutter/material.dart';

class LearningBanner extends StatefulWidget {
  const LearningBanner({super.key});

  @override
  State<LearningBanner> createState() => _LearningBannerState();
}

class _LearningBannerState extends State<LearningBanner> {
  final _controller = PageController();
  int _page = 0;

  static const _slides = [
    _HeroSlide(
      image: 'assets/products/books.png',
      eyebrow: 'STORY TIME',
      title: 'Big stories for\nlittle readers',
      subtitle: 'Discover colorful books made for curious minds.',
    ),
    _HeroSlide(
      image: 'assets/products/toys.png',
      eyebrow: 'LEARN THROUGH PLAY',
      title: 'Build, create\nand imagine',
      subtitle: 'Hands-on toys turn every playtime into discovery.',
    ),
    _HeroSlide(
      image: 'assets/products/courses.png',
      eyebrow: 'FUN COURSES',
      title: 'New skills,\none lesson at a time',
      subtitle: 'Friendly activities children can enjoy at home.',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
    height: 210,
    margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
    child: Stack(
      children: [
        PageView.builder(
          controller: _controller,
          itemCount: _slides.length,
          onPageChanged: (value) => setState(() => _page = value),
          itemBuilder: (context, index) => _slides[index],
        ),
        Positioned(
          left: 18,
          bottom: 14,
          child: Semantics(
            label: 'Slide ${_page + 1} of ${_slides.length}',
            child: Row(
              children: List.generate(
                _slides.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: index == _page ? 22 : 7,
                  height: 7,
                  margin: const EdgeInsets.only(right: 6),
                  decoration: BoxDecoration(
                    color: index == _page ? Colors.white : Colors.white60,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class _HeroSlide extends StatelessWidget {
  final String image, eyebrow, title, subtitle;

  const _HeroSlide({
    required this.image,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [
      Image.asset(image, fit: BoxFit.cover),
      const DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xE621314A), Color(0x9921314A), Color(0x1021314A)],
            stops: [0, .55, 1],
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 92, 34),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              eyebrow,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFFFFD166),
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 23,
                height: 1.04,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  height: 1.35,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
