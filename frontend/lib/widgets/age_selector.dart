import 'package:flutter/material.dart';

class AgeDialSelector extends StatefulWidget {
  final int? initialAge;
  final ValueChanged<int>? onAgeSelected;

  const AgeDialSelector({super.key, this.initialAge, this.onAgeSelected});

  @override
  State<AgeDialSelector> createState() => _AgeDialSelectorState();
}

class _AgeDialSelectorState extends State<AgeDialSelector> {
  double _age = 25;

  @override
  void initState() {
    super.initState();
    if (widget.initialAge != null) {
      _age = widget.initialAge!.toDouble();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const Key('age_selector'),
      children: [
        const Text('Select your age'),
        const SizedBox(height: 12),
        Text('${_age.round()}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        Slider(
          min: 13,
          max: 100,
          divisions: 87,
          value: _age,
          onChanged: (v) {
            setState(() => _age = v);
            widget.onAgeSelected?.call(v.round());
          },
        ),
      ],
    );
  }
}