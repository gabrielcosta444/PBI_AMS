# Carteira e Gargalos — hotfix 2.1 (Broken_Filters + exclusao de Closed)

## Diagnóstico
- O erro Broken_Filters aparece especificamente na tabela `action_table`, onde a V2 trocou o filtro da medida `_Medidas[Exibir proposta na tabela]` (usada na versao anterior, que funcionava) por `FiltroRapidoCarteira[CG Exibir proposta na tabela]`.
- A nova medida EXISTE no TMDL: a evidencia indica uma incompatibilidade ou dessincronizacao do filtro de visual PBIR, e nao comprova coluna apagada. Esta correcao reverte o FILTRO PBIR para o caminho anterior.
- Os dois graficos `aging_state` e `block_incidence_state` estavam sem restricao explicita do eixo State, por isso apareciam `Closed` e `(Em branco)`.

## Arquivos alterados
1. `Acompanhamento_Sales_Team/acompanhamento-sales-team.Report/definition/pages/c7f3b2a1e4d948d6b109/visuals/action_table/visual.json` — restabelece filtro de visual `_Medidas[Exibir proposta na tabela] = 1`.
2. `.../visuals/aging_state/visual.json` — filtra State para New, Next, Triage, Planning, Build, Approval.
3. `.../visuals/block_incidence_state/visual.json` — mesma restricao por State.

## Etapa obrigatoria adicional para os seis botoes
A medida antiga `_Medidas[Exibir proposta na tabela]` precisa encaminhar a avaliacao para a nova medida implementada na V2. **Sem isso, a tabela pode carregar, mas a opcao "Sem avanço" nao usara o calculo correto.**

Com Power BI FECHADO, depois de extrair o ZIP na raiz `PBI_AMS`, execute no terminal PowerShell a partir da raiz:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\APLICAR_AJUSTE_MEDIDA.ps1
```

O script apenas substitui a expressao da medida DAX **Exibir proposta na tabela** no arquivo `_Medidas.tmdl`, mantendo o restante intacto. Faz backup `_Medidas.antes-correcao-....tmdl.bak` na raiz do repositorio. Leia o script antes de executar.

**Alternativa SEM executar script:** abra o Power BI Desktop depois de extrair os 3 JSON, localize a medida `_Medidas[Exibir proposta na tabela]` e substitua sua formula DAX por:

```dax
Exibir proposta na tabela =
    'FiltroRapidoCarteira'[CG Exibir proposta na tabela]
```

Salve o projeto e, se alterar externamente, feche/reabra o Desktop para sincronizar. Nao execute a alternativa manual e o script simultaneamente.

## Como instalar
1. Feche o Power BI Desktop; salve um commit/backup.
2. Extraia este ZIP na **raiz de PBI_AMS**; substitua apenas os 3 `visual.json` (nenhuma outra pagina).
3. Execute o script para adaptar a medida, OU altere a formula manualmente (ver acima).
4. Reabra `Acompanhamento_Sales_Team/acompanhamento-sales-team.pbip`.
5. Verifique se a tabela exibe linhas, se os filtros Todas/Bloqueio externo/Bloqueio interno/Atrasadas/Sem avanço/Vencimento próximo mudam as linhas e se os graficos nao exibem Closed nem `(Em branco)`.
6. Se o erro Broken_Filters permanecer, em vez de salvar o visual com erro, remova somente o filtro de nivel visual da medida no painel de Filtros e reaplique `_Medidas[Exibir proposta na tabela]` igual a 1 pelo Desktop (que gera metadados validos para sua versao do PBI). Envie os novos detalhes.

## Escopo e limites
- Nao muda dataflow, dados, relacionamentos, outros visuais, nem o layout.
- Mantem Approval, exclui Closed e nulos; quaisquer STATES inesperados fora do fluxo principal tambem sao excluidos dos dois graficos. Se houver State adicional de trabalho operacional relevante, ampliar a lista depois de confirmar seu significado.
- Arquivos JSON e integridade ZIP foram checados estaticamente; so o Desktop pode confirmar que o erro foi resolvido.
- GitHub de referencia: ultimo commit conhecido antes da V2 `3bc5d35b4b18907fd2d8cf1ec203b3e87ca33e56`, a V2 foi aplicada localmente. Requer V2 previamente instalada.
