class EventoHistorico {
  const EventoHistorico({
    required this.momento,
    required this.pessoa,
    required this.descricao,
  });

  final DateTime momento;
  final String pessoa;
  final String descricao;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is EventoHistorico &&
            other.momento == momento &&
            other.pessoa == pessoa &&
            other.descricao == descricao;
  }

  @override
  int get hashCode => Object.hash(momento, pessoa, descricao);

  @override
  String toString() {
    return 'EventoHistorico(momento: $momento, pessoa: $pessoa, '
        'descricao: $descricao)';
  }
}
