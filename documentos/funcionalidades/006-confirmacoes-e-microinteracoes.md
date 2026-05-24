# Marco 5 — Proteções e microinterações

Esta fatia amplia o Marco 5 com melhorias de usabilidade: ações sensíveis protegidas por confirmação ou escolha explícita, e ações indisponíveis ocultadas da tela principal.

## O que foi implementado

- A tela inicial expõe ações de movimentação apenas quando elas fazem sentido para o perfil selecionado.
- Observação posterior: a ação fixa `Devolver chave para a portaria` foi substituída na UI pelo fluxo mais geral `Guardar chave`, documentado em `documentos/funcionalidades/008-destinos-customizados-da-chave.md`.
- A tela inicial agora também expõe a ação `Passar chave para outra pessoa` quando a chave está com o perfil selecionado.
- Antes de guardar a chave, o app valida se o perfil selecionado realmente está com a chave e exige a escolha de um destino.
- Antes da transferência, o app pede a pessoa de destino e abre um diálogo de confirmação.
- Ao cancelar uma confirmação ou fechar o seletor de destino sem escolher:
  - o estado da sala não muda;
  - o histórico não recebe novo item.
- Ao escolher um destino para guardar a chave:
  - a chave fica registrada em `Em <destino>`;
  - o novo estado é salvo localmente;
  - um evento é registrado no histórico;
  - o usuário recebe feedback pela mensagem de sucesso.
- Ao confirmar a transferência:
  - a chave passa para a pessoa escolhida;
  - o novo estado é salvo localmente;
  - um evento é registrado no histórico;
  - o usuário recebe feedback pela mensagem de sucesso.

## Ações disponíveis na tela

Para reduzir erro e deixar o app mais claro, a tela não mostra ações que não podem ser executadas no estado atual:

- Sem perfil selecionado: o app pede para escolher um perfil antes de mostrar ações de movimentação.
- Chave na portaria com perfil selecionado: mostra `Pegar chave na portaria`.
- Chave com o perfil selecionado: mostra `Guardar chave` e `Passar chave para outra pessoa`.
- Chave com outra pessoa: oculta as ações e explica quem está com a chave.

## Decisão desta fatia

Ocultar ações indisponíveis foi escolhido em vez de deixar botões inválidos visíveis, porque o protótipo precisa ser rápido de entender durante a apresentação. As regras de domínio continuam protegendo ações inválidas, mas a interface evita oferecer caminhos que o usuário não pode concluir.

A transferência para outra pessoa reaproveita os perfis locais do Marco 3. O diálogo de escolha exclui o perfil atual para evitar transferência para si mesmo.

## Testes automatizados

Arquivo atualizado:

- `test/widget_test.dart`

Coberturas adicionadas ou atualizadas:

- fluxo atual de seletor de destino para guardar a chave, preservando o histórico legado de confirmação de devolução à portaria;
- cancelamento sem alteração de estado nem histórico;
- cancelamento do seletor de destino sem alteração de estado nem histórico;
- confirmação com persistência do novo estado e novo evento no histórico;
- pedido de seleção de perfil antes de mostrar ações de movimentação;
- visibilidade condicional dos botões conforme a localização da chave;
- mensagem explicativa quando a chave está com outra pessoa;
- diálogo de escolha da pessoa que receberá a chave;
- confirmação de transferência antes de persistir;
- cancelamento da transferência sem alteração de estado;
- confirmação da transferência com persistência, histórico e feedback.

## Limitações ainda abertas

- As confirmações ainda usam diálogos simples do Material; o polimento visual final pode ajustar textos, espaçamentos e responsividade.
- A fatia seguinte reorganizou os botões no redesenho do Marco 6; este documento preserva a decisão de confirmação/segurança das ações sensíveis.
