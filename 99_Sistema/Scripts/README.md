# Scripts del sistema

Automatización de la bóveda. Hay dos formas de crear notas: `crear_nota.py` (Python, sin dependencias) y `nueva-nota.ps1` (PowerShell).

---

## crear_nota.py

Script en **Python 3 estándar**, sin paquetes externos. Lee las plantillas de `99_Sistema/Templates/`, sustituye el título y la fecha, y guarda la nota en su carpeta.

### Sintaxis

```powershell
python 99_Sistema/Scripts/crear_nota.py --tipo TIPO --titulo "Nombre de la nota"
```

Ejecútalo siempre desde la raíz de la bóveda (aunque el script resuelve las rutas por sí solo, no depende del directorio actual).

### Tipos y destinos

| `--tipo` | Plantilla | Carpeta destino | Nombre del archivo |
| --- | --- | --- | --- |
| `teoria` | `tpl_teoria.md` | `03_Recursos/` | `kebab-case.md` |
| `probado` | `tpl_probado.md` | `03_Recursos/` | `kebab-case.md` |
| `experimento` | `tpl_experimento.md` | `00_Inbox/` | `kebab-case.md` |
| `proyecto` | `tpl_proyecto.md` | `01_Proyectos/` | `kebab-case.md` |
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
3. Convierte el título a `kebab-case`: minúsculas, sin acentos ni caracteres especiales, palabras unidas por guiones. Ejemplo: `"Parser de retail"` → `parser-de-retail.md`.
4. Crea la carpeta destino si no existe.
5. **No sobrescribe**: si el archivo ya existe, lo indica y termina sin cambios.

### Nota diaria

`--tipo diaria` no usa plantilla (entre las 4 oficiales no hay una de diario). Genera directamente `00_Inbox/YYYY-MM-DD.md` con este frontmatter —`tipo: diaria`, `estado: borrador`, `stack: []`, `fecha`, `actualizado`, `tags: [diario]`— y estas secciones:

- `## Log Técnico del Día`
- `## Tareas / Bloqueos`
- `## Ideas Rápidas`

El `--titulo` se coloca como «Foco del día» dentro de la nota; el nombre del archivo es siempre la fecha.

### Requisitos y resolución de problemas

- Necesitas **Python 3** (`python --version`). No requiere `pip install`.
- Si el sistema usa `python3`, sustituye `python` por `python3` en los comandos.
- Para refrescar los índices de Obsidian después de crear notas, ejecuta:

  ```powershell
  .\99_Sistema\Scripts\actualizar-indices.ps1
  ```

---

## nueva-nota.ps1 (alternativa en PowerShell)

Equivalente con más opciones: acepta los parámetros `-Stack` y `-Proyecto`, actualiza los índices automáticamente y puede abrir la nota en Obsidian.

```powershell
.\99_Sistema\Scripts\nueva-nota.ps1 -Tipo Probado -Titulo "Sesion reutilizable" -Proyecto web-scraping-retail -Stack "python, requests" -Abrir
```

## Otros scripts

| Script | Función |
| --- | --- |
| `actualizar-indices.ps1` | Regenera los bloques `<!-- INDICE:... -->` desde el frontmatter |
| `diaria.ps1` | Crea y abre la nota diaria de hoy en Obsidian |
| `instalar-tarea.ps1` | Programa la diaria automática a las 08:00 (tarea de Windows) |

Normas que rigen estas notas → [[AGENTS]]
