# Feature 001 — Preparação do projeto Flutter

## Objetivo

Preparar a base do projeto Chave 26 para desenvolvimento mobile/Android em Flutter dentro do WSL.

## O que foi feito

- Instalado Flutter Linux no WSL em `/home/dain/dev/flutter`.
- Instalado/configurado Android SDK Linux no WSL em `/home/dain/Android/Sdk`.
- Instalado OpenJDK 17 para o build Android.
- Aceitas as licenças Android SDK.
- Validado `flutter doctor` com Android toolchain reconhecido.
- Gerado APK debug em `build/app/outputs/flutter-apk/app-debug.apk`.
- Criado projeto Flutter com nome técnico `chave_26`.
- Criado somente target Android com `--platforms android`, mantendo foco no celular e deixando Web fora do MVP.
- Adicionadas dependências:
  - `flutter_riverpod` para organização de estado;
  - `shared_preferences` para persistência local simples.
- Movida a imagem fornecida do mascote para `assets/images/mascote_prototipe.png`.
- Registrado o mascote como asset no `pubspec.yaml`.
- Substituído o app padrão de contador por uma tela inicial simples do Chave 26 com o mascote.
- Adicionados testes de widget para validar a identidade inicial do app e a presença do mascote.

## Arquivos principais alterados/criados

- `pubspec.yaml`
- `lib/main.dart`
- `test/widget_test.dart`
- `README.md`
- `BACKLOG.md`
- `docs/decisoes-tecnicas.md`
- `docs/plano-inicial.md`

## Teste adicionado

Arquivo:

- `test/widget_test.dart`

Comportamentos testados:

- a tela inicial renderiza “Chave 26”;
- a tela inicial renderiza “Sala 26”;
- a tela inicial renderiza a descrição do MVP local;
- a tela inicial renderiza o mascote da Prototipe com rótulo semântico.

## Comandos executados

```bash
/home/dain/dev/flutter/bin/flutter --version
/home/dain/dev/flutter/bin/flutter create --platforms android --project-name chave_26 --org br.com.prototipe .
/home/dain/dev/flutter/bin/flutter pub add flutter_riverpod shared_preferences
/home/dain/dev/flutter/bin/flutter test test/widget_test.dart
/home/dain/dev/flutter/bin/flutter doctor -v
/home/dain/dev/flutter/bin/flutter build apk --debug
```

## Resultado

O teste focado passou e o APK debug foi gerado:

```text
All tests passed!
✓ Built build/app/outputs/flutter-apk/app-debug.apk
```

## Limitações/observações

- O app ainda não implementa login, regras da sala, persistência real ou histórico.
- O visual ainda usa paleta provisória; cores oficiais da Prototipe serão adicionadas depois.
- O mascote já foi incluído como asset local em `assets/images/mascote_prototipe.png`.
- Para rodar em celular físico, ainda será necessário conectar o dispositivo ao WSL/ADB.
  - Opção recomendada: usar depuração sem fio do Android e `adb pair`/`adb connect` pelo WSL.
  - Alternativa: usar USB pass-through com `usbipd-win`.
