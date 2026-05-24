# Contexto — App Chave 26

## Nome do app

**Chave 26**

## Ideia principal

O **Chave 26** é um aplicativo simples para ajudar os membros da Prototipe a saberem o estado atual da sala 26.

A ideia é mostrar de forma rápida:

- se a sala 26 está aberta ou fechada;
- se a chave está na portaria;
- ou com qual membro a chave está.

## Contexto do problema

A Prototipe possui uma sala na faculdade, conhecida como **sala 26**.

No dia a dia, quando alguém pega a chave na portaria e abre a sala, essa pessoa costuma avisar no grupo com mensagens como:

```text
Sala 26 aberta.
```

Quando a pessoa sai da sala e fica com a chave, também avisa algo como:

```text
Chave da 26 comigo.
```

Esse processo funciona, mas depende das mensagens no grupo. Com o tempo, pode ficar confuso saber se a sala ainda está aberta, se a chave voltou para a portaria ou se está com algum membro.

## Problema

Nem sempre é fácil saber rapidamente:

- se a sala 26 está aberta;
- quem abriu a sala;
- quem está com a chave;
- se a chave está na portaria;
- qual foi a última atualização sobre a sala.

Isso pode gerar dúvidas no grupo e atrasar quem precisa usar a sala.

## Objetivo do app

O objetivo do **Chave 26** é centralizar essa informação em um lugar simples.

O app deve mostrar o estado atual da sala 26 de forma clara, para que qualquer membro consiga abrir o app e entender a situação.

## O que o app deve mostrar

O app deve mostrar informações como:

- status da sala;
- pessoa responsável pela última atualização;
- localização atual da chave;
- horário da última atualização.

Exemplos de estados:

```text
Sala 26 aberta.
Aberta por: Lucas
Desde: 14:30
```

```text
Sala 26 fechada.
Chave na portaria.
```

```text
Sala 26 fechada.
Chave com: Maria
Última atualização: 18:10
```

## Ações principais

O usuário poderá registrar ações simples, como:

- peguei a chave;
- abri a sala;
- fechei a sala;
- chave ficou comigo;
- devolvi a chave para a portaria.

## Histórico

O app também pode ter um histórico simples para mostrar as últimas movimentações da sala.

Exemplo:

```text
14:20 — Lucas pegou a chave na portaria
14:25 — Lucas abriu a sala 26
17:40 — Maria fechou a sala 26
17:41 — Chave ficou com Maria
```

## Público-alvo

O app é pensado para membros e trainees da Prototipe que usam a sala 26 ou precisam saber se ela está disponível.

## Primeira versão

Na primeira versão, o app deve ser simples.

O foco é mostrar:

- se a sala está aberta ou fechada;
- onde está a chave;
- quem foi o último responsável;
- um histórico básico das ações.

Não é necessário criar uma solução complexa no início.

## Decisões do MVP

Decisões tomadas para o desenvolvimento inicial:

- o foco será celular/Android;
- Web fica fora do MVP;
- o app será funcional, não apenas visual;
- o funcionamento será local/offline, sem backend;
- haverá perfis locais pré-definidos para identificar quem está usando o app no protótipo;
- o perfil local selecionado será usado nas ações e no histórico;
- o app usará Flutter com Dart;
- o app poderá usar Riverpod para organização de estado;
- o app poderá usar SharedPreferences com JSON para persistência local simples;
- os trade-offs do protótipo ficam documentados em `TRADEOFFS.md`;
- o usuário deverá poder transferir a chave para outra pessoa;
- ao fechar a sala, o usuário deverá escolher se a chave ficou com ele, foi passada para outra pessoa ou voltou para a portaria;
- o app deverá ter uma interface amigável, divertida e alinhada à identidade visual da Prototipe;
- o mascote da Prototipe já foi incluído como asset local;
- a paleta de cores da Prototipe foi registrada em `documentos/identidade-visual-prototipe.md`;
- o app terá poucos testes automatizados, mas úteis;
- o app terá README, backlog e documentação.

## Identidade visual da Prototipe

A interface deve usar como referência a paleta visual da Prototipe registrada em `documentos/identidade-visual-prototipe.md`.

Cores principais:

- azul ciano do fundo: `#0397DD`;
- azul médio: `#0E7CC7`;
- azul royal: `#1D58AA`;
- azul índigo escuro: `#274299`;
- azul marinho/contorno: `#060D5B`;
- creme dos títulos: `#FDFBDB`;
- branco dos detalhes/logo: `#F7FBFF`.

Cores de apoio do mascote:

- roxo principal: `#444EDB`;
- roxo sombra: `#383EAA`;
- azul claro/barriga: `#3D9EDD`;
- preto dos óculos: `#161617`.

Gradiente de fundo recomendado:

```css
background: linear-gradient(
  90deg,
  #0397DD 0%,
  #0E7CC7 35%,
  #1D58AA 70%,
  #274299 100%
);
```

## Disciplina de documentação

Durante todo o desenvolvimento, decisões, bibliotecas, mudanças importantes, regras de negócio, limitações e próximos passos devem ser documentados constantemente.

Sempre que uma parte relevante do app for implementada ou alterada, a documentação correspondente deve ser atualizada junto com o código. Isso inclui, quando aplicável:

- `contexto.md` para decisões e contexto geral do produto;
- `BACKLOG.md` para progresso, pendências, limitações e próximos passos;
- `documentos/decisoes-tecnicas.md` para decisões de stack, arquitetura e bibliotecas;
- documentos em `documentos/` para funcionalidades implementadas.

## Possíveis melhorias futuras

Depois da primeira versão, o app pode evoluir com:

- atualização em tempo real;
- login de membros;
- notificações;
- integração com grupo de mensagens;
- botão para copiar mensagem pronta;
- registro de data e hora automático;
- lista de membros da Prototipe.

## Resumo

O **Chave 26** é um app simples para resolver uma situação real da Prototipe: saber rapidamente se a sala 26 está aberta e onde está a chave.

A proposta é transformar uma comunicação que hoje acontece de forma espalhada no grupo em uma informação clara, centralizada e fácil de consultar.
