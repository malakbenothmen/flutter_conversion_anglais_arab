import 'package:flutter/material.dart';
import 'package:number_to_word_arabic/number_to_word_arabic.dart';
import 'package:number2words/number2words.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ConversionScreen(),
    );
  }
}

class ConversionScreen extends StatefulWidget {
  @override
  _ConversionScreenState createState() => _ConversionScreenState();
}

class _ConversionScreenState extends State<ConversionScreen> {
  final TextEditingController _controller = TextEditingController();
  String _result = '';


  void _convertArab() {
    if (_controller.text.isEmpty) {
      _showEmptyFieldAlert();
      return;}
    setState(() {
      List<String> parts = _controller.text.split('.');
      String integerPart =
      Tafqeet.convert(parts[0]); // Arabic number to words conversion
      String fractionalPart = '';

      if (parts.length > 1 && parts[1].isNotEmpty) {
        String fraction = parts[1].padRight(3, '0').substring(0, 3);
        fractionalPart = Tafqeet.convert(fraction); // Arabic fraction to words
      }

      _result = fractionalPart.isEmpty
          ? '$integerPart دينار'
          : '$integerPart دينار و $fractionalPart مليم';
    });
  }


  // Function to convert number to English words
  void _convertToEnglish() {
    setState(() {
      if (_controller.text.isEmpty) {
        _showEmptyFieldAlert(); // Appelle la fonction pour afficher l'alerte
        return;}
        List<String> parts = _controller.text.split('.');
      String intPart = Number2Words.convert(
          int.parse(parts[0]));
      String fractionalPart = '';

      if (parts.length > 1 && parts[1].isNotEmpty) {
        // Handle the fractional part, pad to ensure 3 digits
        String fraction = parts[1].padRight(3, '0').substring(0, 3);
        fractionalPart = Number2Words.convert(
            int.parse(fraction));
      }
      intPart = intPart.replaceAll('Dollars', '');
      fractionalPart = fractionalPart.replaceAll('Dollars', '');
      // Correct the unit to Dinars and Millimes
      _result = fractionalPart.isEmpty
          ? '$intPart Dinars'
          : '$intPart Dinars and $fractionalPart Millimes';
    });
  }

  void _showEmptyFieldAlert() {
    // Affiche une boîte de dialogue d'alerte
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Attention'),
          content: const Text('Le champ ne peut pas être vide.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Ferme la boîte de dialogue
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tp 2'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Conversion',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Entrez un nombre',
              ),
            ),
            const SizedBox(height: 20),

            // conver to araboc btn
            ElevatedButton(
              onPressed: _convertArab,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered)) {
                      return Colors.white; // Changer la couleur d'arrière-plan au survol
                    }
                    return Colors.purple; // Couleur par défaut
                  },
                ),
                foregroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered)) {
                      return Colors.purple; // Couleur du texte au survol
                    }
                    return Colors.white; // Couleur du texte par défaut
                  },
                ),
                minimumSize: MaterialStateProperty.all<Size>(
                  const Size(double.maxFinite, 50),
                ), // Largeur pleine
              ),
              child: const Text(
                'Convert to Arabic',
                style: TextStyle(fontWeight: FontWeight.bold), // Texte en gras
              ),
            ),

            const SizedBox(height: 10),

            // covert to english btn
            ElevatedButton(
              onPressed: _convertToEnglish,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered)) {
                      return Colors.purple; // Couleur de fond au survol
                    }
                    return Colors.black; // Couleur de fond par défaut
                  },
                ),
                foregroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered)) {
                      return Colors.black; // Couleur du texte au survol
                    }
                    return Colors.purple; // Couleur du texte par défaut
                  },
                ),
                minimumSize: MaterialStateProperty.all<Size>(
                  const Size(double.maxFinite, 50),
                ), // Largeur pleine
              ),
              child: const Text(
                'Convert to English',
                style: TextStyle(fontWeight: FontWeight.bold), // Texte en gras
              ),
            ),

            const SizedBox(height: 20),

            // Champ de résultat stylé
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200], // Couleur d'arrière-plan
                border: Border.all(color: Colors.purple, width: 2.0), // Contour violet
                borderRadius: BorderRadius.circular(8.0), // Bords arrondis
              ),
              child: Text(
                _result != null ? '$_result' : 'Aucun résultat',
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Couleur du texte
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
