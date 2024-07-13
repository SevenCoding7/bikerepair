import 'package:flutter/material.dart';
import '../models/vehicle_model.dart';

class VehicleCard extends StatelessWidget {
  final Vehicle vehicle;

  const VehicleCard({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('차량 정보', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('번호: ${vehicle.number}'),
            Text('모델: ${vehicle.model}'),
            Text('연식: ${vehicle.year}'),
            Text('색상: ${vehicle.color}'),
            Text('소유자: ${vehicle.ownerName}'),
          ],
        ),
      ),
    );
  }
}
