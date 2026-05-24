import 'package:shared_preferences/shared_preferences.dart';

class RepositorioLocalDoPerfil {
  RepositorioLocalDoPerfil._(this._preferencias);

  static const _chavePerfilSelecionado = 'configuracoes.perfil_selecionado';

  final SharedPreferences _preferencias;

  static Future<RepositorioLocalDoPerfil> criar() async {
    final preferencias = await SharedPreferences.getInstance();
    return RepositorioLocalDoPerfil._(preferencias);
  }

  Future<String?> carregarPerfilSelecionado() async {
    return _preferencias.getString(_chavePerfilSelecionado);
  }

  Future<void> salvarPerfilSelecionado(String perfil) async {
    await _preferencias.setString(_chavePerfilSelecionado, perfil);
  }

  Future<void> limpar() async {
    await _preferencias.remove(_chavePerfilSelecionado);
  }
}
