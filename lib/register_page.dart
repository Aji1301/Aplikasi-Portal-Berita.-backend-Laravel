import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'api_service.dart';
import 'home_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiService api = ApiService();
  bool isLoading = false;

  void _handleRegister() async {
    setState(() => isLoading = true);
    // Panggil fungsi register
    bool success = await api.register(
      nameController.text, 
      emailController.text, 
      passwordController.text
    );
    setState(() => isLoading = false);

    if (success) {
      // Kalau sukses, langsung masuk ke Home
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal Daftar! Email mungkin sudah dipakai.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, iconTheme: IconThemeData(color: Colors.black)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Buat Akun,", style: GoogleFonts.poppins(fontSize: 30, fontWeight: FontWeight.bold)),
            Text("Gabung untuk baca & komen.", style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey)),
            SizedBox(height: 30),
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Nama Lengkap", border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
            ),
            SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email", border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Password", border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : _handleRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF41B77C), // Tombol hijau buat bedain sama login
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: isLoading 
                  ? CircularProgressIndicator(color: Colors.white) 
                  : Text("DAFTAR", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}