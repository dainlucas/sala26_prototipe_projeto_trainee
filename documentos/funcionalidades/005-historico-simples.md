# Marco 4 — Histórico simples

Esta fatia implementa a primeira visualização simples do histórico da sala na tela inicial.

## O que foi implementado

- A tela inicial agora mostra a seção `Histórico da sala`.
- Quando não há movimentações, a seção mostra uma mensagem amigável:
  - `Ainda não há movimentações registradas.`
  - `Quando alguém mexer na chave, a movimentação aparecerá aqui.`
- Quando há movimentações salvas, a seção mostra uma lista com:
  - pessoa responsável;
  - descrição da movimentação;
  - data e horário no formato `dd/mm/aaaa às hh:mm`.
- A lista aparece do item mais recente para o mais antigo.
- O histórico é lido a partir da `SituacaoDaSala` já restaurada da persistência local.

## Decisão desta fatia

O histórico foi mantido visualmente simples para evitar retrabalho antes do marco de UI principal.

A intenção agora é validar o comportamento funcional: entender rapidamente o que aconteceu com a chave e com a sala. O refinamento visual do card, espaçamentos, cores e hierarquia fica para o marco de UI principal.

## Testes automatizados

Arquivo atualizado:

- `test/widget_test.dart`

Coberturas adicionadas:

- renderização do estado vazio do histórico;
- renderização de histórico com itens;
- ordenação do histórico com movimentações mais recentes primeiro;
- exibição de pessoa, descrição e data/hora formatada;
- histórico longo com 30 movimentações;
- rolagem até movimentações antigas;
- datas em dias, meses e horários limite, incluindo zeros à esquerda e virada de ano.

## Limitações ainda abertas

- A apresentação visual do histórico ainda é simples.
- A tela completa de ações ainda é parcial; outros fluxos de movimentação entram nos próximos marcos.
- O formato de data/hora usa uma formatação local simples, sem pacote de internacionalização.
