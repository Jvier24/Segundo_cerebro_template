---
tipo: proyecto
estado: activo
stack: [Python, SQLite]
repo: ""
actualizado: 2026-11-19
---

# Proyecto de ejemplo

## Arquitectura y Stack

Este proyecto muestra cómo estructurar una carpeta en `01_Proyectos/`: el slug de la carpeta coincide con el nombre de la nota y el frontmatter declara `tipo`, `estado`, `stack` y `repo`. Así los scripts y el dashboard pueden leerlo sin ambigüedad.

## Decisiones Técnicas

- Un proyecto es un resultado concreto con meta, stack y repositorio.
- Lo que se valide dos veces se promueve a una nota `probado` en `03_Recursos/`.
- Los experimentos relacionados viven en `00_Inbox/` y se enlazan desde esta nota: [[prueba-parser-generico]].

## Backlog / Tareas Activas

- [ ] Definir el objetivo y el criterio de terminación
- [ ] Registrar la URL del repositorio en `repo`
- [ ] Convertir los hallazgos estables en conocimiento `probado`
