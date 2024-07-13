import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/database_service.dart';
import '../services/auth_service.dart';
import '../models/vehicle_model.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  AdminScreenState createState() => AdminScreenState();
}

class AdminScreenState extends State<AdminScreen> {
  final _searchController = TextEditingController();
  Vehicle? _selectedVehicle;
  final List<String> _selectedMaintenanceItems = [];

  final List<String> _availableMaintenanceItems = [
    '엔진오일 교체',
    '브레이크 점검',
    '타이어 교체',
    '에어컨 필터 교체',
    '와이퍼 교체',
  ];

  Widget _buildMaintenanceItemsList() {
    return Column(
      children: _availableMaintenanceItems.map((item) {
        return CheckboxListTile(
          title: Text(item),
          value: _selectedMaintenanceItems.contains(item),
          onChanged: (bool? value) {
            setState(() {
              if (value == true) {
                _selectedMaintenanceItems.add(item);
              } else {
                _selectedMaintenanceItems.remove(item);
              }
            });
          },
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final databaseService = Provider.of<DatabaseService>(context);
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('관리자'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => authService.signOut(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(labelText: '차량번호 검색'),
            ),
            ElevatedButton(
              child: const Text('검색'),
              onPressed: () async {
                final result = await databaseService
                    .getUserVehicles(_searchController.text);
                if (result.isNotEmpty) {
                  setState(() {
                    _selectedVehicle = result.first;
                  });
                } else {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('차량을 찾을 수 없습니다.')),
                    );
                  }
                }
              },
            ),
            if (_selectedVehicle != null) ...[
              Text('차량번호: ${_selectedVehicle!.number}'),
              Text('소유자: ${_selectedVehicle!.ownerName}'),
              if (_selectedVehicle!.lastMaintenance != null)
                Text(
                    '마지막 정비: ${_selectedVehicle!.lastMaintenance!.services.join(", ")}'),
              _buildMaintenanceItemsList(),
              ElevatedButton(
                child: const Text('정비 완료'),
                onPressed: () async {
                  if (_selectedMaintenanceItems.isEmpty) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('정비 항목을 선택해주세요.')),
                      );
                    }
                    return;
                  }
                  await databaseService.completeMaintenance(
                      _selectedVehicle!.id, _selectedMaintenanceItems);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              '정비 완료: ${_selectedMaintenanceItems.join(", ")}')),
                    );
                  }
                  final updatedVehicles = await databaseService
                      .getUserVehicles(_selectedVehicle!.number);
                  if (updatedVehicles.isNotEmpty) {
                    setState(() {
                      _selectedVehicle = updatedVehicles.first;
                      _selectedMaintenanceItems.clear();
                    });
                  }
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
