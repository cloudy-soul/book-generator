import 'package:flutter/material.dart';

class GenreBookshelfSelector extends StatefulWidget {
  final List<String>? initialGenres;
  final ValueChanged<List<String>>? onGenresSelected;

  const GenreBookshelfSelector({super.key, this.initialGenres, this.onGenresSelected});

  @override
  State<GenreBookshelfSelector> createState() => _GenreBookshelfSelectorState();
}

class _GenreBookshelfSelectorState extends State<GenreBookshelfSelector> {
  final List<String> _allGenres = [
    'Fiction',
    'Mystery',
    'Fantasy',
    'Sci‑Fi',
    'Romance',
    'Non‑fiction',
    'History',
    'Biography',
    'Poetry',
    'Thriller',
  ];

  final Set<String> _selected = {};

  @override
  void initState() {
    super.initState();
    if (widget.initialGenres != null) {
      _selected.addAll(widget.initialGenres!);
    }
  }

  void _toggle(String genre) {
    setState(() {
      if (_selected.contains(genre)) {
        _selected.remove(genre);
      } else {
        _selected.add(genre);
      }
      widget.onGenresSelected?.call(_selected.toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const Key('genre_bookshelf_selector'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Choose your preferred genres'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: _allGenres.map((g) {
            final selected = _selected.contains(g);
            return FilterChip(
              key: Key('genre_chip_$g'),
              label: Text(g),
              selected: selected,
              onSelected: (_) => _toggle(g),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        Text('Selected: ${_selected.join(', ')}', key: const Key('genre_selection_text')),
      ],
    );
  }
}