# Entrega 01.1 — Correção dos motivos de descarte

**Projeto:** PBI_AMS / Acompanhamento_Sales_Team  
**Base do GitHub consultada:** `5425e541bf94114bb92ec6d8cc26f7ca350bbc1e` (branch `main`).  
**Base de medidas:** arquivo da Entrega 01 entregue previamente nesta conversa, que ainda não estava no GitHub no momento desta correção.

## Instalação

1. Garanta que a **Entrega 01** foi aplicada localmente e que as medidas aparecem no Power BI Desktop.
2. Salve o projeto e **feche o Power BI Desktop**.
3. Faça um commit de segurança do estado atual (ou backup da pasta inteira).
4. Extraia este ZIP **na raiz da pasta local `PBI_AMS/`**, preservando os diretórios.
5. Confirme a substituição de **somente**:

   `Acompanhamento_Sales_Team/acompanhamento-sales-team.SemanticModel/definition/tables/_Medidas.tmdl`

6. Reabra `Acompanhamento_Sales_Team/acompanhamento-sales-team.pbip` no Desktop.
7. Confira a tabela `_Medidas`, teste os cartões e faça commit/push após validar.

**Não há exclusões de arquivos.** O pacote NÃO contém o projeto inteiro nem dados da empresa.

## Regras de negócio implementadas

- **Solicitações recebidas:** Proposals criadas no período (`CreatedDate`); exclui motivos `Duplicate Proposal` e `Incorrect Demand Creation`.
- **Propostas recusadas:** `State = Closed`, `Discarded = TRUE`, com `ClosedDate` no período; exclui os dois motivos administrativos e `Transferred to Support Team`.
- **Propostas aceitas:** sem alteração (`Closed`, `Discarded = FALSE`, data de encerramento).
- **Propostas submetidas:** sem alteração (primeira entrada histórica em `Approval`).
- **Taxa de aceite:** medida recalculada automaticamente com as recusas já corrigidas.
- **Demais motivos `AMS Refusal`, `Customer` e `Work No Longer Needed`:** continuam sendo recusas caso o card esteja fechado, descartado e com data.

### Decisão a confirmar com a equipe

`Transferred to Support Team` foi interpretado como encaminhamento operacional, não recusa comercial. Ele **permanece** em Solicitações recebidas, pois a solicitação existiu, mas **não conta** como Propostas recusadas. Se a área comercial considerar transferência como recusa, essa é a única regra a ajustar depois.

## Validações adicionais

Novas medidas de conferência na pasta `Validação`:

- `Validação - solicitações administrativas`: quantidade histórica de IDs classificados como duplicidade ou criação indevida.
- `Validação - transferidas ao suporte`: quantidade histórica de IDs fechados e descartados por transferência ao suporte.

Essas medidas não entram nos cartões finais e ignoram o filtro do calendário. As duas medidas de validação da Entrega 01 foram mantidas.

### Testes recomendados no Desktop

- Crie uma tabela temporária com `Proposals[ReasonforDiscarded]` e a contagem distinta de `WorkItemId` para conferir a grafia e a presença dos dois motivos administrativos.
- Compare `Solicitações recebidas` antes/depois em um período amplo. Ela deve cair somente pelos dois motivos administrativos.
- Compare `Propostas recusadas` antes/depois em um período amplo. Ela deve cair pelos motivos administrativos **e** transferências ao suporte, considerando `ClosedDate` e `Discarded`.
- Confirme que `Propostas aceitas` e `Propostas submetidas` não mudaram devido a este pacote.
- Confira que `Taxa de aceite` passou a refletir somente as recusas classificadas como comerciais.

**Limitação:** não executei o modelo Power BI nem consultei as linhas corporativas do Dataflow. A validação de valores e a leitura da semântica de transferências devem ser feitas no Desktop e com a equipe.

## Resumo dos arquivos

| Operação | Caminho |
|---|---|
| SUBSTITUIR | `Acompanhamento_Sales_Team/acompanhamento-sales-team.SemanticModel/definition/tables/_Medidas.tmdl` |
| EXCLUIR | Nenhum |
| CRIAR | Nenhum arquivo de projeto |

A alteração preserva a tabela, o `lineageTag`, `Placeholder`, a partição e os nomes das medidas existentes.
