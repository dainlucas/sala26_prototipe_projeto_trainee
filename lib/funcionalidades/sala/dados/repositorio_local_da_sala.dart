import 'package:shared_preferences/shared_preferences.dart';

import '../dominio/evento_historico.dart';
import '../dominio/situacao_da_sala.dart';
import 'serializadores_da_sala.dart';

class RepositorioLocalDaSala {
  RepositorioLocalDaSala._(this._preferencias);

  static const _chaveSituacaoDaSala = 'sala.situacao_atual';
  static const _chaveDestinosCustomizados = 'sala.destinos_customizados';
  static const destinosFixosDaChave = ['Portaria', 'Maker Space'];

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

  Future<List<String>> carregarDestinosDaChave() async {
    return [...destinosFixosDaChave, ..._carregarDestinosCustomizados()];
  }

  Future<void> adicionarDestinoCustomizado(String destino) async {
    final destinoNormalizado = destino.trim();
    if (destinoNormalizado.isEmpty ||
        destinosFixosDaChave.contains(destinoNormalizado)) {
      return;
    }

    final destinos = _carregarDestinosCustomizados();
    if (!destinos.contains(destinoNormalizado)) {
      destinos.add(destinoNormalizado);
      await _salvarDestinosCustomizados(destinos);
    }
  }

  Future<void> renomearDestinoCustomizado(
    String destinoAtual,
    String novoDestino,
  ) async {
    final atual = destinoAtual.trim();
    final novo = novoDestino.trim();
    if (atual.isEmpty || novo.isEmpty || destinosFixosDaChave.contains(atual)) {
      return;
    }

    final destinos = _carregarDestinosCustomizados();
    final indice = destinos.indexOf(atual);
    if (indice == -1 || destinosFixosDaChave.contains(novo)) {
      return;
    }

    destinos[indice] = novo;
    await _salvarDestinosCustomizados(_semDuplicatas(destinos));
  }

  Future<void> removerDestinoCustomizado(String destino) async {
    final destinoNormalizado = destino.trim();
    if (destinoNormalizado.isEmpty ||
        destinosFixosDaChave.contains(destinoNormalizado)) {
      return;
    }

    final destinos = _carregarDestinosCustomizados()
      ..removeWhere((item) => item == destinoNormalizado);
    await _salvarDestinosCustomizados(destinos);
  }

  Future<void> limpar() async {
    await _preferencias.remove(_chaveSituacaoDaSala);
  }

  List<String> _carregarDestinosCustomizados() {
    return _semDuplicatas(
      _preferencias
              .getStringList(_chaveDestinosCustomizados)
              ?.map((destino) => destino.trim())
              .where((destino) => destino.isNotEmpty)
              .where((destino) => !destinosFixosDaChave.contains(destino))
              .toList() ??
          <String>[],
    );
  }

  Future<void> _salvarDestinosCustomizados(List<String> destinos) async {
    await _preferencias.setStringList(
      _chaveDestinosCustomizados,
      _semDuplicatas(destinos),
    );
  }

  List<String> _semDuplicatas(Iterable<String> destinos) {
    final resultado = <String>[];
    for (final destino in destinos) {
      final destinoNormalizado = destino.trim();
      if (destinoNormalizado.isNotEmpty &&
          !resultado.contains(destinoNormalizado)) {
        resultado.add(destinoNormalizado);
      }
    }
    return resultado;
  }
}
