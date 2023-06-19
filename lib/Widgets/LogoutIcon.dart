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
      icon: Icon(Icons.logout),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Logout"),
              content: Text("Are you sure you want to logout?"),
              actions: [
                ElevatedButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                ElevatedButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                    // Do something when user logs out
                    context.read<User>().resetUser();
                    context.read<ShoppingCartProvider>().cartList.clear();
                    Navigator.of(context).pushReplacementNamed('/login');
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
void showLogoutDialog(BuildContext context){
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Logout"),
        content: Text("Are you sure you want to logout?"),
        actions: [
          ElevatedButton(
            child: Text("Cancel"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          ElevatedButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.pop(context);
              // Do something when user logs out
              context.read<User>().resetUser();
              context.read<ShoppingCartProvider>().cartList.clear();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      );
    },
  );
}