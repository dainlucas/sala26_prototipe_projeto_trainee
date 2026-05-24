import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'funcionalidades/configuracoes/dados/repositorio_local_do_perfil.dart';
import 'funcionalidades/sala/dados/repositorio_local_da_sala.dart';
import 'funcionalidades/sala/dominio/controlador_da_sala.dart';
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
  late Future<_DadosLocaisRestaurados> _dadosLocais;

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
        child: FutureBuilder<_DadosLocaisRestaurados>(
          future: _dadosLocais,
          builder: (contexto, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final dados = snapshot.data!;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: _SeletorRapidoDePerfil(
                        perfilSelecionado: dados.perfilSelecionado,
                        aoSelecionar: _selecionarPerfil,
                      ),
                    ),
                    const SizedBox(height: 12),
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
                              style: Theme.of(contexto).textTheme.bodyLarge
                                  ?.copyWith(
                                    color: esquemaDeCores.onPrimaryContainer,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _ResumoDosDadosRestaurados(
                      dados: dados,
                      aoPegarChaveNaPortaria: _pegarChaveNaPortaria,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _selecionarPerfil(String perfil) async {
    final repositorioDoPerfil = await RepositorioLocalDoPerfil.criar();
    await repositorioDoPerfil.salvarPerfilSelecionado(perfil);

    setState(() {
      _dadosLocais = _carregarDadosLocais();
    });
  }

  Future<void> _pegarChaveNaPortaria(_DadosLocaisRestaurados dados) async {
    final perfil = dados.perfilSelecionado?.trim();

    if (perfil == null || perfil.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Escolha um perfil antes de alterar a sala.'),
        ),
      );
      return;
    }

    final resultado = ControladorDaSala().pegarChaveNaPortaria(
      situacaoAtual: dados.situacao,
      pessoaLogada: perfil,
      momento: DateTime.now(),
    );

    if (resultado.sucesso) {
      final repositorioDaSala = await RepositorioLocalDaSala.criar();
      await repositorioDaSala.salvarSituacaoAtual(resultado.situacao);
      setState(() {
        _dadosLocais = _carregarDadosLocais();
      });
    }

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(resultado.mensagem)));
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

class _SeletorRapidoDePerfil extends StatelessWidget {
  const _SeletorRapidoDePerfil({
    required this.perfilSelecionado,
    required this.aoSelecionar,
  });

  static const perfisPreDefinidos = ['Lucas', 'Clara', 'Amanda', 'Vitor'];

  final String? perfilSelecionado;
  final ValueChanged<String> aoSelecionar;

  @override
  Widget build(BuildContext contexto) {
    final esquemaDeCores = Theme.of(contexto).colorScheme;

    return Wrap(
      spacing: 4,
      children: [
        for (final perfil in perfisPreDefinidos)
          IconButton.filledTonal(
            tooltip: 'Selecionar perfil $perfil',
            style: IconButton.styleFrom(
              backgroundColor: perfil == perfilSelecionado
                  ? esquemaDeCores.primaryContainer
                  : esquemaDeCores.surfaceContainerHighest,
              foregroundColor: perfil == perfilSelecionado
                  ? esquemaDeCores.onPrimaryContainer
                  : esquemaDeCores.onSurfaceVariant,
            ),
            onPressed: () => aoSelecionar(perfil),
            icon: Text(
              perfil.characters.first,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
      ],
    );
  }
}

class _ResumoDosDadosRestaurados extends StatelessWidget {
  const _ResumoDosDadosRestaurados({
    required this.dados,
    required this.aoPegarChaveNaPortaria,
  });

  final _DadosLocaisRestaurados dados;
  final Future<void> Function(_DadosLocaisRestaurados dados)
  aoPegarChaveNaPortaria;

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
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => aoPegarChaveNaPortaria(dados),
              child: const Text('Pegar chave na portaria'),
            ),
            const SizedBox(height: 16),
            _HistoricoDaSala(situacao: situacao),
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

class _HistoricoDaSala extends StatelessWidget {
  const _HistoricoDaSala({required this.situacao});

  final SituacaoDaSala situacao;

  @override
  Widget build(BuildContext contexto) {
    final eventosMaisRecentes = situacao.historico.reversed.toList();
    final estiloDoTitulo = Theme.of(contexto).textTheme.titleMedium;
    final estiloDeApoio = Theme.of(contexto).textTheme.bodySmall;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Histórico da sala', style: estiloDoTitulo),
        const SizedBox(height: 8),
        if (eventosMaisRecentes.isEmpty)
          const _EstadoVazioDoHistorico()
        else
          for (final evento in eventosMaisRecentes) ...[
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(evento.descricao),
              subtitle: Text(_formatarMomento(evento.momento)),
              trailing: Text(
                evento.pessoa,
                style: estiloDeApoio?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            if (evento != eventosMaisRecentes.last) const Divider(height: 1),
          ],
      ],
    );
  }

  String _formatarMomento(DateTime momento) {
    final dia = _doisDigitos(momento.day);
    final mes = _doisDigitos(momento.month);
    final ano = momento.year.toString();
    final hora = _doisDigitos(momento.hour);
    final minuto = _doisDigitos(momento.minute);

    return '$dia/$mes/$ano às $hora:$minuto';
  }

  String _doisDigitos(int valor) {
    return valor.toString().padLeft(2, '0');
  }
}

class _EstadoVazioDoHistorico extends StatelessWidget {
  const _EstadoVazioDoHistorico();

  @override
  Widget build(BuildContext contexto) {
    final estiloDeTexto = Theme.of(contexto).textTheme.bodyMedium;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ainda não há movimentações registradas.',
          style: estiloDeTexto?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        const Text(
          'Quando alguém mexer na chave, a movimentação aparecerá aqui.',
        ),
      ],
    );
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
