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
- [x] Haverá login simples/local para diferenciar quem está usando o app.
- [x] O nome da pessoa logada será usado nas ações e no histórico.
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
- [x] Decisões, bibliotecas, regras, limitações e mudanças relevantes devem ser documentadas constantemente conforme o desenvolvimento.

---

## Decisões pendentes antes da implementação visual

- [x] Definir plataforma principal.
  - Decisão: foco em celular/Android.
  - Web fica fora do MVP.

- [ ] Definir o nome técnico do pacote/app.
  - Sugestão: `chave_26`.

- [ ] Definir como representar a identidade visual da Prototipe no MVP.
  - Cores principais serão informadas depois.
  - Mascote/imagem já incluído em `assets/images/mascote_prototipe.png`.
  - Enquanto isso, a paleta de cores continua provisória.

- [x] Definir biblioteca de estado.
  - Decisão: Riverpod pode ser usado.
  - Uso deve ser simples e explicado, sem arquitetura excessiva.

- [x] Definir persistência local.
  - Decisão: SharedPreferences com JSON pode ser usado.
  - Motivo: reduz setup e mantém simplicidade para o MVP.

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
- [ ] Verificar execução em Android/celular.
- [~] Configurar estrutura inicial de pastas.
  - Projeto Flutter criado; estrutura por feature será expandida no Marco 1.
- [x] Criar README inicial.
- [x] Criar docs/decisoes-tecnicas.md.
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
- Documentação da etapa existe em `docs/features/001-preparacao-projeto-flutter.md`.

---

## Marco 1 — Domínio e regras de negócio

- [ ] Criar modelos de domínio:
  - `RoomStatus`.
  - `KeyLocation`.
  - `RoomSnapshot`.
  - `HistoryEvent`.
- [ ] Criar serviço/controlador de regras da sala.
- [ ] Testar ação “peguei a chave”.
- [ ] Testar ação “abri a sala”.
- [ ] Testar ação “fechei a sala com chave comigo”.
- [ ] Testar ação “fechei a sala e devolvi para portaria”.
- [ ] Testar ação “passei a chave para outra pessoa”.
- [ ] Testar bloqueios de ações inválidas.
- [ ] Atualizar docs com as regras implementadas.

Definition of done:

- Regras principais cobertas por testes unitários.
- Histórico é gerado pelas ações.
- Ações inválidas retornam mensagem compreensível.

---

## Marco 2 — Persistência local/offline

- [ ] Criar repositório local para estado atual.
- [ ] Criar repositório local para histórico.
- [ ] Salvar nome da pessoa logada.
- [ ] Salvar estado da sala.
- [ ] Salvar histórico.
- [ ] Restaurar dados ao reabrir o app.
- [ ] Testar serialização/desserialização dos modelos.
- [ ] Documentar limitações da persistência local.

Definition of done:

- Dados não somem ao fechar e reabrir o app.
- Testes de serialização passam.
- App funciona offline.

---

## Marco 3 — Login local simples

- [ ] Criar tela inicial para informar o nome.
- [ ] Validar nome obrigatório.
- [ ] Salvar nome localmente.
- [ ] Usar nome logado nas ações.
- [ ] Permitir trocar usuário em uma tela/configuração simples.
- [ ] Testar fluxo básico de login/local.

Definition of done:

- O usuário informa o nome antes de usar o app.
- As ações aparecem no histórico com esse nome.

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

- [ ] Login local não prova identidade real.
  - Impacto: qualquer pessoa pode digitar qualquer nome.
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
6. Implementar login local.
7. Implementar UI principal.
8. Implementar histórico.
9. Implementar confirmações.
10. Polir documentação e apresentação.
