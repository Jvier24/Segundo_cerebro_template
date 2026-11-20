#!/usr/bin/env python3
"""Regenera los bloques <!-- INDICE:clave --> de la boveda.

Replica el comportamiento de actualizar-indices.ps1 usando solo la
biblioteca estandar de Python 3: mismas exclusiones, mismas claves de
bloque, mismo orden y escritura UTF-8 sin BOM.
"""

import re
import sys
from datetime import datetime
from pathlib import Path

# 99_Sistema/Scripts/actualizar_indices.py -> tres niveles arriba esta la raiz
VAULT = Path(__file__).resolve().parents[2]

MARKER_RE = re.compile(
    r"<!--\s*INDICE:([A-Za-z0-9-]+)\s*-->(.*?)<!--\s*/INDICE:\1\s*-->",
    re.IGNORECASE | re.DOTALL,
)
FRONTMATTER_RE = re.compile(r"^\s*([A-Za-z0-9_-]+)\s*:\s*(.*)$")


class Note:
    """Nota leida de la boveda con su frontmatter ya parseado."""

    __slots__ = ("path", "name", "rel", "text", "fm")

    def __init__(self, path, name, rel, text, fm):
        self.path = path
        self.name = name
        self.rel = rel
        self.text = text
        self.fm = fm


def get_frontmatter(text):
    fm = {}
    lines = re.split(r"\r?\n", text)
    if not lines or lines[0].strip() != "---":
        return fm

    for line in lines[1:]:
        if line.strip() == "---":
            break
        match = FRONTMATTER_RE.match(line)
        if match:
            key = match.group(1).lower()
            value = match.group(2).strip()
            if value.startswith("[") and value.endswith("]"):
                value = value[1:-1]
            value = value.strip("\"'")
            fm[key] = value
    return fm


def get_note_date(note):
    for key in ("actualizado", "creado", "fecha"):
        value = note.fm.get(key)
        if value and re.match(r"^\d{4}-\d{2}-\d{2}", value):
            return value
    return datetime.fromtimestamp(note.path.stat().st_mtime).strftime("%Y-%m-%d")


def list_notes(items, empty):
    items = [item for item in items if item is not None]
    if not items:
        return "- {}".format(empty)
    return "\n".join("- [[{}]]".format(item.name) for item in items)


def is_excluded(rel):
    return (
        re.search(r"(^|/)\.obsidian/", rel, re.IGNORECASE) is not None
        or re.search(r"(^|/)99_Sistema/Templates/", rel, re.IGNORECASE) is not None
        or re.search(r"(^|/)99_Sistema/Scripts/", rel, re.IGNORECASE) is not None
        or re.search(r"(^|/)Plantillas legacy/", rel, re.IGNORECASE) is not None
    )


def gather_notes():
    notes = []
    for path in VAULT.rglob("*.md"):
        if not path.is_file():
            continue
        rel = path.relative_to(VAULT).as_posix()
        if is_excluded(rel):
            continue
        with path.open("r", encoding="utf-8-sig", newline="") as archivo:
            text = archivo.read()
        notes.append(Note(path, path.stem, rel, text, get_frontmatter(text)))

    # Mismo orden base que el indexador de PowerShell: ruta relativa ascendente.
    notes.sort(key=lambda note: note.rel.casefold())
    return notes


def by_date_desc(items):
    """Fecha descendente y, en caso de empate, ruta ascendente."""
    items = sorted(items, key=lambda note: note.rel.casefold())
    return sorted(items, key=lambda note: get_note_date(note), reverse=True)


def build_blocks(notes):
    blocks = {}

    blocks["proyectos"] = list_notes(
        [
            note
            for note in notes
            if note.fm.get("tipo") == "proyecto"
            and note.fm.get("estado") != "terminado"
        ],
        "Sin proyectos activos",
    )

    blocks["areas"] = list_notes(
        [note for note in notes if note.fm.get("tipo") == "area"],
        "Sin areas activas",
    )

    for tipo in ("teoria", "experimento", "probado"):
        items = by_date_desc([note for note in notes if note.fm.get("tipo") == tipo])
        blocks[tipo] = list_notes(items, "Sin notas de {}".format(tipo))

    blocks["archivo"] = list_notes(
        [
            note
            for note in notes
            if note.rel.casefold().startswith("04_archivo/")
            and note.fm.get("tipo") != "indice"
        ],
        "Vacio por ahora.",
    )

    blocks["inbox"] = list_notes(
        [
            note
            for note in notes
            if note.rel.casefold().startswith("00_inbox/")
            and note.fm.get("tipo") != "indice"
        ],
        "Vacio por ahora.",
    )

    recientes = by_date_desc(
        [
            note
            for note in notes
            if note.fm.get("tipo")
            in ("proyecto", "teoria", "experimento", "probado", "area", "diaria")
        ]
    )[:12]

    if not recientes:
        blocks["recientes"] = "- Sin notas todavia"
    else:
        blocks["recientes"] = "\n".join(
            "- [[{}]] - {}".format(note.name, note.fm.get("tipo"))
            for note in recientes
        )

    areas = {
        "area-estudios": "Estudios",
        "area-dev-stack": "Dev-Stack",
        "area-automatizacion-ia": "Automatizacion-IA",
    }
    for key, wanted in areas.items():
        blocks[key] = list_notes(
            [
                note
                for note in notes
                if note.fm.get("tipo") == "teoria" and note.fm.get("area") == wanted
            ],
            "Sin notas todavia",
        )

    return blocks


def replace_blocks(text, blocks):
    matches = list(MARKER_RE.finditer(text))
    if not matches:
        return text, False

    parts = []
    last = 0
    hit = False
    newline = "\r\n" if "\r\n" in text else "\n"
    for match in matches:
        key = match.group(1).lower()
        parts.append(text[last : match.start()])
        if key in blocks:
            body = blocks[key].replace("\n", newline)
            parts.append(
                "<!-- INDICE:{} -->{}{}{}<!-- /INDICE:{} -->".format(
                    key, newline, body, newline, key
                )
            )
            hit = True
        else:
            parts.append(match.group(0))
        last = match.end()
    parts.append(text[last:])
    return "".join(parts), hit


def main():
    notes = gather_notes()
    blocks = build_blocks(notes)
    changed = 0

    for note in notes:
        new_text, hit = replace_blocks(note.text, blocks)
        if hit and new_text != note.text:
            with note.path.open("w", encoding="utf-8", newline="") as archivo:
                archivo.write(new_text)
            changed += 1

    print("Indices actualizados en {} notas.".format(changed))
    return 0


if __name__ == "__main__":
    sys.exit(main())
