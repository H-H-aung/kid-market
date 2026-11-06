import 'package:flutter/material.dart';

class SearchBox extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  const SearchBox({super.key, this.onChanged});
  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  final _controller = TextEditingController();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.fromLTRB(16, 14, 16, 14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0xFFE4ECF4)),
    ),
    child: TextField(
      controller: _controller,
      textInputAction: TextInputAction.search,
      onChanged: (value) {
        setState(() {});
        widget.onChanged?.call(value);
      },
      decoration: InputDecoration(
        border: InputBorder.none,
        prefixIcon: const Icon(Icons.search_rounded),
        hintText: 'Search books, toys, learning tools...',
        suffixIcon: _controller.text.isEmpty
            ? null
            : IconButton(
                tooltip: 'Clear search',
                onPressed: () {
                  _controller.clear();
                  setState(() {});
                  widget.onChanged?.call('');
                },
                icon: const Icon(Icons.close_rounded),
              ),
      ),
    ),
  );
}
