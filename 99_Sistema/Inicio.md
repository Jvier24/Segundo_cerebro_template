---
tipo: indice
estado: activo
stack: []
actualizado: 2026-11-20
tags: [inicio, sistema]
---

# 🏠 Inicio

> [!quote] Segundo Cerebro
> **Estudios** · Desarrollo y **automatización** · **Ideas creativas**.
> Diseñado para ser leído y actualizado tanto por personas como por agentes de código.

## 🧭 Estructura

| Carpeta | Para qué | Índice |
| --- | --- | --- |
| `00_Inbox` | Captura sin clasificar | [[_Inbox]] |
| `01_Proyectos` | Proyectos activos | [[_Proyectos]] |
| `02_Areas` | Responsabilidades continuas | [[_Areas]] |
| `03_Recursos` | Conocimiento por nivel de madurez | [[_Recursos]] |
| `04_Archivo` | Lo inactivo | [[_Archivo]] |
| `99_Sistema` | Plantillas, scripts y documentación | [[Guía del sistema]] |

## 🎓 Áreas

- [[Estudios]] · [[MOC Estudios]]
- [[Dev-Stack]] · [[MOC Dev-Stack]]
- [[Automatizacion-IA]] · [[MOC Automatizacion-IA]]

## 🚀 Proyectos activos

<!-- INDICE:proyectos -->
- [[proyecto-ejemplo]]
<!-- /INDICE:proyectos -->

## 📥 Inbox

<!-- INDICE:inbox -->
- [[prueba-parser-generico]]
<!-- /INDICE:inbox -->

## 🧩 Conocimiento reciente

<!-- INDICE:recientes -->
- [[prueba-parser-generico]] - experimento
- [[configuracion-inicial-de-boveda]] - probado
- [[proyecto-ejemplo]] - proyecto
- [[Automatizacion-IA]] - area
- [[Dev-Stack]] - area
- [[Estudios]] - area
- [[Los enlaces importan más que las carpetas]] - teoria
- [[Pensar es escribir]] - teoria
- [[Un sistema que no se usa no sirve]] - teoria
<!-- /INDICE:recientes -->

---

## ⚡ Comandos rápidos

```powershell
python 99_Sistema/Scripts/crear_nota.py --tipo teoria --titulo "Idea"
python 99_Sistema/Scripts/actualizar_indices.py
```

En Windows también puedes usar `.\99_Sistema\Scripts\nueva-nota.ps1` y `.\99_Sistema\Scripts\actualizar-indices.ps1`.

## ✅ Rutina

- [ ] **Mañana** — revisar [[_Proyectos]] y elegir 3 prioridades
- [ ] **Durante el día** — capturar en [[_Inbox]] sin organizar
- [ ] **Media tarde** — convertir capturas en [[_Recursos|conocimiento]] o tareas
- [ ] **Viernes** — ejecutar `python 99_Sistema/Scripts/actualizar_indices.py` y revisar [[Mapa general]]

> [!tip] Regla de oro
> El conocimiento sube de madurez: `teoria` → `experimento` → `probado`. Un `proyecto` es donde se pone a trabajar.

Manual completo → [[Guía del sistema]] · Convenciones → [[Convenciones]]
