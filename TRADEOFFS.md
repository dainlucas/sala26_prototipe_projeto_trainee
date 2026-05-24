# Trade-offs do projeto Chave 26

Este documento registra escolhas conscientes feitas para o protótipo do Chave 26.

A intenção não é tratar essas escolhas como definitivas para uma versão oficial. A intenção é deixar claro por que elas são boas para o protótipo atual e o que precisará ser revisto caso o app evolua para um produto mais profissional, multiusuário ou usado em produção.

## Contexto geral

O Chave 26, nesta fase, é um protótipo local/offline para apresentação e validação do fluxo principal:

- saber se a sala está aberta ou fechada;
- saber onde está a chave;
- registrar quem fez cada ação;
- manter histórico simples;
- preservar os dados ao fechar e reabrir o app no mesmo aparelho.

O protótipo será demonstrado em um único aparelho. Para simular pessoas diferentes, o app terá perfis locais pré-definidos.

Perfis definidos para o protótipo:

- Lucas;
- Clara;
- Amanda;
- Vitor.

---

## 1. SharedPreferences com JSON em vez de banco de dados

### Decisão atual

Usar `SharedPreferences` com dados em JSON para persistência local simples.

### Por que faz sentido no protótipo

- reduz complexidade de implementação;
- evita configurar banco local, migrations e camadas extras agora;
- é suficiente para poucos dados;
- funciona offline;
- facilita testes de serialização e desserialização;
- combina com o objetivo de prototipar primeiro e profissionalizar depois.

### O que será salvo

- estado atual da sala;
- localização da chave;
- histórico simples;
- perfil local selecionado.

### Limitações aceitas

- os dados ficam apenas no aparelho;
- ao desinstalar o app, os dados podem ser apagados;
- não há sincronização entre aparelhos;
- não é ideal para histórico grande;
- não é ideal para consultas complexas por data, pessoa ou tipo de ação;
- não oferece auditoria forte contra adulteração local.

### Quando reavaliar

Reavaliar essa escolha se o app precisar de:

- muitos eventos no histórico;
- busca/filtro avançado no histórico;
- relatórios;
- múltiplos aparelhos usando o mesmo estado;
- auditoria confiável;
- sincronização com servidor;
- funcionamento oficial em produção.

### Caminhos futuros possíveis

- SQLite/Drift para banco local estruturado;
- Isar/Hive para persistência local mais robusta;
- Supabase/Firebase/API própria para sincronização entre dispositivos;
- backend próprio com autenticação, histórico e auditoria.

---

## 2. Salvar `SituacaoDaSala` inteira em vez de separar estado e histórico

### Decisão atual

Salvar a `SituacaoDaSala` inteira como um único JSON, incluindo o histórico.

Isso significa que o estado atual e o histórico ficam juntos no mesmo objeto persistido.

### Alternativa considerada

Separar em dois repositórios/dados salvos:

- um para o estado atual;
- outro para o histórico.

### Por que escolhemos salvar tudo junto agora

- é mais simples;
- reduz risco de inconsistência entre estado atual e histórico;
- exige menos código;
- é mais fácil de testar;
- atende bem ao volume pequeno esperado no protótipo;
- mantém a implementação alinhada ao modelo de domínio já existente.

### Limitações aceitas

- o JSON pode crescer conforme o histórico aumenta;
- não é eficiente para consultar apenas uma parte do histórico;
- não é ideal para paginação ou filtros;
- qualquer alteração salva novamente o pacote completo de estado + histórico.

### Quando reavaliar

Reavaliar se:

- o histórico crescer muito;
- for necessário pesquisar eventos antigos;
- for necessário exportar relatórios;
- for necessário sincronizar histórico separadamente;
- o app passar a ter uso real por várias pessoas.

### Caminho futuro possível

Em uma versão mais profissional, separar:

- `estado_atual_da_sala` como registro único;
- `eventos_historicos` como lista/tabela de eventos;
- cada evento com identificador, pessoa, data/hora, tipo de ação e descrição.

---

## 3. Perfis locais pré-definidos em vez de login real

### Decisão atual

Usar um setor simples de configurações no app para selecionar um perfil local pré-definido.

Perfis:

- Lucas;
- Clara;
- Amanda;
- Vitor.

### Por que faz sentido no protótipo

- evita a complexidade de autenticação;
- evita cadastro de usuários;
- evita senhas, recuperação de conta e segurança de login;
- facilita apresentação do app em um único aparelho;
- permite demonstrar ações feitas por pessoas diferentes;
- mantém o foco no fluxo da chave, não em infraestrutura.

### Exemplo de apresentação

1. Selecionar perfil `Lucas`.
2. Lucas pega a chave ou transfere a chave.
3. Trocar para perfil `Clara` nas configurações.
4. Clara faz outra ação.
5. O histórico mostra ações com nomes diferentes, simulando o uso por pessoas distintas.

### Limitações aceitas

- o perfil selecionado não prova identidade real;
- qualquer pessoa com acesso ao aparelho pode trocar o perfil;
- não existe senha ou autenticação;
- não representa vários aparelhos usando o app ao mesmo tempo;
- serve para demonstração, não para controle oficial.

### Quando reavaliar

Reavaliar se o app precisar de:

- identificação real de usuários;
- permissões por pessoa;
- responsabilização formal;
- uso em múltiplos aparelhos;
- auditoria confiável;
- integração com e-mail institucional, SSO ou outro login oficial.

### Caminho futuro possível

- login simples por código/PIN;
- cadastro local de membros;
- autenticação via backend;
- autenticação institucional;
- permissões por perfil.

---

## 4. Protótipo local em um aparelho em vez de sistema sincronizado

### Decisão atual

O protótipo será usado em um único aparelho, com dados estáticos salvos na memória interna/local do app.

### Por que faz sentido agora

- reduz muito a complexidade;
- permite validar o fluxo visual e de regras rapidamente;
- evita backend antes de validar a ideia;
- combina com a forma de trabalho da Prototipe: primeiro prototipar, depois transformar em projeto mais completo.

### Limitações aceitas

- outros aparelhos não verão o mesmo estado;
- não há resolução de conflito entre pessoas;
- não há atualização em tempo real;
- não há fonte central de verdade;
- os dados podem desaparecer ao desinstalar o app.

### Quando reavaliar

Reavaliar se a solução deixar de ser apenas uma demonstração e passar a ser usada por várias pessoas no dia a dia.

---

## 5. Histórico simples local em vez de auditoria formal

### Decisão atual

Manter um histórico simples com data/hora, pessoa e descrição.

### Por que faz sentido no protótipo

- mostra claramente o fluxo de uso;
- ajuda na apresentação;
- exige pouco código;
- já valida a regra principal: toda ação importante gera histórico.

### Limitações aceitas

- histórico local pode ser perdido ao desinstalar o app;
- não há assinatura digital;
- não há proteção forte contra manipulação local;
- não deve ser tratado como auditoria oficial.

### Quando reavaliar

Reavaliar em uma versão oficial, especialmente se o histórico for usado para responsabilização formal.

---

## Resumo das escolhas atuais

| Tema | Escolha do protótipo | Reavaliar no futuro quando |
| --- | --- | --- |
| Persistência | SharedPreferences + JSON | precisar de banco, filtros, histórico grande ou produção |
| Estado e histórico | salvar `SituacaoDaSala` inteira | precisar consultar/sincronizar histórico separadamente |
| Identificação | perfis locais pré-definidos | precisar de identidade real ou permissões |
| Sincronização | nenhum backend; um aparelho | precisar de múltiplos dispositivos |
| Auditoria | histórico simples local | precisar de trilha oficial/confiável |

## Regra prática

Para o protótipo, favorecer simplicidade, clareza e velocidade.

Para uma versão oficial, reabrir este documento e revisar cada escolha antes de transformar o app em sistema de produção.
