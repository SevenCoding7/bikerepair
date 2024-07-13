import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('로그인')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: '전화번호'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('인증번호 받기'),
              onPressed: () async {
                try {
                  await authService.signInWithPhoneNumber(
                    _phoneController.text,
                    (String verificationId) async {
                      // SMS 코드 입력 UI를 표시하는 로직
                      if (!mounted) return;
                      String? smsCode = await showDialog<String>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('SMS 코드 입력'),
                          content: const TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(labelText: 'SMS 코드'),
                          ),
                          actions: [
                            TextButton(
                              child: const Text('확인'),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                      );
                      if (smsCode != null && smsCode.isNotEmpty) {
                        await authService.verifySmsCode(
                            verificationId, smsCode);
                      }
                    },
                  );
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('인증번호 전송 실패: $e')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
