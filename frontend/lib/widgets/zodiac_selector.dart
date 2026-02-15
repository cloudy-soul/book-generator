import 'package:flutter/material.dart';
import 'dart:math' as math;

class ZodiacConstellationSelector extends StatefulWidget {
  final String? initialZodiac;
  final ValueChanged<String?>? onZodiacSelected;

  const ZodiacConstellationSelector({super.key, this.initialZodiac, this.onZodiacSelected});

  @override
  State<ZodiacConstellationSelector> createState() => _ZodiacConstellationSelectorState();
}

class _ZodiacConstellationSelectorState extends State<ZodiacConstellationSelector> {
  final List<Map<String, String>> _zodiacs = const [
    {'key': 'aries', 'name': 'Aries', 'symbol': '♈'},
    {'key': 'taurus', 'name': 'Taurus', 'symbol': '♉'},
    {'key': 'gemini', 'name': 'Gemini', 'symbol': '♊'},
    {'key': 'cancer', 'name': 'Cancer', 'symbol': '♋'},
    {'key': 'leo', 'name': 'Leo', 'symbol': '♌'},
    {'key': 'virgo', 'name': 'Virgo', 'symbol': '♍'},
    {'key': 'libra', 'name': 'Libra', 'symbol': '♎'},
    {'key': 'scorpio', 'name': 'Scorpio', 'symbol': '♏'},
    {'key': 'sagittarius', 'name': 'Sagittarius', 'symbol': '♐'},
    {'key': 'capricorn', 'name': 'Capricorn', 'symbol': '♑'},
    {'key': 'aquarius', 'name': 'Aquarius', 'symbol': '♒'},
    {'key': 'pisces', 'name': 'Pisces', 'symbol': '♓'},
  ];

  int _selectedIndex = -1;
  late FixedExtentScrollController _controller;

  @override
  void initState() {
    super.initState();
    int initialItem = 0;
    if (widget.initialZodiac != null) {
      final index = _zodiacs.indexWhere((z) => z['name'] == widget.initialZodiac);
      if (index != -1) {
        _selectedIndex = index;
        initialItem = index;
      }
    }
    _controller = FixedExtentScrollController(initialItem: initialItem);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const Key('zodiac_roulette'),
      children: [
        const Text(
          'Pick your Zodiac',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 160,
          child: ListWheelScrollView.useDelegate(
            controller: _controller,
            itemExtent: 60,
            diameterRatio: 2.0,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: (i) {
              setState(() => _selectedIndex = i);
              widget.onZodiacSelected?.call(_zodiacs[i]['name']);
            },
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: _zodiacs.length,
              builder: (context, index) {
                final item = _zodiacs[index];
                final selected = index == _selectedIndex;
                return GestureDetector(
                  onTap: () {
                    _controller.animateToItem(index, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                    setState(() => _selectedIndex = index);
                    widget.onZodiacSelected?.call(item['name']);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: selected ? Theme.of(context).colorScheme.primary.withOpacity(0.12) : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(item['symbol']!, style: TextStyle(fontSize: 28)),
                        const SizedBox(width: 12),
                        Text(item['name']!, style: TextStyle(fontSize: 16, fontWeight: selected ? FontWeight.w700 : FontWeight.w500)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (_selectedIndex >= 0)
          Text('You selected: ${_zodiacs[_selectedIndex]['name']}', key: const Key('zodiac_selection_text'))
        else
          const SizedBox.shrink(),
      ],
    );
  }
}