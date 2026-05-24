import 'estado_da_sala.dart';
import 'evento_historico.dart';
import 'localizacao_da_chave.dart';

class SituacaoDaSala {
  SituacaoDaSala({
    required this.estado,
    required this.localizacaoDaChave,
    List<EventoHistorico> historico = const [],
    this.pessoaUltimaAtualizacao,
    this.atualizadaEm,
  }) : historico = List.unmodifiable(historico);

  factory SituacaoDaSala.inicial() {
    return SituacaoDaSala(
      estado: EstadoDaSala.fechada,
      localizacaoDaChave: const LocalizacaoDaChave.naPortaria(),
    );
  }

  final EstadoDaSala estado;
  final LocalizacaoDaChave localizacaoDaChave;
  final List<EventoHistorico> historico;
  final String? pessoaUltimaAtualizacao;
  final DateTime? atualizadaEm;

  SituacaoDaSala copiarCom({
    EstadoDaSala? estado,
    LocalizacaoDaChave? localizacaoDaChave,
    List<EventoHistorico>? historico,
    String? pessoaUltimaAtualizacao,
    DateTime? atualizadaEm,
  }) {
    return SituacaoDaSala(
      estado: estado ?? this.estado,
      localizacaoDaChave: localizacaoDaChave ?? this.localizacaoDaChave,
      historico: historico ?? this.historico,
      pessoaUltimaAtualizacao:
          pessoaUltimaAtualizacao ?? this.pessoaUltimaAtualizacao,
      atualizadaEm: atualizadaEm ?? this.atualizadaEm,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is SituacaoDaSala &&
            other.estado == estado &&
            other.localizacaoDaChave == localizacaoDaChave &&
            _listasIguais(other.historico, historico) &&
            other.pessoaUltimaAtualizacao == pessoaUltimaAtualizacao &&
            other.atualizadaEm == atualizadaEm;
  }

  @override
  int get hashCode => Object.hash(
    estado,
    localizacaoDaChave,
    Object.hashAll(historico),
    pessoaUltimaAtualizacao,
    atualizadaEm,
  );

  @override
  String toString() {
    return 'SituacaoDaSala(estado: $estado, '
        'localizacaoDaChave: $localizacaoDaChave, '
        'historico: $historico, '
        'pessoaUltimaAtualizacao: $pessoaUltimaAtualizacao, '
        'atualizadaEm: $atualizadaEm)';
  }
}

bool _listasIguais<T>(List<T> primeira, List<T> segunda) {
  if (identical(primeira, segunda)) {
    return true;
  }

  if (primeira.length != segunda.length) {
    return false;
  }

  for (var indice = 0; indice < primeira.length; indice += 1) {
    if (primeira[indice] != segunda[indice]) {
      return false;
    }
  }

  return true;
}
