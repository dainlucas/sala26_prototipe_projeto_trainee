# Marco 7 — Abertura nativa Android personalizada

Esta fatia remove a aparência padrão de abertura do Flutter no Android e aplica uma primeira impressão mais profissional para o Chave 26.

## Objetivo

Ao tocar no app no celular, a abertura deve parecer intencional e alinhada à identidade visual da Prototipe, antes mesmo da primeira tela Flutter aparecer.

## O que foi implementado

- O rótulo Android do app passou de `chave_26` para `Chave 26`.
- O ícone nativo do launcher foi substituído pela logo da Prototipe em densidades Android `mdpi`, `hdpi`, `xhdpi`, `xxhdpi` e `xxxhdpi`.
- Foi criado ícone adaptativo Android em `mipmap-anydpi-v26`, com fundo branco e foreground com a nova logo.
- A splash screen nativa passou a usar:
  - fundo branco para contrastar com a nova logo;
  - logo centralizada em tamanho reduzido, com respiro suficiente para não parecer cortada ou grande demais;
  - mesma identidade no modo claro e no modo escuro;
  - configuração específica para Android 12+ via `values-v31/styles.xml`.

## Arquivos principais

- `android/app/src/main/AndroidManifest.xml`
- `android/app/src/main/res/values/colors.xml`
- `android/app/src/main/res/values/styles.xml`
- `android/app/src/main/res/values-night/styles.xml`
- `android/app/src/main/res/values-v31/styles.xml`
- `android/app/src/main/res/drawable/launch_background.xml`
- `android/app/src/main/res/drawable-v21/launch_background.xml`
- `android/app/src/main/res/drawable/prototipe_splash_background.xml`
- `android/app/src/main/res/drawable-nodpi/splash_logo.png`
- `android/app/src/main/res/mipmap-*/ic_launcher.png`
- `android/app/src/main/res/mipmap-*/ic_launcher_foreground.png`
- `android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml`
- `android/app/src/main/res/mipmap-anydpi-v26/ic_launcher_round.xml`

## Decisões

- A abertura nativa foi priorizada antes de uma animação Flutter customizada, porque ela aparece imediatamente ao iniciar o app e evita o flash branco/padrão do template.
- A splash deve ser curta e funcional: identidade visual forte, mas sem atraso artificial para o usuário.
- A logo da splash e dos ícones adaptativos deve manter margens internas generosas, porque o Android pode aplicar máscaras circulares ou arredondadas diferentes conforme o aparelho/launcher.
- Como a nova logo é aplicada sobre a abertura e o launcher, os fundos nativos devem usar branco puro (`#FFFFFF`) para evitar o tom amarelado e manter contraste.
- Uma animação Flutter posterior continua possível, mas deve ser opcional e rápida para não prejudicar a usabilidade.

## Validação esperada

- `flutter test`
- `flutter analyze`
- `flutter build apk --debug`

A conferência visual final da splash e do ícone ainda deve ser feita em aparelho/emulador Android, porque testes de widget não exercitam recursos nativos do launcher.
