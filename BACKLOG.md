# BACKLOG — Chave 26

Status legend:

- [ ] pendente
- [~] em andamento/parcial
- [x] concluído

## Objetivo do MVP

Construir um app Flutter/Dart simples, bonito e funcional para o teste de trainee da Prototipe. O app deve resolver o problema real de saber rapidamente se a sala 26 está aberta ou fechada, onde está a chave, quem está responsável por ela e qual foi o histórico recente de movimentações.

O foco do projeto é demonstrar:

- resolução prática de um problema real;
- UI amigável, divertida e alinhada à identidade da Prototipe;
- boa usabilidade;
- código simples, mas organizado;
- armazenamento local/offline;
- alguns testes automatizados;
- documentação clara.

Prazo-alvo: 6 dias.

---

## Decisões já tomadas

- [x] O projeto será um MVP, não um sistema completo de produção.
- [x] A primeira versão será funcional, não apenas uma tela mockada.
- [x] O app será feito em Flutter com Dart.
- [x] O uso principal será em celular Android.
- [x] Web fica fora do MVP para reduzir distração e manter o foco no celular.
- [x] A primeira versão será local/offline, para uso por uma pessoa no teste.
- [x] Haverá perfis locais pré-definidos para diferenciar quem está usando o app no protótipo.
- [x] O perfil local selecionado será usado nas ações e no histórico.
- [x] Não haverá backend no MVP.
- [x] Não haverá integração com grupo de mensagens no MVP.
- [x] Não haverá botão de copiar mensagem pronta no MVP.
- [x] Haverá histórico simples.
- [x] O histórico não poderá ser apagado pelo fluxo normal do app.
- [x] Haverá confirmações para ações importantes, como devolver a chave para a portaria.
- [x] O visual deve usar identidade da Prototipe e um tom divertido com o mascote.
- [x] Não haverá modo escuro no MVP.
- [x] O código deve ser simples, mas organizado.
- [x] O projeto terá README, backlog e documentação.
- [x] O projeto terá poucos testes automatizados de regras e widgets.
- [x] Poderemos usar Riverpod para organização de estado.
- [x] Poderemos usar SharedPreferences com JSON para persistência local simples.
- [x] Decisões de trade-off do protótipo devem ser registradas em `TRADEOFFS.md` para revisão futura antes de uma versão profissional.
- [x] Decisões, bibliotecas, regras, limitações e mudanças relevantes devem ser documentadas constantemente conforme o desenvolvimento.
- [x] Nomes de classes, variáveis, enums, atributos e métodos ligados ao domínio do app devem ser em português para facilitar a leitura e a explicação do projeto.
- [x] Pastas alteráveis do projeto devem usar nomes em português quando isso não quebrar convenções obrigatórias do Flutter/Android.

---

## Decisões pendentes antes da implementação visual

- [x] Definir plataforma principal.
  - Decisão: foco em celular/Android.
  - Web fica fora do MVP.

- [x] Definir o nome técnico do pacote/app.
  - Decisão: `chave_26`.

- [x] Definir como representar a identidade visual da Prototipe no MVP.
  - Paleta de cores registrada em `documentos/identidade-visual-prototipe.md`.
  - Mascote/imagem já incluído em `recursos/imagens/mascote_prototipe.png`.
  - Pendente para a implementação visual: transformar a paleta em constantes Dart e aplicar na UI.

- [x] Definir biblioteca de estado.
  - Decisão: Riverpod pode ser usado.
  - Uso deve ser simples e explicado, sem arquitetura excessiva.

- [x] Definir persistência local.
  - Decisão: SharedPreferences com JSON pode ser usado.
  - Motivo: reduz setup e mantém simplicidade para o MVP.
  - Trade-offs documentados em `TRADEOFFS.md`.

---

## Modelo de domínio do MVP

### Estados da sala

- [ ] Sala aberta.
- [ ] Sala fechada.

### Localização da chave

- [ ] Na portaria.
- [ ] Na sala.
- [ ] Com uma pessoa.
- [x] Guardada em destino escolhido.
  - Destinos fixos `Portaria` e `Maker Space`, com destinos customizados locais, documentados em `documentos/funcionalidades/008-destinos-customizados-da-chave.md`.

### Ações principais

- [ ] Peguei a chave na portaria.
- [ ] Abri a sala.
- [ ] Fechei a sala.
- [ ] Chave ficou comigo.
- [ ] Passei a chave para outra pessoa.
- [ ] Devolvi a chave para a portaria.
- [x] Guardei a chave em um destino escolhido.
  - A UI principal usa `Guardar chave` e permite escolher/cadastrar destinos.

### Regras iniciais sugeridas

- [ ] Só é possível abrir a sala se a chave estiver com a pessoa logada.
- [ ] Ao abrir a sala, o app registra quem abriu e marca a chave como “na sala”.
- [ ] Só é possível fechar a sala se ela estiver aberta.
- [ ] Ao fechar a sala, o usuário precisa escolher o destino da chave:
  - ficou comigo;
  - ficou com outra pessoa;
  - devolvi para a portaria.
- [ ] Só é possível devolver a chave se ela estiver com a pessoa logada.
- [x] Ao guardar a chave, o usuário escolhe entre destinos fixos e destinos customizados locais.
- [ ] Só é possível passar a chave para outra pessoa se ela estiver com a pessoa logada ou se a sala estiver aberta, a chave estiver guardada na sala, e a pessoa logada for quem abriu/responde pela sala.
- [ ] Toda ação gera um item no histórico com data/hora, pessoa e descrição.

---

## Marco 0 — Preparação do projeto

- [x] Criar projeto Flutter `chave_26`.
- [x] Verificar build Android.
  - `flutter build apk --debug` gerou `build/app/outputs/flutter-apk/app-debug.apk`.
- [x] Verificar execução em Android/celular.
  - Confirmado no tablet Android `SM X400`, detectado pelo Flutter como `RXGL202L2RP`, com o app abrindo no dispositivo.
- [~] Configurar estrutura inicial de pastas.
  - Projeto Flutter criado; estrutura por feature será expandida no Marco 1.
- [x] Criar README inicial.
- [x] Criar documentos/decisoes-tecnicas.md.
- [x] Configurar dependências escolhidas.
  - `flutter_riverpod`.
  - `shared_preferences`.
- [x] Rodar teste inicial do Flutter.
- [x] Fazer commit inicial, se o projeto usar Git.
  - Repositório Git inicializado para registrar cada etapa do trainee.

Definition of done:

- Projeto abre e roda.
- Testes iniciais passam.
- README explica objetivo e como rodar.
- Backlog e decisões técnicas existem.
- Documentação da etapa existe em `documentos/funcionalidades/001-preparacao-projeto-flutter.md`.

---

## Marco 1 — Domínio e regras de negócio

Observação de nomenclatura: no domínio do app, usar nomes em português para facilitar a leitura, o aprendizado e a apresentação do projeto. Exemplos: `EstadoDaSala`, `LocalizacaoDaChave`, `SituacaoDaSala`, `EventoHistorico` e `ControladorDaSala`.

- [x] Criar modelos de domínio com nomes em português:
  - `EstadoDaSala`.
  - `LocalizacaoDaChave`.
  - `SituacaoDaSala`.
  - `EventoHistorico`.
- [x] Criar serviço/controlador de regras da sala com nome em português, por exemplo `ControladorDaSala`.
  - Implementado em `lib/funcionalidades/sala/dominio/controlador_da_sala.dart` com resultado explícito de sucesso/falha.
  - Ações principais e bloqueios inválidos cobertos por testes unitários em `test/funcionalidades/sala/dominio/controlador_da_sala_test.dart`.
- [x] Testar ação “peguei a chave”.
- [x] Testar ação “abri a sala”.
- [x] Testar ação “fechei a sala com chave comigo”.
- [x] Testar ação “fechei a sala e devolvi para portaria”.
- [x] Testar ação “passei a chave para outra pessoa”.
- [x] Testar bloqueios de ações inválidas.
  - Bloqueios separados por regra, incluindo nomes vazios/espaços e transferência para a própria pessoa.
- [x] Atualizar docs com as regras implementadas.
  - Regras documentadas em `documentos/funcionalidades/002-modelos-e-controlador-da-sala.md`.

Definition of done:

- Regras principais cobertas por testes unitários.
- Histórico é gerado pelas ações.
- Ações inválidas retornam mensagem compreensível.

---

## Marco 2 — Persistência local/offline

- [x] Criar repositório local para estado atual.
  - Implementado em `lib/funcionalidades/sala/dados/repositorio_local_da_sala.dart`.
- [x] Criar repositório local para histórico.
  - O histórico é carregado a partir da `SituacaoDaSala` salva inteira, conforme trade-off documentado.
- [x] Salvar perfil local selecionado.
  - Implementado em `lib/funcionalidades/configuracoes/dados/repositorio_local_do_perfil.dart`.
- [x] Salvar estado da sala.
- [x] Salvar histórico.
- [x] Restaurar dados ao reabrir o app.
  - A tela inicial carrega `RepositorioLocalDaSala` e `RepositorioLocalDoPerfil` ao abrir.
  - Coberto por teste de widget em `test/widget_test.dart`.
- [x] Testar serialização/desserialização dos modelos.
  - Coberto por `test/funcionalidades/sala/dados/repositorio_local_da_sala_test.dart`.
- [x] Documentar limitações da persistência local.
  - Trade-offs iniciais registrados em `TRADEOFFS.md`.
  - Fatia inicial documentada em `documentos/funcionalidades/003-persistencia-local-inicial.md`.

Definition of done:

- Dados não somem ao fechar e reabrir o app.
- Testes de serialização passam.
- App funciona offline.

---

## Marco 3 — Perfis locais simples

- [x] Criar seletor rápido de perfil na tela inicial, sem tela de configurações separada.
  - Ideia de apresentação: quatro avatares/carinha discretos no canto superior direito.
  - Implementado primeiro como troca funcional com botões de iniciais; refinamento visual de avatares/carinha permanece no Marco 4.
  - Documentado em `documentos/funcionalidades/004-perfis-locais-tela-inicial.md`.
- [x] Disponibilizar perfis pré-definidos: Lucas, Clara, Amanda e Vitor.
- [x] Dar feedback visual do perfil selecionado.
  - Exemplo: avatar destacado, borda/anel, tooltip/texto curto ou resumo “Usuário atual: Lucas”.
  - O resumo mostra o usuário atual e o botão do perfil ativo usa destaque tonal.
- [x] Validar perfil obrigatório antes de ações que alteram a sala.
  - A ação inicial de pegar a chave bloqueia alterações quando nenhum perfil está selecionado.
- [x] Salvar perfil selecionado localmente.
  - O seletor da tela inicial salva a escolha via `RepositorioLocalDoPerfil`.
- [x] Usar perfil selecionado nas ações.
  - A ação inicial `Pegar chave na portaria` usa o perfil salvo como pessoa responsável e grava o evento no histórico.
- [x] Permitir trocar perfil rapidamente pela tela inicial, sem apagar estado nem histórico.
- [x] Testar fluxo básico de seleção/troca de perfil local.
  - Coberto por `test/widget_test.dart`.

Definition of done:

- O usuário escolhe um perfil antes de usar o app.
- As ações aparecem no histórico com esse perfil.

---

## Marco 4 — Histórico simples

- [x] Criar lista de histórico na tela principal.
  - Documentado em `documentos/funcionalidades/005-historico-simples.md`.
- [x] Mostrar as últimas movimentações com data/hora e nome.
- [x] Ordenar histórico do mais recente para o mais antigo.
- [x] Criar estado vazio amigável quando não houver histórico.
- [x] Testar renderização de histórico vazio.
  - Coberto por `test/widget_test.dart`.
- [x] Testar renderização de histórico com itens.
  - Coberto por `test/widget_test.dart`.
- [x] Testar histórico longo com rolagem até movimentações antigas.
  - Coberto por `test/widget_test.dart`.
- [x] Testar formatação de data/hora em dias, meses e horários limite.
  - Coberto por `test/widget_test.dart`.

Definition of done:

- Usuário entende rapidamente o que aconteceu antes.
- Histórico é simples e legível.

---

## Marco 5 — Confirmações e microinterações

- [x] Confirmar devolução da chave para a portaria.
  - Documentado em `documentos/funcionalidades/006-confirmacoes-e-microinteracoes.md`.
- [x] Confirmar transferência da chave para outra pessoa.
  - A tela permite escolher outro perfil local e confirmar antes de salvar a transferência.
- [x] Exibir feedback de sucesso após ações.
  - Pegar, devolver e passar a chave mostram mensagem de sucesso após persistir a alteração.
- [x] Exibir mensagens claras para ações inválidas.
  - A interface oculta ações indisponíveis e explica quando a chave está com outra pessoa.
- [x] Testar pelo menos um diálogo de confirmação.
  - Coberto por `test/widget_test.dart` nos fluxos de devolução e transferência da chave.

Definition of done:

- Ações sensíveis não acontecem por acidente.
- Erros são explicados de forma simples.

---

## Marco 6 — UI principal bonita e amigável

- [x] Registrar referência de produto/UX do v0 como direção do redesenho.
  - Documentado em `documentos/funcionalidades/007-ui-principal-inspirada-v0.md`.
- [x] Criar seletor/atalho visual de perfis na tela inicial.
  - O perfil ativo fica no cabeçalho em botão tonal discreto com tooltip `Trocar perfil` e abre um modal inferior com Lucas, Clara, Amanda e Vitor.
  - O seletor foi refinado para não roubar atenção do status da sala.
- [x] Criar tema visual inicial da Prototipe.
  - Paleta aplicada na UI com Material 3 e constantes em `lib/main.dart`.
- [x] Criar card principal de status da sala.
- [x] Mostrar se a sala está aberta ou fechada.
- [x] Mostrar onde está a chave.
- [x] Mostrar quem está com a chave/responsável pela última ação relevante.
- [x] Mostrar horário da última atualização.
- [x] Criar botões de ação com boa usabilidade.
  - Ações rápidas mostram apenas caminhos válidos para o estado/perfil atual.
  - `Abrir sala`/`Fechar sala` aparece condicionado à pessoa com a chave ou responsável pela sala aberta.
  - `Transferir para` também aparece para o responsável pela sala aberta quando a chave está guardada na sala, permitindo entregar a chave a outra pessoa sem fechar a sala.
- [x] Permitir guardar a chave em destinos fixos ou customizados.
  - Documentado em `documentos/funcionalidades/008-destinos-customizados-da-chave.md`.
  - A tela principal usa `Guardar chave`, abre seletor de destino e permite cadastrar destino local antes de salvar a movimentação.
- [~] Criar área visual divertida com mascote/placeholder do mascote.
  - O cabeçalho usa ícone de chave e identidade Prototipe; o mascote/imagem ainda pode voltar como decoração leve no polimento final sem competir com o status.
- [x] Adicionar navegação inferior entre Início e Histórico.
  - `Início` mostra status, ações e histórico recente.
  - `Histórico` mostra a lista completa.
- [x] Testar renderização básica da tela inicial.
  - Coberto por `test/widget_test.dart`, incluindo estrutura v0, abas, botão abrir/fechar, confirmações e histórico.

Definition of done:

- Ao abrir o app, a situação da sala fica óbvia em poucos segundos.
- Visual parece intencional, não apenas padrão Flutter.
- Tela funciona bem em celular.
- Documentação da etapa existe em `documentos/funcionalidades/007-ui-principal-inspirada-v0.md`.

---

## Marco 7 — Polimento final para apresentação

- [ ] Revisar responsividade em celular.
- [ ] Revisar textos da interface.
- [ ] Revisar README.
- [ ] Atualizar prints/instruções, se necessário.
- [ ] Rodar testes completos.
- [ ] Rodar análise estática do Flutter.
- [ ] Revisar backlog e marcar itens realmente concluídos.
- [ ] Criar explicação curta para apresentar o projeto.

Definition of done:

- Projeto está apresentável para trainee.
- README permite outra pessoa entender e rodar o app.
- Testes passam.
- Backlog reflete o estado real.

---

## Melhorias futuras fora do MVP

- [ ] Sincronização entre vários membros.
- [ ] Backend compartilhado.
- [ ] Login real com autenticação.
- [ ] Lista oficial de membros.
- [ ] Notificações.
- [ ] Integração com WhatsApp/Telegram/Discord.
- [ ] Botão para copiar mensagem pronta.
- [ ] Modo escuro.
- [ ] Auditoria mais forte contra uso indevido.
- [ ] Controle de permissões.
- [ ] Histórico completo com filtros.
- [ ] Dashboard administrativo.

---

## Riscos e limitações conscientes do MVP

- [ ] O app local não mostra o mesmo estado para todos os membros.
  - Impacto: aceitável para teste de trainee, mas não suficiente para uso real em grupo.
  - Futuro: backend ou banco em nuvem.

- [ ] Perfil local não prova identidade real.
  - Impacto: qualquer pessoa com acesso ao aparelho pode trocar o perfil selecionado.
  - Futuro: autenticação real ou código de acesso.

- [ ] Sem integração com grupo de mensagens.
  - Impacto: usuários precisam abrir o app para consultar.
  - Futuro: notificações ou integração com mensagens.

- [ ] Estado pode ficar incorreto se alguém esquecer de registrar uma ação.
  - Impacto: inerente ao processo manual.
  - Futuro: lembretes, confirmações e histórico mais visível.

---

## Sequência recomendada de trabalho

1. Fechar as decisões pendentes de stack visual/persistência.
2. Resolver o problema do Flutter no WSL ou criar/rodar o projeto pelo ambiente Windows.
3. Criar o projeto Flutter.
4. Implementar domínio com testes primeiro.
5. Implementar persistência local.
6. Implementar perfis locais em configurações.
7. Implementar histórico.
8. Implementar confirmações.
9. Implementar UI principal.
10. Polir documentação e apresentação.
