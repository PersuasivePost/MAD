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
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text('A. Student'),
            accountEmail: const Text('16010123085@example.com'),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 60, color: Colors.blue),
            ),
            decoration: const BoxDecoration(color: Colors.blue),
          ),

          _buildDrawerItem(
            icon: Icons.dashboard,
            text: 'Dashboard',
            index: 0,
            onTap: () => onSelectItem(0),
          ),
          _buildDrawerItem(
            icon: Icons.contacts,
            text: 'Contacts',
            index: 1,
            onTap: () => onSelectItem(1),
          ),
          _buildDrawerItem(
            icon: Icons.event,
            text: 'Events',
            index: 2,
            onTap: () => onSelectItem(2),
          ),
          _buildDrawerItem(
            icon: Icons.note,
            text: 'Notes',
            index: 3,
            onTap: () => onSelectItem(3),
          ),
          _buildDrawerItem(
            icon: Icons.settings,
            text: 'Settings',
            index: 4,
            onTap: () => onSelectItem(4),
          ),
          _buildDrawerItem(
            icon: Icons.notifications,
            text: 'Notifications',
            index: 5,
            onTap: () => onSelectItem(5),
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Privacy Policy'),
            onTap: () {
              // This uses a NAMED ROUTE
              Navigator.pop(context); // Close drawer first
              Navigator.pushNamed(context, '/privacy');
            },
          ),
          ListTile(
            leading: const Icon(Icons.feedback),
            title: const Text('Send Feedback'),
            onTap: () {
              // This uses a NAMED ROUTE
              Navigator.pop(context); // Close drawer first
              Navigator.pushNamed(context, '/feedback');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required int index,
    required GestureTapCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      selected: selectedIndex == index,
      selectedTileColor: Colors.blue.withOpacity(0.1),
      onTap: onTap,
    );
  }
}
