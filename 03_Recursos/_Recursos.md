---
tipo: indice
estado: activo
stack: []
actualizado: 2026-11-20
tags: [indice, recursos]
---

# 📚 Recursos

> Aquí vive el conocimiento, ordenado por **nivel de madurez**. La madurez se declara en `tipo` y `estado`, no en la carpeta.

## 🧠 Teoría (`borrador`)

Conceptos entendidos, todavía sin aplicar.

<!-- INDICE:teoria -->
- [[Los enlaces importan más que las carpetas]]
- [[Pensar es escribir]]
- [[Un sistema que no se usa no sirve]]
<!-- /INDICE:teoria -->

## 🧪 Experimentos (`activo`)

Hipótesis en curso, con registro de pruebas y errores. Viven en [[_Inbox]] mientras no estén validadas; al validarse se promueven aquí como `probado`. Ver también [[00_Dashboard]].

<!-- INDICE:experimento -->
- [[prueba-parser-generico]]
<!-- /INDICE:experimento -->

## ✅ Validados (`validado`)

Soluciones que funcionan, con código y condiciones de entorno.

<!-- INDICE:probado -->
- [[configuracion-inicial-de-boveda]]
<!-- /INDICE:probado -->

---

## Mapas por área

- [[MOC Estudios]]
- [[MOC Dev-Stack]]
- [[MOC Automatizacion-IA]]

## Índices específicos

- [[_Teoria]] — todas las notas de teoría

## Crear conocimiento

Python es la opción multiplataforma:

```powershell
python 99_Sistema/Scripts/crear_nota.py --tipo teoria --titulo "Concepto"
python 99_Sistema/Scripts/crear_nota.py --tipo experimento --titulo "Prueba"
python 99_Sistema/Scripts/crear_nota.py --tipo probado --titulo "Patron"
```

Alternativa en Windows:

```powershell
.\99_Sistema\Scripts\nueva-nota.ps1 -Tipo Teoria -Titulo "Concepto"
.\99_Sistema\Scripts\nueva-nota.ps1 -Tipo Experimento -Titulo "Prueba" -Proyecto proyecto-ejemplo
.\99_Sistema\Scripts\nueva-nota.ps1 -Tipo Probado -Titulo "Patrón" -Stack "python, requests"
```
