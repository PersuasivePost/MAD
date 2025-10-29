import 'package:flutter/material.dart';
import 'package:exp6_1/widgets/drawer_content.dart';
import 'package:exp6_1/pages/dashboard_page.dart';
import 'package:exp6_1/pages/contacts_page.dart';
import 'package:exp6_1/pages/events_page.dart';
import 'package:exp6_1/pages/notes_page.dart';
import 'package:exp6_1/pages/settings_page.dart';
import 'package:exp6_1/pages/notifications_page.dart';

// home page
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    const DashboardPage(),
    const ContactsPage(),
    const EventsPage(),
    const NotesPage(),
    const SettingsPage(),
    const NotificationsPage(),
  ];

  static const List<String> _pageTitles = [
    'Dashboard',
    'Contacts',
    'Events',
    'Notes',
    'Settings',
    'Notifications',
  ];

  void _onSelectItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // exp6.2 starts here
    final screenWidth = MediaQuery.of(context).size.width;
    const breakpoint = 600;

    if (screenWidth < breakpoint) {
      Navigator.of(context).pop(); // Close the drawer on small screens
    }
  }

  @override
  Widget build(BuildContext context) {
    //
    final screenWidth = MediaQuery.of(context).size.width;
    const double breakpoint = 600;

    if (screenWidth >= breakpoint) {
      // Portrait phone
      return Scaffold(
        appBar: AppBar(title: Text(_pageTitles[_selectedIndex])),
        body: _pages[_selectedIndex],
        drawer: Drawer(
          child: DrawerContent(
            selectedIndex: _selectedIndex,
            onSelectItem: _onSelectItem,
          ),
        ),
      );
    } else {
      // Tablet or landscape phone
      return Scaffold(
        appBar: AppBar(title: Text(_pageTitles[_selectedIndex])),
        body: Row(
          children: [
            DrawerContent(
              selectedIndex: _selectedIndex,
              onSelectItem: _onSelectItem,
            ),
            const VerticalDivider(width: 1, thickness: 1),
            Expanded(child: _pages[_selectedIndex]),
          ],
        ),
      );
    }
  }
}
