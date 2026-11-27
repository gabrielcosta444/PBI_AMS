# Correção opcional automática da medida DAX para os filtros rápidos
# EXECUTAR na RAIZ do repositório PBI_AMS, com Power BI Desktop FECHADO.
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$target = Join-Path $root 'Acompanhamento_Sales_Team\acompanhamento-sales-team.SemanticModel\definition\tables\_Medidas.tmdl'
if (-not (Test-Path -LiteralPath $target)) { throw "Arquivo nao encontrado: $target. Execute na raiz de PBI_AMS." }
$enc = New-Object System.Text.UTF8Encoding($false)
$source = [System.IO.File]::ReadAllText($target, [System.Text.Encoding]::UTF8)
$pattern = "(?ms)^(\tmeasure 'Exibir proposta na tabela' =\r?\n).*?^(\t\tformatString: 0\r?\n)"
$regex = [regex]::new($pattern)
$matches = $regex.Matches($source)
if ($matches.Count -ne 1) { throw "A medida de origem nao foi encontrada unicamente. Nada foi alterado." }
$replacement = '${1}' + "`t`t`t'FiltroRapidoCarteira'[CG Exibir proposta na tabela]`n" + '${2}'
$updated = $regex.Replace($source, $replacement)
if ($updated -eq $source) { Write-Host 'Medida ja atualizada; nada a fazer.'; exit 0 }
$backup = Join-Path $root ('_Medidas.antes-correcao-' + (Get-Date -Format 'yyyyMMdd-HHmmss') + '.tmdl.bak')
[System.IO.File]::Copy($target, $backup, $true)
[System.IO.File]::WriteAllText($target, $updated, $enc)
Write-Host "Medida adaptada. Backup em $backup"
Write-Host "Reabra o projeto PBIP para recarregar o modelo."
