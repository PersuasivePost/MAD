import 'package:flutter/material.dart';

class SendFeedbackPage extends StatelessWidget {
  const SendFeedbackPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Send Feedback')),
      body: const Center(
        child: Text(
          'This is the Send Feedback Page\n(Pushed via named route)',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
