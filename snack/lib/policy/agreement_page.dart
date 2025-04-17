import 'package:flutter/material.dart';
import 'privacy_policy_page.dart';
import 'terms_of_service_page.dart';
import 'package:snack/authentication/presentation/ui/login_page.dart';

class AgreementPage extends StatefulWidget {
  final VoidCallback onAgreed;
  const AgreementPage({super.key, required this.onAgreed});

  @override
  State<AgreementPage> createState() => _AgreementPageState();
}

class _AgreementPageState extends State<AgreementPage> {
  bool _agreed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('약관 동의')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              '서비스 이용을 위해 아래 약관에 동의해주세요.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('개인정보처리방침'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PrivacyPolicyPage()),
                );
              },
            ),
            ListTile(
              title: const Text('이용약관'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TermsOfServicePage()),
                );
              },
            ),
            const Spacer(),
            CheckboxListTile(
              value: _agreed,
              onChanged: (value) => setState(() => _agreed = value!),
              title: const Text('위 약관에 모두 동의합니다.'),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _agreed
                  ? () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginPage()),
                );
              }
                  : null,
              child: const Text('동의하고 계속하기'),
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
            ),
          ],
        ),
      ),
    );
  }
}
