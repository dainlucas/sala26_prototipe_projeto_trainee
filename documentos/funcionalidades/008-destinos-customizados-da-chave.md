# Destinos customizados da chave

Esta fatia transforma a antiga ação fixa de devolver a chave para a portaria em um fluxo mais flexível de `Guardar chave`. O objetivo é permitir que a sala 26 represente melhor a rotina real: a chave pode ficar na portaria, no Maker Space ou em um destino cadastrado durante o uso do app.

## O que foi implementado

- A localização da chave ganhou a variação `guardadaEm`, com o nome do destino.
- A serialização local preserva destinos customizados no estado salvo.
- O repositório local da sala mantém uma lista de destinos da chave:
  - destinos fixos: `Portaria` e `Maker Space`;
  - destinos customizados persistidos em `SharedPreferences`.
- A tela inicial troca o botão fixo `Devolver chave para a portaria` por `Guardar chave`.
- Ao tocar em `Guardar chave`, o app abre um modal para escolher onde a chave ficará.
- O modal permite adicionar destinos customizados, além de renomear ou remover destinos customizados existentes.
- Ao adicionar/renomear/remover um destino customizado, a lista do modal e os dados carregados da tela inicial são recarregados para que o destino apareça ao reabrir `Guardar chave` sem precisar reiniciar o app.
- Destinos fixos não podem ser removidos pela interface.
- Fechar o modal sem escolher destino não altera a situação nem adiciona histórico.
- Salvar um nome vazio no cadastro/renomeação não cria destino inválido.
- Tentar cadastrar novamente um destino já existente mantém apenas uma entrada na lista.
- Ao escolher um destino, o app registra a movimentação no histórico e atualiza a localização para `Em <destino>`.
- Quando a chave está em `Portaria`, `Maker Space` ou outro destino, o campo `Chave com` mostra `Nenhuma pessoa`, evitando indicar responsabilidade pessoal onde há apenas uma localização.
- Quando a chave está guardada em um destino, a tela oferece `Pegar chave em <destino>` para o perfil selecionado poder retirar a chave dali.

## Decisões da fatia

- `Portaria` continua sendo um destino fixo, mas deixa de ser um fluxo especial exclusivo da UI principal.
- `Maker Space` entra como destino fixo inicial porque é uma alternativa provável no contexto do app.
- Destinos customizados ficam locais ao aparelho, seguindo o mesmo trade-off do restante do MVP.
- A ação legada `devolverChaveParaPortaria` foi mantida no domínio como compatibilidade para regras e testes já existentes, mas a tela principal usa o novo fluxo genérico de guardar em destino.
- A ação de pegar a chave foi generalizada no domínio para locais disponíveis: mantém o texto antigo para `Portaria` e usa o nome do destino para locais como `Maker Space` ou destinos customizados.

## Testes automatizados

Arquivos atualizados:

- `test/funcionalidades/sala/dominio/controlador_da_sala_test.dart`
- `test/funcionalidades/sala/dados/repositorio_local_da_sala_test.dart`
- `test/widget_test.dart`

Coberturas adicionadas ou atualizadas:

- ação de domínio para guardar a chave em um destino informado;
- bloqueio quando o perfil não pode guardar/manusear a chave;
- round-trip de serialização para localização `guardadaEm`;
- persistência de destinos customizados com opções fixas preservadas;
- visibilidade do botão `Guardar chave` conforme estado/perfil;
- escolha de destino fixo pela UI;
- indicação `Chave com: Nenhuma pessoa` quando a chave está em local/destino;
- botão `Pegar chave em <destino>` e persistência da retirada da chave de um destino;
- cancelamento do seletor sem alterar estado nem histórico;
- bloqueio de destino customizado vazio no cadastro e na renomeação;
- bloqueio de destino duplicado pela UI e pelo repositório;
- cadastro de destino customizado pela UI antes de guardar a chave;
- permanência do destino customizado ao fechar/reabrir `Guardar chave` e ao remontar o app;
- renomear e apagar destino customizado pela UI.

## Limitações ainda abertas

- A gestão de destinos ainda é local ao aparelho; em produção, destinos oficiais deveriam vir de backend ou configuração administrável.
- A interface de renomear/remover destino customizado é funcional, mas apagar ainda remove diretamente; no polimento final, vale adicionar confirmação visual para essa ação destrutiva e snackbar específico.
- Ainda não há validação forte contra nomes parecidos, variação de maiúsculas/minúsculas ou destinos oficiais definidos por uma equipe administrativa.
