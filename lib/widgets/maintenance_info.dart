import 'package:flutter/material.dart';
import '../models/maintenance_model.dart';

class MaintenanceInfo extends StatelessWidget {
  final Maintenance maintenance;

  const MaintenanceInfo({super.key, required this.maintenance});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('최근 정비 정보', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('날짜: ${maintenance.date.toLocal().toString().split(' ')[0]}'),
            Text('서비스: ${maintenance.services.join(', ')}'),
          ],
        ),
      ),
    );
  }
}
