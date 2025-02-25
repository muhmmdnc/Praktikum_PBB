import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditBook extends StatefulWidget {
  final String id;
  final String judul;
  final String penulis;
  final String tahunTerbit;

  const EditBook({super.key, 
    required this.id,
    required this.judul,
    required this.penulis,
    required this.tahunTerbit,
  });

  @override
  _EditBookState createState() => _EditBookState();
}

class _EditBookState extends State<EditBook> {
  late TextEditingController _judulController;
  late TextEditingController _penulisController;
  late TextEditingController _tahunTerbitController;

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController(text: widget.judul);
    _penulisController = TextEditingController(text: widget.penulis);
    _tahunTerbitController = TextEditingController(text: widget.tahunTerbit);
  }

  @override
  void dispose() {
    _judulController.dispose();
    _penulisController.dispose();
    _tahunTerbitController.dispose();
    super.dispose();
  }

  Future<void> updateBook() async {
    final response = await http.post(
      Uri.parse('http://localhost/CRUD_API/edit_data.php'), // Replace with your API URL
      body: {
        'id': widget.id,
        'judul': _judulController.text,
        'penulis': _penulisController.text,
        'tahun_terbit': _tahunTerbitController.text,
      },
    );

    if (response.statusCode == 200) {
      // Successfully updated
      Navigator.pop(context, true); // Return to the book list after successful update
    } else {
      // Show error message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Failed to update the book. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Buku'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _judulController,
              decoration: const InputDecoration(
                labelText: 'Judul Buku',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _penulisController,
              decoration: const InputDecoration(
                labelText: 'Penulis Buku',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _tahunTerbitController,
              decoration: const InputDecoration(
                labelText: 'Tahun Terbit',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: updateBook,
                child: const Text('Simpan Perubahan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
