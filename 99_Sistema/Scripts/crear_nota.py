#!/usr/bin/env python3
"""Crea notas en la boveda usando las plantillas oficiales.

Sin dependencias externas: solo biblioteca estandar de Python 3.
"""

import argparse
import re
import sys
import unicodedata
from datetime import date
from pathlib import Path

# 99_Sistema/Scripts/crear_nota.py -> tres niveles arriba esta la raiz de la boveda
VAULT = Path(__file__).resolve().parents[2]
TEMPLATES = VAULT / "99_Sistema" / "Templates"

# tipo -> (carpeta destino, plantilla; None significa contenido generado)
DESTINOS = {
    "teoria": (VAULT / "03_Recursos", "tpl_teoria.md"),
    "probado": (VAULT / "03_Recursos", "tpl_probado.md"),
    "experimento": (VAULT / "00_Inbox", "tpl_experimento.md"),
    "proyecto": (VAULT / "01_Proyectos", "tpl_proyecto.md"),
    "diaria": (VAULT / "00_Inbox", None),
}


def kebab_case(texto):
    """Convierte un titulo en un nombre de archivo ASCII kebab-case."""
    normalizado = unicodedata.normalize("NFKD", texto)
    ascii_texto = normalizado.encode("ascii", "ignore").decode("ascii")
    ascii_texto = re.sub(r"[^a-zA-Z0-9]+", "-", ascii_texto)
    return ascii_texto.strip("-").lower() or "nota"


def contenido_diaria(hoy, titulo):
    """Genera la diaria; no existe plantilla oficial de diaria entre las 4."""
    return (
        "---\n"
        "tipo: diaria\n"
        "estado: borrador\n"
        "stack: []\n"
        f"fecha: {hoy}\n"
        f"actualizado: {hoy}\n"
        "tags: [diario]\n"
        "---\n"
        "\n"
        f"# {hoy} - Diario\n"
        "\n"
        "> [!info] Foco del dia\n"
        f"> {titulo}\n"
        "\n"
        "## Log Técnico del Día\n"
        "\n"
        "- \n"
        "\n"
        "## Tareas / Bloqueos\n"
        "\n"
        "- [ ] \n"
        "\n"
        "## Ideas Rápidas\n"
        "\n"
        "- \n"
    )


def main(argv=None):
    parser = argparse.ArgumentParser(
        description="Crea una nota en la boveda a partir de una plantilla oficial."
    )
    parser.add_argument(
        "--tipo",
        required=True,
        choices=sorted(DESTINOS),
        help="tipo de nota a crear",
    )
    parser.add_argument(
        "--titulo",
        required=True,
        help="titulo de la nota (se usa como nombre de archivo en kebab-case)",
    )
    args = parser.parse_args(argv)

    hoy = date.today().isoformat()
    destino, plantilla = DESTINOS[args.tipo]
    titulo = args.titulo.strip()

    if not titulo:
        parser.error("--titulo no puede estar vacio")

    if args.tipo == "diaria":
        contenido = contenido_diaria(hoy, titulo)
        nombre = hoy + ".md"
    else:
        ruta_plantilla = TEMPLATES / plantilla
        if not ruta_plantilla.is_file():
            parser.error("no se encontro la plantilla: {}".format(ruta_plantilla))
        contenido = ruta_plantilla.read_text(encoding="utf-8")
        contenido = contenido.replace("{{title}}", titulo)
        contenido = contenido.replace("{{date:YYYY-MM-DD}}", hoy)
        contenido = contenido.replace("YYYY-MM-DD", hoy)
        nombre = kebab_case(titulo) + ".md"

    destino.mkdir(parents=True, exist_ok=True)
    ruta = destino / nombre

    if ruta.exists():
        print("Ya existe, no se sobrescribio: {}".format(ruta))
        return 0

    with ruta.open("w", encoding="utf-8", newline="\n") as archivo:
        archivo.write(contenido)

    print("Creada: {}".format(ruta))
    return 0


if __name__ == "__main__":
    sys.exit(main())
