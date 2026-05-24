# Marco 5 — Confirmações e microinterações

Esta fatia inicia o Marco 5 com o primeiro fluxo sensível protegido por confirmação: devolver a chave para a portaria.

## O que foi implementado

- A tela inicial agora expõe a ação `Devolver chave para a portaria`.
- Antes da devolução, o app valida se o perfil selecionado realmente está com a chave.
- Se a ação for inválida, o app mostra uma mensagem clara e não altera o estado local.
- Se a ação for válida, o app abre um diálogo de confirmação antes de salvar.
- Ao cancelar o diálogo:
  - o estado da sala não muda;
  - o histórico não recebe novo item.
- Ao confirmar:
  - a chave volta para a portaria;
  - o novo estado é salvo localmente;
  - um evento é registrado no histórico;
  - o usuário recebe feedback pela mensagem de sucesso.

## Decisão desta fatia

O Marco 5 foi iniciado pela devolução da chave porque é uma ação sensível e fácil de acontecer por engano durante a apresentação.

A confirmação de transferência de chave para outra pessoa permanece para uma próxima fatia do mesmo marco, para evitar misturar muitos fluxos de UI no mesmo commit.

## Testes automatizados

Arquivo atualizado:

- `test/widget_test.dart`

Coberturas adicionadas:

- diálogo de confirmação para devolver a chave à portaria;
- cancelamento sem alteração de estado nem histórico;
- confirmação com persistência do novo estado e novo evento no histórico;
- mensagem clara quando um perfil sem a chave tenta devolver para a portaria;
- garantia de que ação inválida não abre confirmação nem altera os dados salvos.

## Limitações ainda abertas

- A confirmação de transferência da chave para outra pessoa ainda não foi implementada na UI.
- As microinterações visuais ainda são simples; refinamento de aparência e hierarquia fica para o marco de UI principal.
- O botão de devolução ainda está na tela inicial simples, junto dos dados restaurados, para manter a fatia pequena.
