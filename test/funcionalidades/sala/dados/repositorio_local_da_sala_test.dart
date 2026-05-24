import 'package:chave_26/funcionalidades/sala/dados/repositorio_local_da_sala.dart';
import 'package:chave_26/funcionalidades/sala/dados/serializadores_da_sala.dart';
import 'package:chave_26/funcionalidades/sala/dominio/estado_da_sala.dart';
import 'package:chave_26/funcionalidades/sala/dominio/evento_historico.dart';
import 'package:chave_26/funcionalidades/sala/dominio/localizacao_da_chave.dart';
import 'package:chave_26/funcionalidades/sala/dominio/situacao_da_sala.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('SerializadoresDaSala', () {
    test('convertem situação completa da sala para JSON e de volta', () {
      final momentoPegou = DateTime(2026, 1, 2, 14, 20);
      final momentoPassou = DateTime(2026, 1, 2, 15, 10);
      final situacao = SituacaoDaSala(
        estado: EstadoDaSala.fechada,
        localizacaoDaChave: LocalizacaoDaChave.comPessoa('Clara'),
        historico: [
          EventoHistorico(
            momento: momentoPegou,
            pessoa: 'Lucas',
            descricao: 'Lucas pegou a chave na portaria.',
          ),
          EventoHistorico(
            momento: momentoPassou,
            pessoa: 'Lucas',
            descricao: 'Lucas passou a chave para Clara.',
          ),
        ],
        pessoaUltimaAtualizacao: 'Lucas',
        atualizadaEm: momentoPassou,
      );

      final json = SerializadoresDaSala.situacaoParaJson(situacao);
      final restaurada = SerializadoresDaSala.situacaoDeJson(json);

      expect(restaurada, situacao);
      expect(restaurada.historico, hasLength(2));
      expect(restaurada.historico.last.pessoa, 'Lucas');
      expect(
        restaurada.localizacaoDaChave,
        LocalizacaoDaChave.comPessoa('Clara'),
      );
    });
  });

  group('RepositorioLocalDaSala', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test(
      'carrega situação inicial e histórico vazio quando não há dados salvos',
      () async {
        final repositorio = await RepositorioLocalDaSala.criar();

        final situacao = await repositorio.carregarSituacaoAtual();
        final historico = await repositorio.carregarHistorico();

        expect(situacao, SituacaoDaSala.inicial());
        expect(historico, isEmpty);
      },
    );

    test(
      'salva e carrega estado atual da sala com histórico completo',
      () async {
        final repositorio = await RepositorioLocalDaSala.criar();
        final momento = DateTime(2026, 1, 2, 17, 40);
        final situacao = SituacaoDaSala(
          estado: EstadoDaSala.aberta,
          localizacaoDaChave: const LocalizacaoDaChave.naSala(),
          historico: [
            EventoHistorico(
              momento: momento,
              pessoa: 'Amanda',
              descricao: 'Amanda abriu a sala 26.',
            ),
          ],
          pessoaUltimaAtualizacao: 'Amanda',
          atualizadaEm: momento,
        );

        await repositorio.salvarSituacaoAtual(situacao);

        final situacaoCarregada = await repositorio.carregarSituacaoAtual();
        final historicoCarregado = await repositorio.carregarHistorico();

        expect(situacaoCarregada, situacao);
        expect(historicoCarregado, situacao.historico);
      },
    );
  });
}
