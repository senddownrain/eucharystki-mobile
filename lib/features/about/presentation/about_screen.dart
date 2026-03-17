import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Пра праграму')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Мабільны Малітоўнік Эўхарыстак для чытання, пошуку, фільтрацыі і оффлайн-доступу да нататак і малітваў.',
        ),
      ),
    );
  }
}
