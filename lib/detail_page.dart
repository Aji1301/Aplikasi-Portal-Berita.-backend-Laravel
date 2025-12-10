import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'api_service.dart';

class DetailPage extends StatefulWidget {
  final dynamic newsData;
  DetailPage({required this.newsData});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final TextEditingController _commentController = TextEditingController();
  final ApiService api = ApiService();
  
  // Variabel untuk menampung komentar
  List<dynamic> comments = [];
  bool isPosting = false; 

  @override
  void initState() {
    super.initState();
    // Masukkan data komentar awal dari halaman Home saat pertama dibuka
    if (widget.newsData['comments'] != null) {
      comments = widget.newsData['comments'];
    }
  }

  // --- FUNGSI 1: Refresh Data dari Server ---
  void _refreshComments() async {
    // Minta data terbaru berita ini ke server
    var updatedNews = await api.getNewsById(widget.newsData['id']);
    
    if (updatedNews != null) {
      setState(() {
        // Update list komentar di layar dengan yang baru
        comments = updatedNews['comments']; 
      });
    }
  }

  // --- FUNGSI 2: Kirim Komentar ---
  void _submitComment() async {
    if (_commentController.text.isEmpty) return;

    setState(() => isPosting = true); // Loading nyala

    bool success = await api.postComment(widget.newsData['id'], _commentController.text);
    
    setState(() => isPosting = false); // Loading mati

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Komentar terkirim!")));
      _commentController.clear(); 
      
      // Panggil fungsi refresh biar komentar langsung muncul tanpa reload
      _refreshComments(); 
      
    } else {
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal! Pastikan sudah LOGIN.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // --- HEADER GAMBAR & TOMBOL KEMBALI ---
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                backgroundColor: Colors.black,
                
                // TOMBOL KEMBALI (BACK)
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.black45, // Background transparan biar ikon jelas
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context); // Perintah kembali ke Home
                      },
                    ),
                  ),
                ),

                flexibleSpace: FlexibleSpaceBar(
                  background: Opacity(
                    opacity: 0.8,
                    child: Image.network(
                      widget.newsData['image_url'] ?? 'https://picsum.photos/400/300',
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, _, __) => Container(color: Colors.grey, child: Icon(Icons.broken_image)),
                    ),
                  ),
                ),
              ),

              // --- ISI BERITA & LIST KOMENTAR ---
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Judul & Konten
                      Text(widget.newsData['title'], style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.bold)),
                      SizedBox(height: 16),
                      Text(widget.newsData['content'], style: GoogleFonts.poppins(fontSize: 16, height: 1.8, color: Colors.grey[800])),
                      SizedBox(height: 40),
                      Divider(thickness: 1),
                      
                      // Header Komentar
                      Row(
                        children: [
                          Text("Komentar", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(width: 8),
                          Chip(label: Text("${comments.length}"), backgroundColor: Colors.blue[50]),
                        ],
                      ),
                      SizedBox(height: 16),
                      
                      // Tampilan jika belum ada komentar
                      if(comments.isEmpty) 
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text("Belum ada komentar. Jadilah yang pertama!", style: GoogleFonts.poppins(color: Colors.grey)),
                        ),
                      
                      // List Komentar (Looping)
                      ...comments.map((c) => Container(
                        margin: EdgeInsets.only(bottom: 16),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(12)),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 12, 
                                      backgroundColor: Colors.blue, 
                                      child: Text(c['user']['name'][0], style: TextStyle(fontSize: 12, color: Colors.white))
                                    ),
                                    SizedBox(width: 8),
                                    Text(c['user']['name'], style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14)),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Text(c['comment'], style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87)),
                            ]
                        ),
                      )).toList(),
                      
                      SizedBox(height: 100), // Ruang kosong biar list tidak tertutup input
                    ],
                  ),
                ),
              )
            ],
          ),
          
          // --- INPUT FILED (Di Bawah Layar) ---
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12, offset: Offset(0, -5))],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: "Tulis pendapatmu...",
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: isPosting 
                      ? Padding(padding: EdgeInsets.all(10), child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : IconButton(
                          icon: Icon(Icons.send, color: Colors.white, size: 20),
                          onPressed: _submitComment,
                        ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}