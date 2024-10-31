import 'package:flutter/cupertino.dart';

class BodyContainer extends StatelessWidget {
  final Widget child;

  const BodyContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: child,
    );
  }
}
