# Chave 26

App Flutter/Dart para acompanhar o estado da sala 26 da Prototipe.

## Objetivo

O Chave 26 resolve um problema simples e real: saber rapidamente se a sala 26 está aberta ou fechada, onde está a chave, quem está responsável por ela e quais foram as últimas movimentações.

Este projeto é um MVP para teste de trainee. O foco é:

- celular/Android;
- interface simples, bonita e amigável;
- funcionamento local/offline;
- código simples, mas organizado;
- documentação constante;
- poucos testes automatizados, mas úteis.

## Escopo do MVP

Entra no MVP:

- perfis locais pré-definidos para demonstração;
- status da sala;
- localização da chave;
- ações principais da chave/sala;
- transferência da chave para outra pessoa;
- histórico simples;
- persistência local;
- confirmações para ações importantes.

Fica fora do MVP:

- Web;
- backend;
- sincronização entre vários celulares;
- login real/autenticação;
- notificações;
- integração com grupos de mensagem.

## Stack

- Flutter 3.44.0
- Dart 3.12.0
- Riverpod para organização de estado
- SharedPreferences com JSON para persistência local simples

As principais escolhas conscientes e limitações do protótipo estão registradas em `TRADEOFFS.md`.

## Ambiente WSL

Foi instalada uma versão Linux do Flutter em:

```bash
/home/dain/dev/flutter
```

O Android SDK Linux usado pelo WSL está em:

```bash
/home/dain/Android/Sdk
```

O Dart SDK usado pelo Flutter está em:

```bash
/home/dain/dev/flutter/bin/cache/dart-sdk
```

As variáveis de ambiente e PATH foram adicionados ao `~/.bashrc`:

```bash
export PATH="/home/dain/dev/flutter/bin:/home/dain/Android/Sdk/platform-tools:/home/dain/Android/Sdk/cmdline-tools/latest/bin:$PATH"
export ANDROID_HOME="/home/dain/Android/Sdk"
export ANDROID_SDK_ROOT="/home/dain/Android/Sdk"
```

Depois de abrir um novo terminal, os comandos curtos `flutter` e `dart` devem apontar para a instalação Linux do WSL.

Use estes comandos ao rodar pelo WSL:

```bash
flutter --version
flutter doctor
flutter test
flutter analyze
```

## Como rodar testes

```bash
flutter test
```

## Como analisar o código

```bash
flutter analyze
```

## Como gerar APK debug

```bash
flutter build apk --debug
```

O APK debug gerado fica em:

```bash
build/app/outputs/flutter-apk/app-debug.apk
```

## Documentação do projeto

- `contexto.md`: contexto do produto e decisões gerais.
- `BACKLOG.md`: planejamento, marcos, riscos e progresso.
- `documentos/decisoes-tecnicas.md`: decisões de stack, arquitetura e trade-offs.
- `documentos/plano-inicial.md`: plano inicial do MVP.
- `documentos/funcionalidades/`: registros das etapas implementadas.
