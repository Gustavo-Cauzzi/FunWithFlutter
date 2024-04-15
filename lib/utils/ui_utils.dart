import 'dart:async';

import 'package:flutter/material.dart';

Future<bool> confirmationDialog(
    BuildContext context, String title, String description) {
  final completer = Completer<bool>();

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(description),
          actions: [
            TextButton(
              child: const Text("Não"),
              onPressed: () {
                completer.complete(false);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Sim"),
              onPressed: () {
                completer.complete(true);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });

  return completer.future;
}

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void dispose() {
    _timer?.cancel();
  }
}
