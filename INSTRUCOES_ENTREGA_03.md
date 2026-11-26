# Entrega 03 — Primeira página + 5 cartões KPI (Power BI PBIP/PBIR)

## O que foi entregue

- Identidade visual inspirada nos painéis AMS anteriores: faixa de cabeçalho em gradiente laranja–magenta–roxo, barra lateral cinza-escuro, cartões claros e bastante espaçamento.
- Página existente renomeada para **Visão Geral e Resultados** (mantido o ID da página original).
- **5 cartões nativos do Power BI**, cada um vinculado a uma medida da tabela `_Medidas`: Solicitações recebidas, Propostas submetidas, Propostas aceitas, Propostas recusadas e Taxa de aceite.
- 4 espaços reservados para os gráficos da **Entrega 04**: Carteira atual por State, Evolução mensal, Resultados por responsável, Motivos de recusa.

**Nota:** os números dos cartões não estão fixados no desenho. São calculados pelo seu modelo semântico e poderão responder aos filtros, quando adicionados.

## Pré-requisito

A Entrega 01.1 (correção dos motivos de descarte) e a Entrega 02 devem estar aplicadas localmente. As seguintes 5 medidas precisam existir em `_Medidas`. Não alteramos o modelo semântico ou os dados neste pacote.

## Aplicação (Power BI Desktop FECHADO)

1. Faça backup/commit do projeto local.
2. Feche o Power BI Desktop.
3. Extraia o conteúdo deste ZIP **na raiz do seu repositório `PBI_AMS`**, preservando a pasta `Acompanhamento_Sales_Team`.
4. Quando solicitado, **substitua** apenas os arquivos listados em `ALTERACOES_ENTREGA_03.md`.
5. Abra `Acompanhamento_Sales_Team/acompanhamento-sales-team.pbip` no Desktop.
6. Aguarde o carregamento do modelo e confira a página **Visão Geral e Resultados** e os 5 números calculados.
7. Caso tudo funcione, salve no Desktop, faça commit e push.

## O que ainda NÃO é funcional nesta entrega

- Os 4 gráficos ainda são **áreas reservadas**, sem valores reais. Serão incluídos na Entrega 04.
- A barra lateral é **decorativa**: os slicers e botão Limpar filtros só serão implementados na Entrega 05.
- A composição gráfica (textos estáticos, molduras, gradiente e sidebar) está em uma **imagem de fundo**, para reduzir o número de visuais e manter o layout estável. Os 5 cartões numéricos são objetos nativos do Power BI. Na Entrega 04/05, atualizaremos a imagem de fundo para acomodar os gráficos e segmentadores, sem alterar as posições dos KPIs.
- Não há setas de variação mensal ou percentuais comparativos fictícios. Optamos por visual limpo.

## Se os cartões aparecerem com erro

- Verifique se todas as cinco medidas existem na tabela `_Medidas` e correspondem ao nome exato.
- Confira se o `_Medidas.tmdl` da Entrega 02 está aplicado.
- Não tente corrigir salvando múltiplas vezes: feche o Desktop e comunique o texto do erro, preferencialmente com captura de tela.

## Se o background não renderizar

Verifique se o arquivo PNG está em `StaticResources/RegisteredResources/` e se o `report.json` do pacote foi substituído. Os registros do recurso são necessários para exibir o fundo.

## Integridade da entrega

Arquivos JSON foram parseados e referências do recurso e medidas foram verificadas por script; **não houve execução real no Power BI Desktop nesta sessão**.
