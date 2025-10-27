import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onSelectItem;

  const MyDrawer({
    super.key,
    required this.selectedIndex,
    required this.onSelectItem,
  });

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
