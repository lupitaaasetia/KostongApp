import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Profil')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
                radius: 40,
                child: Text(auth.user?.name.substring(0, 1) ?? 'U')),
            SizedBox(height: 12),
            Text(auth.user?.name ?? '-',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 6),
            Text(auth.user?.email ?? '-'),
            SizedBox(height: 12),
            ElevatedButton(
                onPressed: () {
                  auth.logout();
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: Text('Logout'))
          ],
        ),
      ),
    );
  }
}
