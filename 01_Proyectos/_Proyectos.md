---
tipo: indice
estado: activo
stack: []
actualizado: 2026-11-20
tags: [indice, proyectos]
---

# 🚀 Proyectos

> Un proyecto = **un resultado concreto** con stack, repo y tareas activas. Se crea con `tpl_proyecto.md`.

## Proyectos activos

<!-- INDICE:proyectos -->
- [[proyecto-ejemplo]]
<!-- /INDICE:proyectos -->

## Carpetas de proyecto

| Proyecto | Carpeta |
| --- | --- |
| Proyecto de ejemplo | `proyecto-ejemplo/` |

## Crear uno

```powershell
python 99_Sistema/Scripts/crear_nota.py --tipo proyecto --titulo "Nombre"
.\99_Sistema\Scripts\nueva-nota.ps1 -Tipo Proyecto -Titulo "Nombre" -Proyecto proyecto-ejemplo
```

Si omites `-Proyecto`, el slug del título se usa como carpeta y como nombre de la nota: `01_Proyectos/<slug>/<slug>.md`.
