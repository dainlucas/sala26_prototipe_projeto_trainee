# Marco 6 — UI principal inspirada no v0

Esta fatia redesenha a tela principal do Chave 26 usando a referência validada no v0 como direção visual, sem transformar o app em uma tela mockada. As regras, a persistência local e o histórico continuam funcionando com os dados reais do protótipo Flutter.

## Escopo de produto/UX registrado

A referência do v0 mostrou que a tela inicial deve priorizar a leitura rápida do estado da sala:

- cabeçalho com ícone, nome `Chave 26`, subtítulo `Prototipe` e botão discreto para troca de perfil no canto direito;
- status da sala em destaque grande: `Aberta` ou `Fechada`;
- informações importantes logo abaixo do status:
  - `Chave com`;
  - `Localização`;
  - `Última atualização`;
- seção `Ações rápidas` com botão principal dependente do estado e do perfil;
- ação `Guardar chave` quando a chave está com o perfil selecionado, abrindo escolha de destino;
- botão `Abrir sala` ou `Fechar sala` disponível somente quando o perfil atual tem direito de executar a ação;
- seção `Transferir para` quando a chave está com o perfil atual ou quando a sala está aberta com a chave guardada na sala e o perfil atual foi quem abriu/responde pela sala;
- `Histórico recente` na aba inicial;
- `Histórico completo` separado em outra aba;
- menu inferior navegável com `Início` e `Histórico`.

## O que foi implementado

- A tela inicial agora usa um cabeçalho fixo com identidade do app e seletor de perfil escondido/discreto em botão tonal.
- O conteúdo principal foi reorganizado em cartões visuais:
  - card de status da sala;
  - linhas de informação para responsável/localização/última atualização;
  - ações rápidas;
  - histórico recente.
- Foi adicionado menu inferior com duas abas:
  - `Início`, com status, ações e histórico recente;
  - `Histórico`, com a lista completa de movimentações.
- O histórico recente da aba inicial mostra somente as últimas movimentações, mantendo a lista completa na aba própria.
- A aba `Histórico` recebeu um botão discreto e temporário `Limpar histórico`, usado apenas como ferramenta de teste durante a apresentação/desenvolvimento.
- A troca de perfil passou para um modal inferior, mantendo o botão do cabeçalho limpo para a apresentação.
- O botão `Abrir sala`/`Fechar sala` respeita a condição de posse/responsabilidade da chave.
- A transferência continua pedindo confirmação antes de persistir.
- A antiga devolução fixa para a portaria evoluiu para `Guardar chave`, com seleção de `Portaria`, `Maker Space` ou destino customizado local.
- Quando a sala está aberta e a chave ficou guardada na sala, o perfil que abriu/responde pela sala pode transferir a chave para outra pessoa sem precisar fechar a sala primeiro.

## Decisões da fatia

- A referência visual do v0 foi incorporada como direção de estrutura e hierarquia, não como código copiado.
- O app continua usando Flutter nativo/Material 3.
- O seletor de perfil foi mantido acessível por tooltip `Trocar perfil`, mas menos dominante visualmente.
- O histórico completo saiu da tela principal para reduzir ruído e deixar o status da sala mais óbvio em poucos segundos.
- A ação de transferência mantém um botão explícito `Passar chave para outra pessoa` para preservar o fluxo confirmado já testado, além dos atalhos visuais da seção `Transferir para`.

## Testes automatizados

Arquivo atualizado:

- `test/widget_test.dart`

Coberturas adicionadas ou atualizadas:

- renderização da estrutura visual inspirada no v0;
- cabeçalho com `Chave 26`, `Prototipe` e troca de perfil;
- card principal com `Sala 26`, status, `Chave com`, `Localização` e `Última atualização`;
- menu inferior com `Início` e `Histórico`;
- separação entre `Histórico recente` e `Histórico completo`;
- limpeza temporária do histórico pela aba `Histórico`, preservando estado e localização atuais;
- botão `Abrir sala`/`Fechar sala` condicionado ao perfil com a chave;
- preservação dos fluxos existentes de persistência, confirmação, transferência e histórico;
- escolha/cadastro de destino ao guardar a chave;
- transferência da chave guardada na sala aberta pelo responsável, mantendo a sala aberta e registrando a nova pessoa com a chave.

## Limitações ainda abertas

- A responsividade visual em aparelho real ainda precisa ser revisada no Marco 7.
- O mascote/imagem da Prototipe ainda pode voltar como elemento decorativo leve, se não competir com o status da sala.
- O tema visual foi aplicado diretamente em `lib/main.dart`; uma refatoração futura pode mover constantes de tema para `lib/nucleo/tema/`.
