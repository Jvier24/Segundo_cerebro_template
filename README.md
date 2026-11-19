# 🧠 Segundo Cerebro — Template Repository

Bóveda de **Obsidian** lista para clonar, pensada para estudios, desarrollo y automatización, e ideas creativas. Está diseñada para ser leída y actualizada tanto por personas como por agentes de código (OpenCode, Antigravity, etc.).

> [!info] Qué incluye
> Estructura PARA · 4 plantillas de madurez del conocimiento · scripts en Python y PowerShell · **Dataview instalado y habilitado** · una nota `probado` de referencia · reglas normativas para agentes. Sin notas privadas de proyectos.

---

## Arquitectura

### PARA + madurez del conocimiento

La estructura PARA decide **dónde vive** cada nota; el frontmatter decide **qué tan madura** está.

| Carpeta | Función | Índice |
| --- | --- | --- |
| `00_Inbox/` | Capturas, experimentos en curso y diarias | `_Inbox.md` |
| `01_Proyectos/` | Trabajo con meta, stack y repo | `_Proyectos.md` |
| `02_Areas/` | Responsabilidades continuas (INACAP, Dev-Stack, Automatizacion-IA) | `_Areas.md` |
| `03_Recursos/` | Teoría, conocimiento validado y mapas | `_Recursos.md` |
| `04_Archivo/` | Histórico. **Ignorar por defecto** | `_Archivo.md` |
| `99_Sistema/` | Plantillas, scripts, guías y convenciones | `Inicio.md` |

Las carpetas de proyecto (`web-scraping-retail`, `juego-blender`, `sinte-techno`) están vacías y conservan su `.gitkeep`: son ejemplos de estructura, no contenido privado.

### Eje de madurez

```
teoria  →  experimento  →  probado
borrador   activo          validado
```

| `tipo` | `estado` | Plantilla | Destino |
| --- | --- | --- | --- |
| `teoria` | `borrador` | `tpl_teoria.md` | `03_Recursos/` |
| `experimento` | `activo` | `tpl_experimento.md` | `00_Inbox/` |
| `probado` | `validado` | `tpl_probado.md` | `03_Recursos/` |
| `proyecto` | `activo` | `tpl_proyecto.md` | `01_Proyectos/<slug>/` |
| `diaria` | `borrador` | (generada por `crear_nota.py`) | `00_Inbox/YYYY-MM-DD.md` |

**Promoción:** cuando un `experimento` se valida, se mueve a `03_Recursos/` (o a `01_Proyectos/<slug>/` si pasa a ser un proyecto) y su frontmatter cambia a `tipo: probado` + `estado: validado`, completando `## Condiciones y Entorno`. Nunca queda un experimento validado en el Inbox.

Las reglas completas para agentes están en [AGENTS.md](AGENTS.md); el índice navegable, en [00_Dashboard.md](00_Dashboard.md).

---

## Cómo usar este Template en otro PC

1. En GitHub, pulsa **Use this template → Create a new repository** (o clona este repo y elimina la carpeta `.git`).
2. Clona tu nuevo repositorio:
   ```powershell
   git clone https://github.com/TU-USUARIO/TU-REPO.git
   cd TU-REPO
   ```
3. Abre Obsidian y elige **Open folder as vault**, seleccionando la carpeta clonada.
4. Ve a **Ajustes → Community plugins** y desactiva **Restricted mode**.
   Después pulsa **Recargar** (`Ctrl + R`) o reinicia Obsidian.
5. Ya está: los bloques `dataview` de [00_Dashboard.md](00_Dashboard.md) se renderizan como tablas. Dataview se instaló vía archivos en `.obsidian/plugins/dataview/` y está habilitado en `.obsidian/community-plugins.json`.

> [!warning] Modo restringido
> El interruptor de *Restricted mode* se guarda en la configuración global de Obsidian, **no dentro de la bóveda**. Por eso no viene desactivado en el repo y hay que cambiarlo una vez por equipo.

**Requisitos:** Obsidian de escritorio · Python 3 (solo biblioteca estándar) · PowerShell 5.1+ para los scripts `.ps1`.

---

## Scripts

### `crear_nota.py` — crear notas

Sin dependencias externas. Resuelve las rutas por sí mismo, así que funciona desde cualquier directorio.

```powershell
python 99_Sistema/Scripts/crear_nota.py --tipo teoria --titulo "Grafos dirigidos"
python 99_Sistema/Scripts/crear_nota.py --tipo probado --titulo "Sesion HTTP reutilizable"
python 99_Sistema/Scripts/crear_nota.py --tipo experimento --titulo "Parser de retail"
python 99_Sistema/Scripts/crear_nota.py --tipo proyecto --titulo "Sintetizador modular"
python 99_Sistema/Scripts/crear_nota.py --tipo diaria --titulo "Cierre de sprint"
```

- Sustituye `{{title}}` y `{{date:YYYY-MM-DD}}` por el título y la fecha reales.
- Genera nombres de archivo en `kebab-case` sin acentos.
- **No sobrescribe**: si el archivo existe, lo indica y termina.
- La `diaria` lleva las secciones `## Log Técnico del Día`, `## Tareas / Bloqueos` y `## Ideas Rápidas`.

### `actualizar-indices.ps1` — regenerar índices

Reescribe únicamente el contenido entre los marcadores `<!-- INDICE:clave -->` a partir del frontmatter. Nunca escribas a mano dentro de esos bloques.

```powershell
.\99_Sistema\Scripts\actualizar-indices.ps1
```

### Otros scripts

| Script | Función |
| --- | --- |
| `nueva-nota.ps1` | Alternativa en PowerShell: acepta `-Proyecto` y `-Stack`, refresca índices y puede abrir la nota con `-Abrir` |
| `diaria.ps1` | Crea y abre la diaria de hoy |
| `instalar-tarea.ps1` | Programa la diaria automática a las 08:00 (tarea de Windows) |

La guía operativa completa está en `99_Sistema/Guía del sistema.md` y las convenciones de metadatos en `99_Sistema/Convenciones.md`.

---

## Archivos ignorados

`.gitignore` excluye el estado de sesión de Obsidian (`workspace.json`, `workspace-mobile.json`, `cache/`), `__pycache__/`, `.DS_Store` y `Thumbs.db`. **No** excluye `.obsidian/community-plugins.json` ni `.obsidian/plugins/dataview/`: la configuración del plugin se versiona a propósito para que el template llegue funcionando.

---

## Verificación de referencia

La nota [`configuracion-inicial-de-boveda`](03_Recursos/configuracion-inicial-de-boveda.md) es conocimiento `probado / validado`: documenta la estructura, la configuración de `.obsidian/`, los scripts y el entorno verificado. Es la fuente de verdad absoluta según [AGENTS.md](AGENTS.md).
