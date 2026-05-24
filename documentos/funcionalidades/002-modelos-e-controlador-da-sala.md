# Feature 002 — Modelos e controlador da sala

## Objetivo

Criar a base de domínio do Marco 1 com nomes em português para representar a sala 26, a chave, o histórico e um controlador central das regras de negócio.

## O que foi implementado

Arquivos de domínio criados em `lib/funcionalidades/sala/dominio/`:

- `estado_da_sala.dart`
  - Enum `EstadoDaSala` com `aberta` e `fechada`.
- `localizacao_da_chave.dart`
  - Modelo `LocalizacaoDaChave` com fábricas nomeadas:
    - `LocalizacaoDaChave.naPortaria()`;
    - `LocalizacaoDaChave.naSala()`;
    - `LocalizacaoDaChave.comPessoa(nome)`.
- `evento_historico.dart`
  - Modelo `EventoHistorico` com data/hora, pessoa e descrição.
- `situacao_da_sala.dart`
  - Modelo `SituacaoDaSala` com estado atual, localização da chave, histórico, última pessoa responsável e horário da última atualização.
- `controlador_da_sala.dart`
  - Serviço `ControladorDaSala` para concentrar as regras de transição da sala.
  - Resultado explícito em `ResultadoAcaoDaSala`, evitando lançar exceções para ações esperadamente inválidas.
  - Validação simples de nomes no domínio para bloquear ações sem pessoa logada, destinatário vazio ou transferência para a própria pessoa.

## Regras iniciais cobertas pelo controlador

O controlador já possui métodos para as ações principais do MVP:

- `pegarChaveNaPortaria`;
- `abrirSala`;
- `fecharSalaComChaveComigo`;
- `fecharSalaEDevolverChaveParaPortaria`;
- `fecharSalaEPassarChaveParaOutraPessoa`;
- `passarChaveParaOutraPessoa`;
- `devolverChaveParaPortaria`.

As ações válidas geram um `EventoHistorico`, atualizam a pessoa responsável e atualizam o horário da última alteração.

As ações inválidas retornam `ResultadoAcaoDaSala` com `sucesso: false`, preservam a situação anterior e trazem uma mensagem compreensível.

## Testes adicionados

Arquivo:

- `test/funcionalidades/sala/dominio/controlador_da_sala_test.dart`

Comportamentos testados nesta fatia:

- `SituacaoDaSala.inicial()` começa com sala fechada, chave na portaria, sem histórico e sem última atualização.
- `EventoHistorico` guarda data/hora, pessoa e descrição.
- `ControladorDaSala.situacaoInicial()` retorna a situação inicial padrão.
- `pegarChaveNaPortaria` mantém a sala fechada, move a chave para a pessoa logada e registra histórico.
- `abrirSala` exige a chave com a pessoa logada, abre a sala, move a chave para a sala e registra histórico.
- `fecharSalaComChaveComigo` fecha a sala, deixa a chave com a pessoa logada e registra histórico.
- `fecharSalaEDevolverChaveParaPortaria` fecha a sala, devolve a chave para a portaria e registra histórico.
- `devolverChaveParaPortaria` cobre a devolução direta quando a pessoa está com a chave e a sala não precisa ser fechada nessa ação.
- `fecharSalaEPassarChaveParaOutraPessoa` confirma a regra de domínio para fechar a sala e passar a chave a outro membro no mesmo fluxo.
- `passarChaveParaOutraPessoa` move a chave para a outra pessoa informada e registra histórico.
- A sequência completa do histórico permanece na ordem das ações.
- O histórico de `SituacaoDaSala` não pode ser alterado diretamente por listas externas ou por `historico.add` fora do controlador.
- `EventoHistorico`, `LocalizacaoDaChave` e `SituacaoDaSala` comparam por valor nos testes.
- Bloqueios de ações inválidas preservam a situação anterior e retornam mensagem compreensível.

## Regras validadas por testes automatizados

- Não abre a sala se a chave não estiver com a pessoa logada.
- Não pega a chave na portaria quando ela já está com uma pessoa ou em outro lugar.
- Não abre uma sala que já está aberta.
- Não fecha uma sala que já está fechada.
- Não passa a chave se ela não estiver com a pessoa logada.
- Não devolve a chave para a portaria se ela não estiver com a pessoa logada.
- Não aceita pessoa logada vazia ou composta só por espaços; essa validação fica no domínio para proteger o app mesmo fora da UI.
- Não aceita destinatário vazio em transferência de chave.
- Não aceita transferir a chave para a própria pessoa.

## Próximos passos no backlog

O Marco 1 agora está coberto por testes unitários de domínio. As próximas etapas naturais são conectar esses modelos à persistência local no Marco 2 e, depois, à interface visual dos marcos seguintes.

## Comandos de verificação

```bash
/home/dain/dev/flutter/bin/flutter test test/funcionalidades/sala/dominio/controlador_da_sala_test.dart
/home/dain/dev/flutter/bin/dart format lib test
/home/dain/dev/flutter/bin/flutter analyze
/home/dain/dev/flutter/bin/flutter test
```

## Observações

- Nenhum commit foi feito, respeitando a revisão manual antes de versionar.
- A persistência local ainda não foi conectada; isso pertence ao Marco 2.
- A UI ainda não consome esses modelos; isso fica para marcos posteriores.
