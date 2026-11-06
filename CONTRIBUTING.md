# Contribuer

Merci de contribuer à ce standard et à son objectif pédagogique. Garder les
exemples courts, autonomes et sans dépendance externe sauf nécessité justifiée.

## Conventions

- Utiliser des noms descriptifs : fichiers et fonctions Python en `snake_case`,
  constantes en `UPPER_SNAKE_CASE` ; fonctions PowerShell en `Verb-Noun` avec un
  verbe approuvé, fichiers PowerShell de préférence en `Verb-Noun.ps1`.
- Mettre à jour l'en-tête (nom, description, auteur, version, date, prérequis et
  utilisation) et regrouper imports et configuration. Ne pas ajouter de secret.
- Documenter chaque fonction : responsabilité, paramètres, retour et erreurs
  utiles à l'appelant en Python ; aide PowerShell avec synopsis, description,
  paramètres et exemple. Ajouter les annotations ou types pertinents.
- Réserver les commentaires à l'intention et aux choix non évidents : expliquer
  pourquoi, pas traduire les instructions. Supprimer les commentaires périmés.
- Valider les entrées, traiter les erreurs attendues explicitement et conserver
  un code de sortie non nul en cas d'échec. Ne pas masquer les exceptions ;
  libérer les ressources avec `with` ou `finally` selon le cas.
- Réserver la sortie de succès aux résultats. Utiliser `logging` en Python et
  les flux PowerShell (`Write-Verbose`, `Write-Warning`, `Write-Error`,
  `Write-Information`) plutôt que `Write-Host` pour les diagnostics. Ne pas
  journaliser de données sensibles.

## Validations recommandées

Depuis la racine du dépôt, vérifier au minimum l'aide, un cas nominal et un cas
d'erreur pour chaque script modifié, ainsi que son code de sortie. Par exemple :

```sh
python3 -m py_compile python/template.py python/examples/count_lines.py
python3 python/template.py --help
python3 python/examples/count_lines.py --path README.md --verbose
python3 python/examples/count_lines.py --path fichier-inexistant
pwsh -File powershell/template.ps1 -Name Camille -Verbose
pwsh -File powershell/examples/Count-Lines.ps1 -Path README.md -Verbose
pwsh -File powershell/examples/Count-Lines.ps1 -Path fichier-inexistant
```

Le dernier appel de chaque langage doit signaler une erreur et renvoyer un
statut non nul. Ajouter des tests automatisés pour les nouveaux comportements,
notamment les limites, les erreurs et la séparation des flux. Si disponibles,
utiliser aussi un formateur ou analyseur Python compatible PEP 8 et
PSScriptAnalyzer ; ne pas ajouter de dépendance uniquement pour un exemple.

## Pull Request

1. Créer une branche et limiter les modifications à un objectif cohérent.
2. Mettre à jour exemples et documentation, puis effectuer les validations
   pertinentes et la checklist du README.
3. Ouvrir une Pull Request décrivant l'objectif, les changements, les validations
   effectuées et les éventuelles limites ou dépendances.
4. Répondre aux remarques de revue et corriger les problèmes avant fusion.
