# Standard de scripts Python et PowerShell

Ce dépôt fournit des modèles réutilisables et un support de formation pour écrire
des scripts lisibles, testables et faciles à maintenir. Les exemples utilisent
uniquement les bibliothèques et commandes livrées avec les langages.

## Structure

```text
.
├── README.md
├── CONTRIBUTING.md
├── .gitignore
├── python/
│   ├── template.py
│   └── examples/
│       └── count_lines.py
└── powershell/
    ├── template.ps1
    └── examples/
        └── Count-Lines.ps1
```

Les scripts nécessitent Python 3.9+ ou PowerShell 7+, respectivement. Les
commandes ci-dessous sont lancées depuis la racine du dépôt. Les exemples
comptent les lignes non vides d'un fichier texte UTF-8 ; leur résultat est un
entier sur la sortie de succès.

```sh
python3 python/template.py --name "Camille" --verbose
python3 python/examples/count_lines.py --path README.md --verbose
pwsh -File powershell/template.ps1 -Name "Camille" -Verbose
pwsh -File powershell/examples/Count-Lines.ps1 -Path README.md -Verbose
```

Pour afficher l'aide, utiliser `python3 python/template.py --help` ou, dans
PowerShell, `Get-Help ./powershell/template.ps1 -Full`.

## Utiliser un template

Copier le modèle dans le projet cible, lui donner un nom explicite et remplacer
les champs `<ScriptName>`, `<Description>`, `<Author>`, `<Version>` et `<Date>`.
Adapter les prérequis, l'exemple d'utilisation, les paramètres, la configuration
et la logique métier ; retirer les fonctions de démonstration devenues inutiles.
L'en-tête doit décrire le script réel, pas le modèle d'origine.

Par exemple, dans un shell POSIX :

```sh
cp python/template.py python/mon_script.py
python3 python/mon_script.py --name "Camille"
```

Après la copie, remplacer le message de bienvenue par le traitement souhaité et
mettre à jour l'aide. Pour PowerShell, copier `powershell/template.ps1` de la
même façon, puis exécuter le nouveau fichier avec `pwsh -File`.

## Conventions Python

- Suivre [PEP 8](https://peps.python.org/pep-0008/) : noms explicites en
  `snake_case` pour les fonctions et variables, `UPPER_SNAKE_CASE` pour les
  constantes, et imports regroupés en début de fichier. Séparer bibliothèque
  standard, dépendances externes et modules internes par des lignes vides.
- Suivre [PEP 257](https://peps.python.org/pep-0257/) pour les docstrings et
  annoter les paramètres et valeurs de retour. Les annotations aident les lecteurs
  et outils ; elles ne valident pas automatiquement les données à l'exécution.
- Garder la logique métier dans des fonctions ciblées, sans effets de bord à
  l'import. Un `main() -> int` orchestre arguments, journalisation et traitement.

## Conventions PowerShell

- Utiliser des noms de fonctions `Verb-Noun` avec un
  [verbe approuvé](https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_verbs),
  comme `New-Greeting` ou `Measure-NonEmptyLine`. `Main` est l'exception
  réservée ici à l'orchestration interne du script.
- Placer l'aide basée sur les commentaires avant le bloc `param()` du script ou
  dans chaque fonction. Utiliser `.SYNOPSIS`, `.DESCRIPTION`, `.PARAMETER` et
  `.EXAMPLE` lorsque des paramètres sont présents.
- Déclarer des paramètres typés et utiliser `[CmdletBinding()]` pour bénéficier
  notamment des paramètres communs, tels que `-Verbose`. Regrouper les imports
  de modules éventuels après `param()` et éviter les dépendances inutiles.
- Garder les fonctions séparées de leur appel final. Les modèles sont des
  **scripts exécutables**, non des bibliothèques à doter-sourcer : `exit`
  termine leur processus ou leur hôte. Extraire les fonctions dans un module
  si elles doivent être importées sans quitter la session.

## Variables, constantes et configuration

Définir en début de script les valeurs fixes et les valeurs par défaut ; prendre
les entrées variables dans les paramètres. En Python, les constantes en
majuscules sont une convention, pas une protection contre la modification. En
PowerShell, les valeurs de configuration sont regroupées et nommées clairement
en `PascalCase` ; ce sont des variables ordinaires, pas des constantes
immuables. Utiliser `Set-Variable -Option ReadOnly` seulement si cette protection
est nécessaire.

Les valeurs calculées, comme `normalized_name` ou `$count`, restent locales aux
fonctions. Passer les paramètres explicitement limite les dépendances globales
et facilite les tests. Ne jamais placer de secrets dans le dépôt ; les injecter
par un mécanisme adapté à l'environnement.

## Documenter une fonction

Une docstring Python décrit la responsabilité, les arguments, le retour et les
exceptions attendues lorsqu'ils ne sont pas évidents. Une aide PowerShell
équivalente fournit au minimum le synopsis, la description, les paramètres et un
exemple d'appel. Documenter les contrats utiles à l'appelant, sans répéter
chaque ligne de code. Les fonctions `build_greeting` et `New-Greeting` montrent
ces deux formats.

## Rôle du point d'entrée

La fonction principale concentre la coordination : lecture des arguments,
configuration du journal, appel des fonctions et statut final. En Python,
`if __name__ == "__main__": raise SystemExit(main())` évite l'exécution lors
d'un import et transmet le code de retour au système. En PowerShell, `Main` est
appelée explicitement en fin de script ; elle ne rend pas le fichier importable
sans effets de bord.

## Gestion des erreurs et codes de sortie

Valider les entrées, intercepter les exceptions attendues à une frontière où
l'on peut agir et fournir un message utile. Ne pas masquer les erreurs ni
renvoyer un résultat qui ressemble à un succès. En Python, un gestionnaire de
contexte `with` ferme le fichier même en cas d'erreur ; utiliser `finally`
lorsqu'une ressource exige un nettoyage non assuré par un tel gestionnaire. En
PowerShell, `try`/`catch` intercepte les erreurs **terminantes** ; utiliser
`-ErrorAction Stop` ou `$ErrorActionPreference = 'Stop'` lorsque nécessaire et
`finally` pour libérer une ressource si le script en ouvre une.

Les scripts renvoient `0` pour un succès et `1` pour une erreur de traitement
gérée. Les erreurs d'analyse des arguments peuvent avoir un autre code non nul
(notamment `2` avec `argparse`). Dans un shell POSIX, consulter `$?` juste après
la commande ; après `pwsh -File` lancé depuis PowerShell, consulter
`$LASTEXITCODE`. Les exemples lisent l'UTF-8 ; Python signale aussi les octets
invalides, alors que le décodage de `Get-Content` peut les remplacer.

## Journalisation et flux

Python utilise `logging` sur stderr et réserve stdout au résultat ; `--verbose`
active les messages de diagnostic. En PowerShell, le résultat va sur le flux de
succès, les diagnostics sur `Write-Verbose` et les erreurs sur `Write-Error`.
`Write-Warning` convient aux situations anormales non fatales et
`Write-Information` aux informations facultatives (affichables avec
`-InformationAction Continue`). `Write-Host` n'est pas le mécanisme de
journalisation standard. Ces flux sont distincts dans PowerShell ; lors d'un
appel externe via `pwsh -File`, l'hôte peut afficher les messages `Verbose`
sur stdout avec le résultat. Éviter `-Verbose` si un programme externe doit
analyser stdout. Ne journaliser ni secrets ni données sensibles.

## Checklist avant Pull Request

- [ ] Le nom, l'en-tête, les prérequis et les exemples d'utilisation sont à jour.
- [ ] Les paramètres et fonctions sont typés et documentés, avec des noms explicites.
- [ ] La configuration est regroupée ; les valeurs calculées restent locales.
- [ ] Le point d'entrée orchestre les fonctions sans logique métier globale.
- [ ] Les erreurs attendues sont explicites, journalisées et renvoient un code non nul.
- [ ] Les flux de résultat et de diagnostic sont distincts et sans secrets.
- [ ] Le chemin nominal, les erreurs et l'aide ont été vérifiés.
- [ ] La documentation et les éventuels tests ont été adaptés.

Voir [CONTRIBUTING.md](CONTRIBUTING.md) pour les validations et le processus de
contribution.
