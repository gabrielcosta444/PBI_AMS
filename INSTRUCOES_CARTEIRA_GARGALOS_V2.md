# Atualização de UI — Carteira e Gargalos (versão 2)

**Base do GitHub:** `3bc5d35b4b18907fd2d8cf1ec203b3e87ca33e56` (`fix2: etapa 8`).

## Instalação (Windows)

1. Faça commit ou cópia de segurança do projeto inteiro e feche o Power BI Desktop.
2. Extraia este ZIP **na raiz `PBI_AMS/`** (a pasta que contém `Acompanhamento_Sales_Team/`).
3. Confirme **mesclar pastas / substituir arquivos com o mesmo caminho**.
4. Não remova nenhuma pasta ou visual; o pacote faz apenas substituições.
5. Abra `Acompanhamento_Sales_Team/acompanhamento-sales-team.pbip`.
6. Aguarde a atualização do modelo semântico. Se aparecerem campos ausentes em uma primeira abertura, feche **sem salvar sobre o modelo antigo** e reabra para sincronizar os arquivos TMDL.
7. Valide a página Carteira e Gargalos; depois salve e faça commit/push.

## Escopo

- Identidade visual baseada na página anterior e no fundo do `.pbix` antigo fornecido pelo usuário.
- Os 4 gráficos mantêm **2 colunas × 2 linhas**, com fontes, cores e barras mais legíveis.
- 5 KPIs com área útil maior e 32pt para minimizar corte de números.
- Indicador de **atraso** limita-se aos States New, Next, Triage, Planning e Build. O KPI de andamento continua excluindo New, como na regra já aprovada, e mantém a medida original.
- Indicador de **sem avanço** usa `StateChangeDate`, e não `ChangedDate`, nos mesmos States.
- Gráfico `Bloqueios por State` apresenta **quantidade**, com **2 botões Interno/Externo**.
- O gráfico de tipos de dependência é ordenado pela soma das ocorrências internas e externas (pode contar o mesmo card nas duas séries; é ranking, não total distinto).
- 6 botões rápidos usam o **Button slicer** (`advancedSlicerVisual`) e uma medida DAX numérica para o *Highlight label*.
- A medida de filtro da tabela foi substituída por `FiltroRapidoCarteira[CG Exibir proposta na tabela]`.
- 6 segmentações laterais reajustadas e seus cabeçalhos internos ocultados.
- Nenhum visual da página Visão Geral foi modificado.

## Checagens importantes no Power BI Desktop

- **Botões:** todas as 6 opções visíveis em uma linha, uma seleção por vez, valor numérico em cada opção; selecione cada botão e confirme que somente a tabela muda.
- **Interno/Externo:** ambas as opções visíveis; ao alternar, as quantidades nas barras mudam. O modo padrão é Interno.
- **Atraso:** o total não inclui Approval nem Closed.
- **Sem avanço:** verificar manualmente um item com `StateChangeDate` há >15 dias e State pré-Approval.
- **Dependências:** as duas séries (interno/externo) devem respeitar a mesma ordenação decrescente por soma; se o PBI ignorar `sortDefinition`, usar o menu do visual para ordenar por `CG Ocorrências de bloqueio por dependência`.
- **Tabela:** não deve mostrar totais de idade de uma linha; ordene Idade (dias) desc para triagem; a barra de rolagem horizontal é esperada pelas 11 colunas.
- **Sidebar:** os rótulos pertencem ao SVG, mas os dropdowns são reais e devem corresponder à dimensão indicada.

## Limitações honestas

- Os arquivos JSON, SVG e a integridade do ZIP foram testados estaticamente, **mas não foi possível abrir ou renderizar o projeto no Power BI Desktop**.
- A propriedade `Label`/Highlight label do Button slicer e o estado inicial de seleção precisam ser validados na sua versão do Power BI. Caso os números não apareçam, abra o painel **Construir visual** e confira se `CG Contagem do filtro rápido` está em *Highlight label*. Caso nenhum botão esteja selecionado na abertura, clique em **Todas**.
- O pacote parte do commit acima; se você editou arquivos locais depois desse commit, confira o diff antes de substituir.
- A tabela preserva 11 colunas e requer alguma rolagem horizontal em vez de reduzir as fontes a tamanhos ilegíveis.
