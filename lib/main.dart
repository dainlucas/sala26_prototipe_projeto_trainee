import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'funcionalidades/configuracoes/dados/repositorio_local_do_perfil.dart';
import 'funcionalidades/sala/dados/repositorio_local_da_sala.dart';
import 'funcionalidades/sala/dominio/controlador_da_sala.dart';
import 'funcionalidades/sala/dominio/estado_da_sala.dart';
import 'funcionalidades/sala/dominio/evento_historico.dart';
import 'funcionalidades/sala/dominio/localizacao_da_chave.dart';
import 'funcionalidades/sala/dominio/situacao_da_sala.dart';

void main() {
  runApp(const ProviderScope(child: AplicativoChave26()));
}

class CoresPrototipe {
  static const azulCiano = Color(0xFF0397DD);
  static const azulMarinho = Color(0xFF060D5B);
  static const roxo = Color(0xFF444EDB);
  static const superficie = Color(0xFFF8FAFD);
  static const superficieCard = Color(0xFFFFFFFF);
  static const superficieContainer = Color(0xFFECEEF3);
  static const superficieContainerAlta = Color(0xFFE6E8ED);
  static const textoPrincipal = Color(0xFF191C20);
  static const textoSecundario = Color(0xFF42474E);
  static const contornoSuave = Color(0xFFC2C7CE);
  static const containerPrimario = Color(0xFFC8E6FF);
  static const textoContainerPrimario = Color(0xFF001E2F);
  static const containerSecundario = Color(0xFFD2E5F5);
  static const textoContainerSecundario = Color(0xFF0B1D29);
  static const containerTerciario = Color(0xFFDFE0FF);
  static const textoContainerTerciario = Color(0xFF00105C);
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
          seedColor: CoresPrototipe.azulCiano,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: CoresPrototipe.superficie,
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
  int _indiceDaAba = 0;

  @override
  void initState() {
    super.initState();
    _dadosLocais = _carregarDadosLocais();
  }

  @override
  Widget build(BuildContext contexto) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<_DadosLocaisRestaurados>(
          future: _dadosLocais,
          builder: (contexto, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final dados = snapshot.data!;

            return Column(
              children: [
                _CabecalhoChave26(
                  perfilSelecionado: dados.perfilSelecionado,
                  aoTrocarPerfil: () => _mostrarTrocaDePerfil(dados),
                ),
                Expanded(
                  child: IndexedStack(
                    index: _indiceDaAba,
                    children: [
                      _AbaInicio(
                        dados: dados,
                        aoPegarChaveNaPortaria: _pegarChaveNaPortaria,
                        aoAbrirSala: _abrirSala,
                        aoFecharSala: _fecharSala,
                        aoGuardarChave: _guardarChave,
                        aoPassarChaveParaOutraPessoa:
                            _passarChaveParaOutraPessoa,
                      ),
                      _AbaHistorico(
                        dados: dados,
                        aoLimparHistorico: _limparHistorico,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indiceDaAba,
        onDestinationSelected: (indice) {
          setState(() {
            _indiceDaAba = indice;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            label: 'Histórico',
          ),
        ],
      ),
    );
  }

  Future<void> _mostrarTrocaDePerfil(_DadosLocaisRestaurados dados) async {
    final perfil = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (contextoDoSheet) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Trocar perfil',
                  style: Theme.of(
                    contextoDoSheet,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                for (final perfil in _perfisPreDefinidos)
                  ListTile(
                    leading: _AvatarDePerfil(
                      nome: perfil,
                      selecionado: perfil == dados.perfilSelecionado,
                    ),
                    title: Text(perfil),
                    selected: perfil == dados.perfilSelecionado,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    onTap: () => Navigator.of(contextoDoSheet).pop(perfil),
                    trailing: perfil == dados.perfilSelecionado
                        ? const Icon(Icons.check)
                        : null,
                  ),
              ],
            ),
          ),
        );
      },
    );

    if (perfil != null) {
      await _selecionarPerfil(perfil);
    }
  }

  Future<void> _selecionarPerfil(String perfil) async {
    final repositorioDoPerfil = await RepositorioLocalDoPerfil.criar();
    await repositorioDoPerfil.salvarPerfilSelecionado(perfil);

    setState(() {
      _dadosLocais = _carregarDadosLocais();
    });
  }

  Future<void> _pegarChaveNaPortaria(_DadosLocaisRestaurados dados) async {
    final perfil = _perfilObrigatorio(dados);
    if (perfil == null) {
      return;
    }

    final resultado = ControladorDaSala().pegarChaveNoLocal(
      situacaoAtual: dados.situacao,
      pessoaLogada: perfil,
      momento: DateTime.now(),
    );

    await _aplicarResultadoDaAcao(resultado);
  }

  Future<void> _abrirSala(_DadosLocaisRestaurados dados) async {
    final perfil = _perfilObrigatorio(dados);
    if (perfil == null) {
      return;
    }

    final resultado = ControladorDaSala().abrirSala(
      situacaoAtual: dados.situacao,
      pessoaLogada: perfil,
      momento: DateTime.now(),
    );

    await _aplicarResultadoDaAcao(resultado);
  }

  Future<void> _fecharSala(_DadosLocaisRestaurados dados) async {
    final perfil = _perfilObrigatorio(dados);
    if (perfil == null) {
      return;
    }

    final resultado = ControladorDaSala().fecharSalaComChaveComigo(
      situacaoAtual: dados.situacao,
      pessoaLogada: perfil,
      momento: DateTime.now(),
    );

    await _aplicarResultadoDaAcao(resultado);
  }

  Future<void> _guardarChave(_DadosLocaisRestaurados dados) async {
    final perfil = _perfilObrigatorio(dados);
    if (perfil == null) {
      return;
    }

    final destino = await _escolherDestinoDaChave(dados);
    if (destino == null) {
      return;
    }

    final resultado = ControladorDaSala().guardarChaveEmDestino(
      situacaoAtual: dados.situacao,
      pessoaLogada: perfil,
      destino: destino,
      momento: DateTime.now(),
    );

    await _aplicarResultadoDaAcao(resultado);
  }

  Future<String?> _escolherDestinoDaChave(_DadosLocaisRestaurados dados) {
    return showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (contextoDoSheet) {
        var destinos = List<String>.from(dados.destinosDaChave);

        Future<void> recarregar(StateSetter setSheetState) async {
          final repositorio = await RepositorioLocalDaSala.criar();
          final destinosAtualizados = await repositorio
              .carregarDestinosDaChave();
          if (!contextoDoSheet.mounted) {
            return;
          }
          setSheetState(() {
            destinos = destinosAtualizados;
          });
          if (!mounted) {
            return;
          }
          setState(() {
            _dadosLocais = _carregarDadosLocais();
          });
        }

        return StatefulBuilder(
          builder: (contextoDoSheet, setSheetState) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Onde você vai guardar a chave?',
                        style: Theme.of(contextoDoSheet).textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      for (final destino in destinos)
                        ListTile(
                          leading: const Icon(Icons.place_outlined),
                          title: Text(destino),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          onTap: () =>
                              Navigator.of(contextoDoSheet).pop(destino),
                          trailing:
                              RepositorioLocalDaSala.destinosFixosDaChave
                                  .contains(destino)
                              ? null
                              : Wrap(
                                  children: [
                                    IconButton(
                                      tooltip: 'Renomear $destino',
                                      icon: const Icon(Icons.edit_outlined),
                                      onPressed: () async {
                                        final novoDestino =
                                            await _pedirNomeDestino(
                                              titulo: 'Renomear destino',
                                              valorInicial: destino,
                                            );
                                        if (novoDestino == null) {
                                          return;
                                        }
                                        final repositorio =
                                            await RepositorioLocalDaSala.criar();
                                        await repositorio
                                            .renomearDestinoCustomizado(
                                              destino,
                                              novoDestino,
                                            );
                                        await recarregar(setSheetState);
                                      },
                                    ),
                                    IconButton(
                                      tooltip: 'Apagar $destino',
                                      icon: const Icon(Icons.delete_outline),
                                      onPressed: () async {
                                        final repositorio =
                                            await RepositorioLocalDaSala.criar();
                                        await repositorio
                                            .removerDestinoCustomizado(destino);
                                        await recarregar(setSheetState);
                                      },
                                    ),
                                  ],
                                ),
                        ),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: () async {
                          final novoDestino = await _pedirNomeDestino(
                            titulo: 'Adicionar novo local',
                          );
                          if (novoDestino == null) {
                            return;
                          }
                          final repositorio =
                              await RepositorioLocalDaSala.criar();
                          await repositorio.adicionarDestinoCustomizado(
                            novoDestino,
                          );
                          await recarregar(setSheetState);
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Adicionar novo local'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<String?> _pedirNomeDestino({
    required String titulo,
    String? valorInicial,
  }) {
    final controlador = TextEditingController(text: valorInicial);
    return showDialog<String>(
      context: context,
      builder: (contextoDoDialogo) {
        return AlertDialog(
          title: Text(titulo),
          content: TextField(
            controller: controlador,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Nome do local',
              hintText: 'Ex: Biblioteca ou Maker Space',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(contextoDoDialogo).pop(),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                final nome = controlador.text.trim();
                Navigator.of(contextoDoDialogo).pop(nome.isEmpty ? null : nome);
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _passarChaveParaOutraPessoa(
    _DadosLocaisRestaurados dados, [
    String? destinoInicial,
  ]) async {
    final perfil = _perfilObrigatorio(dados);
    if (perfil == null) {
      return;
    }

    final destino = destinoInicial ?? await _escolherPessoaDestino(perfil);
    if (destino == null) {
      return;
    }

    if (!mounted) {
      return;
    }

    final confirmou = await showDialog<bool>(
      context: context,
      builder: (contextoDoDialogo) {
        return AlertDialog(
          title: const Text('Confirmar passagem da chave'),
          content: Text(
            'Você confirma que $perfil está passando a chave para $destino?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(contextoDoDialogo).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(contextoDoDialogo).pop(true),
              child: const Text('Confirmar transferência'),
            ),
          ],
        );
      },
    );

    if (confirmou != true) {
      return;
    }

    final resultado = ControladorDaSala().passarChaveParaOutraPessoa(
      situacaoAtual: dados.situacao,
      pessoaLogada: perfil,
      outraPessoa: destino,
      momento: DateTime.now(),
    );

    await _aplicarResultadoDaAcao(resultado);
  }

  Future<String?> _escolherPessoaDestino(String perfil) {
    return showDialog<String>(
      context: context,
      builder: (contextoDoDialogo) {
        final perfisDisponiveis = _perfisPreDefinidos
            .where((pessoa) => pessoa != perfil)
            .toList();

        return SimpleDialog(
          title: const Text('Escolha quem vai receber a chave'),
          children: [
            for (final pessoa in perfisDisponiveis)
              SimpleDialogOption(
                onPressed: () => Navigator.of(contextoDoDialogo).pop(pessoa),
                child: Text(pessoa),
              ),
            SimpleDialogOption(
              onPressed: () => Navigator.of(contextoDoDialogo).pop(),
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  String? _perfilObrigatorio(_DadosLocaisRestaurados dados) {
    final perfil = dados.perfilSelecionado?.trim();

    if (perfil == null || perfil.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Escolha um perfil antes de registrar uma movimentação.',
          ),
        ),
      );
      return null;
    }

    return perfil;
  }

  Future<void> _aplicarResultadoDaAcao(ResultadoAcaoDaSala resultado) async {
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

  Future<void> _limparHistorico(_DadosLocaisRestaurados dados) async {
    final repositorioDaSala = await RepositorioLocalDaSala.criar();
    await repositorioDaSala.salvarSituacaoAtual(
      dados.situacao.copiarCom(historico: []),
    );

    setState(() {
      _dadosLocais = _carregarDadosLocais();
    });

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Histórico apagado para a demonstração.')),
    );
  }

  Future<_DadosLocaisRestaurados> _carregarDadosLocais() async {
    final repositorioDaSala = await RepositorioLocalDaSala.criar();
    final repositorioDoPerfil = await RepositorioLocalDoPerfil.criar();

    final situacao = await repositorioDaSala.carregarSituacaoAtual();
    final destinosDaChave = await repositorioDaSala.carregarDestinosDaChave();
    final perfilSelecionado = await repositorioDoPerfil
        .carregarPerfilSelecionado();

    return _DadosLocaisRestaurados(
      perfilSelecionado: perfilSelecionado,
      situacao: situacao,
      destinosDaChave: destinosDaChave,
    );
  }
}

class _CabecalhoChave26 extends StatelessWidget {
  const _CabecalhoChave26({
    required this.perfilSelecionado,
    required this.aoTrocarPerfil,
  });

  final String? perfilSelecionado;
  final VoidCallback aoTrocarPerfil;

  @override
  Widget build(BuildContext contexto) {
    final nome = perfilSelecionado?.trim();
    final temPerfil = nome != null && nome.isNotEmpty;

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: CoresPrototipe.superficie,
        border: Border(
          bottom: BorderSide(color: CoresPrototipe.contornoSuave, width: 0.6),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: CoresPrototipe.contornoSuave),
              ),
              child: Transform.scale(
                scale: 1.18,
                child: Image.asset(
                  'recursos/imagens/logo.png',
                  semanticLabel: 'Logo da Prototipe',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chave 26',
                    style: TextStyle(
                      color: CoresPrototipe.textoPrincipal,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Prototipe',
                    style: TextStyle(
                      color: CoresPrototipe.textoSecundario,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Tooltip(
              message: 'Trocar perfil',
              child: FilledButton.tonalIcon(
                onPressed: aoTrocarPerfil,
                icon: _AvatarDePerfil(nome: nome ?? '?', selecionado: true),
                label: Text(temPerfil ? nome : 'Escolher perfil'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.only(left: 6, right: 10),
                  minimumSize: const Size(0, 44),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AbaInicio extends StatelessWidget {
  const _AbaInicio({
    required this.dados,
    required this.aoPegarChaveNaPortaria,
    required this.aoAbrirSala,
    required this.aoFecharSala,
    required this.aoGuardarChave,
    required this.aoPassarChaveParaOutraPessoa,
  });

  final _DadosLocaisRestaurados dados;
  final Future<void> Function(_DadosLocaisRestaurados dados)
  aoPegarChaveNaPortaria;
  final Future<void> Function(_DadosLocaisRestaurados dados) aoAbrirSala;
  final Future<void> Function(_DadosLocaisRestaurados dados) aoFecharSala;
  final Future<void> Function(_DadosLocaisRestaurados dados) aoGuardarChave;
  final Future<void> Function(_DadosLocaisRestaurados dados, [String? destino])
  aoPassarChaveParaOutraPessoa;

  @override
  Widget build(BuildContext contexto) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CardStatusDaSala(situacao: dados.situacao),
            const SizedBox(height: 24),
            _AcoesRapidasDaSala(
              dados: dados,
              aoPegarChaveNaPortaria: aoPegarChaveNaPortaria,
              aoAbrirSala: aoAbrirSala,
              aoFecharSala: aoFecharSala,
              aoGuardarChave: aoGuardarChave,
              aoPassarChaveParaOutraPessoa: aoPassarChaveParaOutraPessoa,
            ),
            const SizedBox(height: 24),
            _HistoricoDaSala(
              situacao: dados.situacao,
              titulo: 'Histórico recente',
              limite: 3,
            ),
          ],
        ),
      ),
    );
  }
}

class _AbaHistorico extends StatelessWidget {
  const _AbaHistorico({required this.dados, required this.aoLimparHistorico});

  final _DadosLocaisRestaurados dados;
  final Future<void> Function(_DadosLocaisRestaurados dados) aoLimparHistorico;

  @override
  Widget build(BuildContext contexto) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _HistoricoDaSala(
              situacao: dados.situacao,
              titulo: 'Histórico de movimentações',
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: dados.situacao.historico.isEmpty
                    ? null
                    : () => aoLimparHistorico(dados),
                icon: const Icon(Icons.delete_sweep_outlined, size: 18),
                label: const Text('Limpar histórico da demo'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardStatusDaSala extends StatelessWidget {
  const _CardStatusDaSala({required this.situacao});

  final SituacaoDaSala situacao;

  @override
  Widget build(BuildContext contexto) {
    final aberta = situacao.estado == EstadoDaSala.aberta;

    return _SuperficieElevada(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: aberta
                      ? CoresPrototipe.containerPrimario
                      : CoresPrototipe.containerSecundario,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.key,
                  color: aberta
                      ? CoresPrototipe.textoContainerPrimario
                      : CoresPrototipe.textoContainerSecundario,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sala 26',
                      style: TextStyle(
                        color: CoresPrototipe.textoSecundario,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      aberta ? 'Aberta' : 'Fechada',
                      style: const TextStyle(
                        color: CoresPrototipe.textoPrincipal,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: aberta
                      ? CoresPrototipe.azulCiano
                      : CoresPrototipe.textoSecundario,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  aberta ? 'Ativa' : 'Inativa',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 22),
            child: Divider(height: 1, color: CoresPrototipe.contornoSuave),
          ),
          _LinhaDeInformacao(
            icone: Icons.person_outline,
            rotulo: 'Chave com',
            valor: _textoDeResponsavelDaChave(situacao),
          ),
          const SizedBox(height: 16),
          _LinhaDeInformacao(
            icone: Icons.location_on_outlined,
            rotulo: 'Localização',
            valor: _textoDaLocalizacao(situacao.localizacaoDaChave),
          ),
          const SizedBox(height: 16),
          _LinhaDeInformacao(
            icone: Icons.schedule_outlined,
            rotulo: 'Última atualização',
            valor: _formatarAtualizacao(situacao.atualizadaEm),
          ),
        ],
      ),
    );
  }
}

class _LinhaDeInformacao extends StatelessWidget {
  const _LinhaDeInformacao({
    required this.icone,
    required this.rotulo,
    required this.valor,
  });

  final IconData icone;
  final String rotulo;
  final String valor;

  @override
  Widget build(BuildContext contexto) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: CoresPrototipe.superficieContainerAlta,
            shape: BoxShape.circle,
          ),
          child: Icon(icone, color: CoresPrototipe.textoSecundario, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                rotulo,
                style: const TextStyle(
                  color: CoresPrototipe.textoSecundario,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                valor,
                style: const TextStyle(
                  color: CoresPrototipe.textoPrincipal,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AcoesRapidasDaSala extends StatelessWidget {
  const _AcoesRapidasDaSala({
    required this.dados,
    required this.aoPegarChaveNaPortaria,
    required this.aoAbrirSala,
    required this.aoFecharSala,
    required this.aoGuardarChave,
    required this.aoPassarChaveParaOutraPessoa,
  });

  final _DadosLocaisRestaurados dados;
  final Future<void> Function(_DadosLocaisRestaurados dados)
  aoPegarChaveNaPortaria;
  final Future<void> Function(_DadosLocaisRestaurados dados) aoAbrirSala;
  final Future<void> Function(_DadosLocaisRestaurados dados) aoFecharSala;
  final Future<void> Function(_DadosLocaisRestaurados dados) aoGuardarChave;
  final Future<void> Function(_DadosLocaisRestaurados dados, [String? destino])
  aoPassarChaveParaOutraPessoa;

  @override
  Widget build(BuildContext contexto) {
    final situacao = dados.situacao;
    final perfil = dados.perfilSelecionado?.trim();
    final temPerfil = perfil != null && perfil.isNotEmpty;
    final chaveNaPortaria = situacao.localizacaoDaChave.estaNaPortaria;
    final chaveEmDestino = situacao.localizacaoDaChave.estaGuardadaEmDestino;
    final chaveDisponivelEmLocal = chaveNaPortaria || chaveEmDestino;
    final chaveComPerfil =
        temPerfil && situacao.localizacaoDaChave.estaCom(perfil);
    final chaveComOutraPessoa =
        temPerfil &&
        situacao.localizacaoDaChave.estaComPessoa &&
        !chaveComPerfil;
    final salaAberta = situacao.estado == EstadoDaSala.aberta;
    final responsavelPelaSalaAberta =
        temPerfil &&
        salaAberta &&
        situacao.localizacaoDaChave.estaNaSala &&
        situacao.pessoaUltimaAtualizacao == perfil;
    final podeTransferirChave = chaveComPerfil || responsavelPelaSalaAberta;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'O que você quer fazer agora?',
            style: TextStyle(
              color: CoresPrototipe.textoSecundario,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (!temPerfil)
          const _AvisoDeEstado(
            texto: 'Escolha quem está usando o app para liberar as ações.',
          )
        else if (chaveDisponivelEmLocal)
          _BotaoAcaoPrincipal(
            icone: Icons.key,
            texto: chaveNaPortaria
                ? 'Pegar chave na portaria'
                : 'Pegar chave em ${situacao.localizacaoDaChave.nomeDoDestino ?? 'destino'}',
            aoPressionar: () => aoPegarChaveNaPortaria(dados),
          )
        else if (chaveComPerfil)
          Row(
            children: [
              Expanded(
                child: _BotaoAcaoPrincipal(
                  icone: Icons.place_outlined,
                  texto: 'Guardar chave',
                  aoPressionar: () => aoGuardarChave(dados),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _BotaoAcaoPrincipal(
                  icone: salaAberta
                      ? Icons.door_back_door_outlined
                      : Icons.meeting_room_outlined,
                  texto: salaAberta ? 'Fechar sala' : 'Abrir sala',
                  aoPressionar: () =>
                      salaAberta ? aoFecharSala(dados) : aoAbrirSala(dados),
                ),
              ),
            ],
          )
        else if (responsavelPelaSalaAberta)
          _BotaoAcaoPrincipal(
            icone: Icons.door_back_door_outlined,
            texto: 'Fechar sala',
            aoPressionar: () => aoFecharSala(dados),
          )
        else if (chaveComOutraPessoa)
          _AvisoDeEstado(
            texto:
                'A chave está com ${situacao.localizacaoDaChave.nomeDaPessoa}. '
                'Apenas ${situacao.localizacaoDaChave.nomeDaPessoa} pode guardar ou passar a chave.',
          ),
        if (podeTransferirChave) ...[
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              'Passar a chave para',
              style: TextStyle(
                color: CoresPrototipe.textoSecundario,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => aoPassarChaveParaOutraPessoa(dados),
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Escolher pessoa'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final pessoa in _perfisPreDefinidos.where(
                  (pessoa) => pessoa != perfil,
                ))
                  Padding(
                    padding: const EdgeInsets.only(right: 14),
                    child: _AtalhoDeTransferencia(
                      nome: pessoa,
                      aoPressionar: () =>
                          aoPassarChaveParaOutraPessoa(dados, pessoa),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _BotaoAcaoPrincipal extends StatelessWidget {
  const _BotaoAcaoPrincipal({
    required this.icone,
    required this.texto,
    required this.aoPressionar,
  });

  final IconData icone;
  final String texto;
  final VoidCallback aoPressionar;

  @override
  Widget build(BuildContext contexto) {
    return FilledButton.icon(
      onPressed: aoPressionar,
      icon: Icon(icone),
      label: Text(texto),
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _AvisoDeEstado extends StatelessWidget {
  const _AvisoDeEstado({required this.texto});

  final String texto;

  @override
  Widget build(BuildContext contexto) {
    return Container(
      constraints: const BoxConstraints(minHeight: 56),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: CoresPrototipe.superficieContainer,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: CoresPrototipe.textoSecundario),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              texto,
              style: const TextStyle(color: CoresPrototipe.textoSecundario),
            ),
          ),
        ],
      ),
    );
  }
}

class _AtalhoDeTransferencia extends StatelessWidget {
  const _AtalhoDeTransferencia({
    required this.nome,
    required this.aoPressionar,
  });

  final String nome;
  final VoidCallback aoPressionar;

  @override
  Widget build(BuildContext contexto) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: aoPressionar,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _AvatarDePerfil(nome: nome, selecionado: false, tamanho: 48),
          const SizedBox(height: 6),
          Text(
            nome,
            style: const TextStyle(
              color: CoresPrototipe.textoSecundario,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoricoDaSala extends StatelessWidget {
  const _HistoricoDaSala({
    required this.situacao,
    required this.titulo,
    this.limite,
  });

  final SituacaoDaSala situacao;
  final String titulo;
  final int? limite;

  @override
  Widget build(BuildContext contexto) {
    var eventosMaisRecentes = situacao.historico.reversed.toList();
    if (limite != null && eventosMaisRecentes.length > limite!) {
      eventosMaisRecentes = eventosMaisRecentes.take(limite!).toList();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            titulo,
            style: const TextStyle(
              color: CoresPrototipe.textoSecundario,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 12),
        _SuperficieElevada(
          padding: EdgeInsets.zero,
          child: eventosMaisRecentes.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(18),
                  child: _EstadoVazioDoHistorico(),
                )
              : Column(
                  children: [
                    for (
                      var indice = 0;
                      indice < eventosMaisRecentes.length;
                      indice += 1
                    ) ...[
                      _ItemDeHistorico(evento: eventosMaisRecentes[indice]),
                      if (indice != eventosMaisRecentes.length - 1)
                        const Divider(
                          height: 1,
                          color: CoresPrototipe.contornoSuave,
                        ),
                    ],
                  ],
                ),
        ),
      ],
    );
  }
}

class _ItemDeHistorico extends StatelessWidget {
  const _ItemDeHistorico({required this.evento});

  final EventoHistorico evento;

  @override
  Widget build(BuildContext contexto) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: CoresPrototipe.superficieContainerAlta,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _iconeDoEvento(evento.descricao),
              color: CoresPrototipe.azulCiano,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  evento.descricao,
                  style: const TextStyle(
                    color: CoresPrototipe.textoPrincipal,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _formatarMomento(evento.momento),
                  style: const TextStyle(
                    color: CoresPrototipe.textoSecundario,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            evento.pessoa,
            style: const TextStyle(
              color: CoresPrototipe.textoSecundario,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconeDoEvento(String descricao) {
    if (descricao.contains('abriu')) {
      return Icons.meeting_room_outlined;
    }
    if (descricao.contains('fechou')) {
      return Icons.door_back_door_outlined;
    }
    if (descricao.contains('passou')) {
      return Icons.arrow_forward;
    }
    return Icons.key;
  }
}

class _EstadoVazioDoHistorico extends StatelessWidget {
  const _EstadoVazioDoHistorico();

  @override
  Widget build(BuildContext contexto) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Ainda não há movimentações registradas.',
          style: TextStyle(
            color: CoresPrototipe.textoPrincipal,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Quando alguém registrar uma ação, ela aparecerá aqui.',
          style: TextStyle(color: CoresPrototipe.textoSecundario),
        ),
      ],
    );
  }
}

class _SuperficieElevada extends StatelessWidget {
  const _SuperficieElevada({
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext contexto) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: CoresPrototipe.superficieCard,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x24000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _AvatarDePerfil extends StatelessWidget {
  const _AvatarDePerfil({
    required this.nome,
    required this.selecionado,
    this.tamanho = 28,
  });

  final String nome;
  final bool selecionado;
  final double tamanho;

  @override
  Widget build(BuildContext contexto) {
    return Container(
      width: tamanho,
      height: tamanho,
      decoration: BoxDecoration(
        color: selecionado
            ? CoresPrototipe.azulCiano
            : CoresPrototipe.containerSecundario,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        nome.characters.first.toUpperCase(),
        style: TextStyle(
          color: selecionado
              ? Colors.white
              : CoresPrototipe.textoContainerSecundario,
          fontSize: tamanho >= 40 ? 18 : 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _DadosLocaisRestaurados {
  const _DadosLocaisRestaurados({
    required this.perfilSelecionado,
    required this.situacao,
    required this.destinosDaChave,
  });

  final String? perfilSelecionado;
  final SituacaoDaSala situacao;
  final List<String> destinosDaChave;
}

const _perfisPreDefinidos = ['Lucas', 'Clara', 'Amanda', 'Vitor'];

String _textoDeResponsavelDaChave(SituacaoDaSala situacao) {
  final localizacao = situacao.localizacaoDaChave;
  return switch (localizacao.tipo) {
    TipoLocalizacaoDaChave.pessoa => localizacao.nomeDaPessoa ?? 'Alguém',
    TipoLocalizacaoDaChave.portaria ||
    TipoLocalizacaoDaChave.sala ||
    TipoLocalizacaoDaChave.destino => 'Nenhuma pessoa',
  };
}

String _textoDaLocalizacao(LocalizacaoDaChave localizacao) {
  return switch (localizacao.tipo) {
    TipoLocalizacaoDaChave.portaria => 'Portaria',
    TipoLocalizacaoDaChave.sala => 'Sala 26',
    TipoLocalizacaoDaChave.pessoa =>
      'Com ${localizacao.nomeDaPessoa ?? 'alguém'}',
    TipoLocalizacaoDaChave.destino =>
      'Em ${localizacao.nomeDoDestino ?? 'destino'}',
  };
}

String _formatarAtualizacao(DateTime? momento) {
  if (momento == null) {
    return 'Sem atualização';
  }

  final agora = DateTime.now();
  final hora = _doisDigitos(momento.hour);
  final minuto = _doisDigitos(momento.minute);
  if (agora.year == momento.year &&
      agora.month == momento.month &&
      agora.day == momento.day) {
    return 'Hoje, $hora:$minuto';
  }

  final dia = _doisDigitos(momento.day);
  final mes = _doisDigitos(momento.month);
  return '$dia/$mes/${momento.year} às $hora:$minuto';
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
