# Plano inicial — Chave 26

## Resumo do app

O Chave 26 será um app Flutter/Dart para celular, com foco em Android, que mostra de forma clara:

- se a sala 26 está aberta ou fechada;
- onde está a chave;
- quem fez a última atualização;
- histórico simples das movimentações.

O projeto será um MVP para teste de trainee, com visual amigável, divertido e alinhado à Prototipe.

## Escopo fechado do MVP

Entram no MVP:

- login local por nome;
- status da sala;
- localização da chave;
- ações principais;
- transferência de titular da chave;
- histórico simples;
- persistência local/offline;
- confirmações para ações importantes;
- UI principal bem feita;
- poucos testes automatizados;
- README e backlog.

Não entram no MVP:

- backend;
- login real;
- sincronização entre vários usuários;
- notificações;
- integração com grupo de mensagens;
- botão de copiar mensagem pronta;
- modo escuro.

## Stack recomendada

- Flutter + Dart.
- Riverpod para estado, usado de forma simples.
- SharedPreferences com JSON para persistência local.
- Testes unitários e poucos testes de widget.

Motivo: essa combinação equilibra simplicidade, organização e demonstração técnica sem aumentar demais o risco para um prazo de 6 dias.

## Ordem de implementação

1. Resolver ambiente Flutter. — concluído com Flutter Linux no WSL.
2. Criar projeto Flutter. — concluído com target Android.
3. Criar modelos e regras de negócio com testes.
4. Criar persistência local.
5. Criar login local por nome.
6. Criar tela principal.
7. Criar histórico.
8. Criar confirmações.
9. Polir UI e documentação.

## Perguntas finais antes de criar o app

1. Você tem a imagem/arquivo do mascote da Prototipe?

Se sim, coloque no projeto ou me diga o caminho. Se não, começo com um placeholder divertido.

2. Você sabe as cores da Prototipe?

Se não souber, posso começar com uma paleta provisória e depois ajustamos.

3. Como vamos resolver o Flutter no WSL?

O Flutter encontrado em `/mnt/c/src/flutter` parece estar com scripts Windows/CRLF quando chamado pelo WSL. A recomendação é instalar/configurar Flutter Linux dentro do WSL para permitir criação do projeto, testes e análise estática diretamente daqui.
