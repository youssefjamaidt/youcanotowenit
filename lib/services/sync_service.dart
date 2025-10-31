import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/swimmer_model.dart';

class PrintService {
  // Imprimer la fiche d'un nageur
  static Future<void> printSwimmerProfile(Swimmer swimmer) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(level: 0, child: pw.Text('FICHE NAGEUR - ${swimmer.name}')),
              
              pw.SizedBox(height: 20),
              pw.Text('Informations Générales:', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text('Nom: ${swimmer.name}'),
              pw.Text('Date de naissance: ${swimmer.birthDate.toString().split(' ')[0]}'),
              pw.Text('Catégorie: ${swimmer.category}'),
              pw.Text('Club: ${swimmer.club}'),
              pw.Text('Entraîneur: ${swimmer.coach}'),
              
              pw.SizedBox(height: 20),
              pw.Text('Dernière mise à jour: ${swimmer.updatedAt.toString().split(' ')[0]}'),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  // Imprimer l'évaluation physique complète
  static Future<void> printPhysicalEvaluation(PhysicalEvaluation evaluation, Swimmer swimmer) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(level: 0, child: pw.Text('ÉVALUATION PHYSIQUE - ${swimmer.name}')),
              
              pw.SizedBox(height: 20),
              pw.Text('Date du test: ${evaluation.testDate.toString().split(' ')[0]}'),
              
              pw.SizedBox(height: 20),
              pw.Text('Données Physiques:', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.Text('Poids: ${evaluation.weight} kg'),
              pw.Text('Taille: ${evaluation.height} cm'),
              pw.Text('IMC: ${evaluation.bmi.toStringAsFixed(1)}'),
              pw.Text('Masse grasse: ${evaluation.bodyFat}%'),
              pw.Text('Masse musculaire: ${evaluation.muscleMass}%'),
              
              pw.SizedBox(height: 20),
              pw.Text('Tests de Force:', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.Text('Tractions: ${evaluation.pullUps} reps'),
              pw.Text('Pompes (1min): ${evaluation.pushUps}'),
              pw.Text('Gainage: ${evaluation.plankTime} sec'),
              pw.Text('Squat max: ${evaluation.squatMax} kg'),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
