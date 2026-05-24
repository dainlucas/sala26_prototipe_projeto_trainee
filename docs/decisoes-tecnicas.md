# Decisões técnicas — Chave 26

## Contexto

O Chave 26 é um app Flutter/Dart para o teste de trainee da Prototipe. O objetivo é resolver um problema real de forma simples: mostrar se a sala 26 está aberta ou fechada, onde está a chave, quem está responsável e quais foram as últimas movimentações.

O projeto deve demonstrar boa resolução de problema, UI agradável, usabilidade, simplicidade de código e um pouco de habilidade técnica, sem exagerar na complexidade.

## Plataforma

Decisão: foco em Android/celular.

Web fica fora do MVP para reduzir distração e manter o desenvolvimento concentrado no uso em celular. Flutter ainda pode permitir suporte futuro para Web, mas a primeira versão será pensada, testada e apresentada como app mobile.

Recomendação prática:

- criar o projeto com foco em Android;
- testar primeiro em celular;
- não gastar tempo polindo Web no MVP.

## Backend

Decisão: não usar backend no MVP.

Motivo:

- o projeto é para teste de trainee;
- o prazo é de 6 dias;
- o uso será demonstrativo/local;
- backend aumentaria escopo, autenticação, deploy e sincronização.

Limitação consciente:

- cada instalação terá seu próprio estado local;
- isso não serve como solução oficial para todos os membros simultaneamente.

Evolução futura:

- Firebase, Supabase ou API própria poderiam sincronizar estado e histórico entre membros.

## Login

Decisão: login local simples.

O usuário informará seu nome no app. Esse nome será salvo localmente e usado nas ações e no histórico.

Motivo:

- o app precisa diferenciar quem está com a chave;
- login real seria complexo demais para o MVP;
- o nome local resolve a necessidade da demonstração.

Limitação:

- não há verificação de identidade.

## Estado e regras

Estados principais:

- sala aberta;
- sala fechada.

Localizações da chave:

- na portaria;
- na sala;
- com uma pessoa.

Ações do MVP:

- peguei a chave na portaria;
- abri a sala;
- fechei a sala;
- chave ficou comigo;
- passei a chave para outra pessoa;
- devolvi a chave para a portaria.

Regra importante:

Ao fechar a sala, o usuário precisa informar o destino da chave:

- ficou comigo;
- ficou com outra pessoa;
- foi devolvida para a portaria.

## Gerenciamento de estado

Decisão: Riverpod pode ser usado no MVP.

Explicação simples:

Riverpod é uma biblioteca para organizar o estado do app, como:

- nome da pessoa logada;
- sala aberta ou fechada;
- localização da chave;
- histórico de ações.

Motivo:

- ajuda a separar UI de regra de negócio;
- é testável;
- evita espalhar variáveis pelas telas;
- permite manter o código simples, se usado com moderação.

Regra do projeto:

- usar Riverpod de forma simples;
- documentar onde e por que ele foi usado;
- evitar arquitetura pesada demais para o trainee/MVP.

## Persistência local

Decisão: SharedPreferences com JSON pode ser usado no MVP.

Explicação simples:

SharedPreferences é uma forma simples de salvar dados pequenos no celular. Usaremos JSON para guardar estruturas como estado atual e histórico.

Opções consideradas:

- SharedPreferences com JSON;
- Hive;
- SQLite/Drift;
- Firebase/Supabase.

Motivo da decisão:

- menor setup;
- suficiente para salvar nome, estado atual e histórico simples;
- reduz risco técnico no prazo de 6 dias;
- evita complexidade de banco local para poucos dados.

Limitação:

- não é ideal para grande volume de histórico ou consultas complexas.

Evolução futura:

- migrar para Hive, Isar ou SQLite/Drift se o app crescer.

## Disciplina de documentação

Decisão: tudo que for relevante durante o desenvolvimento deve ser documentado continuamente.

Isso inclui:

- decisões de produto;
- decisões técnicas;
- bibliotecas adicionadas;
- regras de negócio;
- limitações encontradas;
- mudanças de escopo;
- próximos passos;
- testes adicionados;
- motivos para escolher ou rejeitar alternativas.

Arquivos principais:

- `contexto.md`: contexto geral e decisões de produto.
- `BACKLOG.md`: progresso, pendências, riscos e próximos passos.
- `docs/decisoes-tecnicas.md`: stack, bibliotecas, arquitetura e trade-offs.
- `docs/`: documentação das funcionalidades implementadas.

## Arquitetura de código

Objetivo: simples, mas organizado.

Estrutura sugerida:

```text
lib/
  main.dart
  app.dart
  core/
    theme/
      app_theme.dart
  features/
    auth/
      login_screen.dart
      user_controller.dart
    room/
      domain/
        room_status.dart
        key_location.dart
        room_snapshot.dart
        history_event.dart
        room_action_service.dart
      data/
        room_repository.dart
        local_room_repository.dart
      presentation/
        home_screen.dart
        widgets/
          status_card.dart
          room_action_buttons.dart
          history_list.dart
```

Essa estrutura evita colocar tudo em `main.dart`, mas também não força uma arquitetura pesada.

## UI e identidade

Decisão: UI amigável, divertida e alinhada à Prototipe.

Direção visual:

- tela inicial com card grande de status;
- cores claras, vivas e baseadas na paleta da Prototipe;
- mascote/placeholder do mascote;
- botões grandes e óbvios;
- texto simples;
- foco em celular.

Paleta registrada:

- a paleta oficial/referencial da Prototipe está documentada em `docs/identidade-visual-prototipe.md`;
- o gradiente principal recomendado vai de `#0397DD` para `#274299`, passando por `#0E7CC7` e `#1D58AA`;
- títulos podem usar o creme `#FDFBDB`;
- detalhes claros podem usar `#F7FBFF`;
- contornos/contrastes escuros podem usar `#060D5B`;
- cores do mascote incluem roxo `#444EDB`, roxo sombra `#383EAA`, azul claro `#3D9EDD` e preto `#161617`.

Pendente:

- transformar a paleta em constantes Dart dentro do tema do app;
- aplicar o gradiente e as cores da marca na UI principal.

## Testes

Decisão: poucos testes, mas úteis.

Prioridade:

1. Testes unitários das regras da sala.
2. Testes de serialização/persistência local.
3. Poucos testes de widget para validar tela principal, histórico e login.

Não será uma suíte enorme. O objetivo é mostrar cuidado técnico proporcional ao projeto.

## Documentação

Arquivos principais:

- `README.md`: visão geral, como rodar, funcionalidades e decisões resumidas.
- `BACKLOG.md`: planejamento e acompanhamento.
- `docs/decisoes-tecnicas.md`: decisões técnicas.
- `docs/features/`: notas curtas por marco implementado, se o desenvolvimento avançar em etapas.

## Ambiente atual

O diretório atual contém o projeto Flutter `chave_26` com target Android, documentação inicial, backlog e teste de widget inicial.

Foi instalada uma versão Linux do Flutter em:

```text
/home/dain/dev/flutter
```

Foi instalado/configurado um Android SDK Linux próprio para o WSL em:

```text
/home/dain/Android/Sdk
```

Isso evita depender do Android SDK do Windows em `/mnt/c/Users/lucas/AppData/Local/Android/Sdk`, que contém executáveis `.exe` e não é o ideal para o Flutter Linux dentro do WSL.

Versões verificadas:

```text
Flutter 3.44.0
Dart 3.12.0
```

O Flutter anterior encontrado em `/mnt/c/src/flutter` apresentou erro de final de linha Windows/CRLF quando chamado pelo WSL:

```text
/mnt/c/src/flutter/bin/internal/shared.sh: line 5: $'\r': command not found
```

Por isso, os comandos no WSL devem usar `/home/dain/dev/flutter/bin/flutter`.

Dependências iniciais adicionadas:

- `flutter_riverpod`;
- `shared_preferences`.

Componentes Android instalados no SDK do WSL:

- command-line tools;
- platform-tools;
- platform `android-36`;
- build-tools `36.1.0`;
- OpenJDK 17;
- licenças Android aceitas.

Validação Android:

- `flutter doctor` agora reconhece o Android toolchain no WSL;
- `flutter build apk --debug` gerou `build/app/outputs/flutter-apk/app-debug.apk`.

Pendências irrelevantes para o MVP atual:

- Chrome/Web não configurado, pois Web está fora do MVP;
- Linux desktop toolchain não configurado, pois desktop está fora do MVP.

Asset visual inicial:

- `assets/images/mascote_prototipe.png` contém o mascote fornecido para a identidade do app.

Comandos principais:

```bash
/home/dain/dev/flutter/bin/flutter test
/home/dain/dev/flutter/bin/flutter analyze
```
