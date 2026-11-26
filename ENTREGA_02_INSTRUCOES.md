# Entrega 02 — Medidas dos quatro gráficos da Visão Geral

## Base da entrega

- Repositório: https://github.com/gabrielcosta444/PBI_AMS
- Código do modelo consultado no GitHub: commit `5425e541bf94114bb92ec6d8cc26f7ca350bbc1e`.
- **Arquivo `_Medidas.tmdl` usado como base: Entrega 01.1 (correção dos motivos de descarte), pois o GitHub ainda não contém essas medidas.**
- SHA-256 do arquivo `_Medidas.tmdl` da Entrega 01.1: `7f5339624ce388174c120fd11f62f513a38a7f212871527c09879643ce280f6f`.
- SHA-256 do arquivo atualizado: `9b48f8d79d21e93fd700e0d869ca4df10169eb9908829704b4bb9d79ce594438`.

## Instalação

1. Faça um commit/backup das alterações locais existentes.
2. Confirme que a **Entrega 01.1** foi aplicada e carregou no Power BI. Se você editou suas medidas manualmente depois, faça backup e compare os arquivos antes de substituir.
3. Salve e **feche o Power BI Desktop**.
4. Extraia este ZIP **na raiz do repositório `PBI_AMS`** (onde já está a pasta `Acompanhamento_Sales_Team`).
5. Confirme a mesclagem de pastas e **substituição somente de `_Medidas.tmdl`**.
6. Abra `Acompanhamento_Sales_Team/acompanhamento-sales-team.pbip` no Power BI Desktop.
7. Em `_Medidas`, confira a subpasta `Visão Geral/Gráficos` e as cinco novas medidas. Verifique também que todas as medidas da Entrega 01.1 foram preservadas.
8. Valide os cálculos com os dados reais, faça commit e push.

## Operações nos arquivos

| Ação | Caminho relativo à raiz de `PBI_AMS` |
|---|---|
| Substituir | `Acompanhamento_Sales_Team/acompanhamento-sales-team.SemanticModel/definition/tables/_Medidas.tmdl` |
| Criar no projeto | Nenhum |
| Excluir | Nenhum |

O `ENTREGA_02_INSTRUCOES.md` e `ALTERACOES.md` do ZIP são apenas documentos explicativos; não precisam ser colocados no projeto.

## Quatro visuais e como configurá-los depois (Entrega 04)

| Visual | Eixo/Categoria | Valores | Opcional |
|---|---|---|---|
| Carteira atual por State | `Proposals[State]` | `[Carteira atual]` | Tooltip `[Carteira atual (% por State)]`; exclua o State Closed e Estados vazios |
| Evolução mensal | `Calendario[AnoMes]` | `[Solicitações recebidas]`, `[Propostas submetidas]`, `[Propostas aceitas]` | Ordenar AnoMes pelo AnoMesOrdem já configurado no modelo |
| Resultados por responsável | `Proposals[AssignedToUserName]` | `[Propostas aceitas]`, `[Propostas recusadas]` | Tooltip `[Taxa de aceite]`, `[Taxa de recusa]` |
| Motivos de recusa | `Proposals[ReasonforDiscarded]` | `[Recusas com motivo informado]` | Ordenar por quantidade desc.; Top N opcional |

## Como as novas medidas funcionam

- **Carteira atual:** conta propostas com State diferente de `Closed` e nao vazio (inclusive outros States abertos, como `Release`), exclui `Duplicate Proposal` e `Incorrect Demand Creation`, ignora apenas `Calendario` (período de criação), mas respeita responsável, cliente, torre técnica e o contexto de State.
- **Carteira atual (% por State):** divide a carteira no State atual pelo total da carteira nos States nao fechados, ignorando apenas o filtro em `Proposals[State]` no denominador.
- **Taxa de recusa:** recusadas ÷ decisões comerciais; reutiliza as regras da Entrega 01.1.
- **Recusas com motivo informado:** utiliza `Propostas recusadas` e retém somente motivos com texto preenchido.
- **Validação - recusas sem motivo:** quantifica as recusas sem motivo, para verificar perdas no gráfico de motivos.

## Testes rápidos sugeridos

1. Monte uma tabela provisória com `Proposals[State]` e `[Carteira atual]`. Os States diferentes de Closed e nao vazios podem ter contagens (incluindo Release, se existir).
2. Troque o período em um slicer de `Calendario[Date]`: a **Carteira atual** deve permanecer igual, se não houver outros filtros mudando.
3. Filtre um responsável: a Carteira atual deve mudar conforme a carteira dele.
4. Coloque `Calendario[AnoMes]` em uma matriz e as três medidas de evolução mensal. Uma proposta criada no mês A e encerrada no mês B deve contar como recebida em A e aceita/recusada em B, conforme o resultado.
5. Monte uma tabela por `Proposals[AssignedToUserName]` com `[Propostas aceitas]` e `[Propostas recusadas]`.
6. Monte uma tabela por `Proposals[ReasonforDiscarded]` e `[Recusas com motivo informado]`. Não devem ter contagem os motivos `Duplicate Proposal`, `Incorrect Demand Creation` ou `Transferred to Support Team`.
7. Verifique `[Validação - recusas sem motivo]`. Se não for zero, parte das recusas não aparecerá no gráfico por motivo; isso é um problema de preenchimento dos dados.
8. Confira se os cinco indicadores da Entrega 01.1 continuam funcionando.

## Pontos importantes

- **State adicional observado:** uma exportacao historica contem `Release` alem dos seis States da lista do funil. A carteira conta qualquer State diferente de `Closed`; confirme o significado de `Release` antes de decidir como representa-lo no visual.
- **Ordenação de States:** a coluna `Proposals[OrdemState]` existe, mas não configure `Proposals[State]` para ordenar por ela. Isso gerou uma dependência circular anteriormente. Podemos criar uma dimensão de State independente em uma futura etapa de layout, se necessário.
- **Responsável:** os resultados refletem `AssignedToUserName` **atual** da proposta, não necessariamente quem era responsável na data da submissão ou do encerramento.
- **Histórico mensal:** reutiliza `[Propostas submetidas]` da Entrega 01.1, que determina a primeira entrada em `Approval`; não utiliza a `ApprovalDate` diretamente.
- **Período:** o visual de carteira é uma fotografia atual. Os três indicadores de evolução mensal respeitam suas respectivas datas de evento e filtros do calendário.
- **Submissões administrativas:** a regra de exclusão de duplicidades e criações incorretas está aplicada a **recebidas** e **recusadas** na Entrega 01.1, mas não foi adicionada à medida de submissões. Mantida como definida para não mudar decisões anteriores nesta entrega.
- Os testes executados aqui são estáticos (arquivos e integridade do ZIP); a validação DAX em execução deve ocorrer no Power BI Desktop.
