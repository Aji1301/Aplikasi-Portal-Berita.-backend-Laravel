import 'package:flutter/material.dart';
import 'login_page.dart'; // Import halaman login

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Portal Berita',
      theme: ThemeData(
        primarySwatch: Colors.green, // Sesuaikan warna tema utama
        scaffoldBackgroundColor: Colors.white,
      ),
      home: LoginPage(), // Panggil halaman Login di sini
    );
  }
}