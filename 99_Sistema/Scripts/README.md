# Scripts del sistema

Automatización de la bóveda. Python es la opción multiplataforma recomendada: `crear_nota.py` crea notas y `actualizar_indices.py` regenera los índices. `nueva-nota.ps1` y `actualizar-indices.ps1` son la alternativa en Windows.

---

## crear_nota.py

Script en **Python 3 estándar**, sin paquetes externos. Lee las plantillas de `99_Sistema/Templates/`, sustituye el título y la fecha, y guarda la nota en su carpeta.

### Sintaxis

```powershell
python 99_Sistema/Scripts/crear_nota.py --tipo TIPO --titulo "Nombre de la nota" [--no-indices]
```

Ejecútalo siempre desde la raíz de la bóveda (aunque el script resuelve las rutas por sí solo, no depende del directorio actual).

### Tipos y destinos

| `--tipo` | Plantilla | Carpeta destino | Nombre del archivo |
| --- | --- | --- | --- |
| `teoria` | `tpl_teoria.md` | `03_Recursos/` | `kebab-case.md` |
| `probado` | `tpl_probado.md` | `03_Recursos/` | `kebab-case.md` |
| `experimento` | `tpl_experimento.md` | `00_Inbox/` | `kebab-case.md` |
| `proyecto` | `tpl_proyecto.md` | `01_Proyectos/<slug>/` | `<slug>.md` (carpeta y nota con el mismo nombre) |
| `diaria` | (generada por el script) | `00_Inbox/` | `YYYY-MM-DD.md` |

### Ejemplos

```powershell
python 99_Sistema/Scripts/crear_nota.py --tipo teoria --titulo "Grafos dirigidos"
python 99_Sistema/Scripts/crear_nota.py --tipo probado --titulo "Sesion HTTP reutilizable"
python 99_Sistema/Scripts/crear_nota.py --tipo experimento --titulo "Parser de retail con BeautifulSoup"
python 99_Sistema/Scripts/crear_nota.py --tipo proyecto --titulo "Sintetizador modular"
python 99_Sistema/Scripts/crear_nota.py --tipo diaria --titulo "Cierre de sprint"
```

### Qué hace exactamente

1. Sustituye `{{title}}` por el valor de `--titulo`.
2. Sustituye `{{date:YYYY-MM-DD}}` (y cualquier `YYYY-MM-DD` literal) por la fecha actual del sistema.
3. Convierte el título a `kebab-case`: minúsculas, sin acentos ni caracteres especiales, palabras unidas por guiones. Ejemplo: `"Parser de retail"` → `parser-de-retail.md`. En `proyecto` ese slug es también el nombre de la carpeta: `"Sintetizador modular"` → `01_Proyectos/sintetizador-modular/sintetizador-modular.md`.
4. Crea la carpeta destino si no existe.
5. **No sobrescribe**: si el archivo ya existe, lo indica y termina sin cambios.
6. Refresca los índices llamando a `actualizar_indices.py`; `--no-indices` omite este paso.

### Nota diaria

`--tipo diaria` no usa plantilla (entre las 4 oficiales no hay una de diario). Genera directamente `00_Inbox/YYYY-MM-DD.md` con este frontmatter —`tipo: diaria`, `estado: borrador`, `stack: []`, `fecha`, `actualizado`, `tags: [diario]`— y estas secciones:

- `## Log Técnico del Día`
- `## Tareas / Bloqueos`
- `## Ideas Rápidas`

El `--titulo` se coloca como «Foco del día» dentro de la nota; el nombre del archivo es siempre la fecha.

### Requisitos y resolución de problemas

- Necesitas **Python 3** (`python --version`). No requiere `pip install`.
- Si el sistema usa `python3`, sustituye `python` por `python3` en los comandos.
- Para refrescar los índices manualmente, ejecuta:

  ```powershell
  python 99_Sistema/Scripts/actualizar_indices.py
  ```

  En Windows también puedes usar `.\99_Sistema\Scripts\actualizar-indices.ps1`.

---

## actualizar_indices.py

Indexador multiplataforma en Python estándar. Replica el comportamiento de `actualizar-indices.ps1`: mismas exclusiones (`.obsidian`, `Templates`, `Scripts`, `Plantillas legacy`), mismas claves de bloque, mismo orden y escritura UTF-8 sin BOM. Es idempotente.

```powershell
python 99_Sistema/Scripts/actualizar_indices.py
```

`crear_nota.py` lo ejecuta automáticamente al terminar. Se puede omitir con `--no-indices`.

---

## nueva-nota.ps1 (alternativa en Windows)

Equivalente con más opciones: acepta los parámetros `-Stack` y `-Proyecto`, actualiza los índices automáticamente y puede abrir la nota en Obsidian. Usa el indexador de PowerShell.

```powershell
.\99_Sistema\Scripts\nueva-nota.ps1 -Tipo Probado -Titulo "Sesion reutilizable" -Proyecto proyecto-ejemplo -Stack "python, requests" -Abrir
```

Con `-Tipo Proyecto`, la nota se guarda en `01_Proyectos/<Proyecto>/` si pasas `-Proyecto`; si lo omites, el slug del título se usa a la vez como carpeta y como nombre de la nota (`01_Proyectos/<slug>/<slug>.md`).

## Otros scripts

| Script | Función |
| --- | --- |
| `actualizar_indices.py` | Regenera los bloques `<!-- INDICE:... -->` desde el frontmatter (multiplataforma) |
| `actualizar-indices.ps1` | Alternativa en Windows del indexador |
| `diaria.ps1` | Crea y abre la nota diaria de hoy en Obsidian |
| `instalar-tarea.ps1` | Programa la diaria automática a las 08:00 (tarea de Windows) |

Normas que rigen estas notas → [[AGENTS]]
