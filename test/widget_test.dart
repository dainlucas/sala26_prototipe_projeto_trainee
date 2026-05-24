import 'package:chave_26/funcionalidades/configuracoes/dados/repositorio_local_do_perfil.dart';
import 'package:chave_26/funcionalidades/sala/dados/repositorio_local_da_sala.dart';
import 'package:chave_26/funcionalidades/sala/dominio/estado_da_sala.dart';
import 'package:chave_26/funcionalidades/sala/dominio/evento_historico.dart';
import 'package:chave_26/funcionalidades/sala/dominio/localizacao_da_chave.dart';
import 'package:chave_26/funcionalidades/sala/dominio/situacao_da_sala.dart';
import 'package:chave_26/main.dart';
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

  testWidgets('bloqueia ação quando nenhum perfil foi selecionado', (
    testador,
  ) async {
    final repositorioDaSala = await RepositorioLocalDaSala.criar();

    await testador.pumpWidget(const AplicativoChave26());
    await testador.pumpAndSettle();

    await testador.ensureVisible(find.text('Pegar chave na portaria'));
    await testador.tap(find.text('Pegar chave na portaria'));
    await testador.pumpAndSettle();

    expect(
      find.text('Escolha um perfil antes de alterar a sala.'),
      findsOneWidget,
    );
    expect(
      await repositorioDaSala.carregarSituacaoAtual(),
      SituacaoDaSala.inicial(),
    );
    expect(find.text('Histórico: 0 registros'), findsOneWidget);
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
}
