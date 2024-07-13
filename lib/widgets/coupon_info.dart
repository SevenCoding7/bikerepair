import 'package:flutter/material.dart';

class CouponInfo extends StatelessWidget {
  final int couponCount;

  const CouponInfo({super.key, required this.couponCount});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('쿠폰 정보', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('적립 횟수: $couponCount'),
            Text('다음 무료 정비까지: ${5 - (couponCount % 5)}회'),
          ],
        ),
      ),
    );
  }
}
