import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '/providers/auth.dart';
import '/screens/text_to_speech_screen.dart';

// ignore: must_be_immutable
class AppDrawer extends StatelessWidget {
  AppDrawer({super.key});
  Divider divider = const Divider(color: Colors.white);

  Widget cutomListTile({
    required BuildContext ctx,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      tileColor: Colors.grey[200],
      leading: Icon(
        icon,
        color: Colors.grey,
        size: 30,
      ),
      title: Text(
        title,
        style: GoogleFonts.mavenPro(
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 20,
        ),
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 200,
            color: Colors.white,
            child: Image.asset(
              'assets/icon/notes.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.note_add_rounded,
                          size: 60,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Notes App',
                          style: GoogleFonts.mavenPro(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          divider,
          cutomListTile(
            ctx: context,
            title: 'Add New Note',
            icon: Icons.note_add_rounded,
            onTap: () {
              Scaffold.of(context).closeDrawer();
              Navigator.of(context).pushNamed(TextToSpeechScreen.routeName);
            },
          ),
          divider,
          cutomListTile(
            ctx: context,
            title: 'Logout',
            icon: Icons.logout,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Are you sure?'),
                    content: const Text('Do you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Provider.of<Auth>(context, listen: false).logout();
                        },
                        child: const Text('Yes'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
