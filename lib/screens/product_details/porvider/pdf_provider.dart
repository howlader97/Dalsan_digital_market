import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

final pdfProvider = Provider((ref) => PdfService());

class PdfService {

  Future<File> generatePdf({
    required String title,
    required String price,
    required String description,
    required String imageUrl,
  }) async {

    final pdf = pw.Document();

    // image download
    final response = await http.get(Uri.parse(imageUrl));
    Uint8List imageBytes = response.bodyBytes;

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [

              pw.Image(pw.MemoryImage(imageBytes), height: 200),

              pw.SizedBox(height: 20),

              pw.Text(title, style: pw.TextStyle(fontSize: 24)),

              pw.SizedBox(height: 10),

              pw.Text("Price: $price", style: pw.TextStyle(fontSize: 18)),

              pw.SizedBox(height: 10),

              pw.Text(description, style: pw.TextStyle(fontSize: 14)),
            ],
          );
        },
      ),
    );

    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/product.pdf");

    await file.writeAsBytes(await pdf.save());

    return file;
  }

  Future<void> shareToWhatsApp(File file) async {
    await Share.shareXFiles(
      [XFile(file.path)],
      text: "Hello, I want to order this product",
    );
  }
}