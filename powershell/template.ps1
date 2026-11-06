<#
.SYNOPSIS
    <ScriptName> - <Description>
.DESCRIPTION
    Auteur : <Author>
    Version : <Version>
    Date : <Date>
    Prérequis : PowerShell 7 ou supérieur ; aucun module externe.
.PARAMETER Name
    Nom de la personne à saluer.
.EXAMPLE
    ./template.ps1 -Name "Camille" -Verbose
#>
[CmdletBinding()]
param(
    [string] $Name = 'monde'
)

# Configuration regroupée : la distinguer des valeurs calculées dans les fonctions.
$GreetingPrefix = 'Bonjour'

# Stop transforme les erreurs non terminantes en exceptions interceptables.
$ErrorActionPreference = 'Stop'

function New-Greeting {
    <#
    .SYNOPSIS
        Construit un message de bienvenue.
    .DESCRIPTION
        Normalise le nom et refuse une valeur vide.
    .PARAMETER Name
        Nom non vide de la personne à saluer.
    .PARAMETER Prefix
        Texte placé avant le nom.
    .EXAMPLE
        New-Greeting -Name 'Camille' -Prefix 'Bonjour'
    #>
    [CmdletBinding()]
    param(
        [AllowEmptyString()]
        [string] $Name,

        [string] $Prefix
    )

    $normalizedName = $Name.Trim()
    if ([string]::IsNullOrWhiteSpace($normalizedName)) {
        throw 'Le nom ne doit pas être vide.'
    }

    return "${Prefix}, ${normalizedName} !"
}

function Main {
    <#
    .SYNOPSIS
        Exécute le traitement principal du script.
    .DESCRIPTION
        Construit le résultat et signale les erreurs avant de quitter.
    .PARAMETER Name
        Nom de la personne à saluer.
    .PARAMETER Prefix
        Texte placé avant le nom.
    .EXAMPLE
        Main -Name 'Camille' -Prefix 'Bonjour'
    #>
    [CmdletBinding()]
    param(
        [AllowEmptyString()]
        [string] $Name,

        [string] $Prefix
    )

    try {
        Write-Verbose 'Construction du message de bienvenue.'
        $greeting = New-Greeting -Name $Name -Prefix $Prefix
        # Le résultat reste sur le flux de succès, distinct des diagnostics.
        Write-Output $greeting
    }
    catch {
        # Continue évite que la préférence Stop interrompe le traitement du catch.
        Write-Error "Impossible de construire le message : $_" -ErrorAction Continue
        exit 1
    }
}

# Point d'entrée unique ; ce script est destiné à être exécuté, pas doté-sourcé.
Main -Name $Name -Prefix $GreetingPrefix
exit 0
