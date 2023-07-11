import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ommer/Providers/ShoppingCartProvider.dart';
import 'package:provider/provider.dart';

import '../Objects/User.dart';

class LogoutIcon extends StatelessWidget {
  const LogoutIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.logout),
      onPressed: () => showLogoutDialog(context),
    );
  }
}
void showLogoutDialog(BuildContext context){
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          ElevatedButton(
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          ElevatedButton(
            child: const Text("Logout"),
            onPressed: () {
              Navigator.pop(context);
              // Do something when user logs out
              context.read<User>().resetUser();
              context.read<ShoppingCartProvider>().resetCart();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      );
    },
  );
}