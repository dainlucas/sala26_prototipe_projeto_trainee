# 003 — Persistência local inicial

## Objetivo

Implementar a primeira camada de persistência local/offline do Chave 26.

Esta fatia cobre os dados que precisam continuar salvos no aparelho durante o protótipo:

- situação atual da sala;
- histórico da sala;
- perfil local selecionado.

## Decisão de persistência

A implementação usa `SharedPreferences` com JSON.

A situação da sala é salva inteira em um único JSON, incluindo o histórico. Essa escolha segue o trade-off documentado em `TRADEOFFS.md`: para o protótipo, é melhor manter a implementação simples e fácil de revisar.

## Arquivos criados

### Sala

- `lib/funcionalidades/sala/dados/serializadores_da_sala.dart`
  - Converte `SituacaoDaSala` para JSON.
  - Converte JSON de volta para `SituacaoDaSala`.
  - Inclui estado, localização da chave, histórico, pessoa da última atualização e data/hora.

- `lib/funcionalidades/sala/dados/repositorio_local_da_sala.dart`
  - Salva a situação atual da sala no aparelho.
  - Carrega a situação atual da sala.
  - Retorna `SituacaoDaSala.inicial()` quando ainda não há dado salvo.
  - Carrega o histórico a partir da situação salva.
  - Salva estado atual e histórico juntos, no mesmo JSON.

### Configurações/perfil

- `lib/funcionalidades/configuracoes/dados/repositorio_local_do_perfil.dart`
  - Salva o perfil local selecionado.
  - Carrega o perfil local selecionado.
  - Retorna `null` quando ainda não há perfil salvo.

## Testes adicionados

- `test/funcionalidades/sala/dados/repositorio_local_da_sala_test.dart`
  - Testa conversão de `SituacaoDaSala` completa para JSON e de volta.
  - Testa carregamento do estado inicial quando não há dados salvos.
  - Testa salvamento e carregamento da situação da sala com histórico completo.

- `test/funcionalidades/configuracoes/dados/repositorio_local_do_perfil_test.dart`
  - Testa ausência de perfil salvo.
  - Testa salvamento e carregamento do perfil local selecionado.

## O que esta fatia já resolve

- Criar repositório local para estado atual.
- Criar acesso local ao histórico salvo.
- Salvar perfil local selecionado.
- Salvar estado da sala.
- Salvar histórico junto da situação da sala.
- Testar serialização/desserialização da situação da sala.

## O que ainda não foi integrado

A camada de persistência já existe e está testada, mas ainda não está conectada à interface do app.

Ainda falta, nas próximas fatias:

- carregar os dados automaticamente quando o app abrir;
- salvar automaticamente após ações feitas na interface;
- conectar a seleção de perfil à tela/configurações;
- validar o fluxo completo em widget/app.

## Limitações conscientes

- Os dados ficam apenas no aparelho.
- Ao desinstalar o app, os dados podem sumir.
- Não há sincronização entre dispositivos.
- O histórico local não é auditoria formal.
- `SharedPreferences` é suficiente para o protótipo, mas deve ser reavaliado em uma versão oficial.

Essas limitações estão detalhadas em `TRADEOFFS.md`.
