import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'dashboard_screen.dart';
import 'profile_screen.dart'; // Kita tambahkan profile screen juga

class MainNavigation extends StatefulWidget {
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0; // Menyimpan indeks tab yang sedang aktif

  // Daftar semua layar/widget yang akan ditampilkan
  static final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(), // Indeks 0
    DashboardScreen(), // Indeks 1
    ProfileScreen(), // Indeks 2
  ];

  // Fungsi yang dipanggil ketika item di-tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Body akan menampilkan layar yang sesuai
      // dengan _selectedIndex dari _widgetOptions
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),

      // Di sinilah kita membuat menu navigasi bawah
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home), // Ikon saat aktif
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex, // Item yang sedang aktif
        selectedItemColor: const Color(0xFF6B46C1), // Warna item aktif
        unselectedItemColor: Colors.grey[600], // Warna item tidak aktif
        onTap: _onItemTapped, // Panggil fungsi saat di-tap
        type: BottomNavigationBarType.fixed, // Agar label selalu terlihat
        backgroundColor: Colors.white,
        elevation: 8,
      ),
    );
  }
}
