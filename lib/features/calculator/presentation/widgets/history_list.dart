import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/calc_entry.dart';
import '../state/calculator_controller.dart';

class HistoryList extends ConsumerWidget {
  final Function(CalcEntry) onItemTap;

  const HistoryList({super.key, required this.onItemTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(
      calculatorProvider.select((state) => state.history),
    );

    if (history.isEmpty) {
      return const Center(child: Text('No calculation history'));
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: history.length,
      itemBuilder: (context, index) {
        final entry = history[index];
        return Card(
          child: ListTile(
            title: Text(entry.expression),
            subtitle: Text(entry.result),
            trailing: Text(
              '${entry.timestamp.hour}:${entry.timestamp.minute.toString().padLeft(2, '0')}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            onTap: () => onItemTap(entry),
          ),
        );
      },
    );
  }
}
