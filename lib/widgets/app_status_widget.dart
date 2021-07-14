import 'package:flutter/material.dart';

class LoadingMessage extends StatelessWidget {
  final String _hint;

  LoadingMessage(this._hint);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 10),
        Text(_hint),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }
}

class ErrorMessage extends StatelessWidget {
  final String _error;
  final String _hint;

  ErrorMessage(
    this._error,
    this._hint,
  );

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: _error,
            style: const TextStyle(
              color: Colors.red,
            ),
          ),
          TextSpan(
            text: _hint,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ],
      ),
      maxLines: 2,
      textAlign: TextAlign.center,
    );
  }
}
