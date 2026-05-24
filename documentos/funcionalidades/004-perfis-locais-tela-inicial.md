# Marco 3 — Perfis locais na tela inicial

Esta fatia inicia o Marco 3 com a troca funcional de perfis locais diretamente na tela inicial, sem criar uma tela de configurações separada.

## O que foi implementado

- A tela inicial mostra um seletor rápido no canto superior direito do conteúdo.
- O seletor oferece quatro perfis pré-definidos:
  - Lucas;
  - Clara;
  - Amanda;
  - Vitor.
- Cada perfil aparece como um botão curto com a inicial do nome.
- Tocar em um perfil salva a seleção localmente usando `RepositorioLocalDoPerfil`.
- Após a troca, o resumo local passa a mostrar o perfil salvo, por exemplo `Perfil salvo: Clara`.
- A troca de perfil não apaga o estado da sala nem o histórico salvo.
- A tela inicial oferece a primeira ação funcional do MVP: `Pegar chave na portaria`.
- Essa ação usa o perfil selecionado como responsável pela alteração.
- Quando nenhum perfil foi escolhido, a ação é bloqueada com a mensagem `Escolha um perfil antes de alterar a sala.` e a situação da sala não é alterada.
- Quando há perfil selecionado, a ação grava a nova situação localmente, atualiza a localização da chave e registra o evento no histórico com a pessoa selecionada.

## Decisão visual desta fatia

O backlog sugere quatro avatares/carinha discretos no canto superior direito. Nesta fatia, o visual foi mantido simples: quatro botões circulares/tonais com iniciais.

Isso entrega a troca funcional agora e deixa o refinamento visual dos avatares/carinha para o Marco 4, caso a apresentação precise de mais polimento.

## Testes automatizados

Arquivo atualizado:

- `test/widget_test.dart`

Coberturas adicionadas:

- a tela inicial oferece os quatro perfis pré-definidos;
- tocar no atalho de perfil troca e salva o perfil local;
- a troca mantém o estado da sala visível, sem apagar os dados restaurados;
- ação sem perfil selecionado é bloqueada sem alterar o estado salvo;
- ação com perfil selecionado usa o perfil salvo no evento de histórico.

## Limitações ainda abertas

- O visual dos avatares/carinha ainda pode ser refinado no Marco 4.
- A tela completa de ações ainda será refinada em marcos posteriores; neste marco só a primeira ação necessária para validar o vínculo com perfil foi ligada à tela inicial.
