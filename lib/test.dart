import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PhoneAuthScreen extends StatefulWidget {
  @override
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? verificationId;
  bool codeSent = false;
  bool resendCode = false;

  void verifyPhoneNumber() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneController.text,

      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
      },
      codeSent: (String verId, int? resendToken) {
        setState(() {
          verificationId = verId;
          codeSent = true;
        });
      },
      codeAutoRetrievalTimeout: (String verId) {
        verificationId = verId;
      },
    );
  }

  void resendVerificationCode() async {
    setState(() {
      resendCode = true;
    });

    verifyPhoneNumber();

    setState(() {
      resendCode = false;
    });
  }

  void signInWithOTP() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId!,
      smsCode: otpController.text,
    );

    await _auth.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phone Auth'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (!codeSent)
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Phone Number'),
              ),
            if (codeSent)
              TextField(
                controller: otpController,
                decoration: InputDecoration(labelText: 'OTP'),
              ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: codeSent ? signInWithOTP : verifyPhoneNumber,
              child: Text(codeSent ? 'Sign In' : 'Verify Phone Number'),
            ),
            if (codeSent)
              TextButton(
                onPressed: resendCode ? null : resendVerificationCode,
                child: Text('Resend OTP'),
              ),
          ],
        ),
      ),
    );
  }
}
