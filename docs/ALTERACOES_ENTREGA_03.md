# ALTERAÇÕES — Entrega 03

Base PBIR verificada no GitHub: commit `5d47d273ddaa91d28d0ba3be9502e864a969a9c3` (26/11/2026). Medidas locais devem ser da Entrega 02.

| Operação | Caminho relativo à raiz `PBI_AMS` | Finalidade |
|---|---|---|
| SUBSTITUIR | `Acompanhamento_Sales_Team/acompanhamento-sales-team.Report/definition/report.json` | Registrar o recurso PNG sem perder o tema existente |
| SUBSTITUIR | `Acompanhamento_Sales_Team/acompanhamento-sales-team.Report/definition/pages/046b26eedf429928de17/page.json` | Título da página e plano de fundo |
| CRIAR | `Acompanhamento_Sales_Team/acompanhamento-sales-team.Report/StaticResources/RegisteredResources/ams_visao_geral_layout202611260901.png` | Layout visual |
| CRIAR | `Acompanhamento_Sales_Team/acompanhamento-sales-team.Report/definition/pages/046b26eedf429928de17/visuals/06e54475b84fe2f16fbb/visual.json` | KPI Solicitações recebidas |
| CRIAR | `.../visuals/e8dc47e831aa15b31895/visual.json` | KPI Propostas submetidas |
| CRIAR | `.../visuals/7766a0c9cbf87c3f382e/visual.json` | KPI Propostas aceitas |
| CRIAR | `.../visuals/e1c4faf33a04b1b78cbe/visual.json` | KPI Propostas recusadas |
| CRIAR | `.../visuals/eb34401019c0ce012163/visual.json` | KPI Taxa de aceite |

**Excluir: nenhum arquivo.**

**Não modifica:** `_Medidas.tmdl`, `Calendario.tmdl`, relacionamentos, Dataflow, tabelas, PBIP, outros relatórios ou a referência ao tema Fluent2.

**Atenção:** essa atualização está baseada no relatório ainda vazio da `main`. Caso você já tenha criado visuais localmente na mesma página, avalie se prefere removê-los para não sobrepor o fundo/novos KPIs.
