import 'package:chave_26/funcionalidades/configuracoes/dados/repositorio_local_do_perfil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('RepositorioLocalDoPerfil', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('não carrega perfil quando nenhum perfil foi salvo', () async {
      final repositorio = await RepositorioLocalDoPerfil.criar();

      final perfil = await repositorio.carregarPerfilSelecionado();

      expect(perfil, isNull);
    });

    test('salva e carrega perfil local selecionado', () async {
      final repositorio = await RepositorioLocalDoPerfil.criar();

      await repositorio.salvarPerfilSelecionado('Clara');

      final perfil = await repositorio.carregarPerfilSelecionado();

      expect(perfil, 'Clara');
    });

    test('limpa perfil local selecionado', () async {
      final repositorio = await RepositorioLocalDoPerfil.criar();

      await repositorio.salvarPerfilSelecionado('Amanda');
      expect(await repositorio.carregarPerfilSelecionado(), 'Amanda');

      await repositorio.limpar();

      expect(await repositorio.carregarPerfilSelecionado(), isNull);
    });
  });
}
