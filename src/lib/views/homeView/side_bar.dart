import 'package:flutter/material.dart';
import 'package:hci_air_quality/controllers/side_bar_controller.dart';

class SideBar extends StatelessWidget {
  final SideBarController sideBarController = SideBarController();
  SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            leading: Icon(sideBarController.isConnected()
                ? Icons.bluetooth_connected
                : Icons.bluetooth_disabled),
            title: const Text('Bluetooth Connection'),
            subtitle: sideBarController.isConnected()
                ? const Text('Connected')
                : const Text('Disconnected'),
          ),
          ListTile(
            leading: const Icon(Icons.manage_search),
            title: const Text('Records'),
            onTap: () => Navigator.pushNamed(context, '/records'),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
    );
  }
}
