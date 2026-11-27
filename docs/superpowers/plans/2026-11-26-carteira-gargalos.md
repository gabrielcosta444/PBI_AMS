# Carteira e Gargalos — Etapa 8 Implementation Plan

> **For agentic workers:** Use `superpowers:executing-plans` to implement this plan task-by-task.

**Goal:** Criar a segunda página PBIR de operação da carteira comercial, com KPIs, quatro gráficos e tabela de ações, preservando a página executiva e o Dataflow.

**Architecture:** Reutilizar o sistema visual da página 1, mas criar uma página PBIR com ID próprio. Medidas de estoque removem o filtro de calendário; o aging do State atual usa `StateChangeDate`; bloqueios técnicos ficam fora do escopo.

**Tech Stack:** PBIP, PBIR visual JSON, TMDL/DAX, Power BI Desktop para validação de renderização e dados.

**Spec:** `docs/PLANO_DE_EXECUCAO.md`, seção Etapa 08, atualizada para o protótipo aprovado.

## Global Constraints

- Não alterar conexões, partições M ou Dataflow.
- Preservar a página 1, seus IDs e seus visuais.
- Não usar `BlockedTimeInMinutes` como tempo bloqueado por State.
- Não criar dependência circular em `State`/`OrdemState`.
- Não usar números fixos do protótipo.
- Validar PBIR/TMDL estaticamente e renderização/dados no Desktop separadamente.

## Review Focus

- Aging no State atual versus idade total: o gráfico deve usar `StateChangeDate`, enquanto a tabela mantém idade desde `CreatedDate`.
- Cauda de aging: a faixa `>60` não pode ser absorvida por `>30`; tooltips devem expor média, mediana, máximo e quantidade acima de 60.
- Incidência de bloqueio: percentual deve usar bloqueadas / abertas no mesmo State e permanecer uma fotografia atual.
- Motivo de bloqueio ausente: deve aparecer explicitamente, sem misturar bloqueios técnicos.
- Campos ocultos da tabela: `WorkItemId` e `DependencyType` devem ser expostos sem alterar a origem.

### Task 1: Medidas e campos do modelo

- Modify: `Acompanhamento_Sales_Team/acompanhamento-sales-team.SemanticModel/definition/tables/_Medidas.tmdl`
- Modify: `Acompanhamento_Sales_Team/acompanhamento-sales-team.SemanticModel/definition/tables/Proposals.tmdl`
- Add measures for work-in-progress States, current-State age bands (`0–7`, `8–15`, `16–30`, `31–60`, `>60`), average, maximum, `>60` count and blocked percentage.
- Expose only `WorkItemId` and `DependencyType` required by the operational table.
- Validate measure names, referenced columns, duplicate names, TMDL structure and unchanged partitions.

### Task 2: Second PBIR page and layout

- Modify: `...Report/definition/pages/pages.json`
- Create: second page directory and `page.json` with a stable new ID.
- Create native visuals for five KPIs, four charts and the operational table; reuse the registered background resource only if it does not introduce fake values.
- Add slicers/quick filters for supported dimensions and avoid a period slicer by default.

### Task 3: Static validation and Desktop validation

- Parse all JSON files and run `git diff --check`.
- Verify page/visual IDs, entity and measure references, no PBIR changes on page 1, and no connection/partition edits.
- Reopen PBIP in Desktop, test real WorkItemIds, filters, tooltips, Fit to page and empty/blank states.

