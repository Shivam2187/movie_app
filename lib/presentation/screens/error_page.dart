import 'package:flutter/material.dart';

import '../../utils/constants.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({
    super.key,
    this.onPressed,
  });
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text(MovieConstant.errorScreenTitle)),
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
            const Text(
              MovieConstant.somethingWentWrong,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: onPressed,
              style: const ButtonStyle(),
              child: const Text(MovieConstant.retry),
            ),
          ],
        ),
      ),
    );
  }
}
