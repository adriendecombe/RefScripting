#!/usr/bin/env python3
"""<ScriptName> - <Description>.

Auteur : <Author>
Version : <Version>
Date : <Date>
Prérequis : Python 3.9 ou supérieur ; bibliothèque standard uniquement.
Exemple : python3 template.py --name "Camille" --verbose
"""

import argparse
import logging

# Adapter les constantes et valeurs par défaut sans modifier la logique métier.
DEFAULT_NAME = "monde"
GREETING_PREFIX = "Bonjour"
LOG_FORMAT = "%(levelname)s: %(message)s"

LOGGER = logging.getLogger(__name__)


def build_greeting(name: str) -> str:
    """Construire un message de bienvenue.

    Args:
        name: Nom non vide de la personne à saluer.

    Returns:
        Message destiné à la sortie standard.

    Raises:
        ValueError: Si le nom est vide ou ne contient que des espaces.
    """
    normalized_name = name.strip()
    if not normalized_name:
        raise ValueError("Le nom ne doit pas être vide.")
    return f"{GREETING_PREFIX}, {normalized_name} !"


def main() -> int:
    """Analyser les arguments, produire le résultat et renvoyer le statut.

    Returns:
        0 en cas de succès, 1 si le nom fourni est invalide.
    """
    parser = argparse.ArgumentParser(
        description="Afficher un message de bienvenue."
    )
    parser.add_argument("--name", default=DEFAULT_NAME, help="Nom à saluer.")
    parser.add_argument(
        "--verbose",
        action="store_true",
        help="Afficher les détails de diagnostic.",
    )
    args = parser.parse_args()

    # stderr préserve stdout pour un programme qui exploite le résultat.
    logging.basicConfig(
        level=logging.DEBUG if args.verbose else logging.INFO,
        format=LOG_FORMAT,
    )
    try:
        LOGGER.debug("Construction du message de bienvenue.")
        greeting = build_greeting(args.name)
    except ValueError as exc:
        LOGGER.error("Impossible de construire le message : %s", exc)
        return 1

    print(greeting)
    return 0


# L'import rend les fonctions disponibles sans lancer le script.
if __name__ == "__main__":
    raise SystemExit(main())
