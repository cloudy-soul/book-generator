import 'package:flutter/material.dart';

class CoffeeCupSelector extends StatefulWidget {
  final String? initialCoffee;
  final ValueChanged<String?>? onCoffeeSelected;

  const CoffeeCupSelector({super.key, this.initialCoffee, this.onCoffeeSelected});

  @override
  State<CoffeeCupSelector> createState() => _CoffeeCupSelectorState();
}

class _CoffeeCupSelectorState extends State<CoffeeCupSelector> {
  final List<String> _options = ['Espresso', 'Latte', 'Americano', 'Cappuccino', 'None'];
  String? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialCoffee;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const Key('coffee_selector'),
      children: [
        const Text('Choose your coffee'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _options.map((o) {
            final selected = _selected == o;
            return ChoiceChip(
              label: Text(o),
              selected: selected,
              onSelected: (_) {
                final newVal = selected ? null : o;
                setState(() => _selected = newVal);
                widget.onCoffeeSelected?.call(newVal);
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        if (_selected != null) Text('Selection: $_selected', key: const Key('coffee_selection_text'))
        else const SizedBox.shrink(),
      ],
    );
  }
}