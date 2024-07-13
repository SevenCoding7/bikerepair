import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/database_service.dart';
import '../services/auth_service.dart';
import '../models/reservation_model.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});

  @override
  ReservationScreenState createState() => ReservationScreenState();
}

class ReservationScreenState extends State<ReservationScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final List<String> _selectedServices = [];

  final List<String> _availableServices = [
    '엔진오일 교체',
    '브레이크 점검',
    '타이어 교체',
    '일반 점검',
  ];

  @override
  Widget build(BuildContext context) {
    final databaseService = Provider.of<DatabaseService>(context);
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('예약하기')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('날짜 선택:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ElevatedButton(
              child: Text(_selectedDate?.toString().split(' ')[0] ?? '날짜 선택'),
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                );
                if (picked != null) {
                  setState(() => _selectedDate = picked);
                }
              },
            ),
            const SizedBox(height: 20),
            const Text('시간 선택:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ElevatedButton(
              child: Text(_selectedTime?.format(context) ?? '시간 선택'),
              onPressed: () async {
                final TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: _selectedTime ?? TimeOfDay.now(),
                );
                if (picked != null) {
                  setState(() => _selectedTime = picked);
                }
              },
            ),
            const SizedBox(height: 20),
            const Text('서비스 선택:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ..._availableServices.map((service) => CheckboxListTile(
                  title: Text(service),
                  value: _selectedServices.contains(service),
                  onChanged: (bool? value) {
                    if (value != null) {
                      setState(() {
                        if (value) {
                          _selectedServices.add(service);
                        } else {
                          _selectedServices.remove(service);
                        }
                      });
                    }
                  },
                )),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('예약하기'),
              onPressed: () async {
                if (_selectedServices.isEmpty) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('서비스를 선택해주세요.')),
                    );
                  }
                  return;
                }
                final reservation = Reservation(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  userId: authService.currentUser!.uid,
                  dateTime: DateTime(
                    _selectedDate?.year ?? DateTime.now().year,
                    _selectedDate?.month ?? DateTime.now().month,
                    _selectedDate?.day ?? DateTime.now().day,
                    _selectedTime?.hour ?? TimeOfDay.now().hour,
                    _selectedTime?.minute ?? TimeOfDay.now().minute,
                  ),
                  services: _selectedServices,
                  status: 'pending',
                );
                try {
                  await databaseService.createReservation(reservation);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('예약이 완료되었습니다.')),
                    );
                    Navigator.pop(context);
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('예약 생성 중 오류가 발생했습니다: $e')),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
