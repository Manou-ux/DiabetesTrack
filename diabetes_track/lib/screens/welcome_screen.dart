import 'dart:async';
import 'package:flutter/material.dart';
import 'main_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isLoading = true;
  bool _showButton = false;

  @override
  void initState() {
    super.initState();
    // Simule un chargement rapide avant d'afficher le bouton
    Timer(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _showButton = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131824), // Ton fond sombre global
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 3),
              
              // --- TITRE DESIGN DUPLICATE DE L'IMAGE ---
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 40,
                    letterSpacing: 1.2,
                  ),
                  children: [
                    TextSpan(
                      text: 'Diabetes',
                      style: TextStyle(
                        fontWeight: FontWeight.w300, // Fin
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(
                      text: 'Track',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF0FB2A0), // Ton teal
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 12),
              
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Suivi du Diabete: glycemie, medicament et alimentation',
                  textAlign: TextAlign.center, // <-- CORRIGÉ ICI
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: Colors.grey,
                  ),
                ),
              ),

              const Spacer(flex: 2),

              // --- LOGIQUE D'ANIMATION ET CHARGEMENT ---
              SizedBox(
                height: 60, // Espace fixe pour éviter les sauts de layout
                child: _isLoading
                    ? const Center(
                        child: SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0FB2A0)),
                          ),
                        ),
                      )
                    : null,
              ),

              // --- BOUTON COMMENCER APPARITION FLUIDE ---
              AnimatedOpacity(
                opacity: _showButton ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: _showButton
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: ElevatedButton(
                          onPressed: () { // <-- CORRIGÉ ICI (onPressed au lieu de onTap)
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const MainScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0FB2A0),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Commencer',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
              ),
              
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}