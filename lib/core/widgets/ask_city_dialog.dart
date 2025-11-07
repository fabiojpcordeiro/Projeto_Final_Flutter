import 'package:flutter/material.dart';

Future<String?> showCityDialog(BuildContext context) async {
    final cityController = TextEditingController();

    return await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Digite sua cidade: '),
          content: TextField(
            controller: cityController,
            decoration: const InputDecoration(
              labelText: 'Digite sua cidade para ver vagas',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final city = cityController.text.trim();
                if (city.isNotEmpty) {
                  Navigator.of(context).pop(city);
                }
              },
              child: Text('Buscar'),
            ),
          ],
        );
      },
    );
  }