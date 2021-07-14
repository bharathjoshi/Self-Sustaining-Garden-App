import 'package:flutter/material.dart';

class GardenView extends StatelessWidget {
  final String _picurl;
  final String _label;
  final double height;

  GardenView(
    this._picurl,
    this._label, {
    this.height: 200,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(_picurl),
                ),
              ),
              height: height,
              width: double.infinity,
            ),
            Container(
              padding: const EdgeInsets.only(right: 8),
              child: Align(
                child: Text(
                  _label,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                alignment: Alignment.centerRight,
              ),
              height: 30,
              color: Colors.black54,
              width: double.infinity,
            ),
          ],
          alignment: Alignment.bottomCenter,
        ),
      ],
    );
  }
}
