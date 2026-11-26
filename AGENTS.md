# PBI_AMS — instruções permanentes para agentes de código

> Leia `docs/PLANO_DE_EXECUCAO.md` antes de modificar qualquer arquivo. Este repositório contém um projeto Power BI Project (PBIP) com modelo TMDL e relatório PBIR. Trabalhe incrementalmente.

## Estado de referência (26/11/2026)

- Repositório: `gabrielcosta444/PBI_AMS`; commit de referência observado: `659fc44bc34d3128124632798106b6be4be21047` (Entrega 04). **Confira `git status`, `git log -1` e o HEAD local; não suponha que este SHA continue sendo o último.**
- Arquivo de entrada: `Acompanhamento_Sales_Team/acompanhamento-sales-team.pbip`.
- Modelo: `Acompanhamento_Sales_Team/acompanhamento-sales-team.SemanticModel/definition/` (TMDL).
- Páginas: `Acompanhamento_Sales_Team/acompanhamento-sales-team.Report/definition/pages/` (PBIR).
- A primeira página, **Visão Geral e Resultados**, existe e possui cinco cartões KPI e quatro gráficos nativos do Power BI, além do fundo minimalista; os filtros da barra lateral ainda são decorativos.
- `SemanticModel/definition/tables/_Medidas.tmdl` possui aproximadamente 15 medidas DAX, incluindo as comerciais e auxiliares de gráficos. No Power BI Desktop, a sincronização das medidas já foi recuperada **fechando e reabrindo o PBIP**; não reimplemente nem sobrescreva medidas desnecessariamente.
- Os dados vêm de um **Dataflow Gen1 v5.3** já funcional; não substitua por consultas diretas ao DevOps nem refaça conexões, M ou credenciais sem uma necessidade identificada e autorização.

## Regras de colaboração e segurança

1. **Na primeira execução:** examine `git status`, histórico recente, arquivos TMDL/PBIR existentes, nomes das medidas, relações e página atual. Relate o diagnóstico resumidamente. Identifique alterações locais antes de editar; nunca sobrescreva trabalho não commitado.
2. **Faça apenas uma etapa por vez**, conforme `docs/PLANO_DE_EXECUCAO.md`. A primeira é a **Etapa 05 (filtros funcionais da Visão Geral)**. Não comece páginas 2 e 3 na mesma alteração.
3. Preserve todos os visuais e medidas existentes, a nomenclatura de objetos, os IDs PBIR, `lineageTag`, referências de recursos, relatórios e partições M. Ao adicionar visual, gere ID novo e estável; não reutilize IDs.
4. Evite alterações estruturais desnecessárias. Para grandes edições TMDL/PBIR, solicite que o usuário **feche o Power BI Desktop** antes de editar. Nunca salve a versão antiga pelo Desktop durante alterações externas. Depois, o usuário reabre o PBIP e valida.
5. **Não recrie o Dataflow. Não limpe o cache `.pbi` de forma destrutiva, não toque em `cache.abf` nem publique dados ou credenciais.** O GitHub é público no estado observado; não adicione prints corporativos, dados pessoais, exports, credenciais, IDs sensíveis novos ou arquivos de cache ao Git sem conferir a política da organização.
6. Não alegue que um visual foi testado em Power BI Desktop só porque JSON é válido. Diferencie claramente: validação estática da estrutura PBIR/TMDL, validação do cálculo DAX e validação de renderização/dados reais no Desktop.
7. Antes de avançar, informe os arquivos adicionados/alterados/excluídos, o comportamento esperado, limitações e os **passos exatos de validação no Power BI Desktop**. Não faça push automático sem autorização.
8. Se uma suposição de negócio for ambígua, examine a origem e escolha a interpretação mais conservadora, documentando-a; solicite confirmação apenas se a decisão afetar materialmente o indicador.

## Modelo e regras de negócio que NÃO podem se perder

**Seis tabelas do Dataflow:** `Proposals`, `ProposalStateHistory`, `TechnicalWorkItems`, `ProposalTechnicalLinks`, `ProposalDependencyTypes`, `CardFields`. Outras tabelas no modelo: `Calendario` e `_Medidas`.

- Datas: `Calendario[Date]` -> `Proposals[CreatedDate]` ativo; -> `Proposals[ClosedDate]` inativo; -> `ProposalStateHistory[DataEntrada]` inativo. As medidas por **evento** precisam tratar explicitamente a data de evento e neutralizar o filtro da data de criação quando necessário. Datas são `dateTime`, relações usam `joinOnDateBehavior: datePartOnly`.
- **Solicitações recebidas:** contagem por criação, excluindo `ReasonforDiscarded` em `Duplicate Proposal` ou `Incorrect Demand Creation`.
- **Propostas submetidas:** primeira entrada histórica no State `Approval`, por data dessa entrada (não usar simplesmente `ApprovalDate`).
- **Propostas aceitas:** `Closed` + `Discarded = FALSE`, por `ClosedDate`.
- **Propostas recusadas:** `Closed` + `Discarded = TRUE`, por `ClosedDate`, excluindo `Duplicate Proposal`, `Incorrect Demand Creation` e `Transferred to Support Team`. Demais motivos como `Customer - ...`, `AMS Refusal - ...` e `Work No Longer Needed` são recusas, conforme classificação acordada; revisar com a equipe se a regra mudar.
- **Taxa de aceite:** aceitas / (aceitas + recusadas). **Não** usar submetidas como denominador.
- **Carteira atual:** propostas abertas agora (não `Closed`), excluindo solicitações administrativas inválidas; é uma foto do estado atual, **não deve variar com o filtro de período**. Respeitar responsável, cliente, torre e projeto, conforme os filtros permitirem.
- `Proposals[ProjectWorkTypes]`: torre **associada comercialmente** à Proposal. `TechnicalWorkItems[AreaPath]`: área da **torre técnica proprietária** do card. Não misture essas dimensões.
- Relacionamento de cartas técnicas: `Proposals[WorkItemId]` -> `ProposalTechnicalLinks[ProposalId]` <- `TechnicalWorkItems[WorkItemId]` por `ProposalTechnicalLinks[TechnicalWorkItemId]`. Relacionamento N:N mediado pela ponte; usar `DISTINCTCOUNT` e tratamentos explícitos de contexto, evitando duplicação.
- Os cards técnicos extraídos representam **somente aqueles vinculados às Proposals coletadas**; não representam automaticamente toda a carteira técnica da empresa.
- **Não** fazer `sortByColumn` em `Proposals[State]` apontando para uma coluna calculada `OrdemState` que depende de `State`: isso já causou dependência circular e impediu abertura do projeto. Para ordem do funil, use dimensão separada/ordenação segura após validar.

## Identidade visual aprovada

- Referência: relatórios AMS antigos: **barra lateral cinza-escura**, nome ArcelorMittal / Sales Team, **cabeçalho com gradiente laranja → magenta → roxo**, cartões brancos com borda leve, acentos roxos, tipografia legível e poucos elementos.
- Preferência expressa: **menos poluição visual**. Sem rankings e donuts redundantes, sem números fictícios, sem texto auxiliar excessivo e sem repetir o mesmo gráfico em duas páginas.
- Página 1 tem imagem de fundo registrada (`ams_visao_geral_layout202611260901.png`) com espaços reservados para gráficos. **Preservar e adaptar a arquitetura atual**, em vez de redesenhar tudo. Todo KPI/gráfico deve ser visual nativo com dados, não texto/números impressos na imagem.
- Base atual da página: **1920 × 1080**. Verificar coordenadas dos visuais e testar sem sobreposições, inclusive em `FitToPage`.

## Objetivo imediato do próximo agente

**Etapa 05 — filtros funcionais da Visão Geral**. Leia a especificação em `docs/PLANO_DE_EXECUCAO.md`, audite o PBIR atual e implemente apenas a etapa 05. Ao terminar, forneça lista de arquivos e checklist de testes. Aguarde validação do usuário antes de iniciar a etapa 06.
