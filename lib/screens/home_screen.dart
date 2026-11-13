import 'package:flutter/material.dart';
import 'package:kids_mart/models/product.dart';
import 'package:kids_mart/screens/product_list_screen.dart';
import 'package:kids_mart/widgets/category_widgets.dart';
import 'package:kids_mart/widgets/home_header.dart';
import 'package:kids_mart/widgets/learning_banner.dart';
import 'package:kids_mart/widgets/product_grid.dart';
import 'package:kids_mart/widgets/search_box.dart';
import 'package:kids_mart/widgets/section_header.dart';
import 'package:kids_mart/data/app_data.dart';
import 'package:kids_mart/widgets/empty_state.dart';

class HomeScreen extends StatefulWidget {
  final ValueChanged<Product> onAdd;
  const HomeScreen({super.key, required this.onAdd});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ValueChanged<Product> get onAdd => widget.onAdd;
  String _query = '';
  String _ageGroup = 'All';

  bool _matchesAge(Product product) {
    if (_ageGroup == 'All') return true;
    final match = RegExp(r'\d+').firstMatch(product.age);
    final age = int.tryParse(match?.group(0) ?? '');
    if (age == null) return true;
    return switch (_ageGroup) {
      '2–4' => age <= 4,
      '5–7' => age >= 5 && age <= 7,
      '8+' => age >= 8,
      _ => true,
    };
  }

  @override
  Widget build(BuildContext context) {
    final items = products
        .where(
          (p) =>
              (p.title.toLowerCase().contains(_query) ||
                  p.categoryId.contains(_query)) &&
              _matchesAge(p),
        )
        .toList();
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: HomeHeader()),
        SliverToBoxAdapter(
          child: SearchBox(
            onChanged: (value) =>
                setState(() => _query = value.trim().toLowerCase()),
          ),
        ),
        if (_query.isEmpty) ...[
          const SliverToBoxAdapter(child: LearningBanner()),
          const SliverToBoxAdapter(child: SectionHeader('Categories')),
          SliverToBoxAdapter(
            child: CategoryRow(
              onSelected: (category) => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductListScreen(
                    title: category.title,
                    categoryId: category.id,
                    onAdd: onAdd,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _AgeGroupFilter(
              selected: _ageGroup,
              onSelected: (value) => setState(() => _ageGroup = value),
            ),
          ),
          SliverToBoxAdapter(
            child: SectionHeader(
              'Popular finds',
              onSeeAll: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductListScreen(
                    title: 'Popular Products',
                    onAdd: onAdd,
                  ),
                ),
              ),
            ),
          ),
        ] else
          const SliverToBoxAdapter(child: SectionHeader('Search results')),
        if (items.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: EdgeInsets.all(24),
              child: EmptyState(
                Icons.search_off_rounded,
                'No products found',
                'Try another name or category.',
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 130),
            sliver: ProductGrid(onAdd: onAdd, items: items),
          ),
      ],
    );
  }
}

class _AgeGroupFilter extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelected;

  const _AgeGroupFilter({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 18, 0, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Shop by age',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(right: 16),
          child: Row(
            children: ['All', '2–4', '5–7', '8+']
                .map(
                  (label) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(label == 'All' ? 'All ages' : 'Ages $label'),
                      selected: selected == label,
                      onSelected: (_) => onSelected(label),
                      avatar: Icon(
                        label == 'All'
                            ? Icons.auto_awesome_rounded
                            : Icons.child_care_rounded,
                        size: 17,
                      ),
                      showCheckmark: false,
                      selectedColor: const Color(0xFFDCEEFF),
                      backgroundColor: Colors.white,
                      side: BorderSide(
                        color: selected == label
                            ? const Color(0xFF1688F8)
                            : const Color(0xFFE4ECF4),
                      ),
                      labelStyle: TextStyle(
                        color: selected == label
                            ? const Color(0xFF1688F8)
                            : const Color(0xFF21314A),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    ),
  );
}
