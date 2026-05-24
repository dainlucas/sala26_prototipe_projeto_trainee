enum TipoLocalizacaoDaChave { portaria, sala, pessoa, destino }

class LocalizacaoDaChave {
  const LocalizacaoDaChave._({
    required this.tipo,
    this.nomeDaPessoa,
    this.nomeDoDestino,
  });

  const LocalizacaoDaChave.naPortaria()
    : this._(tipo: TipoLocalizacaoDaChave.portaria);

  const LocalizacaoDaChave.naSala() : this._(tipo: TipoLocalizacaoDaChave.sala);

  const LocalizacaoDaChave.comPessoa(String nomeDaPessoa)
    : this._(tipo: TipoLocalizacaoDaChave.pessoa, nomeDaPessoa: nomeDaPessoa);

  const LocalizacaoDaChave.guardadaEm(String nomeDoDestino)
    : this._(
        tipo: TipoLocalizacaoDaChave.destino,
        nomeDoDestino: nomeDoDestino,
      );

  final TipoLocalizacaoDaChave tipo;
  final String? nomeDaPessoa;
  final String? nomeDoDestino;

  bool get estaNaPortaria => tipo == TipoLocalizacaoDaChave.portaria;
  bool get estaNaSala => tipo == TipoLocalizacaoDaChave.sala;
  bool get estaComPessoa => tipo == TipoLocalizacaoDaChave.pessoa;
  bool get estaGuardadaEmDestino => tipo == TipoLocalizacaoDaChave.destino;

  bool estaCom(String pessoa) => estaComPessoa && nomeDaPessoa == pessoa;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is LocalizacaoDaChave &&
            other.tipo == tipo &&
            other.nomeDaPessoa == nomeDaPessoa &&
            other.nomeDoDestino == nomeDoDestino;
  }

  @override
  int get hashCode => Object.hash(tipo, nomeDaPessoa, nomeDoDestino);

  @override
  String toString() {
    return switch (tipo) {
      TipoLocalizacaoDaChave.portaria => 'LocalizacaoDaChave.naPortaria()',
      TipoLocalizacaoDaChave.sala => 'LocalizacaoDaChave.naSala()',
      TipoLocalizacaoDaChave.pessoa =>
        'LocalizacaoDaChave.comPessoa($nomeDaPessoa)',
      TipoLocalizacaoDaChave.destino =>
        'LocalizacaoDaChave.guardadaEm($nomeDoDestino)',
    };
  }
}
