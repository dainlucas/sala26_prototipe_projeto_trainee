import 'package:shared_preferences/shared_preferences.dart';

import '../dominio/evento_historico.dart';
import '../dominio/situacao_da_sala.dart';
import 'serializadores_da_sala.dart';

class RepositorioLocalDaSala {
  RepositorioLocalDaSala._(this._preferencias);

  static const _chaveSituacaoDaSala = 'sala.situacao_atual';

  final SharedPreferences _preferencias;

  static Future<RepositorioLocalDaSala> criar() async {
    final preferencias = await SharedPreferences.getInstance();
    return RepositorioLocalDaSala._(preferencias);
  }

  Future<SituacaoDaSala> carregarSituacaoAtual() async {
    final json = _preferencias.getString(_chaveSituacaoDaSala);
    if (json == null) {
      return SituacaoDaSala.inicial();
    }

    return SerializadoresDaSala.situacaoDeJson(json);
  }

  Future<List<EventoHistorico>> carregarHistorico() async {
    final situacao = await carregarSituacaoAtual();
    return situacao.historico;
  }

  Future<void> salvarSituacaoAtual(SituacaoDaSala situacao) async {
    final json = SerializadoresDaSala.situacaoParaJson(situacao);
    await _preferencias.setString(_chaveSituacaoDaSala, json);
  }

  Future<void> limpar() async {
    await _preferencias.remove(_chaveSituacaoDaSala);
  }
}
