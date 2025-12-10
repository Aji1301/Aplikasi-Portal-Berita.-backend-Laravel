import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'api_service.dart';
import 'home_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService api = ApiService();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _rememberMe = false;

  final Color _greenColor = const Color(0xFF41B77C);

  void _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Email dan Password harus diisi!"))
      );
      return;
    }

    setState(() => _isLoading = true);
    bool success = await api.login(_emailController.text, _passwordController.text);
    setState(() => _isLoading = false);

    if (success) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login Gagal! Cek email/password"), backgroundColor: Colors.red)
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Halo,", style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold)),
              Text("Silakan masuk kembali.", style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey)),
              SizedBox(height: 40),

              // INPUT EMAIL
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: 16),

              // INPUT PASSWORD
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: 10),

              // --- REMEMBER ME & LUPA PASSWORD (SUDAH DIPERBAIKI) ---
              Row(
                children: [
                  SizedBox(
                    height: 24, width: 24,
                    child: Checkbox(
                      value: _rememberMe,
                      activeColor: _greenColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      onChanged: (val) => setState(() => _rememberMe = val ?? false),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text("Remember me", style: GoogleFonts.poppins(color: Colors.grey[700])),
                  Spacer(),
                  TextButton(
                    onPressed: () {}, 
                    child: Text("Lupa Password?", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.grey))
                  )
                ],
              ),
              SizedBox(height: 24),

              // TOMBOL LOGIN
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _greenColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading 
                    ? CircularProgressIndicator(color: Colors.white) 
                    : Text("LOGIN", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
                ),
              ),
              SizedBox(height: 20),

              // TOMBOL DAFTAR
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Belum punya akun? ", style: GoogleFonts.poppins(color: Colors.grey)),
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterPage())),
                    child: Text("Daftar Sekarang", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: _greenColor)),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}