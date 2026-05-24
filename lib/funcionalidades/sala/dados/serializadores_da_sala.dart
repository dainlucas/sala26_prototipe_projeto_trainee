import 'dart:convert';

import '../dominio/estado_da_sala.dart';
import '../dominio/evento_historico.dart';
import '../dominio/localizacao_da_chave.dart';
import '../dominio/situacao_da_sala.dart';

class SerializadoresDaSala {
  const SerializadoresDaSala._();

  static String situacaoParaJson(SituacaoDaSala situacao) {
    return jsonEncode(_situacaoParaMapa(situacao));
  }

  static SituacaoDaSala situacaoDeJson(String json) {
    final mapa = jsonDecode(json) as Map<String, Object?>;
    return _situacaoDeMapa(mapa);
  }

  static Map<String, Object?> _situacaoParaMapa(SituacaoDaSala situacao) {
    return {
      'estado': situacao.estado.name,
      'localizacaoDaChave': _localizacaoParaMapa(situacao.localizacaoDaChave),
      'historico': situacao.historico.map(_eventoParaMapa).toList(),
      'pessoaUltimaAtualizacao': situacao.pessoaUltimaAtualizacao,
      'atualizadaEm': situacao.atualizadaEm?.toIso8601String(),
    };
  }

  static SituacaoDaSala _situacaoDeMapa(Map<String, Object?> mapa) {
    final historicoJson = (mapa['historico'] as List<Object?>? ?? const []);

    return SituacaoDaSala(
      estado: _estadoDeTexto(mapa['estado'] as String),
      localizacaoDaChave: _localizacaoDeMapa(
        mapa['localizacaoDaChave'] as Map<String, Object?>,
      ),
      historico: historicoJson
          .cast<Map<String, Object?>>()
          .map(_eventoDeMapa)
          .toList(),
      pessoaUltimaAtualizacao: mapa['pessoaUltimaAtualizacao'] as String?,
      atualizadaEm: _dataOpcionalDeTexto(mapa['atualizadaEm'] as String?),
    );
  }

  static Map<String, Object?> _localizacaoParaMapa(
    LocalizacaoDaChave localizacao,
  ) {
    return {
      'tipo': localizacao.tipo.name,
      'nomeDaPessoa': localizacao.nomeDaPessoa,
    };
  }

  static LocalizacaoDaChave _localizacaoDeMapa(Map<String, Object?> mapa) {
    final tipo = _tipoLocalizacaoDeTexto(mapa['tipo'] as String);

    return switch (tipo) {
      TipoLocalizacaoDaChave.portaria => const LocalizacaoDaChave.naPortaria(),
      TipoLocalizacaoDaChave.sala => const LocalizacaoDaChave.naSala(),
      TipoLocalizacaoDaChave.pessoa => LocalizacaoDaChave.comPessoa(
        mapa['nomeDaPessoa'] as String,
      ),
    };
  }

  static Map<String, Object?> _eventoParaMapa(EventoHistorico evento) {
    return {
      'momento': evento.momento.toIso8601String(),
      'pessoa': evento.pessoa,
      'descricao': evento.descricao,
    };
  }

  static EventoHistorico _eventoDeMapa(Map<String, Object?> mapa) {
    return EventoHistorico(
      momento: DateTime.parse(mapa['momento'] as String),
      pessoa: mapa['pessoa'] as String,
      descricao: mapa['descricao'] as String,
    );
  }

  static EstadoDaSala _estadoDeTexto(String texto) {
    return EstadoDaSala.values.byName(texto);
  }

  static TipoLocalizacaoDaChave _tipoLocalizacaoDeTexto(String texto) {
    return TipoLocalizacaoDaChave.values.byName(texto);
  }

  static DateTime? _dataOpcionalDeTexto(String? texto) {
    if (texto == null) {
      return null;
    }

    return DateTime.parse(texto);
  }
}
