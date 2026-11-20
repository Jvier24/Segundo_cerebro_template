---
tipo: probado
estado: validado
stack: [Obsidian, Python, Git]
proyecto: segundo-cerebro
actualizado: 2026-11-20
---

# Configuración inicial de bóveda

## Problema que resuelve

Dejar la bóveda operativa para Obsidian y para agentes de código: estructura PARA, plantillas de madurez del conocimiento, scripts de creación e índices, y consultas Dataview funcionales en [[00_Dashboard]].

## Código / Configuración Funcional

**Estructura de carpetas**

- `00_Inbox/` — capturas, experimentos y diarias
- `01_Proyectos/` — proyectos activos
- `02_Areas/` — Estudios, Dev-Stack, Automatizacion-IA
- `03_Recursos/` — teoría, conocimiento validado y mapas
- `04_Archivo/` — histórico (ignorar por defecto)
- `99_Sistema/Templates/` y `99_Sistema/Scripts/`

**Configuración en `.obsidian/`**

```text
templates.json        -> carpeta 99_Sistema/Templates
daily-notes.json      -> carpeta 00_Inbox
app.json              -> adjuntos en 03_Recursos/Adjuntos
core-plugins.json     -> diarias, plantillas, propiedades y zk-prefixer activos
community-plugins.json -> ["dataview"]
plugins/dataview/     -> main.js, manifest.json, styles.css (0.5.70)
```

**Scripts**

```powershell
python 99_Sistema/Scripts/crear_nota.py --tipo probado --titulo "Titulo"
.\99_Sistema\Scripts\nueva-nota.ps1 -Tipo Probado -Titulo "Titulo"
.\99_Sistema\Scripts\actualizar-indices.ps1
.\99_Sistema\Scripts\diaria.ps1
```

**Convivencia de directorios**: `experimento` se crea en `00_Inbox/`; al validarse se promueve a `03_Recursos/` con `tipo: probado` y `estado: validado`. Regla normativa en [[AGENTS]] y [[99_Sistema/Convenciones|Convenciones]].

## Condiciones y Entorno

- Windows; PowerShell 5.1+ y Python 3.13.14 verificados. `crear_nota.py` usa solo biblioteca estándar.
- Obsidian de escritorio. **El modo restringido debe desactivarse en Ajustes → Community plugins** para que Dataview cargue; esa preferencia se guarda fuera de la bóveda, no en `.obsidian/`.
- Después de instalar el plugin, recargar Obsidian (`Ctrl + R`) o reiniciarlo.
- Nombres de carpetas y archivos sin acentos; el contenido puede llevar acentos.
- Fecha de verificación: 2026-11-19. Comprobados los cinco tipos de nota de `crear_nota.py`, sus destinos y la resolución de wikilinks.

> [!NOTE] Resultado
> Esta nota aparece en la consulta «Conocimiento validado reciente» de [[00_Dashboard]] porque cumple `tipo = "probado"` y `estado = "validado"` dentro de `03_Recursos/`.
