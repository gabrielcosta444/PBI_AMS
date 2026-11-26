# Entrega 01 — Medidas DAX da Visão Geral

**Repositório:** `gabrielcosta444/PBI_AMS`  
**Branch e commit de base:** `main` / `5425e541bf94114bb92ec6d8cc26f7ca350bbc1e` (26/11/2026).  
**Arquivos substituídos:** apenas `_Medidas.tmdl`.  
**Arquivos excluídos:** nenhum.  
**Modelo/relacionamentos alterados:** nenhum.

## Como instalar

1. Faça commit ou backup do estado atual e confirme que não há alterações locais conflitantes. O ZIP é baseado no commit acima.
2. **Feche o Power BI Desktop** antes de substituir arquivos TMDL.
3. Abra no Windows a **pasta raiz do repositório `PBI_AMS`** (onde existe `Acompanhamento_Sales_Team`).
4. Extraia **o conteúdo deste ZIP nessa pasta raiz**, mantendo a estrutura de diretórios.
5. Quando o Windows perguntar, escolha **Substituir o arquivo no destino**. Não exclua nada manualmente.
6. O destino exato do arquivo alterado será:

   `Acompanhamento_Sales_Team/acompanhamento-sales-team.SemanticModel/definition/tables/_Medidas.tmdl`

7. No VS Code, confira o diff. Abra `Acompanhamento_Sales_Team/acompanhamento-sales-team.pbip` no Power BI Desktop e valide as medidas.
8. Se aprovado, faça commit e push para continuarmos a partir do repositório atualizado.

## Medidas incluídas (8)

| Medida | Definição |
| --- | --- |
| Solicitações recebidas | Propostas criadas no período por `CreatedDate` |
| Propostas submetidas | Propostas cuja **primeira** entrada no State `Approval` ocorreu no período, usando `ProposalStateHistory[DataEntrada]` |
| Propostas aceitas | `State = Closed`, `Discarded = FALSE`, na data `ClosedDate` |
| Propostas recusadas | `State = Closed`, `Discarded = TRUE`, na data `ClosedDate` |
| Decisões comerciais | Aceitas + recusadas |
| Taxa de aceite | Aceitas / (aceitas + recusadas); em branco se não houver decisões |
| Validação - fechadas sem classificação | Propostas Closed com `Discarded` vazio, independentemente do período |
| Validação - fechadas sem data | Propostas Closed com `ClosedDate` vazio, independentemente do período |

## Pendência de regra de negócio — importante

**Ainda NÃO foram excluídas propostas administrativas (duplicadas, criadas por engano etc.)** dos indicadores. Precisamos identificar os valores **reais** de `ReasonforDiscarded` e a regra acordada com a equipe antes de excluí-los. Os dados da empresa e esses valores não aparecem nos metadados do GitHub; não seria seguro inventar uma lista.

Portanto, os indicadores devem ser considerados **provisórios e não prontos para publicação** até essa definição, especialmente recusas, recebidas e taxa de aceite.

## Checklist de validação no Power BI Desktop

- [ ] PBIP abre sem erro e tabela `_Medidas` contém 8 medidas.
- [ ] Cinco medidas principais calculam sem erros; a taxa pode ficar em branco se não houver decisões.
- [ ] Uma proposta **criada em setembro e encerrada em novembro** conta em recebidas de setembro e em aceitas/recusadas de novembro — não precisa ser a mesma proposta do exemplo, use um caso real equivalente.
- [ ] Uma proposta criada em um mês e submetida a `Approval` em outro aparece apenas no mês da **primeira** submissão, mesmo com reentradas posteriores.
- [ ] Filtros por responsável, cliente, torre comercial `ProjectWorkTypes` e tipo de projeto afetam os indicadores conforme o esperado.
- [ ] Examine os resultados das duas medidas de validação. Se alguma for diferente de zero, investigue os casos antes da publicação.
- [ ] Não use um slicer de `State` na primeira página; ele poderia distorcer indicadores de eventos históricos.

## Observações técnicas

- A relação ativa `Calendario.Date → Proposals.CreatedDate` continua a definir **recebidas**.
- Em **aceitas/recusadas**, `CROSSFILTER(..., NONE)` desativa a relação de criação apenas durante o cálculo e `USERELATIONSHIP` utiliza a relação inativa com `ClosedDate`.
- Para **submetidas**, `SUMMARIZE` e `MIN(DataEntrada)` identificam a primeira entrada em `Approval` por proposta; a data selecionada é comparada ao calendário com a parte inteira do datetime (`INT`).
- Não tivemos acesso à execução do seu Power BI Desktop e nem aos dados privados do Dataflow nesta etapa. Os testes feitos aqui são estruturais, não validação de DAX com o motor Tabular.

## Recuperação se houver erro

Feche o Power BI Desktop. Reverta apenas o arquivo `_Medidas.tmdl` no Git ou restaure o backup. Envie a mensagem exata do erro para corrigirmos pontualmente.
