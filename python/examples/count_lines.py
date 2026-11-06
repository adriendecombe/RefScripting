#!/usr/bin/env python3
"""count_lines.py - Compter les lignes non vides d'un fichier texte.

Auteur : contributeurs du repository
Version : 1.0.0
Date : 2026-11-06
Prérequis : Python 3.9 ou supérieur ; bibliothèque standard uniquement.
Exemple : python3 python/examples/count_lines.py --path README.md --verbose
"""

import argparse
import logging
from pathlib import Path

# La configuration est séparée des données fournies au lancement.
FILE_ENCODING = "utf-8"
LOG_FORMAT = "%(levelname)s: %(message)s"
LOGGER = logging.getLogger(__name__)


def count_nonempty_lines(path: Path) -> int:
    """Compter les lignes contenant autre chose que des espaces.

    Args:
        path: Chemin du fichier texte à lire en UTF-8.

    Returns:
        Nombre de lignes non vides.

    Raises:
        OSError: Si le fichier ne peut pas être ouvert ou lu.
        UnicodeError: Si son contenu n'est pas valide en UTF-8.
    """
    # Le gestionnaire de contexte ferme le fichier même en cas d'erreur.
    with path.open(encoding=FILE_ENCODING) as source:
        return sum(1 for line in source if line.strip())


def main() -> int:
    """Exécuter le comptage et renvoyer 0, ou 1 en cas d'erreur de lecture."""
    parser = argparse.ArgumentParser(
        description="Compter les lignes non vides."
    )
    parser.add_argument(
        "--path", type=Path, required=True, help="Fichier texte UTF-8."
    )
    parser.add_argument(
        "--verbose", action="store_true", help="Afficher les diagnostics."
    )
    args = parser.parse_args()

    logging.basicConfig(
        level=logging.DEBUG if args.verbose else logging.INFO,
        format=LOG_FORMAT,
    )
    try:
        LOGGER.debug("Lecture du fichier : %s", args.path)
        count = count_nonempty_lines(args.path)
    except (OSError, UnicodeError) as exc:
        LOGGER.error("Impossible de lire %s : %s", args.path, exc)
        return 1

    print(count)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
