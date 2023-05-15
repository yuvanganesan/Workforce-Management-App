import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/authentication.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 120,
          width: double.infinity,
          color: Theme.of(context).colorScheme.primary,
          alignment: Alignment.centerLeft,
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              "Wages",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).colorScheme.secondary),
            ),
          ),
        ),
        ListTile(
          onTap: () {
            Provider.of<Authentication>(context, listen: false).logout();
          },
          trailing: const Icon(
            Icons.logout,
            color: Colors.black,
            size: 26,
          ),
          leading: const Text(
            "Logout",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        )
      ],
    );
  }
}
