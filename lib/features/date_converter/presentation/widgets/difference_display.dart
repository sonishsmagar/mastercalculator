import 'package:flutter/material.dart';

class DifferenceDisplay extends StatelessWidget {
  final String difference;

  const DifferenceDisplay({super.key, required this.difference});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.schedule,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            'Difference: $difference',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
          ),
        ],
      ),
    );
  }
}
