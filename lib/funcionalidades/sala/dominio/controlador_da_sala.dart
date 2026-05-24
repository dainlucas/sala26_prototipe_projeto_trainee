import 'estado_da_sala.dart';
import 'evento_historico.dart';
import 'localizacao_da_chave.dart';
import 'situacao_da_sala.dart';

class ResultadoAcaoDaSala {
  const ResultadoAcaoDaSala._({
    required this.sucesso,
    required this.situacao,
    required this.mensagem,
  });

  factory ResultadoAcaoDaSala.sucesso({
    required SituacaoDaSala situacao,
    required String mensagem,
  }) {
    return ResultadoAcaoDaSala._(
      sucesso: true,
      situacao: situacao,
      mensagem: mensagem,
    );
  }

  factory ResultadoAcaoDaSala.falha({
    required SituacaoDaSala situacao,
    required String mensagem,
  }) {
    return ResultadoAcaoDaSala._(
      sucesso: false,
      situacao: situacao,
      mensagem: mensagem,
    );
  }

  final bool sucesso;
  final SituacaoDaSala situacao;
  final String mensagem;
}

class ControladorDaSala {
  SituacaoDaSala situacaoInicial() => SituacaoDaSala.inicial();

  ResultadoAcaoDaSala pegarChaveNaPortaria({
    required SituacaoDaSala situacaoAtual,
    required String pessoaLogada,
    required DateTime momento,
  }) {
    final pessoa = pessoaLogada.trim();
    final falhaNome = _falhaSePessoaLogadaInvalida(situacaoAtual, pessoa);
    if (falhaNome != null) {
      return falhaNome;
    }

    if (!situacaoAtual.localizacaoDaChave.estaNaPortaria) {
      return ResultadoAcaoDaSala.falha(
        situacao: situacaoAtual,
        mensagem: 'A chave não está na portaria agora.',
      );
    }

    return _sucessoComEvento(
      situacaoAtual: situacaoAtual,
      pessoaLogada: pessoa,
      momento: momento,
      mensagem: '$pessoa pegou a chave na portaria.',
      estado: situacaoAtual.estado,
      localizacaoDaChave: LocalizacaoDaChave.comPessoa(pessoa),
    );
  }

  ResultadoAcaoDaSala abrirSala({
    required SituacaoDaSala situacaoAtual,
    required String pessoaLogada,
    required DateTime momento,
  }) {
    final pessoa = pessoaLogada.trim();
    final falhaNome = _falhaSePessoaLogadaInvalida(situacaoAtual, pessoa);
    if (falhaNome != null) {
      return falhaNome;
    }

    if (!situacaoAtual.localizacaoDaChave.estaCom(pessoa)) {
      return ResultadoAcaoDaSala.falha(
        situacao: situacaoAtual,
        mensagem: '$pessoa precisa estar com a chave para abrir a sala.',
      );
    }

    if (situacaoAtual.estado == EstadoDaSala.aberta) {
      return ResultadoAcaoDaSala.falha(
        situacao: situacaoAtual,
        mensagem: 'A sala já está aberta.',
      );
    }

    return _sucessoComEvento(
      situacaoAtual: situacaoAtual,
      pessoaLogada: pessoa,
      momento: momento,
      mensagem: '$pessoa abriu a sala 26.',
      estado: EstadoDaSala.aberta,
      localizacaoDaChave: const LocalizacaoDaChave.naSala(),
    );
  }

  ResultadoAcaoDaSala fecharSalaComChaveComigo({
    required SituacaoDaSala situacaoAtual,
    required String pessoaLogada,
    required DateTime momento,
  }) {
    final pessoa = pessoaLogada.trim();
    final falhaNome = _falhaSePessoaLogadaInvalida(situacaoAtual, pessoa);
    if (falhaNome != null) {
      return falhaNome;
    }

    final falhaSalaFechada = _falhaSeSalaJaEstaFechada(situacaoAtual);
    if (falhaSalaFechada != null) {
      return falhaSalaFechada;
    }

    if (!_podeManusearChaveDaSala(situacaoAtual, pessoa)) {
      return ResultadoAcaoDaSala.falha(
        situacao: situacaoAtual,
        mensagem:
            '$pessoa só pode fechar se estiver com a chave ou se for responsável pela sala aberta.',
      );
    }

    return _sucessoComEvento(
      situacaoAtual: situacaoAtual,
      pessoaLogada: pessoa,
      momento: momento,
      mensagem: '$pessoa fechou a sala 26 e ficou com a chave.',
      estado: EstadoDaSala.fechada,
      localizacaoDaChave: LocalizacaoDaChave.comPessoa(pessoa),
    );
  }

  ResultadoAcaoDaSala fecharSalaEDevolverChaveParaPortaria({
    required SituacaoDaSala situacaoAtual,
    required String pessoaLogada,
    required DateTime momento,
  }) {
    final pessoa = pessoaLogada.trim();
    final falhaNome = _falhaSePessoaLogadaInvalida(situacaoAtual, pessoa);
    if (falhaNome != null) {
      return falhaNome;
    }

    final falhaSalaFechada = _falhaSeSalaJaEstaFechada(situacaoAtual);
    if (falhaSalaFechada != null) {
      return falhaSalaFechada;
    }

    return _sucessoComEvento(
      situacaoAtual: situacaoAtual,
      pessoaLogada: pessoa,
      momento: momento,
      mensagem: '$pessoa fechou a sala 26 e devolveu a chave para a portaria.',
      estado: EstadoDaSala.fechada,
      localizacaoDaChave: const LocalizacaoDaChave.naPortaria(),
    );
  }

  ResultadoAcaoDaSala fecharSalaEPassarChaveParaOutraPessoa({
    required SituacaoDaSala situacaoAtual,
    required String pessoaLogada,
    required String outraPessoa,
    required DateTime momento,
  }) {
    final pessoa = pessoaLogada.trim();
    final pessoaDestino = outraPessoa.trim();
    final falhaNome =
        _falhaSePessoaLogadaInvalida(situacaoAtual, pessoa) ??
        _falhaSePessoaDestinoInvalida(situacaoAtual, pessoaDestino) ??
        _falhaSeTransferenciaParaSiMesmo(
          situacaoAtual,
          pessoaOrigem: pessoa,
          pessoaDestino: pessoaDestino,
        );
    if (falhaNome != null) {
      return falhaNome;
    }

    final falhaSalaFechada = _falhaSeSalaJaEstaFechada(situacaoAtual);
    if (falhaSalaFechada != null) {
      return falhaSalaFechada;
    }

    return _sucessoComEvento(
      situacaoAtual: situacaoAtual,
      pessoaLogada: pessoa,
      momento: momento,
      mensagem:
          '$pessoa fechou a sala 26 e passou a chave para $pessoaDestino.',
      estado: EstadoDaSala.fechada,
      localizacaoDaChave: LocalizacaoDaChave.comPessoa(pessoaDestino),
    );
  }

  ResultadoAcaoDaSala passarChaveParaOutraPessoa({
    required SituacaoDaSala situacaoAtual,
    required String pessoaLogada,
    required String outraPessoa,
    required DateTime momento,
  }) {
    final pessoa = pessoaLogada.trim();
    final pessoaDestino = outraPessoa.trim();
    final falhaNome =
        _falhaSePessoaLogadaInvalida(situacaoAtual, pessoa) ??
        _falhaSePessoaDestinoInvalida(situacaoAtual, pessoaDestino) ??
        _falhaSeTransferenciaParaSiMesmo(
          situacaoAtual,
          pessoaOrigem: pessoa,
          pessoaDestino: pessoaDestino,
        );
    if (falhaNome != null) {
      return falhaNome;
    }

    if (!_podeManusearChaveDaSala(situacaoAtual, pessoa)) {
      return ResultadoAcaoDaSala.falha(
        situacao: situacaoAtual,
        mensagem:
            '$pessoa precisa estar com a chave ou ser responsável pela sala aberta para passar para outra pessoa.',
      );
    }

    return _sucessoComEvento(
      situacaoAtual: situacaoAtual,
      pessoaLogada: pessoa,
      momento: momento,
      mensagem: '$pessoa passou a chave para $pessoaDestino.',
      estado: situacaoAtual.estado,
      localizacaoDaChave: LocalizacaoDaChave.comPessoa(pessoaDestino),
    );
  }

  ResultadoAcaoDaSala devolverChaveParaPortaria({
    required SituacaoDaSala situacaoAtual,
    required String pessoaLogada,
    required DateTime momento,
  }) {
    final pessoa = pessoaLogada.trim();
    final falhaNome = _falhaSePessoaLogadaInvalida(situacaoAtual, pessoa);
    if (falhaNome != null) {
      return falhaNome;
    }

    if (!situacaoAtual.localizacaoDaChave.estaCom(pessoa)) {
      return ResultadoAcaoDaSala.falha(
        situacao: situacaoAtual,
        mensagem:
            '$pessoa precisa estar com a chave para devolver para a portaria.',
      );
    }

    return _sucessoComEvento(
      situacaoAtual: situacaoAtual,
      pessoaLogada: pessoa,
      momento: momento,
      mensagem: '$pessoa devolveu a chave para a portaria.',
      estado: situacaoAtual.estado,
      localizacaoDaChave: const LocalizacaoDaChave.naPortaria(),
    );
  }

  ResultadoAcaoDaSala? _falhaSePessoaLogadaInvalida(
    SituacaoDaSala situacaoAtual,
    String pessoaLogada,
  ) {
    if (pessoaLogada.isEmpty) {
      return ResultadoAcaoDaSala.falha(
        situacao: situacaoAtual,
        mensagem: 'Informe o nome da pessoa logada.',
      );
    }

    return null;
  }

  ResultadoAcaoDaSala? _falhaSePessoaDestinoInvalida(
    SituacaoDaSala situacaoAtual,
    String pessoaDestino,
  ) {
    if (pessoaDestino.isEmpty) {
      return ResultadoAcaoDaSala.falha(
        situacao: situacaoAtual,
        mensagem: 'Informe o nome da pessoa que receberá a chave.',
      );
    }

    return null;
  }

  ResultadoAcaoDaSala? _falhaSeTransferenciaParaSiMesmo(
    SituacaoDaSala situacaoAtual, {
    required String pessoaOrigem,
    required String pessoaDestino,
  }) {
    if (pessoaOrigem == pessoaDestino) {
      return ResultadoAcaoDaSala.falha(
        situacao: situacaoAtual,
        mensagem: 'Escolha uma pessoa diferente para receber a chave.',
      );
    }

    return null;
  }

  ResultadoAcaoDaSala? _falhaSeSalaJaEstaFechada(SituacaoDaSala situacaoAtual) {
    if (situacaoAtual.estado == EstadoDaSala.fechada) {
      return ResultadoAcaoDaSala.falha(
        situacao: situacaoAtual,
        mensagem: 'A sala já está fechada.',
      );
    }

    return null;
  }

  bool _podeManusearChaveDaSala(SituacaoDaSala situacaoAtual, String pessoa) {
    if (situacaoAtual.localizacaoDaChave.estaCom(pessoa)) {
      return true;
    }

    return situacaoAtual.estado == EstadoDaSala.aberta &&
        situacaoAtual.localizacaoDaChave.estaNaSala &&
        situacaoAtual.pessoaUltimaAtualizacao == pessoa;
  }

  ResultadoAcaoDaSala _sucessoComEvento({
    required SituacaoDaSala situacaoAtual,
    required String pessoaLogada,
    required DateTime momento,
    required String mensagem,
    required EstadoDaSala estado,
    required LocalizacaoDaChave localizacaoDaChave,
  }) {
    final evento = EventoHistorico(
      momento: momento,
      pessoa: pessoaLogada,
      descricao: mensagem,
    );

    final novaSituacao = situacaoAtual.copiarCom(
      estado: estado,
      localizacaoDaChave: localizacaoDaChave,
      historico: [...situacaoAtual.historico, evento],
      pessoaUltimaAtualizacao: pessoaLogada,
      atualizadaEm: momento,
    );

    return ResultadoAcaoDaSala.sucesso(
      situacao: novaSituacao,
      mensagem: mensagem,
    );
  }
}
