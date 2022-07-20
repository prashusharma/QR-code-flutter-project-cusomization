import 'package:flutter/material.dart';

class VegComponent extends StatelessWidget {
  final double? size;

  VegComponent({this.size = 20});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(border: Border.all(color: Colors.green)),
      child: Icon(Icons.circle, size: size! - 2, color: Colors.green),
    );
  }
}

class NonVegComponent extends StatelessWidget {
  final double? size;

  NonVegComponent({this.size = 20});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(border: Border.all(color: Colors.red)),
      child: Icon(Icons.circle, size: size! - 2, color: Colors.red),
    );
  }
}
