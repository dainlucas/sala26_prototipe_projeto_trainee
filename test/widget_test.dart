import 'package:chave_26/funcionalidades/configuracoes/dados/repositorio_local_do_perfil.dart';
import 'package:chave_26/funcionalidades/sala/dados/repositorio_local_da_sala.dart';
import 'package:chave_26/funcionalidades/sala/dominio/estado_da_sala.dart';
import 'package:chave_26/funcionalidades/sala/dominio/evento_historico.dart';
import 'package:chave_26/funcionalidades/sala/dominio/localizacao_da_chave.dart';
import 'package:chave_26/funcionalidades/sala/dominio/situacao_da_sala.dart';
import 'package:chave_26/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('mostra a identidade inicial do Chave 26', (testador) async {
    await testador.pumpWidget(const AplicativoChave26());
    await testador.pumpAndSettle();

    expect(find.text('Chave 26'), findsOneWidget);
    expect(find.text('Sala 26'), findsWidgets);
    expect(find.text('Prototipe'), findsOneWidget);
  });

  testWidgets('mostra logo do Chave 26 no cabeçalho inicial', (testador) async {
    await testador.pumpWidget(const AplicativoChave26());
    await testador.pumpAndSettle();

    expect(
      find.image(const AssetImage('recursos/imagens/icone_sala_26.png')),
      findsOneWidget,
    );
  });

  testWidgets('mostra situação inicial quando não há dados salvos', (
    testador,
  ) async {
    await testador.pumpWidget(const AplicativoChave26());
    await testador.pumpAndSettle();

    expect(find.text('Escolher perfil'), findsOneWidget);
    expect(find.text('Fechada'), findsOneWidget);
    expect(find.text('Portaria'), findsWidgets);
    expect(find.textContaining('Histórico:'), findsNothing);
  });

  testWidgets('oferece os quatro perfis predefinidos na troca de perfil', (
    testador,
  ) async {
    await testador.pumpWidget(const AplicativoChave26());
    await testador.pumpAndSettle();

    await testador.tap(find.byTooltip('Trocar perfil'));
    await testador.pumpAndSettle();

    expect(find.text('Lucas'), findsOneWidget);
    expect(find.text('Clara'), findsOneWidget);
    expect(find.text('Amanda'), findsOneWidget);
    expect(find.text('Vitor'), findsOneWidget);
  });

  testWidgets('troca e salva o perfil pela tela inicial sem apagar estado', (
    testador,
  ) async {
    final repositorioDaSala = await RepositorioLocalDaSala.criar();
    final repositorioDoPerfil = await RepositorioLocalDoPerfil.criar();

    await repositorioDaSala.salvarSituacaoAtual(
      SituacaoDaSala(
        estado: EstadoDaSala.aberta,
        localizacaoDaChave: const LocalizacaoDaChave.naSala(),
      ),
    );

    await testador.pumpWidget(const AplicativoChave26());
    await testador.pumpAndSettle();

    await testador.tap(find.byTooltip('Trocar perfil'));
    await testador.pumpAndSettle();
    await testador.tap(find.text('Clara'));
    await testador.pumpAndSettle();

    expect(find.text('Clara'), findsOneWidget);
    expect(await repositorioDoPerfil.carregarPerfilSelecionado(), 'Clara');
    expect(find.text('Aberta'), findsOneWidget);
    expect(find.text('Sala 26'), findsWidgets);
  });

  testWidgets('restaura dados locais salvos ao abrir o app', (testador) async {
    final repositorioDaSala = await RepositorioLocalDaSala.criar();
    final repositorioDoPerfil = await RepositorioLocalDoPerfil.criar();
    final momento = DateTime(2026, 1, 2, 16, 30);

    await repositorioDoPerfil.salvarPerfilSelecionado('Clara');
    await repositorioDaSala.salvarSituacaoAtual(
      SituacaoDaSala(
        estado: EstadoDaSala.aberta,
        localizacaoDaChave: const LocalizacaoDaChave.naSala(),
        historico: [
          EventoHistorico(
            momento: momento,
            pessoa: 'Clara',
            descricao: 'Clara abriu a sala 26.',
          ),
        ],
        pessoaUltimaAtualizacao: 'Clara',
        atualizadaEm: momento,
      ),
    );

    await testador.pumpWidget(const AplicativoChave26());
    await testador.pumpAndSettle();

    expect(find.text('Clara'), findsWidgets);
    expect(find.text('Aberta'), findsOneWidget);
    expect(find.text('Sala 26'), findsWidgets);
    expect(find.textContaining('Histórico:'), findsNothing);
  });

  testWidgets('mostra chave com pessoa quando esse dado está salvo', (
    testador,
  ) async {
    final repositorioDaSala = await RepositorioLocalDaSala.criar();
    final repositorioDoPerfil = await RepositorioLocalDoPerfil.criar();

    await repositorioDoPerfil.salvarPerfilSelecionado('Vitor');
    await repositorioDaSala.salvarSituacaoAtual(
      SituacaoDaSala(
        estado: EstadoDaSala.fechada,
        localizacaoDaChave: LocalizacaoDaChave.comPessoa('Vitor'),
      ),
    );

    await testador.pumpWidget(const AplicativoChave26());
    await testador.pumpAndSettle();

    expect(find.text('Vitor'), findsWidgets);
    expect(find.text('Fechada'), findsOneWidget);
    expect(find.text('Com Vitor'), findsOneWidget);
    expect(find.textContaining('Histórico:'), findsNothing);
  });

  testWidgets('mostra chave sem pessoa quando está guardada em local', (
    testador,
  ) async {
    final repositorioDaSala = await RepositorioLocalDaSala.criar();
    final repositorioDoPerfil = await RepositorioLocalDoPerfil.criar();

    await repositorioDoPerfil.salvarPerfilSelecionado('Lucas');
    await repositorioDaSala.salvarSituacaoAtual(
      SituacaoDaSala(
        estado: EstadoDaSala.fechada,
        localizacaoDaChave: LocalizacaoDaChave.guardadaEm('Maker Space'),
        pessoaUltimaAtualizacao: 'Clara',
      ),
    );

    await testador.pumpWidget(const AplicativoChave26());
    await testador.pumpAndSettle();

    expect(find.text('Chave com'), findsOneWidget);
    expect(find.text('Nenhuma pessoa'), findsOneWidget);
    expect(find.text('Em Maker Space'), findsOneWidget);
    expect(find.text('Clara'), findsNothing);
  });

  testWidgets('pede seleção de perfil antes de mostrar ações de movimentação', (
    testador,
  ) async {
    await testador.pumpWidget(const AplicativoChave26());
    await testador.pumpAndSettle();

    expect(
      find.text('Escolha quem está usando o app para liberar as ações.'),
      findsOneWidget,
    );
    expect(find.text('Pegar chave na portaria'), findsNothing);
    expect(find.text('Guardar chave'), findsNothing);
    expect(find.text('Escolher pessoa'), findsNothing);
    expect(find.textContaining('Histórico:'), findsNothing);
  });

  testWidgets('mostra apenas ações disponíveis conforme localização da chave', (
    testador,
  ) async {
    final repositorioDaSala = await RepositorioLocalDaSala.criar();
    final repositorioDoPerfil = await RepositorioLocalDoPerfil.criar();

    await repositorioDoPerfil.salvarPerfilSelecionado('Lucas');

    await testador.pumpWidget(const AplicativoChave26());
    await testador.pumpAndSettle();

    expect(find.text('Pegar chave na portaria'), findsOneWidget);
    expect(find.text('Guardar chave'), findsNothing);
    expect(find.text('Escolher pessoa'), findsNothing);

    await repositorioDaSala.salvarSituacaoAtual(
      SituacaoDaSala(
        estado: EstadoDaSala.fechada,
        localizacaoDaChave: LocalizacaoDaChave.comPessoa('Lucas'),
      ),
    );
    await testador.pumpWidget(const SizedBox.shrink());
    await testador.pumpWidget(const AplicativoChave26());
    await testador.pumpAndSettle();

    expect(find.text('Pegar chave na portaria'), findsNothing);
    expect(find.text('Guardar chave'), findsOneWidget);
    expect(find.text('Escolher pessoa'), findsOneWidget);

    await repositorioDaSala.salvarSituacaoAtual(
      SituacaoDaSala(
        estado: EstadoDaSala.fechada,
        localizacaoDaChave: LocalizacaoDaChave.comPessoa('Clara'),
      ),
    );
    await testador.pumpWidget(const SizedBox.shrink());
    await testador.pumpWidget(const AplicativoChave26());
    await testador.pumpAndSettle();

    expect(find.text('Pegar chave na portaria'), findsNothing);
    expect(find.text('Guardar chave'), findsNothing);
    expect(find.text('Escolher pessoa'), findsNothing);
    expect(
      find.text(
        'A chave está com Clara. Apenas Clara pode guardar ou passar a chave.',
      ),
      findsOneWidget,
    );

    await repositorioDaSala.salvarSituacaoAtual(
      SituacaoDaSala(
        estado: EstadoDaSala.fechada,
        localizacaoDaChave: LocalizacaoDaChave.guardadaEm('Maker Space'),
      ),
    );
    await testador.pumpWidget(const SizedBox.shrink());
    await testador.pumpWidget(const AplicativoChave26());
    await testador.pumpAndSettle();

    expect(find.text('Pegar chave em Maker Space'), findsOneWidget);
    expect(find.text('Guardar chave'), findsNothing);
    expect(find.text('Escolher pessoa'), findsNothing);
  });

  testWidgets('usa o perfil selecionado ao registrar ação da sala', (
    testador,
  ) async {
    final repositorioDaSala = await RepositorioLocalDaSala.criar();
    final repositorioDoPerfil = await RepositorioLocalDoPerfil.criar();

    await repositorioDoPerfil.salvarPerfilSelecionado('Clara');

    await testador.pumpWidget(const AplicativoChave26());
    await testador.pumpAndSettle();

    await testador.ensureVisible(find.text('Pegar chave na portaria'));
    await testador.tap(find.text('Pegar chave na portaria'));
    await testador.pumpAndSettle();

    final situacaoSalva = await repositorioDaSala.carregarSituacaoAtual();

    expect(
      situacaoSalva.localizacaoDaChave,
      LocalizacaoDaChave.comPessoa('Clara'),
    );
    expect(situacaoSalva.pessoaUltimaAtualizacao, 'Clara');
    expect(situacaoSalva.historico.single.pessoa, 'Clara');
    expect(
      situacaoSalva.historico.single.descricao,
      'Clara pegou a chave na portaria.',
    );
    expect(find.text('Com Clara'), findsOneWidget);
    expect(find.textContaining('Histórico:'), findsNothing);
  });

  testWidgets('pega a chave quando ela está guardada em destino', (
    testador,
  ) async {
    final repositorioDaSala = await RepositorioLocalDaSala.criar();
    final repositorioDoPerfil = await RepositorioLocalDoPerfil.criar();

    await repositorioDoPerfil.salvarPerfilSelecionado('Lucas');
    await repositorioDaSala.salvarSituacaoAtual(
      SituacaoDaSala(
        estado: EstadoDaSala.fechada,
        localizacaoDaChave: LocalizacaoDaChave.guardadaEm('Maker Space'),
      ),
    );

    await testador.pumpWidget(const AplicativoChave26());
    await testador.pumpAndSettle();

    await testador.ensureVisible(find.text('Pegar chave em Maker Space'));
    await testador.tap(find.text('Pegar chave em Maker Space'));
    await testador.pumpAndSettle();

    final situacaoSalva = await repositorioDaSala.carregarSituacaoAtual();

    expect(
      situacaoSalva.localizacaoDaChave,
      LocalizacaoDaChave.comPessoa('Lucas'),
    );
    expect(situacaoSalva.historico.single.pessoa, 'Lucas');
    expect(
      situacaoSalva.historico.single.descricao,
      'Lucas pegou a chave em Maker Space.',
    );
    expect(find.text('Com Lucas'), findsOneWidget);
  });

  testWidgets('mostra estado vazio amigável quando não há histórico', (
    testador,
  ) async {
    await testador.pumpWidget(const AplicativoChave26());
    await testador.pumpAndSettle();

    expect(find.text('Histórico recente'), findsNothing);

    await testador.tap(find.text('Histórico'));
    await testador.pumpAndSettle();

    expect(find.text('Histórico de movimentações'), findsOneWidget);
    expect(
      find.text('Ainda não há movimentações registradas.'),
      findsOneWidget,
    );
    expect(
      find.text('Quando alguém registrar uma ação, ela aparecerá aqui.'),
      findsOneWidget,
    );
  });

  testWidgets('mostra histórico com itens mais recentes primeiro', (
    testador,
  ) async {
    final repositorioDaSala = await RepositorioLocalDaSala.criar();
    final momentoMaisAntigo = DateTime(2026, 1, 2, 14, 30);
    final momentoMaisRecente = DateTime(2026, 1, 2, 17, 10);

    await repositorioDaSala.salvarSituacaoAtual(
      SituacaoDaSala(
        estado: EstadoDaSala.fechada,
        localizacaoDaChave: const LocalizacaoDaChave.naPortaria(),
        historico: [
          EventoHistorico(
            momento: momentoMaisAntigo,
            pessoa: 'Clara',
            descricao: 'Clara pegou a chave na portaria.',
          ),
          EventoHistorico(
            momento: momentoMaisRecente,
            pessoa: 'Vitor',
            descricao: 'Vitor devolveu a chave para a portaria.',
          ),
        ],
        pessoaUltimaAtualizacao: 'Vitor',
        atualizadaEm: momentoMaisRecente,
      ),
    );

    await testador.pumpWidget(const AplicativoChave26());
    await testador.pumpAndSettle();

    expect(find.text('Histórico recente'), findsNothing);

    await testador.tap(find.text('Histórico'));
    await testador.pumpAndSettle();

    expect(find.text('Histórico de movimentações'), findsOneWidget);
    expect(find.text('Vitor'), findsOneWidget);
    expect(
      find.text('Vitor devolveu a chave para a portaria.'),
      findsOneWidget,
    );
    expect(find.text('02/01/2026 às 17:10'), findsWidgets);
    expect(find.text('Clara'), findsOneWidget);
    expect(find.text('Clara pegou a chave na portaria.'), findsOneWidget);
    expect(find.text('02/01/2026 às 14:30'), findsOneWidget);

    final posicaoMaisRecente = testador.getTopLeft(
      find.text('Vitor devolveu a chave para a portaria.'),
    );
    final posicaoMaisAntiga = testador.getTopLeft(
      find.text('Clara pegou a chave na portaria.'),
    );

    expect(posicaoMaisRecente.dy, lessThan(posicaoMaisAntiga.dy));
  });

  testWidgets('permite rolar histórico longo até movimentações antigas', (
    testador,
  ) async {
    final repositorioDaSala = await RepositorioLocalDaSala.criar();
    final inicio = DateTime(2026, 3, 10, 8);
    final historico = List.generate(30, (indice) {
      final numero = indice + 1;
      return EventoHistorico(
        momento: inicio.add(Duration(minutes: indice)),
        pessoa: 'Pessoa $numero',
        descricao: 'Movimentação número $numero.',
      );
    });

    await repositorioDaSala.salvarSituacaoAtual(
      SituacaoDaSala(
        estado: EstadoDaSala.fechada,
        localizacaoDaChave: const LocalizacaoDaChave.naPortaria(),
        historico: historico,
        pessoaUltimaAtualizacao: 'Pessoa 30',
        atualizadaEm: historico.last.momento,
      ),
    );

    await testador.pumpWidget(const AplicativoChave26());
    await testador.pumpAndSettle();

    expect(find.textContaining('Histórico:'), findsNothing);
    expect(find.text('Movimentação número 30.'), findsNothing);
    expect(find.text('10/03/2026 às 08:29'), findsOneWidget);

    await testador.tap(find.text('Histórico'));
    await testador.pumpAndSettle();

    expect(find.text('Movimentação número 30.'), findsOneWidget);
    expect(find.text('10/03/2026 às 08:29'), findsWidgets);

    final itemMaisAntigo = find.text('Movimentação número 1.');
    expect(itemMaisAntigo.hitTestable(), findsNothing);

    await testador.scrollUntilVisible(itemMaisAntigo, -400);
    await testador.pumpAndSettle();

    expect(itemMaisAntigo.hitTestable(), findsOneWidget);
    expect(find.text('10/03/2026 às 08:00'), findsOneWidget);
  });

  testWidgets('formata datas em dias meses e horários limite', (
    testador,
  ) async {
    final repositorioDaSala = await RepositorioLocalDaSala.criar();
    final eventos = [
      EventoHistorico(
        momento: DateTime(2026, 1, 1),
        pessoa: 'Lucas',
        descricao: 'Lucas abriu o ano com a chave.',
      ),
      EventoHistorico(
        momento: DateTime(2026, 9, 5, 7, 3),
        pessoa: 'Clara',
        descricao: 'Clara registrou horário com zero à esquerda.',
      ),
      EventoHistorico(
        momento: DateTime(2026, 12, 31, 23, 59),
        pessoa: 'Amanda',
        descricao: 'Amanda fechou o ano com a chave.',
      ),
    ];

    await repositorioDaSala.salvarSituacaoAtual(
      SituacaoDaSala(
        estado: EstadoDaSala.aberta,
        localizacaoDaChave: const LocalizacaoDaChave.naSala(),
        historico: eventos,
        pessoaUltimaAtualizacao: 'Amanda',
        atualizadaEm: eventos.last.momento,
      ),
    );

    await testador.pumpWidget(const AplicativoChave26());
    await testador.pumpAndSettle();

    expect(find.text('01/01/2026 às 00:00'), findsNothing);
    expect(find.text('05/09/2026 às 07:03'), findsNothing);
    expect(find.text('31/12/2026 às 23:59'), findsOneWidget);

    await testador.tap(find.text('Histórico'));
    await testador.pumpAndSettle();

    expect(find.text('01/01/2026 às 00:00'), findsOneWidget);
    expect(find.text('05/09/2026 às 07:03'), findsOneWidget);
    expect(find.text('31/12/2026 às 23:59'), findsWidgets);
  });

  testWidgets('escolhe destino antes de guardar a chave', (testador) async {
    final repositorioDaSala = await RepositorioLocalDaSala.criar();
    final repositorioDoPerfil = await RepositorioLocalDoPerfil.criar();
    final situacaoInicial = SituacaoDaSala(
      estado: EstadoDaSala.fechada,
      localizacaoDaChave: LocalizacaoDaChave.comPessoa('Clara'),
      historico: [
        EventoHistorico(
          momento: DateTime(2026, 1, 2, 16, 30),
          pessoa: 'Clara',
          descricao: 'Clara pegou a chave na portaria.',
        ),
      ],
      pessoaUltimaAtualizacao: 'Clara',
      atualizadaEm: DateTime(2026, 1, 2, 16, 30),
    );

    await repositorioDoPerfil.salvarPerfilSelecionado('Clara');
    await repositorioDaSala.salvarSituacaoAtual(situacaoInicial);

    await testador.pumpWidget(const AplicativoChave26());
    await testador.pumpAndSettle();

    await testador.ensureVisible(find.text('Guardar chave'));
    await testador.tap(find.text('Guardar chave'));
    await testador.pumpAndSettle();

    expect(find.text('Onde você vai guardar a chave?'), findsOneWidget);
    final seletorDeDestino = find.byType(BottomSheet);
    expect(
      find.descendant(of: seletorDeDestino, matching: find.text('Portaria')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: seletorDeDestino, matching: find.text('Maker Space')),
      findsOneWidget,
    );

    await testador.tap(
      find.descendant(of: seletorDeDestino, matching: find.text('Portaria')),
    );
    await testador.pumpAndSettle();

    final situacaoFinal = await repositorioDaSala.carregarSituacaoAtual();
    expect(
      situacaoFinal.localizacaoDaChave,
      LocalizacaoDaChave.guardadaEm('Portaria'),
    );
    expect(situacaoFinal.historico.length, 2);
    expect(
      situacaoFinal.historico.last.descricao,
      'Clara guardou a chave em Portaria.',
    );
    expect(find.text('Em Portaria'), findsOneWidget);
    expect(find.textContaining('Histórico:'), findsNothing);
    expect(find.text('Clara guardou a chave em Portaria.'), findsWidgets);
  });

  testWidgets('adiciona destino customizado ao guardar a chave', (
    testador,
  ) async {
    final repositorioDaSala = await RepositorioLocalDaSala.criar();
    final repositorioDoPerfil = await RepositorioLocalDoPerfil.criar();

    await repositorioDoPerfil.salvarPerfilSelecionado('Lucas');
    await repositorioDaSala.salvarSituacaoAtual(
      SituacaoDaSala(
        estado: EstadoDaSala.fechada,
        localizacaoDaChave: LocalizacaoDaChave.comPessoa('Lucas'),
      ),
    );

    await testador.pumpWidget(const AplicativoChave26());
    await testador.pumpAndSettle();

    await testador.ensureVisible(find.text('Guardar chave'));
    await testador.tap(find.text('Guardar chave'));
    await testador.pumpAndSettle();

    await testador.tap(find.text('Adicionar novo local'));
    await testador.pumpAndSettle();
    await testador.enterText(find.byType(TextField), 'Biblioteca');
    await testador.tap(find.text('Salvar'));
    await testador.pumpAndSettle();

    expect(find.text('Biblioteca'), findsOneWidget);

    await testador.tap(find.text('Biblioteca'));
    await testador.pumpAndSettle();

    final situacaoFinal = await repositorioDaSala.carregarSituacaoAtual();
    expect(
      situacaoFinal.localizacaoDaChave,
      LocalizacaoDaChave.guardadaEm('Biblioteca'),
    );
    expect(
      situacaoFinal.historico.single.descricao,
      'Lucas guardou a chave em Biblioteca.',
    );
    expect(await repositorioDaSala.carregarDestinosDaChave(), [
      'Portaria',
      'Maker Space',
      'Biblioteca',
    ]);
  });

  testWidgets(
    'mantém destino customizado visível ao reabrir Guardar chave e reiniciar app',
    (testador) async {
      final repositorioDaSala = await RepositorioLocalDaSala.criar();
      final repositorioDoPerfil = await RepositorioLocalDoPerfil.criar();

      await repositorioDoPerfil.salvarPerfilSelecionado('Lucas');
      await repositorioDaSala.salvarSituacaoAtual(
        SituacaoDaSala(
          estado: EstadoDaSala.fechada,
          localizacaoDaChave: LocalizacaoDaChave.comPessoa('Lucas'),
        ),
      );

      await testador.pumpWidget(const AplicativoChave26());
      await testador.pumpAndSettle();

      await testador.ensureVisible(find.text('Guardar chave'));
      await testador.tap(find.text('Guardar chave'));
      await testador.pumpAndSettle();

      await testador.tap(find.text('Adicionar novo local'));
      await testador.pumpAndSettle();
      await testador.enterText(find.byType(TextField), 'Biblioteca');
      await testador.tap(find.text('Salvar'));
      await testador.pumpAndSettle();

      var seletorDeDestino = find.byType(BottomSheet);
      expect(
        find.descendant(
          of: seletorDeDestino,
          matching: find.text('Biblioteca'),
        ),
        findsOneWidget,
      );

      await testador.tapAt(const Offset(10, 10));
      await testador.pumpAndSettle();

      await testador.ensureVisible(find.text('Guardar chave'));
      await testador.tap(find.text('Guardar chave'));
      await testador.pumpAndSettle();

      seletorDeDestino = find.byType(BottomSheet);
      expect(
        find.descendant(
          of: seletorDeDestino,
          matching: find.text('Biblioteca'),
        ),
        findsOneWidget,
      );

      await testador.tapAt(const Offset(10, 10));
      await testador.pumpAndSettle();
      await testador.pumpWidget(const SizedBox.shrink());
      await testador.pumpAndSettle();
      await testador.pumpWidget(const AplicativoChave26());
      await testador.pumpAndSettle();

      await testador.ensureVisible(find.text('Guardar chave'));
      await testador.tap(find.text('Guardar chave'));
      await testador.pumpAndSettle();

      seletorDeDestino = find.byType(BottomSheet);
      expect(
        find.descendant(
          of: seletorDeDestino,
          matching: find.text('Biblioteca'),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets('cancelar escolha de destino não altera estado nem histórico', (
    testador,
  ) async {
    final repositorioDaSala = await RepositorioLocalDaSala.criar();
    final repositorioDoPerfil = await RepositorioLocalDoPerfil.criar();
    final situacaoInicial = SituacaoDaSala(
      estado: EstadoDaSala.fechada,
      localizacaoDaChave: LocalizacaoDaChave.comPessoa('Clara'),
      historico: [
        EventoHistorico(
          momento: DateTime(2026, 1, 2, 16, 30),
          pessoa: 'Clara',
          descricao: 'Clara pegou a chave na portaria.',
        ),
      ],
      pessoaUltimaAtualizacao: 'Clara',
      atualizadaEm: DateTime(2026, 1, 2, 16, 30),
    );

    await repositorioDoPerfil.salvarPerfilSelecionado('Clara');
    await repositorioDaSala.salvarSituacaoAtual(situacaoInicial);

    await testador.pumpWidget(const AplicativoChave26());
    await testador.pumpAndSettle();

    await testador.ensureVisible(find.text('Guardar chave'));
    await testador.tap(find.text('Guardar chave'));
    await testador.pumpAndSettle();

    expect(find.text('Onde você vai guardar a chave?'), findsOneWidget);

    await testador.tapAt(const Offset(10, 10));
    await testador.pumpAndSettle();

    expect(await repositorioDaSala.carregarSituacaoAtual(), situacaoInicial);
    expect(find.text('Com Clara'), findsOneWidget);
    expect(find.text('Clara guardou a chave em Portaria.'), findsNothing);
  });

  testWidgets('não adiciona destino customizado com nome vazio', (
    testador,
  ) async {
    final repositorioDaSala = await RepositorioLocalDaSala.criar();
    final repositorioDoPerfil = await RepositorioLocalDoPerfil.criar();

    await repositorioDoPerfil.salvarPerfilSelecionado('Lucas');
    await repositorioDaSala.salvarSituacaoAtual(
      SituacaoDaSala(
        estado: EstadoDaSala.fechada,
        localizacaoDaChave: LocalizacaoDaChave.comPessoa('Lucas'),
      ),
    );

    await testador.pumpWidget(const AplicativoChave26());
    await testador.pumpAndSettle();

    await testador.ensureVisible(find.text('Guardar chave'));
    await testador.tap(find.text('Guardar chave'));
    await testador.pumpAndSettle();

    await testador.tap(find.text('Adicionar novo local'));
    await testador.pumpAndSettle();
    await testador.enterText(find.byType(TextField), '   ');
    await testador.tap(find.text('Salvar'));
    await testador.pumpAndSettle();

    expect(await repositorioDaSala.carregarDestinosDaChave(), [
      'Portaria',
      'Maker Space',
    ]);
    expect(find.byType(BottomSheet), findsOneWidget);
    expect(find.text('Onde você vai guardar a chave?'), findsOneWidget);
  });

  testWidgets('não duplica destino customizado já existente', (testador) async {
    final repositorioDaSala = await RepositorioLocalDaSala.criar();
    final repositorioDoPerfil = await RepositorioLocalDoPerfil.criar();

    await repositorioDoPerfil.salvarPerfilSelecionado('Lucas');
    await repositorioDaSala.salvarSituacaoAtual(
      SituacaoDaSala(
        estado: EstadoDaSala.fechada,
        localizacaoDaChave: LocalizacaoDaChave.comPessoa('Lucas'),
      ),
    );
    await repositorioDaSala.adicionarDestinoCustomizado('Biblioteca');

    await testador.pumpWidget(const AplicativoChave26());
    await testador.pumpAndSettle();

    await testador.ensureVisible(find.text('Guardar chave'));
    await testador.tap(find.text('Guardar chave'));
    await testador.pumpAndSettle();

    await testador.tap(find.text('Adicionar novo local'));
    await testador.pumpAndSettle();
    await testador.enterText(find.byType(TextField), 'Biblioteca');
    await testador.tap(find.text('Salvar'));
    await testador.pumpAndSettle();

    expect(await repositorioDaSala.carregarDestinosDaChave(), [
      'Portaria',
      'Maker Space',
      'Biblioteca',
    ]);
    expect(find.text('Biblioteca'), findsOneWidget);
  });

  testWidgets('não renomeia destino customizado para nome vazio', (
    testador,
  ) async {
    final repositorioDaSala = await RepositorioLocalDaSala.criar();
    final repositorioDoPerfil = await RepositorioLocalDoPerfil.criar();

    await repositorioDoPerfil.salvarPerfilSelecionado('Lucas');
    await repositorioDaSala.salvarSituacaoAtual(
      SituacaoDaSala(
        estado: EstadoDaSala.fechada,
        localizacaoDaChave: LocalizacaoDaChave.comPessoa('Lucas'),
      ),
    );
    await repositorioDaSala.adicionarDestinoCustomizado('Biblioteca');

    await testador.pumpWidget(const AplicativoChave26());
    await testador.pumpAndSettle();

    await testador.ensureVisible(find.text('Guardar chave'));
    await testador.tap(find.text('Guardar chave'));
    await testador.pumpAndSettle();

    await testador.tap(find.byTooltip('Renomear Biblioteca'));
    await testador.pumpAndSettle();
    await testador.enterText(find.byType(TextField), '   ');
    await testador.tap(find.text('Salvar'));
    await testador.pumpAndSettle();

    expect(await repositorioDaSala.carregarDestinosDaChave(), [
      'Portaria',
      'Maker Space',
      'Biblioteca',
    ]);
    expect(find.text('Biblioteca'), findsOneWidget);
    expect(find.byTooltip('Renomear Biblioteca'), findsOneWidget);
  });

  testWidgets('permite renomear e apagar destino customizado no seletor', (
    testador,
  ) async {
    final repositorioDaSala = await RepositorioLocalDaSala.criar();
    final repositorioDoPerfil = await RepositorioLocalDoPerfil.criar();

    await repositorioDoPerfil.salvarPerfilSelecionado('Lucas');
    await repositorioDaSala.salvarSituacaoAtual(
      SituacaoDaSala(
        estado: EstadoDaSala.fechada,
        localizacaoDaChave: LocalizacaoDaChave.comPessoa('Lucas'),
      ),
    );
    await repositorioDaSala.adicionarDestinoCustomizado('Biblioteca');
    await repositorioDaSala.adicionarDestinoCustomizado('Laboratório');

    await testador.pumpWidget(const AplicativoChave26());
    await testador.pumpAndSettle();

    await testador.ensureVisible(find.text('Guardar chave'));
    await testador.tap(find.text('Guardar chave'));
    await testador.pumpAndSettle();

    await testador.tap(find.byTooltip('Renomear Biblioteca'));
    await testador.pumpAndSettle();
    await testador.enterText(find.byType(TextField), 'Biblioteca Central');
    await testador.tap(find.text('Salvar'));
    await testador.pumpAndSettle();

    expect(await repositorioDaSala.carregarDestinosDaChave(), [
      'Portaria',
      'Maker Space',
      'Biblioteca Central',
      'Laboratório',
    ]);
    expect(find.text('Biblioteca Central'), findsOneWidget);
    expect(find.text('Biblioteca'), findsNothing);

    await testador.tap(find.byTooltip('Apagar Laboratório'));
    await testador.pumpAndSettle();

    expect(await repositorioDaSala.carregarDestinosDaChave(), [
      'Portaria',
      'Maker Space',
      'Biblioteca Central',
    ]);
    expect(find.text('Laboratório'), findsNothing);
    expect(find.text('Biblioteca Central'), findsOneWidget);
  });

  testWidgets(
    'confirma transferência da chave para outra pessoa antes de persistir',
    (testador) async {
      final repositorioDaSala = await RepositorioLocalDaSala.criar();
      final repositorioDoPerfil = await RepositorioLocalDoPerfil.criar();
      final situacaoInicial = SituacaoDaSala(
        estado: EstadoDaSala.fechada,
        localizacaoDaChave: LocalizacaoDaChave.comPessoa('Lucas'),
      );

      await repositorioDoPerfil.salvarPerfilSelecionado('Lucas');
      await repositorioDaSala.salvarSituacaoAtual(situacaoInicial);

      await testador.pumpWidget(const AplicativoChave26());
      await testador.pumpAndSettle();

      await testador.ensureVisible(find.text('Escolher pessoa'));
      await testador.tap(find.text('Escolher pessoa'));
      await testador.pumpAndSettle();

      expect(find.text('Escolha quem vai receber a chave'), findsOneWidget);
      final dialogoDeDestino = find.byType(SimpleDialog);
      expect(
        find.descendant(of: dialogoDeDestino, matching: find.text('Clara')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: dialogoDeDestino, matching: find.text('Amanda')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: dialogoDeDestino, matching: find.text('Vitor')),
        findsOneWidget,
      );

      await testador.tap(
        find.descendant(of: dialogoDeDestino, matching: find.text('Amanda')),
      );
      await testador.pumpAndSettle();

      expect(find.text('Confirmar passagem da chave'), findsOneWidget);
      expect(
        find.text('Você confirma que Lucas está passando a chave para Amanda?'),
        findsOneWidget,
      );

      await testador.tap(find.text('Cancelar'));
      await testador.pumpAndSettle();

      expect(await repositorioDaSala.carregarSituacaoAtual(), situacaoInicial);

      await testador.ensureVisible(find.text('Escolher pessoa'));
      await testador.tap(find.text('Escolher pessoa'));
      await testador.pumpAndSettle();
      final dialogoDeDestinoParaConfirmar = find.byType(SimpleDialog);
      await testador.tap(
        find.descendant(
          of: dialogoDeDestinoParaConfirmar,
          matching: find.text('Amanda'),
        ),
      );
      await testador.pumpAndSettle();
      await testador.tap(find.text('Confirmar transferência'));
      await testador.pumpAndSettle();

      final situacaoFinal = await repositorioDaSala.carregarSituacaoAtual();
      expect(
        situacaoFinal.localizacaoDaChave,
        LocalizacaoDaChave.comPessoa('Amanda'),
      );
      expect(
        situacaoFinal.historico.single.descricao,
        'Lucas passou a chave para Amanda.',
      );
      expect(find.text('Com Amanda'), findsOneWidget);
      expect(find.textContaining('Histórico:'), findsNothing);
      expect(find.text('Lucas passou a chave para Amanda.'), findsWidgets);
    },
  );

  testWidgets('permite transferir a chave guardada na sala para outra pessoa', (
    testador,
  ) async {
    final repositorioDaSala = await RepositorioLocalDaSala.criar();
    final repositorioDoPerfil = await RepositorioLocalDoPerfil.criar();
    final situacaoInicial = SituacaoDaSala(
      estado: EstadoDaSala.aberta,
      localizacaoDaChave: const LocalizacaoDaChave.naSala(),
      historico: [
        EventoHistorico(
          momento: DateTime(2026, 1, 2, 14, 30),
          pessoa: 'Lucas',
          descricao: 'Lucas abriu a sala 26.',
        ),
      ],
      pessoaUltimaAtualizacao: 'Lucas',
      atualizadaEm: DateTime(2026, 1, 2, 14, 30),
    );

    await repositorioDoPerfil.salvarPerfilSelecionado('Lucas');
    await repositorioDaSala.salvarSituacaoAtual(situacaoInicial);

    await testador.pumpWidget(const AplicativoChave26());
    await testador.pumpAndSettle();

    expect(find.text('Fechar sala'), findsOneWidget);
    expect(find.text('Passar a chave para'), findsOneWidget);
    expect(find.text('Escolher pessoa'), findsOneWidget);

    await testador.ensureVisible(find.text('Escolher pessoa'));
    await testador.tap(find.text('Escolher pessoa'));
    await testador.pumpAndSettle();
    await testador.tap(
      find.descendant(
        of: find.byType(SimpleDialog),
        matching: find.text('Clara'),
      ),
    );
    await testador.pumpAndSettle();
    await testador.tap(find.text('Confirmar transferência'));
    await testador.pumpAndSettle();

    final situacaoFinal = await repositorioDaSala.carregarSituacaoAtual();
    expect(situacaoFinal.estado, EstadoDaSala.aberta);
    expect(
      situacaoFinal.localizacaoDaChave,
      LocalizacaoDaChave.comPessoa('Clara'),
    );
    expect(
      situacaoFinal.historico.last.descricao,
      'Lucas passou a chave para Clara.',
    );
    expect(find.text('Com Clara'), findsOneWidget);
  });

  testWidgets('mostra estrutura visual inspirada no v0 na tela inicial', (
    testador,
  ) async {
    final repositorioDaSala = await RepositorioLocalDaSala.criar();
    final repositorioDoPerfil = await RepositorioLocalDoPerfil.criar();
    final momento = DateTime(2026, 5, 24, 12, 10);

    await repositorioDoPerfil.salvarPerfilSelecionado('Lucas');
    await repositorioDaSala.salvarSituacaoAtual(
      SituacaoDaSala(
        estado: EstadoDaSala.fechada,
        localizacaoDaChave: LocalizacaoDaChave.comPessoa('Lucas'),
        pessoaUltimaAtualizacao: 'Lucas',
        atualizadaEm: momento,
      ),
    );

    await testador.pumpWidget(const AplicativoChave26());
    await testador.pumpAndSettle();

    expect(find.text('Chave 26'), findsOneWidget);
    expect(find.text('Prototipe'), findsOneWidget);
    expect(find.byTooltip('Trocar perfil'), findsOneWidget);
    expect(find.text('Sala 26'), findsOneWidget);
    expect(find.text('Fechada'), findsOneWidget);
    expect(find.text('Ativa'), findsNothing);
    expect(find.text('Inativa'), findsNothing);
    expect(find.text('Chave com'), findsOneWidget);
    expect(find.text('Lucas'), findsWidgets);
    expect(find.text('Localização'), findsOneWidget);
    expect(find.text('Com Lucas'), findsOneWidget);
    expect(find.text('Última atualização'), findsOneWidget);
    expect(find.text('24/05/2026 às 12:10'), findsOneWidget);
    expect(find.text('O que você quer fazer agora?'), findsOneWidget);
    expect(find.text('Passar a chave para'), findsOneWidget);
    expect(find.text('Histórico recente'), findsNothing);
  });

  testWidgets(
    'permite abrir e fechar a sala quando o perfil está com a chave',
    (testador) async {
      final repositorioDaSala = await RepositorioLocalDaSala.criar();
      final repositorioDoPerfil = await RepositorioLocalDoPerfil.criar();

      await repositorioDoPerfil.salvarPerfilSelecionado('Lucas');
      await repositorioDaSala.salvarSituacaoAtual(
        SituacaoDaSala(
          estado: EstadoDaSala.fechada,
          localizacaoDaChave: LocalizacaoDaChave.comPessoa('Lucas'),
        ),
      );

      await testador.pumpWidget(const AplicativoChave26());
      await testador.pumpAndSettle();

      expect(find.text('Abrir sala'), findsOneWidget);
      await testador.tap(find.text('Abrir sala'));
      await testador.pumpAndSettle();

      var situacao = await repositorioDaSala.carregarSituacaoAtual();
      expect(situacao.estado, EstadoDaSala.aberta);
      expect(situacao.historico.last.descricao, 'Lucas abriu a sala 26.');

      expect(find.text('Fechar sala'), findsOneWidget);
      await testador.ensureVisible(find.text('Fechar sala'));
      await testador.tap(find.text('Fechar sala'));
      await testador.pumpAndSettle();

      situacao = await repositorioDaSala.carregarSituacaoAtual();
      expect(situacao.estado, EstadoDaSala.fechada);
      expect(
        situacao.localizacaoDaChave,
        LocalizacaoDaChave.comPessoa('Lucas'),
      );
      expect(
        situacao.historico.last.descricao,
        'Lucas fechou a sala 26 e ficou com a chave.',
      );
    },
  );

  testWidgets('limpa histórico pela ferramenta temporária na aba histórico', (
    testador,
  ) async {
    final repositorioDaSala = await RepositorioLocalDaSala.criar();
    final historico = [
      EventoHistorico(
        momento: DateTime(2026, 5, 24, 8),
        pessoa: 'Lucas',
        descricao: 'Lucas pegou a chave na portaria.',
      ),
      EventoHistorico(
        momento: DateTime(2026, 5, 24, 9),
        pessoa: 'Lucas',
        descricao: 'Lucas abriu a sala 26.',
      ),
    ];

    await repositorioDaSala.salvarSituacaoAtual(
      SituacaoDaSala(
        estado: EstadoDaSala.aberta,
        localizacaoDaChave: const LocalizacaoDaChave.naSala(),
        historico: historico,
        pessoaUltimaAtualizacao: 'Lucas',
        atualizadaEm: historico.last.momento,
      ),
    );

    await testador.pumpWidget(const AplicativoChave26());
    await testador.pumpAndSettle();

    await testador.tap(find.text('Histórico'));
    await testador.pumpAndSettle();

    expect(find.text('Lucas abriu a sala 26.'), findsOneWidget);
    await testador.tap(find.text('Limpar histórico da demo'));
    await testador.pumpAndSettle();

    final situacao = await repositorioDaSala.carregarSituacaoAtual();
    expect(situacao.historico, isEmpty);
    expect(situacao.estado, EstadoDaSala.aberta);
    expect(situacao.localizacaoDaChave, const LocalizacaoDaChave.naSala());
    expect(
      find.text('Ainda não há movimentações registradas.'),
      findsOneWidget,
    );
    expect(find.text('Histórico apagado para a demonstração.'), findsOneWidget);
  });

  testWidgets('filtra histórico completo por data', (testador) async {
    final repositorioDaSala = await RepositorioLocalDaSala.criar();
    final historico = [
      EventoHistorico(
        momento: DateTime(2026, 5, 23, 18),
        pessoa: 'Clara',
        descricao: 'Clara guardou a chave na portaria.',
      ),
      EventoHistorico(
        momento: DateTime(2026, 5, 24, 8),
        pessoa: 'Lucas',
        descricao: 'Lucas pegou a chave na portaria.',
      ),
      EventoHistorico(
        momento: DateTime(2026, 5, 24, 9),
        pessoa: 'Amanda',
        descricao: 'Amanda abriu a sala 26.',
      ),
    ];

    await repositorioDaSala.salvarSituacaoAtual(
      SituacaoDaSala(
        estado: EstadoDaSala.aberta,
        localizacaoDaChave: const LocalizacaoDaChave.naSala(),
        historico: historico,
        pessoaUltimaAtualizacao: 'Amanda',
        atualizadaEm: historico.last.momento,
      ),
    );

    await testador.pumpWidget(const AplicativoChave26());
    await testador.pumpAndSettle();

    await testador.tap(find.text('Histórico'));
    await testador.pumpAndSettle();

    expect(find.text('Filtrar por data'), findsOneWidget);
    expect(find.text('Todas as datas'), findsOneWidget);
    expect(find.text('Amanda abriu a sala 26.'), findsOneWidget);
    expect(find.text('Lucas pegou a chave na portaria.'), findsOneWidget);
    expect(find.text('Clara guardou a chave na portaria.'), findsOneWidget);

    await testador.tap(find.byKey(const Key('filtro-data-historico')));
    await testador.pumpAndSettle();
    await testador.tap(find.text('24/05/2026').last);
    await testador.pumpAndSettle();

    expect(find.text('Amanda abriu a sala 26.'), findsOneWidget);
    expect(find.text('Lucas pegou a chave na portaria.'), findsOneWidget);
    expect(find.text('Clara guardou a chave na portaria.'), findsNothing);

    await testador.tap(find.byKey(const Key('filtro-data-historico')));
    await testador.pumpAndSettle();
    await testador.tap(find.text('Todas as datas').last);
    await testador.pumpAndSettle();

    expect(find.text('Clara guardou a chave na portaria.'), findsOneWidget);
  });

  testWidgets('usa menu inferior para separar início e histórico completo', (
    testador,
  ) async {
    final repositorioDaSala = await RepositorioLocalDaSala.criar();
    final inicio = DateTime(2026, 5, 24, 8);
    final historico = List.generate(4, (indice) {
      final numero = indice + 1;
      return EventoHistorico(
        momento: inicio.add(Duration(minutes: indice)),
        pessoa: 'Pessoa $numero',
        descricao: 'Movimentação completa $numero.',
      );
    });

    await repositorioDaSala.salvarSituacaoAtual(
      SituacaoDaSala(
        estado: EstadoDaSala.fechada,
        localizacaoDaChave: const LocalizacaoDaChave.naPortaria(),
        historico: historico,
        pessoaUltimaAtualizacao: 'Pessoa 4',
        atualizadaEm: historico.last.momento,
      ),
    );

    await testador.pumpWidget(const AplicativoChave26());
    await testador.pumpAndSettle();

    expect(find.text('Histórico recente'), findsNothing);
    expect(find.text('Movimentação completa 4.'), findsNothing);
    expect(find.text('Movimentação completa 1.'), findsNothing);

    await testador.tap(find.text('Histórico'));
    await testador.pumpAndSettle();

    expect(find.text('Histórico de movimentações'), findsOneWidget);
    expect(find.text('Movimentação completa 1.'), findsOneWidget);
  });
}
