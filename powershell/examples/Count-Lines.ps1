<#
.SYNOPSIS
    Count-Lines.ps1 - Compte les lignes non vides d'un fichier texte.
.DESCRIPTION
    Auteur : contributeurs du repository
    Version : 1.0.0
    Date : 2026-11-06
    Prérequis : PowerShell 7 ou supérieur ; aucun module externe.
.PARAMETER Path
    Chemin du fichier texte à lire en UTF-8.
.EXAMPLE
    ./powershell/examples/Count-Lines.ps1 -Path README.md -Verbose
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string] $Path
)

# La configuration est distincte du chemin fourni au lancement.
$FileEncoding = 'utf8'
$ErrorActionPreference = 'Stop'

function Measure-NonEmptyLine {
    <#
    .SYNOPSIS
        Compte les lignes contenant autre chose que des espaces.
    .DESCRIPTION
        Lit le fichier et renvoie un entier ; les erreurs de lecture sont propagées.
    .PARAMETER Path
        Chemin littéral du fichier texte.
    .PARAMETER Encoding
        Encodage utilisé pour lire le fichier.
    .EXAMPLE
        Measure-NonEmptyLine -Path 'README.md' -Encoding 'utf8'
    #>
    [CmdletBinding()]
    param(
        [string] $Path,
        [string] $Encoding
    )

    $count = 0
    foreach ($line in (Get-Content -LiteralPath $Path -Encoding $Encoding)) {
        if (-not [string]::IsNullOrWhiteSpace($line)) {
            $count++
        }
    }
    return $count
}

function Main {
    <#
    .SYNOPSIS
        Exécute le comptage et signale les erreurs.
    .DESCRIPTION
        Écrit le nombre sur le flux de succès ou quitte avec le code 1.
    .PARAMETER Path
        Chemin du fichier texte.
    .PARAMETER Encoding
        Encodage utilisé pour lire le fichier.
    .EXAMPLE
        Main -Path 'README.md' -Encoding 'utf8'
    #>
    [CmdletBinding()]
    param(
        [string] $Path,
        [string] $Encoding
    )

    try {
        Write-Verbose "Lecture du fichier : $Path"
        $count = Measure-NonEmptyLine -Path $Path -Encoding $Encoding
        Write-Output $count
    }
    catch {
        Write-Error "Impossible de lire ${Path} : $_" -ErrorAction Continue
        exit 1
    }
}

Main -Path $Path -Encoding $FileEncoding
exit 0
