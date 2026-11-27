# Correção Carteira V2.2 — remover filtro quebrado

Base: arquivo action_table/visual.json do pacote V2.1.

1. Faça backup/commit. Feche o Power BI Desktop.
2. Extraia na raiz de PBI_AMS e substitua o arquivo visual.json da tabela. Nenhum script necessário.
3. Abra o PBIP. A tabela deve carregar sem o filtro quebrado. Neste momento ela NÃO está validada como carteira aberta e os filtros rápidos não restringem suas linhas.
4. Selecione a tabela. Na tabela de dados FiltroRapidoCarteira, localize a medida CG Exibir proposta na tabela. Arraste-a para Filtros neste visual (não para as colunas da tabela).
5. Configure o filtro numérico para mostrar itens quando o valor é igual a 1 e aplique.
6. Confira Todas, Bloqueio externo, Bloqueio interno, Atrasadas, Sem avanço e Vencimento próximo. A tabela deve responder às opções. Confirme que Closed não aparece.
7. Salve o PBIP pelo Desktop para serializar o filtro e faça commit/push.

A única alteração no JSON é a retirada de filterConfig. Não modifica o modelo semântico, as medidas, os outros visuais ou o fundo. Não requer o script da V2.1 porque usa a medida CG diretamente na interface.

Validação: JSON parseado, estrutura dos campos preservada, ZIP íntegro. Não executado no Power BI Desktop. Se a tabela continuar com erro antes de adicionar o filtro, não prossiga; verifique detalhes técnicos e campos disponíveis.
