enum TipoLocalizacaoDaChave { portaria, sala, pessoa }

class LocalizacaoDaChave {
  const LocalizacaoDaChave._({required this.tipo, this.nomeDaPessoa});

  const LocalizacaoDaChave.naPortaria()
    : this._(tipo: TipoLocalizacaoDaChave.portaria);

  const LocalizacaoDaChave.naSala() : this._(tipo: TipoLocalizacaoDaChave.sala);

  const LocalizacaoDaChave.comPessoa(String nomeDaPessoa)
    : this._(tipo: TipoLocalizacaoDaChave.pessoa, nomeDaPessoa: nomeDaPessoa);

  final TipoLocalizacaoDaChave tipo;
  final String? nomeDaPessoa;

  bool get estaNaPortaria => tipo == TipoLocalizacaoDaChave.portaria;
  bool get estaNaSala => tipo == TipoLocalizacaoDaChave.sala;
  bool get estaComPessoa => tipo == TipoLocalizacaoDaChave.pessoa;

  bool estaCom(String pessoa) => estaComPessoa && nomeDaPessoa == pessoa;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is LocalizacaoDaChave &&
            other.tipo == tipo &&
            other.nomeDaPessoa == nomeDaPessoa;
  }

  @override
  int get hashCode => Object.hash(tipo, nomeDaPessoa);

  @override
  String toString() {
    return switch (tipo) {
      TipoLocalizacaoDaChave.portaria => 'LocalizacaoDaChave.naPortaria()',
      TipoLocalizacaoDaChave.sala => 'LocalizacaoDaChave.naSala()',
      TipoLocalizacaoDaChave.pessoa =>
        'LocalizacaoDaChave.comPessoa($nomeDaPessoa)',
    };
  }
}
