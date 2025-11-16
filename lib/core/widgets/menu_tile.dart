import 'package:flutter/material.dart';

class MenuTile extends StatelessWidget {
  final String title;
  final IconData? icon;
  final VoidCallback? onTap;

  const MenuTile({super.key, required this.title, this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black, blurRadius: 2)],
      ),
      child: ListTile(onTap: onTap, leading: Icon(icon), title: Text(title)),
    );
  }
}
