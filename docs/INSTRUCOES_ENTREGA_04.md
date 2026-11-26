# Entrega 04 — Quatro gráficos nativos da página Visão Geral

## Base conferida

- Repositório: https://github.com/gabrielcosta444/PBI_AMS
- Branch `main`, commit base `7ec906d072` (`feat (visão geral): entrega 3 - cartões kpi`).
- Preserva **os cinco cartões KPI existentes**, todos os dados, TMDL, tabelas, relacionamentos e medidas DAX.
- Requer Entregas 01.1, 02 e 03 aplicadas. A estrutura da Entrega 03 foi conferida no GitHub.

## Instalação segura

1. Feche o Power BI Desktop e salve seu trabalho.
2. No VS Code, confira se não existem mudanças locais importantes. Faça commit ou backup.
3. Extraia este ZIP na **raiz da pasta do repositório `PBI_AMS`**, mantendo a estrutura `Acompanhamento_Sales_Team/...`.
4. Confirme **substituição apenas do arquivo PNG** descrito no `ALTERACOES_ENTREGA_04.md`. Os quatro arquivos `visual.json` são novos e devem ser criados nos diretórios indicados.
5. NÃO exclua pastas, nem substitua `_Medidas.tmdl`, `report.json`, `page.json` ou os cinco visuais KPI.
6. Abra `Acompanhamento_Sales_Team/acompanhamento-sales-team.pbip` no Desktop.
7. Confira a página **Visão Geral e Resultados**, os cinco cartões preservados e os quatro novos gráficos.
8. Se tudo estiver funcionando, salve no Desktop, faça commit e push para o GitHub.

## Gráficos e vínculos

1. **Carteira atual por State**: `Proposals[State]` + `[_Medidas].[Carteira atual]`; tooltip `Carteira atual (% por State)`; barras horizontais, ordenadas por quantidade decrescente.
2. **Evolução mensal**: `Calendario[AnoMes]` + `Solicitações recebidas`, `Propostas submetidas` (colunas), `Propostas aceitas` (linha). Ordenada por AnoMes crescente (AnoMes tem sortByColumn no modelo).
3. **Resultados por responsável**: `Proposals[AssignedToUserName]` + `Propostas aceitas` e `Propostas recusadas`; barras horizontais empilhadas, ordenadas por aceites; tooltip Taxa de recusa.
4. **Motivos de recusa**: `Proposals[ReasonforDiscarded]` + `Recusas com motivo informado`; barras horizontais, ordenadas por frequência comercial.

## Checklist de validação

- **Estrutura**: os quatro visuais aparecem sem mensagem de erro ou campo desconhecido.
- **Carteira**: `Closed` não aparece com valor positivo; o total corresponde a `Carteira atual`; depois, ao adicionar um slicer de Período na Entrega 05, seu total deve ficar inalterado.
- **Mensal**: o eixo é cronológico; uma proposta criada em um mês e fechada no outro deve contabilizar os respectivos eventos em cada mês.
- **Responsável**: aparecem duas séries separadas, aceitas e recusadas, e nenhuma barra usa propostas submetidas como se fossem decisões.
- **Recusas**: `Duplicate Proposal`, `Incorrect Demand Creation` e `Transferred to Support Team` não devem ter contagem positiva. Se esses itens aparecerem com zero, podemos aplicar um filtro visual na próxima revisão.
- **Identidade**: os quatro espaços anteriores não exibem mais ícones placeholders. Os cinco cartões KPI permanecem no topo.

## Limitações conscientes

- Os cinco itens de filtro na barra lateral ainda são **decorativos**. Os segmentadores serão implementados na Entrega 05.
- A visualização de `State` está ordenada pelo volume, não pela sequência do funil; ordenar pelo `OrdemState` calculado dentro da mesma tabela já causou dependência circular no passado. A ordenação de negócio poderá ser corrigida com uma dimensão `DimState`, sem reintroduzir o ciclo.
- O ranking por responsável pode exibir rolagem se houver muitas pessoas. Top N pode ser acrescentado depois da validação dos visuais reais.
- O indicador `Carteira atual` respeita os outros filtros, mas ignora calendário por definição; não é um retrato histórico na data selecionada.
- Valores e motivos dependem da atualização do Dataflow e do modelo; nenhuma barra contém números fictícios no PBIR.
- Abertura/renderização e resultado DAX precisam ser validados no Power BI Desktop; este ambiente não executa o Desktop.

## Recuperação caso algo falhe

Feche o Desktop, recupere o PNG anterior e apague **somente os quatro novos diretórios `visuals/<id>` listados no changelog**. Os cinco cartões KPI e o modelo semântico não são alterados por esta entrega.
