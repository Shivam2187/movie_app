import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../utils/constants.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(MovieConstant.errorScreenTitle)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error,
              size: 100,
              color: Colors.red,
            ),
            const SizedBox(height: 24),
            const Center(
              child: Text(
                MovieConstant.somethingWentWrong,
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () {
                context.pop(true);
              },
              style: const ButtonStyle(),
              child: const Text(MovieConstant.retry),
            ),
          ],
        ),
      ),
    );
  }
}
