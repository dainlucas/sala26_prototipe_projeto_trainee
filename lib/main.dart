import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'funcionalidades/configuracoes/dados/repositorio_local_do_perfil.dart';
import 'funcionalidades/sala/dados/repositorio_local_da_sala.dart';
import 'funcionalidades/sala/dominio/estado_da_sala.dart';
import 'funcionalidades/sala/dominio/localizacao_da_chave.dart';
import 'funcionalidades/sala/dominio/situacao_da_sala.dart';

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

class TelaInicialChave26 extends StatefulWidget {
  const TelaInicialChave26({super.key});

  @override
  State<TelaInicialChave26> createState() => _TelaInicialChave26State();
}

class _TelaInicialChave26State extends State<TelaInicialChave26> {
  late final Future<_DadosLocaisRestaurados> _dadosLocais;

  @override
  void initState() {
    super.initState();
    _dadosLocais = _carregarDadosLocais();
  }

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
              FutureBuilder<_DadosLocaisRestaurados>(
                future: _dadosLocais,
                builder: (contexto, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return _ResumoDosDadosRestaurados(dados: snapshot.data!);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<_DadosLocaisRestaurados> _carregarDadosLocais() async {
    final repositorioDaSala = await RepositorioLocalDaSala.criar();
    final repositorioDoPerfil = await RepositorioLocalDoPerfil.criar();

    final situacao = await repositorioDaSala.carregarSituacaoAtual();
    final perfilSelecionado = await repositorioDoPerfil
        .carregarPerfilSelecionado();

    return _DadosLocaisRestaurados(
      perfilSelecionado: perfilSelecionado,
      situacao: situacao,
    );
  }
}

class _ResumoDosDadosRestaurados extends StatelessWidget {
  const _ResumoDosDadosRestaurados({required this.dados});

  final _DadosLocaisRestaurados dados;

  @override
  Widget build(BuildContext contexto) {
    final situacao = dados.situacao;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dados locais restaurados',
              style: Theme.of(contexto).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text('Perfil salvo: ${dados.perfilSelecionado ?? 'nenhum'}'),
            Text(_textoDoEstado(situacao.estado)),
            Text(_textoDaLocalizacao(situacao.localizacaoDaChave)),
            Text(_textoDoHistorico(situacao.historico.length)),
          ],
        ),
      ),
    );
  }

  String _textoDoEstado(EstadoDaSala estado) {
    return switch (estado) {
      EstadoDaSala.aberta => 'Sala aberta',
      EstadoDaSala.fechada => 'Sala fechada',
    };
  }

  String _textoDaLocalizacao(LocalizacaoDaChave localizacao) {
    return switch (localizacao.tipo) {
      TipoLocalizacaoDaChave.portaria => 'Chave na portaria',
      TipoLocalizacaoDaChave.sala => 'Chave na sala',
      TipoLocalizacaoDaChave.pessoa =>
        'Chave com ${localizacao.nomeDaPessoa ?? 'alguém'}',
    };
  }

  String _textoDoHistorico(int quantidade) {
    if (quantidade == 1) {
      return 'Histórico: 1 registro';
    }

    return 'Histórico: $quantidade registros';
  }
}

class _DadosLocaisRestaurados {
  const _DadosLocaisRestaurados({
    required this.perfilSelecionado,
    required this.situacao,
  });

  final String? perfilSelecionado;
  final SituacaoDaSala situacao;
}
