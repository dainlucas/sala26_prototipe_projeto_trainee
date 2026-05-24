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

### Ações principais

- [ ] Peguei a chave na portaria.
- [ ] Abri a sala.
- [ ] Fechei a sala.
- [ ] Chave ficou comigo.
- [ ] Passei a chave para outra pessoa.
- [ ] Devolvi a chave para a portaria.

### Regras iniciais sugeridas

- [ ] Só é possível abrir a sala se a chave estiver com a pessoa logada.
- [ ] Ao abrir a sala, o app registra quem abriu e marca a chave como “na sala”.
- [ ] Só é possível fechar a sala se ela estiver aberta.
- [ ] Ao fechar a sala, o usuário precisa escolher o destino da chave:
  - ficou comigo;
  - ficou com outra pessoa;
  - devolvi para a portaria.
- [ ] Só é possível devolver a chave se ela estiver com a pessoa logada.
- [ ] Só é possível passar a chave para outra pessoa se ela estiver com a pessoa logada.
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

- [ ] Criar setor de configurações simples para escolher perfil.
- [ ] Disponibilizar perfis pré-definidos: Lucas, Clara, Amanda e Vitor.
- [ ] Validar perfil obrigatório.
- [ ] Salvar perfil selecionado localmente.
- [ ] Usar perfil selecionado nas ações.
- [ ] Permitir trocar perfil em uma tela/configuração simples.
- [ ] Testar fluxo básico de seleção/troca de perfil local.

Definition of done:

- O usuário escolhe um perfil antes de usar o app.
- As ações aparecem no histórico com esse perfil.

---

## Marco 4 — UI principal bonita e amigável

- [ ] Criar tema visual inicial da Prototipe.
- [ ] Criar card principal de status da sala.
- [ ] Mostrar se a sala está aberta ou fechada.
- [ ] Mostrar onde está a chave.
- [ ] Mostrar quem fez a última atualização.
- [ ] Mostrar horário da última atualização.
- [ ] Criar botões de ação com boa usabilidade.
- [ ] Criar área visual divertida com mascote/placeholder do mascote.
- [ ] Testar renderização básica da tela inicial.

Definition of done:

- Ao abrir o app, a situação da sala fica óbvia em poucos segundos.
- Visual parece intencional, não apenas padrão Flutter.
- Tela funciona bem em celular.

---

## Marco 5 — Histórico simples

- [ ] Criar lista de histórico na tela principal.
- [ ] Mostrar as últimas movimentações com data/hora e nome.
- [ ] Ordenar histórico do mais recente para o mais antigo.
- [ ] Criar estado vazio amigável quando não houver histórico.
- [ ] Testar renderização de histórico vazio.
- [ ] Testar renderização de histórico com itens.

Definition of done:

- Usuário entende rapidamente o que aconteceu antes.
- Histórico é simples e legível.

---

## Marco 6 — Confirmações e microinterações

- [ ] Confirmar devolução da chave para a portaria.
- [ ] Confirmar transferência da chave para outra pessoa.
- [ ] Exibir feedback de sucesso após ações.
- [ ] Exibir mensagens claras para ações inválidas.
- [ ] Testar pelo menos um diálogo de confirmação.

Definition of done:

- Ações sensíveis não acontecem por acidente.
- Erros são explicados de forma simples.

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
7. Implementar UI principal.
8. Implementar histórico.
9. Implementar confirmações.
10. Polir documentação e apresentação.
