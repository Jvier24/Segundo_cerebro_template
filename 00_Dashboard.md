---
tipo: indice
estado: activo
stack: []
actualizado: 2026-11-20
tags: [dashboard, indice]
---

# 🧭 Dashboard

Índice central de la bóveda. Antes de proponer código o arquitectura, lee [[AGENTS]].

## 📁 Estructura

| Carpeta | Enlace | Función |
| --- | --- | --- |
| `00_Inbox` | [[00_Inbox/_Inbox\|00_Inbox]] | Captura sin clasificar |
| `01_Proyectos` | [[01_Proyectos/_Proyectos\|01_Proyectos]] | Proyectos activos |
| `02_Areas` | [[02_Areas/_Areas\|02_Areas]] | Responsabilidades continuas |
| `03_Recursos` | [[03_Recursos/_Recursos\|03_Recursos]] | Conocimiento por madurez |
| `04_Archivo` | [[04_Archivo/_Archivo\|04_Archivo]] | Histórico (ignorar por defecto) |
| `99_Sistema` | [[99_Sistema/Guía del sistema\|99_Sistema]] | Plantillas, scripts y guías |

## 🎓 Áreas

- [[02_Areas/Estudios/Estudios|Estudios]]
- [[02_Areas/Dev-Stack/Dev-Stack|Dev-Stack]]
- [[02_Areas/Automatizacion-IA/Automatizacion-IA|Automatizacion-IA]]

## 📄 Plantillas oficiales

| Plantilla | Enlace | Produce |
| --- | --- | --- |
| `tpl_teoria.md` | [[99_Sistema/Templates/tpl_teoria\|tpl_teoria]] | `tipo: teoria` / `borrador` |
| `tpl_probado.md` | [[99_Sistema/Templates/tpl_probado\|tpl_probado]] | `tipo: probado` / `validado` |
| `tpl_experimento.md` | [[99_Sistema/Templates/tpl_experimento\|tpl_experimento]] | `tipo: experimento` / `activo` |
| `tpl_proyecto.md` | [[99_Sistema/Templates/tpl_proyecto\|tpl_proyecto]] | `tipo: proyecto` / `activo` |

## 📊 Consultas Dataview

### Proyectos activos

```dataview
TABLE estado, stack, actualizado
FROM "01_Proyectos"
WHERE tipo = "proyecto" AND estado = "activo"
SORT actualizado DESC
```

### Conocimiento validado reciente

```dataview
TABLE proyecto, stack, actualizado
FROM "03_Recursos"
WHERE tipo = "probado" AND estado = "validado"
SORT actualizado DESC
LIMIT 10
```

### Experimentos en curso

```dataview
TABLE proyecto, stack, actualizado
FROM "00_Inbox"
WHERE tipo = "experimento"
SORT actualizado DESC
```

---

## 🔧 Referencia rápida

```powershell
python 99_Sistema/Scripts/crear_nota.py --tipo probado --titulo "Patron"
python 99_Sistema/Scripts/actualizar_indices.py

# Alternativa en Windows
.\99_Sistema\Scripts\nueva-nota.ps1 -Tipo Probado -Titulo "Patron" -Proyecto proyecto-ejemplo -Stack "python"
.\99_Sistema\Scripts\actualizar-indices.ps1
.\99_Sistema\Scripts\diaria.ps1
```

Normas para agentes → [[AGENTS]] · Guía completa → [[99_Sistema/Guía del sistema|Guía del sistema]]
