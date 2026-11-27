# PBI_AMS — plano de execução até o relatório final

**Data de preparação:** 26/11/2026  
**Repositório:** https://github.com/gabrielcosta444/PBI_AMS  
**Commit observado na preparação:** `659fc44bc34d3128124632798106b6be4be21047` — `feat (visão geral): entregta 4 - gráficos`.  
**Próxima etapa:** **05 — Filtros funcionais da Visão Geral**.

## 0. Visão do produto

Relatório Power BI de acompanhamento de **Proposals do Sales Team da AMS**, relacionando-as a Enablers e Demands de torres técnicas. O escopo final são **três páginas complementares**, evitando duplicação:

1. **Visão Geral e Resultados Comerciais:** indicadores executivos de recebimento, submissão, decisão e resultados.
2. **Carteira e Gargalos:** operação do estoque atual; bloqueios, aging, paradas, prazos, responsáveis e lista de ações.
3. **Torres Técnicas:** carga técnica vinculada às propostas, bloqueios, aging, distribuição por torre e impacto comercial.

### 0.1 O que já foi concluído

- Dataflow Gen1 v5.3 executando, seis tabelas importadas. Em observação anterior eram aproximadamente 1.413 Proposals, 835 cards técnicos e 843 links; são números de refresh anterior, **não totais fixos ou promessas atuais**.
- Modelo semântico TMDL com calendário, medidas comerciais/auxiliares e relações.
- Página `Visão Geral e Resultados` no PBIR, com cabeçalho, barra lateral visual, cinco cartões reais e quatro gráficos reais. Erros de campos ausentes nos três gráficos foram resolvidos pelo usuário **fechando e reabrindo o Power BI Desktop**: foi uma dessincronização externa do modelo. Não criar novamente os visuais por esse motivo.
- Último commit observado já contém a Entrega 04. A barra lateral possui caixas aparentando filtros, mas ainda **não filtra nada**.

### 0.2 Entradas principais do repositório

```text
PBI_AMS/
├── Acompanhamento_Sales_Team/
│   ├── acompanhamento-sales-team.pbip
│   ├── acompanhamento-sales-team.Report/
│   │   ├── definition/report.json
│   │   ├── definition/pages/pages.json
│   │   ├── definition/pages/046b26eedf429928de17/page.json
│   │   ├── definition/pages/046b26eedf429928de17/visuals/<id>/visual.json
│   │   └── StaticResources/RegisteredResources/ams_visao_geral_layout202611260901.png
│   └── acompanhamento-sales-team.SemanticModel/
│       └── definition/
│           ├── tables/_Medidas.tmdl
│           ├── tables/Calendario.tmdl
│           ├── tables/Proposals.tmdl
│           ├── tables/ProposalStateHistory.tmdl
│           ├── tables/TechnicalWorkItems.tmdl
│           ├── tables/ProposalTechnicalLinks.tmdl
│           ├── tables/ProposalDependencyTypes.tmdl
│           ├── tables/CardFields.tmdl
│           ├── relationships.tmdl
│           └── model.tmdl
├── AGENTS.md                      # este arquivo deve ser colocado na raiz
└── docs/PLANO_DE_EXECUCAO.md      # este plano
```

**Aviso:** o histórico do Git pode avançar. Ao iniciar cada fase, confira sempre o último commit e diferenças locais. Não copie arquivos de snapshots antigos sobre mudanças posteriores.

## 1. Métricas e semântica temporal: contrato obrigatório

| Indicador | Definição | Referência temporal | Observações |
|---|---|---|---|
| Solicitações recebidas | `DISTINCTCOUNT(Proposals.WorkItemId)` válidas | `CreatedDate` | Excluir Duplicate Proposal e Incorrect Demand Creation |
| Propostas submetidas | Propostas distintas cuja **primeira** entrada em Approval ocorreu no período | `ProposalStateHistory.DataEntrada` | Não usar o valor atual de State, nem ApprovalDate como proxy |
| Propostas aceitas | Closed, Discarded=false | `ClosedDate` | Não contar no mês de criação se foi encerrada depois |
| Propostas recusadas | Closed, Discarded=true e recusa comercial válida | `ClosedDate` | Excluir duplicidade, criação incorreta e transferência ao suporte |
| Taxa de aceite | Aceitas / (Aceitas + Recusadas) | eventos de decisão | Só decisões comerciais válidas |
| Carteira atual | Propostas abertas na data atual | situação atual, sem relação com período selecionado | Excluir duplicidade/criação indevida; respeitar filtros de dimensão |

Motivos conhecidos em `ReasonforDiscarded`: `Duplicate Proposal`, `Incorrect Demand Creation`, `Transferred to Support Team`, `Work No Longer Needed`, `Customer - ...`, `AMS Refusal - ...`. As três primeiras categorias recebem tratamento especial conforme tabela. **Não incluir `Duplicate Proposal` num gráfico de recusas comerciais.**

**Atenção ao calendário:** `Calendario` está ligado ativamente a `Proposals.CreatedDate`, e inativamente a `Proposals.ClosedDate` e `ProposalStateHistory.DataEntrada`. A maioria dos KPIs usa evento diferente de criação. Revisar DAX com casos de teste de proposta criada em setembro e aceita em novembro. Respeitar `dateTime` versus `date`.

**Cuidados com filtro:** sempre documentar se o filtro de período opera em eventos, criação ou foto de carteira; números agregados por datas diferentes não formam necessariamente um funil de coorte. Não usar rótulo “taxa de conversão” para métricas com denominador diferente sem validar.

## 2. Design aprovado

O usuário quer a identidade dos **relatórios AMS antigos**, porém com menos elementos: sidebar cinza-escura, marca ArcelorMittal / Sales Team, cabeçalho gradiente laranja→rosa→roxo, cartões claros com borda fina, gráficos roxos e laranja quando necessário, muito espaço em branco. Página 1920×1080. Um indicador deve aparecer uma vez, sem redundância em donut + barra + cartão sem justificativa.

Padrão de implementação atual: fundo gráfico registrado e **visuais nativos sobrepostos**. Nas próximas etapas, preferir visuais nativos com interações reais; não representar filtros ou números funcionais apenas como parte da imagem. Conferir z-order e legibilidade do fundo. Para novas páginas, reutilizar o sistema visual (não copiar números fictícios dos protótipos).

## 3. Etapa 05 — Filtros funcionais da Visão Geral (executar AGORA)

**Objetivo:** transformar a barra lateral decorativa da página 1 em filtros reais, sem modificar cálculos, cartões e gráficos que já renderizam.

**Filtros aprovados, nesta ordem:**

1. **Período:** `Calendario[Date]` ou `Calendario[Ano]` com seleção amigável e período claramente sinalizado. Dar suporte a análise por mês/ano ou intervalo, respeitando capacidade do PBIR e espaço disponível.
2. **Responsável:** `Proposals[AssignedToUserName]`.
3. **Torre técnica (associada à Proposal):** `Proposals[ProjectWorkTypes]`.
4. **Cliente:** `Proposals[AMSClient]`.
5. **Tipo de projeto:** `Proposals[ProjectType]`.

- **Não adicionar State nem Blocked na página executiva.** Isso distorceria alguns indicadores e duplicaria a página 2.
- Implementar segmentadores/slicers nativos PBIR, posicionados nos campos visuais existentes; ocultar ou retirar apenas a parte decorativa do fundo que conflitar, sem destruir o layout.
- **Limpar filtros:** configurar botão/bookmark/reset funcional; especificar exatamente o estado restaurado. Não basta desenhar um retângulo “Limpar filtros”.
- Verificar interações com KPI e gráficos. `Carteira atual` intencionalmente **ignora o período**, mas respeita os demais filtros de dimensão.
- O gráfico de Evolução mensal atualmente exibe muitos meses; restringir a **janela visível inicial** (por exemplo, últimos 12 meses ou ano corrente) sem impedir que o usuário amplie a análise. Preferir estado padrão de filtro/segmentador, não recortar definitivamente os dados.
- Se o Desktop não aceitar um tipo de slicer/botão criado por JSON, usar visual PBIR conhecido ou adaptar mediante exemplo gerado no Desktop; nunca publicar propriedades de schema inventadas.

**Aceitação:** os cinco slicers aparecem e funcionam; usuário seleciona um responsável e os KPIs/gráficos respondem de maneira coerente; período muda os KPIs de evento mas não o estoque atual; limpar filtros funciona; layout permanece limpo; PBIP abre sem erros.

## 4. Etapa 06 — Refinamento e QA da Visão Geral

**Objetivo:** finalizar a página 1 antes de criar as seguintes.

- Manter 5 KPIs: Recebidas, Submetidas, Aceitas, Recusadas, Taxa de aceite.
- Manter 4 gráficos, sem acrescentar mais: **Carteira atual por State**, **Evolução mensal**, **Resultados por responsável** (aceitas e recusadas; verificar se o visual de fato usa barras empilhadas), **Motivos de recusa**.
- **Carteira atual por State:** excluir Closed; verificar ordem operacional `New → Next → Triage → Planning → Build → Approval`, contemplando states adicionais do conjunto real se necessários. Não criar dependência circular `State` ↔ `OrdemState`. Se usar ordenação alternativa, testar com dados.
- **Evolução mensal:** legenda compreensível, escala adequada, datas em ordem cronológica, intervalo inicial inteligível, propostas recebidas/submetidas/aceitas por suas datas corretas. Não usar dados fictícios.
- **Resultados por responsável:** comparar aceitas e recusadas com a mesma regra de datas e dimensões, sem confundir responsável do card técnico com responsável da Proposal.
- **Motivos de recusa:** mostrar apenas motivos comerciais, evitar excesso de categorias e duplicidades, não mostrar `Duplicate Proposal`, `Incorrect Demand Creation` ou `Transferred to Support Team` como recusa.
- Conferir correspondência entre valor do gráfico e cartões sob filtros equivalentes, tooltips, números por extenso vs abreviados, textos e nomes de eixos. Verificar `15` medidas no modelo (ou mais, caso novas medidas tenham sido adicionadas intencionalmente), sem recriar duplicatas.
- Se os visuais de gráficos referirem medidas ausentes, **primeiro feche/reabra o Desktop e confira TMDL**, pois esse problema já ocorreu e foi resolvido por recarregamento.

**Aceitação:** página executiva funcional, pouca poluição visual, números coerentes, sem erros, captura de tela aprovada pelo usuário.

## 5. Etapa 07 — Modelo e medidas da página Carteira e Gargalos

**Objetivo:** implementar análises operacionais sem repetir o gráfico de quantidade por State da Visão Geral.

**KPIs propostos** (validar regras com os dados antes de consolidar):

1. **Propostas em andamento**: carteira ativa em estados de trabalho, a definir com base nos valores reais (`Next`, `Triage`, `Planning`, `Build` foram sugeridos). Se incluir todos não fechados, denominar **Propostas abertas** para evitar ambiguidade.
2. **Bloqueadas**: propostas abertas com `Proposals[Blocked] = TRUE`.
3. **Em atraso**: propostas abertas com `TargetDate` preenchida e anterior à data atual; não classificar data vazia como atrasada.
4. **Sem movimentação > 15 dias**: propostas abertas com `ChangedDate` mais antiga do que 15 dias. Se a regra desejada for “sem mudança de State”, usar `StateChangeDate` e renomear o indicador. Diferenciar os conceitos.
5. **Idade mediana da carteira**: mediana de `TODAY() - DATEVALUE(Proposals[CreatedDate])` apenas para propostas abertas válidas; deixar claro que é idade **total**, não dias no State atual.

**Gráficos:**

- **Idade das propostas por State:** barras empilhadas 100% por faixas `0–7`, `8–15`, `16–30`, `>30 dias`. Não é simples contagem por State.
- **Bloqueios por motivo:** contagem de propostas abertas bloqueadas por `BlockedReason`; tratar motivos ausentes explicitamente.
- **Carteira por responsável:** contagem de abertas atribuídas a cada pessoa (possível Top 10).
- **Tempo parado por etapa:** preferir dias no **State atual** (`StateChangeDate`), com média ou mediana por State. Se usar histórico `ProposalStateHistory[DuracaoDias]`, dizer que se trata de **duração histórica das passagens**, não “tempo parado” atual.

**Tabela operacional:** `Propostas que exigem ação`, com WorkItemId, Título, Cliente, State, Responsável, Idade total, Dias no State atual, Bloqueado?, Prazo (`TargetDate`) e Dependência/Tipo de dependência. Usar formatação condicional discreta para bloqueio, vencimento e idade. Se criar botões `Todas`, `Bloqueadas`, `Atrasadas`, `Sem movimentação`, `Vencimento próximo`, especificar critério e fazer esses botões filtrarem de verdade. **Não inventar “alta prioridade” se não existir campo de prioridade na fonte.**

**Temporalidade:** página operacional retrata o **estoque atual**. Decidir de forma explícita se haverá Período: se houver, definir se seleciona coorte por criação ou só indicadores de fluxo. Não permitir que o usuário acredite que vê uma fotografia histórica da carteira sem snapshots. Uma opção é omitir período nesta página e manter filtros de responsável, torre, cliente, State, Bloqueado e tipo de projeto.

**Aceitação:** KPIs, quatro gráficos e tabela com casos reais; sinais de atraso, bloqueio e inatividade reproduzíveis em amostras de WorkItemId; sem repetição da contagem simples por State da página 1.

## 6. Etapa 08 — Layout e interatividade da Carteira e Gargalos

- Criar **segunda página PBIR** com ID próprio, atualizar `pages.json`, adicionar nome de página adequado e preservar a primeira.
- Reutilizar marca/gradiente/sidebar/card, com densidade informacional controlada; tabela ocupa faixa inferior e pode permitir rolagem.
- Manter cinco KPIs: `Propostas em andamento`, **`Propostas com bloqueio`**, `Propostas em atraso`, `Propostas sem movimentação há mais de 15 dias` e `Idade mediana da carteira`. “Com bloqueio” é a união distinta de `Blocked = TRUE()` (externo) ou `InternalBlock = TRUE()` (interno); não contar duas vezes quando ambos estiverem ativos.
- Criar quatro gráficos, sem acrescentar elementos decorativos:
  1. **Idade das propostas por State**: barras horizontais 100% empilhadas por tempo no State atual (`StateChangeDate`), nas faixas `0–7`, `8–15`, `16–30`, `31–60` e `>60 dias`. Tooltips devem trazer quantidade, média, mediana, maior permanência e quantidade acima de 60 dias.
  2. **Tipos de dependência das propostas bloqueadas**: usar `ProposalDependencyTypes[DependencyType]` como dimensão e duas séries — bloqueio interno e externo — com contagem distinta de `WorkItemId`. A categoria de dependência é uma associação, não uma causa comprovada; não usar `BlockedReasonDisplay` como dimensão.
  3. **Carteira por responsável**: quantidade de propostas abertas válidas por `Proposals[AssignedToUserName]`.
  4. **Incidência de bloqueios por State**: seletor único **Interno/Externo**, padrão Interno. O denominador é o total aberto no State; o numerador alterna entre `InternalBlock = TRUE()` e `Blocked = TRUE()`. Tooltips mostram o modo, total aberto, bloqueadas e percentual. Esta é uma fotografia atual, não histórico de bloqueios.
- Não usar `BlockedTimeInMinutes` como tempo bloqueado no State. O modelo não possui histórico completo de intervalos de bloqueio; essa métrica fica como melhoria futura e não deve ser inferida de `ProposalStateHistory`.
- A tabela **Propostas que exigem ação** deve conter `WorkItemId`, `Title`, `AMSClient`, `State`, `AssignedToUserName`, idade total, dias no State atual, `Blocked` (externo), `InternalBlock` (interno), `TargetDate` e `DependencyType`. A medida `Exibir proposta na tabela` mantém somente propostas abertas válidas e aplica o filtro rápido selecionado.
- Filtros rápidos funcionais, mutuamente exclusivos e limitados à tabela: **Todas**, **Bloqueio externo**, **Bloqueio interno**, **Atrasadas**, **Sem movimentação** e **Vencimento próximo**. As categorias podem se sobrepor nos dados; suas contagens devem ignorar a seleção rápida atual e respeitar os filtros gerais. Remover Alta prioridade.
- Filtros gerais: Responsável, State, Torre associada (`ProjectWorkTypes`), Cliente, Tipo de projeto e Tipo de dependência (`ProposalDependencyTypes[DependencyType]`). Omitir Período por padrão, pois a página representa o estoque atual e não possui snapshots históricos.
- Adicionar medidas e filtros da Etapa 07 aos visuais. A identidade usa o mesmo sidebar escuro, cabeçalho laranja–magenta–roxo, cartões brancos e roxo principal da Visão Geral; os visuais nativos ficam transparentes sobre o layout, sem duplicar molduras. Conferir sorting, formatos, labels, acessibilidade, responsividade em `FitToPage` e tooltips sem números fictícios.
- Não usar números fixos do protótipo. Validar casos reais por `WorkItemId` no Desktop e registrar a captura aprovada pelo usuário.

**Aceitação:** página 2 concluída e validada por usuário antes de iniciar a 3.

**Execução registrada (27/11/2026):** a página `Carteira e Gargalos` mantém o ID `c7f3b2a1e4d948d6b109` e foi revisada sobre o padrão visual da Visão Geral. Foram separados bloqueios externos/internos, incluídas as tabelas desconectadas `ModoBloqueio` e `FiltroRapidoCarteira`, trocada a dimensão do gráfico para `ProposalDependencyTypes[DependencyType]`, adicionada a medida de filtro da tabela e substituído o layout por um fundo AMS com visuais transparentes. A validação estrutural confirmou JSON parseável, nomes visuais únicos, referências sem `BlockedReasonDisplay`/ `BlockedTimeInMinutes` e recurso registrado; a validação de renderização e números reais permanece pendente de abertura no Power BI Desktop.

## 7. Etapa 09 — Modelo e medidas da página Torres Técnicas

**Relações centrais:** `TechnicalWorkItems`, `ProposalTechnicalLinks`, `Proposals`. `TechnicalWorkItems[AreaPath]` indica a torre real do card. `WorkItemType` indica Enabler/Demand. `Proposals[ProjectWorkTypes]` é uma **classificação comercial** distinta; não usá-la para identificar proprietários dos cards técnicos.

**KPIs planejados** (confirmar estados ativos da fonte):

1. **Cards técnicos ativos:** distintos WorkItemId de Enabler/Demand vinculados a propostas, em States considerados abertos.
2. **Cards bloqueados:** técnicos vinculados com `Blocked = TRUE`.
3. **Propostas impactadas:** distinct `ProposalTechnicalLinks[ProposalId]` associado aos cards no contexto; deixar claro se inclui todos relacionados ou somente com dependência/bloqueio, e adotar nome coerente.
4. **Aging médio:** média de dias desde `CreatedDate` nos cards técnicos abertos (diferenciar de tempo no State ou bloqueio).
5. **Torres ativas:** número de torres identificadas com cards no escopo atual; exigir mapeamento consistente de AreaPath.

**Gráficos:**

- **Cards por torre técnica**: quantidade de cards técnicos vinculados, distinta, por torre real.
- **Bloqueios por torre**: bloqueados e não bloqueados; mostrar também **taxa de bloqueio** (percentual), para comparar torres de tamanhos diferentes.
- **Propostas impactadas por torre**: quantidade de Proposals distintas relacionadas a cards daquela torre; não duplicar por múltiplos links.
- **Aging por torre**: média ou mediana da idade de cards técnicos ativos.

**Opcional, condicionado à disponibilidade de dados históricos:** evolução mensal de **cards criados por mês** pode ser feita com `CreatedDate`. **Não representar “cards ativos historicamente” usando a tabela atual**, porque ela não contém necessariamente snapshots ou revisões para essa reconstrução.

**Tabela:** ID do card técnico, Título, Tipo de card (Enabler/Demand), Torre/AreaPath, State, Responsável, Bloqueado, Idade, Proposal relacionada e Cliente quando possível. Um card pode aparecer ligado a mais de uma Proposal; explicitar a granularidade da tabela e manter contagens distintas.

**Filtro cruzado:** a ponte possui relações da Proposal e do card técnico para a tabela de Links. Não ativar bidirecionalidade global sem análise de ambiguidade. Se os filtros de cliente/responsável comercial precisarem restringir KPIs técnicos, implementar controle de contexto via DAX/TREATAS ou desenho de dimensões apropriado, com testes.

**Aceitação:** medidas reproduzíveis, definição transparente da torre e de ativos, filtragem por `Enabler`/`Demand`, nenhuma duplicação por Links, nenhuma inferência de série histórica impossível.

## 8. Etapa 10 — Layout da página Torres Técnicas

- Criar terceira página PBIR com ID distinto, atualizar `pages.json` mantendo ordem 1 → 2 → 3.
- Mesma identidade visual das páginas anteriores, com cinco KPIs e quatro gráficos, mais tabela de cards.
- Sidebar sugerida: Período (de criação do card, se usar), Torre técnica, State técnico, Responsável técnico, Tipo de card (Enabler/Demand), Bloqueado. Não confundir nome do filtro com os campos comerciais.
- Implementar os visuais reais e, caso haja página de detalhe, navegação que efetivamente funcione, não apenas rótulos de imagem.
- Testar filtragem entre torre, card técnico, proposta e cliente; um card pode estar ligado a várias propostas.

**Aceitação:** terceira página funcional, consistente com o escopo de dados extraídos e com a identidade visual aprovada.

## 9. Etapa 11 — Integração, qualidade e entrega final

1. **Validação funcional:** filtros individuais, combinados, botão Limpar, alterações de período, interações entre gráficos, ausência de filtros fantasma, tratamento de zeros e blanks.
2. **Validação numérica:** comparar medidas com tabelas de conferência por WorkItemId; testar cruzamento de anos/meses, primeira entrada em Approval, recusas administrativas, datas faltantes, multi-relacionamentos.
3. **Validação técnica:** o PBIP abre e recarrega; os arquivos TMDL/PBIR são parseáveis; referências a tabela/medida e IDs de página e visual existem; nenhum recurso gráfico órfão; sem dependências circulares.
4. **Validação visual:** espaçamento, fontes, cores, corte de textos, contrastes, gráficos legíveis, hierarquia, formatos `pt-BR`; nenhuma página excessivamente poluída.
5. **Segurança:** assegurar que o repositório não publicou cache, credenciais, dados brutos corporativos nem imagens internas sem autorização; recomendar repositório privado se apropriado.
6. **Operação:** documentar atualização do Dataflow, dependências das conexões, regra temporal de cada KPI, e como o usuário pode corrigir a dessincronização local fechando/reabrindo o Desktop.

**Entrega final:** três páginas aprovadas, definições DAX documentadas e projeto PBIP versionado, mais um resumo de decisões e limitações remanescentes.

## 10. Protocolo de cada execução do Codex

**Pré-execução:**

```text
1. Ler AGENTS.md e docs/PLANO_DE_EXECUCAO.md.
2. Executar git status e git log -1.
3. Confirmar HEAD, branch, mudanças locais e etapa autorizada pelo usuário.
4. Ler somente os TMDL e PBIR relevantes para a etapa.
5. Listar arquivos planejados para criação/edição/exclusão ANTES de editar.
```

**Implementação:** não alterar dados/conexões desnecessariamente; gerar IDs estáveis; evitar propriedades de PBIR especulativas; preservar recursos de fundo; preferir exemplos locais válidos e schema oficial; nunca inserir números fictícios.

**Pós-execução:**

```text
1. Validar JSON e TMDL na medida do possível no ambiente local.
2. Inspecionar git diff --check e git diff --stat.
3. Revisar se nenhuma alteração local não relacionada foi sobrescrita.
4. Entregar: resumo, arquivos alterados, critérios adotados, riscos e 3-8 testes manuais concretos no Power BI Desktop.
5. Solicitar validação do usuário; aguardar antes da próxima etapa.
6. Commit/push somente com autorização.
```

**Limite operacional:** Codex modifica código, mas a validação definitiva dos números e da renderização acontece no Power BI Desktop autenticado do usuário. Não alegar sucesso de execução no Desktop sem evidência.

## 11. Primeiro comando sugerido ao Codex

```text
Leia AGENTS.md e docs/PLANO_DE_EXECUCAO.md por completo e faça uma auditoria rápida do estado local do repositório. Estamos após a Entrega 04; o Power BI Desktop já voltou a sincronizar corretamente as 15 medidas DAX e os quatro gráficos funcionam após reinicialização. Execute APENAS a Etapa 05: transformar os cinco filtros desenhados na barra lateral da página Visão Geral e Resultados em slicers nativos, implementar um botão Limpar filtros funcional, preservar os cinco cartões e os quatro gráficos e ajustar a janela inicial da Evolução mensal sem cortar dados historicamente. Não altere o modelo semântico nem refaça as medidas sem demonstrar necessidade. Antes de editar, apresente o plano e arquivos afetados; depois, gere alterações incrementais, valide os schemas e forneça o roteiro de teste no Power BI Desktop. Não avance às outras páginas até eu validar a Etapa 05.
```
