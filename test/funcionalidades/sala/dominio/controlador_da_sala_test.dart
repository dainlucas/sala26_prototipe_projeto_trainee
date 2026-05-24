import 'package:chave_26/funcionalidades/sala/dominio/controlador_da_sala.dart';
import 'package:chave_26/funcionalidades/sala/dominio/estado_da_sala.dart';
import 'package:chave_26/funcionalidades/sala/dominio/evento_historico.dart';
import 'package:chave_26/funcionalidades/sala/dominio/localizacao_da_chave.dart';
import 'package:chave_26/funcionalidades/sala/dominio/situacao_da_sala.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('modelos de domínio da sala', () {
    test('representam a situação inicial da sala 26', () {
      final situacao = SituacaoDaSala.inicial();

      expect(situacao.estado, EstadoDaSala.fechada);
      expect(situacao.localizacaoDaChave, LocalizacaoDaChave.naPortaria());
      expect(situacao.historico, isEmpty);
      expect(situacao.pessoaUltimaAtualizacao, isNull);
      expect(situacao.atualizadaEm, isNull);
    });

    test('registram evento histórico com data, pessoa e descrição', () {
      final momento = DateTime(2026, 1, 2, 14, 30);
      final evento = EventoHistorico(
        momento: momento,
        pessoa: 'Maria',
        descricao: 'Maria pegou a chave na portaria.',
      );

      expect(evento.momento, momento);
      expect(evento.pessoa, 'Maria');
      expect(evento.descricao, 'Maria pegou a chave na portaria.');
    });

    test('comparam eventos, localizações e situações por valor', () {
      final momento = DateTime(2026, 1, 2, 14, 30);
      final evento = EventoHistorico(
        momento: momento,
        pessoa: 'Maria',
        descricao: 'Maria pegou a chave na portaria.',
      );
      final eventoEquivalente = EventoHistorico(
        momento: momento,
        pessoa: 'Maria',
        descricao: 'Maria pegou a chave na portaria.',
      );
      final situacao = SituacaoDaSala(
        estado: EstadoDaSala.fechada,
        localizacaoDaChave: LocalizacaoDaChave.comPessoa('Maria'),
        historico: [evento],
        pessoaUltimaAtualizacao: 'Maria',
        atualizadaEm: momento,
      );
      final situacaoEquivalente = SituacaoDaSala(
        estado: EstadoDaSala.fechada,
        localizacaoDaChave: LocalizacaoDaChave.comPessoa('Maria'),
        historico: [eventoEquivalente],
        pessoaUltimaAtualizacao: 'Maria',
        atualizadaEm: momento,
      );

      expect(evento, eventoEquivalente);
      expect(
        LocalizacaoDaChave.comPessoa('Maria'),
        LocalizacaoDaChave.comPessoa('Maria'),
      );
      expect(situacao, situacaoEquivalente);
    });

    test('protegem o histórico contra alteração externa indevida', () {
      final momento = DateTime(2026, 1, 2, 14, 30);
      final eventosExternos = [
        EventoHistorico(
          momento: momento,
          pessoa: 'Lucas',
          descricao: 'Lucas pegou a chave na portaria.',
        ),
      ];
      final situacao = SituacaoDaSala(
        estado: EstadoDaSala.fechada,
        localizacaoDaChave: LocalizacaoDaChave.comPessoa('Lucas'),
        historico: eventosExternos,
        pessoaUltimaAtualizacao: 'Lucas',
        atualizadaEm: momento,
      );

      eventosExternos.add(
        EventoHistorico(
          momento: momento.add(const Duration(minutes: 5)),
          pessoa: 'Maria',
          descricao: 'Maria tentou alterar o histórico por fora.',
        ),
      );

      expect(situacao.historico, hasLength(1));
      expect(
        () => situacao.historico.add(
          EventoHistorico(
            momento: momento.add(const Duration(minutes: 10)),
            pessoa: 'João',
            descricao: 'João tentou alterar o histórico diretamente.',
          ),
        ),
        throwsUnsupportedError,
      );
    });
  });

  group('ControladorDaSala', () {
    test('cria a situação inicial padrão', () {
      final controlador = ControladorDaSala();

      expect(controlador.situacaoInicial(), SituacaoDaSala.inicial());
    });

    test('testa ação peguei a chave na portaria', () {
      final controlador = ControladorDaSala();
      final momento = DateTime(2026, 1, 2, 14, 30);

      final resultado = controlador.pegarChaveNaPortaria(
        situacaoAtual: SituacaoDaSala.inicial(),
        pessoaLogada: 'Lucas',
        momento: momento,
      );

      expect(resultado.sucesso, isTrue);
      expect(resultado.mensagem, 'Lucas pegou a chave na portaria.');
      expect(resultado.situacao.estado, EstadoDaSala.fechada);
      expect(
        resultado.situacao.localizacaoDaChave,
        LocalizacaoDaChave.comPessoa('Lucas'),
      );
      _esperarUltimaAtualizacao(
        resultado.situacao,
        pessoa: 'Lucas',
        momento: momento,
        descricao: 'Lucas pegou a chave na portaria.',
      );
    });

    test('testa ação abri a sala', () {
      final controlador = ControladorDaSala();
      final momentoPegou = DateTime(2026, 1, 2, 14, 20);
      final momentoAbriu = DateTime(2026, 1, 2, 14, 30);
      final comChave = controlador
          .pegarChaveNaPortaria(
            situacaoAtual: SituacaoDaSala.inicial(),
            pessoaLogada: 'Lucas',
            momento: momentoPegou,
          )
          .situacao;

      final resultado = controlador.abrirSala(
        situacaoAtual: comChave,
        pessoaLogada: 'Lucas',
        momento: momentoAbriu,
      );

      expect(resultado.sucesso, isTrue);
      expect(resultado.mensagem, 'Lucas abriu a sala 26.');
      expect(resultado.situacao.estado, EstadoDaSala.aberta);
      expect(
        resultado.situacao.localizacaoDaChave,
        LocalizacaoDaChave.naSala(),
      );
      expect(resultado.situacao.historico, hasLength(2));
      _esperarUltimaAtualizacao(
        resultado.situacao,
        pessoa: 'Lucas',
        momento: momentoAbriu,
        descricao: 'Lucas abriu a sala 26.',
      );
    });

    test('testa ação fechei a sala com chave comigo', () {
      final controlador = ControladorDaSala();
      final salaAberta = _situacaoAbertaPeloLucas(controlador);
      final momentoFechou = DateTime(2026, 1, 2, 17, 40);

      final resultado = controlador.fecharSalaComChaveComigo(
        situacaoAtual: salaAberta,
        pessoaLogada: 'Lucas',
        momento: momentoFechou,
      );

      expect(resultado.sucesso, isTrue);
      expect(resultado.mensagem, 'Lucas fechou a sala 26 e ficou com a chave.');
      expect(resultado.situacao.estado, EstadoDaSala.fechada);
      expect(
        resultado.situacao.localizacaoDaChave,
        LocalizacaoDaChave.comPessoa('Lucas'),
      );
      expect(resultado.situacao.historico, hasLength(3));
      _esperarUltimaAtualizacao(
        resultado.situacao,
        pessoa: 'Lucas',
        momento: momentoFechou,
        descricao: 'Lucas fechou a sala 26 e ficou com a chave.',
      );
    });

    test('testa ação fechei a sala e devolvi para portaria', () {
      final controlador = ControladorDaSala();
      final salaAberta = _situacaoAbertaPeloLucas(controlador);
      final momentoFechou = DateTime(2026, 1, 2, 17, 40);

      final resultado = controlador.fecharSalaEDevolverChaveParaPortaria(
        situacaoAtual: salaAberta,
        pessoaLogada: 'Lucas',
        momento: momentoFechou,
      );

      expect(resultado.sucesso, isTrue);
      expect(
        resultado.mensagem,
        'Lucas fechou a sala 26 e devolveu a chave para a portaria.',
      );
      expect(resultado.situacao.estado, EstadoDaSala.fechada);
      expect(
        resultado.situacao.localizacaoDaChave,
        LocalizacaoDaChave.naPortaria(),
      );
      expect(resultado.situacao.historico, hasLength(3));
      _esperarUltimaAtualizacao(
        resultado.situacao,
        pessoa: 'Lucas',
        momento: momentoFechou,
        descricao: 'Lucas fechou a sala 26 e devolveu a chave para a portaria.',
      );
    });

    test('testa ação devolvi a chave para portaria sem fechar a sala', () {
      final controlador = ControladorDaSala();
      final momentoPegou = DateTime(2026, 1, 2, 14, 20);
      final momentoDevolveu = DateTime(2026, 1, 2, 14, 35);
      final comChave = controlador
          .pegarChaveNaPortaria(
            situacaoAtual: SituacaoDaSala.inicial(),
            pessoaLogada: 'Lucas',
            momento: momentoPegou,
          )
          .situacao;

      final resultado = controlador.devolverChaveParaPortaria(
        situacaoAtual: comChave,
        pessoaLogada: 'Lucas',
        momento: momentoDevolveu,
      );

      expect(resultado.sucesso, isTrue);
      expect(resultado.mensagem, 'Lucas devolveu a chave para a portaria.');
      expect(resultado.situacao.estado, EstadoDaSala.fechada);
      expect(
        resultado.situacao.localizacaoDaChave,
        LocalizacaoDaChave.naPortaria(),
      );
      expect(resultado.situacao.historico, hasLength(2));
      _esperarUltimaAtualizacao(
        resultado.situacao,
        pessoa: 'Lucas',
        momento: momentoDevolveu,
        descricao: 'Lucas devolveu a chave para a portaria.',
      );
    });

    test('testa ação fechei a sala e passei a chave para outra pessoa', () {
      final controlador = ControladorDaSala();
      final salaAberta = _situacaoAbertaPeloLucas(controlador);
      final momentoFechou = DateTime(2026, 1, 2, 17, 40);

      final resultado = controlador.fecharSalaEPassarChaveParaOutraPessoa(
        situacaoAtual: salaAberta,
        pessoaLogada: 'Lucas',
        outraPessoa: 'Maria',
        momento: momentoFechou,
      );

      expect(resultado.sucesso, isTrue);
      expect(
        resultado.mensagem,
        'Lucas fechou a sala 26 e passou a chave para Maria.',
      );
      expect(resultado.situacao.estado, EstadoDaSala.fechada);
      expect(
        resultado.situacao.localizacaoDaChave,
        LocalizacaoDaChave.comPessoa('Maria'),
      );
      expect(resultado.situacao.historico, hasLength(3));
      _esperarUltimaAtualizacao(
        resultado.situacao,
        pessoa: 'Lucas',
        momento: momentoFechou,
        descricao: 'Lucas fechou a sala 26 e passou a chave para Maria.',
      );
    });

    test('testa ação passei a chave para outra pessoa', () {
      final controlador = ControladorDaSala();
      final momentoPegou = DateTime(2026, 1, 2, 14, 20);
      final momentoPassou = DateTime(2026, 1, 2, 15, 10);
      final comChave = controlador
          .pegarChaveNaPortaria(
            situacaoAtual: SituacaoDaSala.inicial(),
            pessoaLogada: 'Lucas',
            momento: momentoPegou,
          )
          .situacao;

      final resultado = controlador.passarChaveParaOutraPessoa(
        situacaoAtual: comChave,
        pessoaLogada: 'Lucas',
        outraPessoa: 'Maria',
        momento: momentoPassou,
      );

      expect(resultado.sucesso, isTrue);
      expect(resultado.mensagem, 'Lucas passou a chave para Maria.');
      expect(resultado.situacao.estado, EstadoDaSala.fechada);
      expect(
        resultado.situacao.localizacaoDaChave,
        LocalizacaoDaChave.comPessoa('Maria'),
      );
      expect(resultado.situacao.historico, hasLength(2));
      _esperarUltimaAtualizacao(
        resultado.situacao,
        pessoa: 'Lucas',
        momento: momentoPassou,
        descricao: 'Lucas passou a chave para Maria.',
      );
    });

    test('permite que quem abriu a sala passe a chave guardada na sala', () {
      final controlador = ControladorDaSala();
      final salaAberta = _situacaoAbertaPeloLucas(controlador);
      final momentoPassou = DateTime(2026, 1, 2, 15, 10);

      final resultado = controlador.passarChaveParaOutraPessoa(
        situacaoAtual: salaAberta,
        pessoaLogada: 'Lucas',
        outraPessoa: 'Maria',
        momento: momentoPassou,
      );

      expect(resultado.sucesso, isTrue);
      expect(resultado.mensagem, 'Lucas passou a chave para Maria.');
      expect(resultado.situacao.estado, EstadoDaSala.aberta);
      expect(
        resultado.situacao.localizacaoDaChave,
        LocalizacaoDaChave.comPessoa('Maria'),
      );
      expect(resultado.situacao.historico, hasLength(3));
      _esperarUltimaAtualizacao(
        resultado.situacao,
        pessoa: 'Lucas',
        momento: momentoPassou,
        descricao: 'Lucas passou a chave para Maria.',
      );
    });

    test('mantém a sequência completa do histórico na ordem das ações', () {
      final controlador = ControladorDaSala();
      final momentoPegou = DateTime(2026, 1, 2, 14, 20);
      final momentoAbriu = DateTime(2026, 1, 2, 14, 30);
      final momentoFechou = DateTime(2026, 1, 2, 17, 40);

      final comChave = controlador
          .pegarChaveNaPortaria(
            situacaoAtual: SituacaoDaSala.inicial(),
            pessoaLogada: 'Lucas',
            momento: momentoPegou,
          )
          .situacao;
      final salaAberta = controlador
          .abrirSala(
            situacaoAtual: comChave,
            pessoaLogada: 'Lucas',
            momento: momentoAbriu,
          )
          .situacao;
      final salaFechada = controlador
          .fecharSalaEPassarChaveParaOutraPessoa(
            situacaoAtual: salaAberta,
            pessoaLogada: 'Lucas',
            outraPessoa: 'Maria',
            momento: momentoFechou,
          )
          .situacao;

      expect(salaFechada.historico, [
        EventoHistorico(
          momento: momentoPegou,
          pessoa: 'Lucas',
          descricao: 'Lucas pegou a chave na portaria.',
        ),
        EventoHistorico(
          momento: momentoAbriu,
          pessoa: 'Lucas',
          descricao: 'Lucas abriu a sala 26.',
        ),
        EventoHistorico(
          momento: momentoFechou,
          pessoa: 'Lucas',
          descricao: 'Lucas fechou a sala 26 e passou a chave para Maria.',
        ),
      ]);
    });

    group('bloqueios de ações inválidas', () {
      test(
        'bloqueia abrir a sala quando a chave não está com a pessoa logada',
        () {
          final controlador = ControladorDaSala();
          final situacaoInicial = SituacaoDaSala.inicial();
          final momento = DateTime(2026, 1, 2, 14, 30);

          final resultado = controlador.abrirSala(
            situacaoAtual: situacaoInicial,
            pessoaLogada: 'Lucas',
            momento: momento,
          );

          _esperarFalhaSemAlterarSituacao(
            resultado,
            situacaoEsperada: situacaoInicial,
            mensagemEsperada:
                'Lucas precisa estar com a chave para abrir a sala.',
          );
        },
      );

      test('bloqueia pegar a chave quando ela não está na portaria', () {
        final controlador = ControladorDaSala();
        final momento = DateTime(2026, 1, 2, 14, 30);
        final comChaveLucas = controlador
            .pegarChaveNaPortaria(
              situacaoAtual: SituacaoDaSala.inicial(),
              pessoaLogada: 'Lucas',
              momento: momento,
            )
            .situacao;

        final resultado = controlador.pegarChaveNaPortaria(
          situacaoAtual: comChaveLucas,
          pessoaLogada: 'Maria',
          momento: momento.add(const Duration(minutes: 5)),
        );

        _esperarFalhaSemAlterarSituacao(
          resultado,
          situacaoEsperada: comChaveLucas,
          mensagemEsperada: 'A chave não está na portaria agora.',
        );
      });

      test('bloqueia abrir uma sala que já está aberta', () {
        final controlador = ControladorDaSala();
        final salaAbertaComChaveNaMao = _situacaoAbertaPeloLucas(
          controlador,
        ).copiarCom(localizacaoDaChave: LocalizacaoDaChave.comPessoa('Lucas'));

        final resultado = controlador.abrirSala(
          situacaoAtual: salaAbertaComChaveNaMao,
          pessoaLogada: 'Lucas',
          momento: DateTime(2026, 1, 2, 15),
        );

        _esperarFalhaSemAlterarSituacao(
          resultado,
          situacaoEsperada: salaAbertaComChaveNaMao,
          mensagemEsperada: 'A sala já está aberta.',
        );
      });

      test('bloqueia fechar uma sala que já está fechada', () {
        final controlador = ControladorDaSala();
        final situacaoInicial = SituacaoDaSala.inicial();

        final resultado = controlador.fecharSalaComChaveComigo(
          situacaoAtual: situacaoInicial,
          pessoaLogada: 'Lucas',
          momento: DateTime(2026, 1, 2, 15),
        );

        _esperarFalhaSemAlterarSituacao(
          resultado,
          situacaoEsperada: situacaoInicial,
          mensagemEsperada: 'A sala já está fechada.',
        );
      });

      test('bloqueia outro perfil de fechar a sala aberta por Lucas', () {
        final controlador = ControladorDaSala();
        final salaAberta = _situacaoAbertaPeloLucas(controlador);

        final resultado = controlador.fecharSalaComChaveComigo(
          situacaoAtual: salaAberta,
          pessoaLogada: 'Clara',
          momento: DateTime(2026, 1, 2, 17, 40),
        );

        _esperarFalhaSemAlterarSituacao(
          resultado,
          situacaoEsperada: salaAberta,
          mensagemEsperada:
              'Clara só pode fechar se estiver com a chave ou se for responsável pela sala aberta.',
        );
      });

      test(
        'bloqueia passar a chave sem estar com ela ou sem ser responsável',
        () {
          final controlador = ControladorDaSala();
          final situacaoInicial = SituacaoDaSala.inicial();

          final resultado = controlador.passarChaveParaOutraPessoa(
            situacaoAtual: situacaoInicial,
            pessoaLogada: 'Lucas',
            outraPessoa: 'Maria',
            momento: DateTime(2026, 1, 2, 15),
          );

          _esperarFalhaSemAlterarSituacao(
            resultado,
            situacaoEsperada: situacaoInicial,
            mensagemEsperada:
                'Lucas precisa estar com a chave ou ser responsável pela sala aberta para passar para outra pessoa.',
          );
        },
      );

      test('bloqueia devolver a chave sem estar com ela', () {
        final controlador = ControladorDaSala();
        final situacaoInicial = SituacaoDaSala.inicial();

        final resultado = controlador.devolverChaveParaPortaria(
          situacaoAtual: situacaoInicial,
          pessoaLogada: 'Lucas',
          momento: DateTime(2026, 1, 2, 15),
        );

        _esperarFalhaSemAlterarSituacao(
          resultado,
          situacaoEsperada: situacaoInicial,
          mensagemEsperada:
              'Lucas precisa estar com a chave para devolver para a portaria.',
        );
      });
    });

    group('validação de nomes no domínio', () {
      test('bloqueia pessoa logada vazia ou só com espaços', () {
        final controlador = ControladorDaSala();
        final situacaoInicial = SituacaoDaSala.inicial();

        final resultadoNomeVazio = controlador.pegarChaveNaPortaria(
          situacaoAtual: situacaoInicial,
          pessoaLogada: '',
          momento: DateTime(2026, 1, 2, 15),
        );
        final resultadoNomeComEspacos = controlador.pegarChaveNaPortaria(
          situacaoAtual: situacaoInicial,
          pessoaLogada: '   ',
          momento: DateTime(2026, 1, 2, 15),
        );

        _esperarFalhaSemAlterarSituacao(
          resultadoNomeVazio,
          situacaoEsperada: situacaoInicial,
          mensagemEsperada: 'Informe o nome da pessoa logada.',
        );
        _esperarFalhaSemAlterarSituacao(
          resultadoNomeComEspacos,
          situacaoEsperada: situacaoInicial,
          mensagemEsperada: 'Informe o nome da pessoa logada.',
        );
      });

      test(
        'bloqueia transferência para nome vazio ou para a própria pessoa',
        () {
          final controlador = ControladorDaSala();
          final momento = DateTime(2026, 1, 2, 15);
          final comChaveLucas = controlador
              .pegarChaveNaPortaria(
                situacaoAtual: SituacaoDaSala.inicial(),
                pessoaLogada: 'Lucas',
                momento: momento,
              )
              .situacao;

          final resultadoPessoaVazia = controlador.passarChaveParaOutraPessoa(
            situacaoAtual: comChaveLucas,
            pessoaLogada: 'Lucas',
            outraPessoa: '   ',
            momento: momento.add(const Duration(minutes: 5)),
          );
          final resultadoMesmaPessoa = controlador.passarChaveParaOutraPessoa(
            situacaoAtual: comChaveLucas,
            pessoaLogada: 'Lucas',
            outraPessoa: 'Lucas',
            momento: momento.add(const Duration(minutes: 5)),
          );

          _esperarFalhaSemAlterarSituacao(
            resultadoPessoaVazia,
            situacaoEsperada: comChaveLucas,
            mensagemEsperada: 'Informe o nome da pessoa que receberá a chave.',
          );
          _esperarFalhaSemAlterarSituacao(
            resultadoMesmaPessoa,
            situacaoEsperada: comChaveLucas,
            mensagemEsperada:
                'Escolha uma pessoa diferente para receber a chave.',
          );
        },
      );
    });
  });
}

SituacaoDaSala _situacaoAbertaPeloLucas(ControladorDaSala controlador) {
  final comChave = controlador
      .pegarChaveNaPortaria(
        situacaoAtual: SituacaoDaSala.inicial(),
        pessoaLogada: 'Lucas',
        momento: DateTime(2026, 1, 2, 14, 20),
      )
      .situacao;

  return controlador
      .abrirSala(
        situacaoAtual: comChave,
        pessoaLogada: 'Lucas',
        momento: DateTime(2026, 1, 2, 14, 30),
      )
      .situacao;
}

void _esperarUltimaAtualizacao(
  SituacaoDaSala situacao, {
  required String pessoa,
  required DateTime momento,
  required String descricao,
}) {
  expect(situacao.pessoaUltimaAtualizacao, pessoa);
  expect(situacao.atualizadaEm, momento);
  expect(
    situacao.historico.last,
    EventoHistorico(momento: momento, pessoa: pessoa, descricao: descricao),
  );
}

void _esperarFalhaSemAlterarSituacao(
  ResultadoAcaoDaSala resultado, {
  required SituacaoDaSala situacaoEsperada,
  required String mensagemEsperada,
}) {
  expect(resultado.sucesso, isFalse);
  expect(resultado.situacao, situacaoEsperada);
  expect(resultado.mensagem, mensagemEsperada);
}
