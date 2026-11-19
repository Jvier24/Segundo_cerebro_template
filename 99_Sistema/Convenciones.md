---
tipo: sistema
estado: activo
stack: []
actualizado: 2026-11-19
tags: [sistema, convenciones]
---

# 📐 Convenciones

Reglas para que un agente de código —o tú— puedan leer y escribir esta bóveda sin ambigüedad.

## Nombres

- Carpetas y archivos: **sin acentos**, en kebab-case cuando haga falta (`web-scraping-retail`). Los acentos en el contenido son normales.
- Notas diarias: `YYYY-MM-DD.md` en `00_Inbox`.
- El resto: título claro en forma de afirmación para teoría; nombre descriptivo para proyecto.

## Frontmatter

Todas las notas empiezan con YAML. Las listas van en una sola línea para que los scripts las lean fácil.

```yaml
---
tipo: experimento
estado: activo
stack: [python, requests]
proyecto: sinte-techno
actualizado: 2026-11-19
---
```

### Campos por `tipo`

| `tipo` | `estado` | Campos obligatorios | Plantilla |
| --- | --- | --- | --- |
| `teoria` | `borrador` | `area`, `stack`, `actualizado` | `tpl_teoria.md` |
| `probado` | `validado` | `stack`, `proyecto`, `actualizado` | `tpl_probado.md` |
| `experimento` | `activo` | `stack`, `proyecto`, `actualizado` | `tpl_experimento.md` |
| `proyecto` | `activo` | `stack`, `repo`, `actualizado` | `tpl_proyecto.md` |

### Campos de apoyo

| Campo | Uso |
| --- | --- |
| `area` | `INACAP`, `Dev-Stack`, `Automatizacion-IA` |
| `stack` | Lista de tecnologías; `[]` si aún no aplica |
| `proyecto` | Slug de la carpeta en `01_Proyectos`, o `""` |
| `repo` | URL o ruta del repositorio, o `""` |
| `actualizado` | `YYYY-MM-DD` |
| `tags` | Lista entre corchetes |

Notas de sistema e índices pueden usar `tipo: indice`, `tipo: area`, `tipo: moc` o `tipo: diaria`; no son artefactos de conocimiento.

## Enlaces

- Usa los wikilinks de Obsidian (dobles corchetes) para que se actualicen al renombrar.
- Toda nota de teoría enlaza al menos su mapa correspondiente: [[MOC INACAP]], [[MOC Dev-Stack]] o [[MOC Automatizacion-IA]].
- Toda nota `probado` debe poder reproducirse con lo escrito en `## Condiciones y Entorno`.

## PARA: destino de cada nota

| Pregunta | Destino |
| --- | --- |
| ¿Todavía no sé qué es? | `00_Inbox` |
| ¿Es una hipótesis en prueba (`experimento`)? | `00_Inbox` |
| ¿Tiene meta, stack y repo? | `01_Proyectos` |
| ¿Es una responsabilidad continua? | `02_Areas` |
| ¿Es teoría o conocimiento validado? | `03_Recursos` |
| ¿Ya no aplica? | `04_Archivo` |

## Promoción de experimentos

Un `experimento` nace en `00_Inbox/` con `estado: activo` y permanece allí mientras no esté validado.

Cuando se valide:

1. Muévelo a `03_Recursos/` (o a `01_Proyectos/<slug>/` si pasa a ser trabajo con meta).
2. Cambia el frontmatter a `tipo: probado` y `estado: validado`.
3. Completa `## Código / Configuración Funcional` y `## Condiciones y Entorno` con lo necesario para reproducirlo.
4. Actualiza `actualizado` a la fecha de la promoción.

Así, `00_Inbox/` queda como zona de captura y prueba, y `03_Recursos/` como fuente de verdad validada.

## Migración

El esquema anterior (`00_Inicio`, `10_Proyectos`, `20_Areas`, `30_Recursos`, `40_Archivo`, `50_Diario`, `60_Plantillas`, `70_Bandeja`, `80_Adjuntos`, `90_Sistema`, `99_Scripts`) fue migrado el 2026-11-19. Equivalencias:

| Antiguo | Nuevo |
| --- | --- |
| `00_Inicio` | `99_Sistema` |
| `10_Proyectos` | `01_Proyectos` + `04_Archivo` |
| `20_Areas/Estudio` | `02_Areas/INACAP` |
| `20_Areas/Trabajo` | `02_Areas/Dev-Stack` |
| `20_Areas/Personal` | `02_Areas/Automatizacion-IA` |
| `30_Recursos/Notas atomicas` | `03_Recursos` (`tipo: teoria`) |
| `40_Archivo` | `04_Archivo` |
| `50_Diario`, `70_Bandeja` | `00_Inbox` |
| `60_Plantillas` | `99_Sistema/Templates` (4 plantillas) |
| `90_Sistema` | `99_Sistema` |
| `99_Scripts` | `99_Sistema/Scripts` |

Volver a [[Inicio]] · Ver [[Guía del sistema]]
