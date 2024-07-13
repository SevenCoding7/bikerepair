import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/database_service.dart';
import '../services/auth_service.dart';
import '../services/push_notification_service.dart';
import '../widgets/vehicle_card.dart';
import '../widgets/maintenance_info.dart';
import '../widgets/coupon_info.dart';
import 'reservation_screen.dart';
import 'chat_screen.dart';
import '../models/user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late PushNotificationService _pushNotificationService;

  @override
  void initState() {
    super.initState();
    _pushNotificationService =
        Provider.of<PushNotificationService>(context, listen: false);
    _pushNotificationService.subscribeToTopic('all_users');
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final databaseService = Provider.of<DatabaseService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('홈'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await _pushNotificationService.unsubscribeFromTopic('all_users');
              await authService.signOut();
            },
          ),
        ],
      ),
      body: FutureBuilder<UserData?>(
        future: databaseService.getUserData(authService.currentUser.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('오류가 발생했습니다: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('사용자 데이터를 찾을 수 없습니다.'));
          }

          final userData = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VehicleCard(vehicle: userData.vehicle),
                const SizedBox(height: 20),
                MaintenanceInfo(maintenance: userData.lastMaintenance),
                const SizedBox(height: 20),
                CouponInfo(couponCount: userData.couponCount),
                const SizedBox(height: 20),
                ElevatedButton(
                  child: const Text('예약하기'),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ReservationScreen()),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  child: const Text('문의하기'),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ChatScreen()),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
