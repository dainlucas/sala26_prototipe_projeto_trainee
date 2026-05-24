import 'package:chave_26/funcionalidades/configuracoes/dados/repositorio_local_do_perfil.dart';
import 'package:chave_26/funcionalidades/sala/dados/repositorio_local_da_sala.dart';
import 'package:chave_26/funcionalidades/sala/dominio/estado_da_sala.dart';
import 'package:chave_26/funcionalidades/sala/dominio/evento_historico.dart';
import 'package:chave_26/funcionalidades/sala/dominio/localizacao_da_chave.dart';
import 'package:chave_26/funcionalidades/sala/dominio/situacao_da_sala.dart';
import 'package:chave_26/main.dart';
import 'package:flutter/widgets.dart';
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
    expect(find.text('Sala 26'), findsOneWidget);
    expect(
      find.text('MVP local para acompanhar a chave da Prototipe'),
      findsOneWidget,
    );
  });

  testWidgets('mostra o mascote da Prototipe na tela inicial', (
    testador,
  ) async {
    await testador.pumpWidget(const AplicativoChave26());
    await testador.pumpAndSettle();

    expect(find.bySemanticsLabel('Mascote da Prototipe'), findsOneWidget);
  });

  testWidgets('mostra situação inicial quando não há dados salvos', (
    testador,
  ) async {
    await testador.pumpWidget(const AplicativoChave26());
    await testador.pumpAndSettle();

    expect(find.text('Perfil salvo: nenhum'), findsOneWidget);
    expect(find.text('Sala fechada'), findsOneWidget);
    expect(find.text('Chave na portaria'), findsOneWidget);
    expect(find.text('Histórico: 0 registros'), findsOneWidget);
  });

  testWidgets('oferece os quatro perfis predefinidos na tela inicial', (
    testador,
  ) async {
    await testador.pumpWidget(const AplicativoChave26());
    await testador.pumpAndSettle();

    expect(find.byTooltip('Selecionar perfil Lucas'), findsOneWidget);
    expect(find.byTooltip('Selecionar perfil Clara'), findsOneWidget);
    expect(find.byTooltip('Selecionar perfil Amanda'), findsOneWidget);
    expect(find.byTooltip('Selecionar perfil Vitor'), findsOneWidget);
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

    await testador.tap(find.byTooltip('Selecionar perfil Clara'));
    await testador.pumpAndSettle();

    expect(find.text('Perfil salvo: Clara'), findsOneWidget);
    expect(await repositorioDoPerfil.carregarPerfilSelecionado(), 'Clara');
    expect(find.text('Sala aberta'), findsOneWidget);
    expect(find.text('Chave na sala'), findsOneWidget);
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

    expect(find.text('Perfil salvo: Clara'), findsOneWidget);
    expect(find.text('Sala aberta'), findsOneWidget);
    expect(find.text('Chave na sala'), findsOneWidget);
    expect(find.text('Histórico: 1 registro'), findsOneWidget);
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

    expect(find.text('Perfil salvo: Vitor'), findsOneWidget);
    expect(find.text('Sala fechada'), findsOneWidget);
    expect(find.text('Chave com Vitor'), findsOneWidget);
    expect(find.text('Histórico: 0 registros'), findsOneWidget);
  });

  testWidgets('pede seleção de perfil antes de mostrar ações de movimentação', (
    testador,
  ) async {
    await testador.pumpWidget(const AplicativoChave26());
    await testador.pumpAndSettle();

    expect(
      find.text('Escolha um perfil para ver as ações disponíveis.'),
      findsOneWidget,
    );
    expect(find.text('Pegar chave na portaria'), findsNothing);
    expect(find.text('Devolver chave para a portaria'), findsNothing);
    expect(find.text('Passar chave para outra pessoa'), findsNothing);
    expect(find.text('Histórico: 0 registros'), findsOneWidget);
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
    expect(find.text('Devolver chave para a portaria'), findsNothing);
    expect(find.text('Passar chave para outra pessoa'), findsNothing);

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
    expect(find.text('Devolver chave para a portaria'), findsOneWidget);
    expect(find.text('Passar chave para outra pessoa'), findsOneWidget);

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
    expect(find.text('Devolver chave para a portaria'), findsNothing);
    expect(find.text('Passar chave para outra pessoa'), findsNothing);
    expect(
      find.text(
        'A chave está com Clara. Apenas Clara pode devolver ou passar a chave.',
      ),
      findsOneWidget,
    );
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
    expect(find.text('Chave com Clara'), findsOneWidget);
    expect(find.text('Histórico: 1 registro'), findsOneWidget);
  });

  testWidgets('mostra estado vazio amigável quando não há histórico', (
    testador,
  ) async {
    await testador.pumpWidget(const AplicativoChave26());
    await testador.pumpAndSettle();

    expect(find.text('Histórico da sala'), findsOneWidget);
    expect(
      find.text('Ainda não há movimentações registradas.'),
      findsOneWidget,
    );
    expect(
      find.text('Quando alguém mexer na chave, a movimentação aparecerá aqui.'),
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

    expect(find.text('Histórico da sala'), findsOneWidget);
    expect(find.text('Vitor'), findsOneWidget);
    expect(
      find.text('Vitor devolveu a chave para a portaria.'),
      findsOneWidget,
    );
    expect(find.text('02/01/2026 às 17:10'), findsOneWidget);
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

    expect(find.text('Histórico: 30 registros'), findsOneWidget);
    expect(find.text('Movimentação número 30.'), findsOneWidget);
    expect(find.text('10/03/2026 às 08:29'), findsOneWidget);

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

    expect(find.text('01/01/2026 às 00:00'), findsOneWidget);
    expect(find.text('05/09/2026 às 07:03'), findsOneWidget);
    expect(find.text('31/12/2026 às 23:59'), findsOneWidget);
  });

  testWidgets('confirma antes de devolver chave para a portaria', (
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

    await testador.ensureVisible(find.text('Devolver chave para a portaria'));
    await testador.tap(find.text('Devolver chave para a portaria'));
    await testador.pumpAndSettle();

    expect(find.text('Devolver chave?'), findsOneWidget);
    expect(
      find.text('Confirme que Clara está devolvendo a chave para a portaria.'),
      findsOneWidget,
    );

    await testador.tap(find.text('Cancelar'));
    await testador.pumpAndSettle();

    expect(await repositorioDaSala.carregarSituacaoAtual(), situacaoInicial);
    expect(find.text('Chave com Clara'), findsOneWidget);
    expect(find.text('Histórico: 1 registro'), findsOneWidget);

    await testador.ensureVisible(find.text('Devolver chave para a portaria'));
    await testador.tap(find.text('Devolver chave para a portaria'));
    await testador.pumpAndSettle();
    await testador.tap(find.text('Confirmar devolução'));
    await testador.pumpAndSettle();

    final situacaoFinal = await repositorioDaSala.carregarSituacaoAtual();
    expect(
      situacaoFinal.localizacaoDaChave,
      const LocalizacaoDaChave.naPortaria(),
    );
    expect(situacaoFinal.historico.length, 2);
    expect(
      situacaoFinal.historico.last.descricao,
      'Clara devolveu a chave para a portaria.',
    );
    expect(find.text('Chave na portaria'), findsOneWidget);
    expect(find.text('Histórico: 2 registros'), findsOneWidget);
    expect(find.text('Clara devolveu a chave para a portaria.'), findsWidgets);
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

      await testador.ensureVisible(find.text('Passar chave para outra pessoa'));
      await testador.tap(find.text('Passar chave para outra pessoa'));
      await testador.pumpAndSettle();

      expect(find.text('Passar chave para quem?'), findsOneWidget);
      expect(find.text('Lucas'), findsNothing);
      expect(find.text('Clara'), findsOneWidget);
      expect(find.text('Amanda'), findsOneWidget);
      expect(find.text('Vitor'), findsOneWidget);

      await testador.tap(find.text('Amanda'));
      await testador.pumpAndSettle();

      expect(find.text('Passar chave?'), findsOneWidget);
      expect(
        find.text('Confirme que Lucas está passando a chave para Amanda.'),
        findsOneWidget,
      );

      await testador.tap(find.text('Cancelar'));
      await testador.pumpAndSettle();

      expect(await repositorioDaSala.carregarSituacaoAtual(), situacaoInicial);

      await testador.ensureVisible(find.text('Passar chave para outra pessoa'));
      await testador.tap(find.text('Passar chave para outra pessoa'));
      await testador.pumpAndSettle();
      await testador.tap(find.text('Amanda'));
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
      expect(find.text('Chave com Amanda'), findsOneWidget);
      expect(find.text('Histórico: 1 registro'), findsOneWidget);
      expect(find.text('Lucas passou a chave para Amanda.'), findsWidgets);
    },
  );
}
