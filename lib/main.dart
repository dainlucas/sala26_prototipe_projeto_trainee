import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: AplicativoChave26()));
}

class AplicativoChave26 extends StatelessWidget {
  const AplicativoChave26({super.key});

  @override
  Widget build(BuildContext contexto) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chave 26',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C3DF4),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const TelaInicialChave26(),
    );
  }
}

class TelaInicialChave26 extends StatelessWidget {
  const TelaInicialChave26({super.key});

  @override
  Widget build(BuildContext contexto) {
    final esquemaDeCores = Theme.of(contexto).colorScheme;

    return Scaffold(
      backgroundColor: esquemaDeCores.surface,
      appBar: AppBar(title: const Text('Chave 26'), centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 0,
                color: esquemaDeCores.primaryContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Image.asset(
                        'recursos/imagens/mascote_prototipe.png',
                        height: 120,
                        semanticLabel: 'Mascote da Prototipe',
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Sala 26',
                        style: Theme.of(contexto).textTheme.headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: esquemaDeCores.onPrimaryContainer,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'MVP local para acompanhar a chave da Prototipe',
                        textAlign: TextAlign.center,
                        style: Theme.of(contexto).textTheme.bodyLarge?.copyWith(
                          color: esquemaDeCores.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Próximo passo: implementar perfis locais, estado da sala e histórico.',
                textAlign: TextAlign.center,
                style: Theme.of(contexto).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
