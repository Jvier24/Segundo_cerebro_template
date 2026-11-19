---
tipo: sistema
estado: activo
stack: []
actualizado: 2026-11-19
tags: [sistema, guia]
---

# 📖 Guía del sistema

Tu segundo cerebro combina **PARA** (dónde vive algo) con un eje de **madurez del conocimiento** (qué tan seguro es). Enfoque mixto: formación, desarrollo/automatización e ideas creativas. Pensado para ser leído y actualizado por agentes de código.

---

## 1. Estructura

```text
00_Inbox/                    Captura sin clasificar
01_Proyectos/                Proyectos activos (tpl_proyecto)
  └── proyecto-ejemplo/
02_Areas/                    Responsabilidades continuas
  ├── Estudios/
  ├── Dev-Stack/
  └── Automatizacion-IA/
03_Recursos/                 Conocimiento por madurez
04_Archivo/                  Lo inactivo
99_Sistema/                  Plantillas, scripts y documentación
  ├── Templates/             4 plantillas oficiales
  └── Scripts/               Automatización PowerShell
```

## 2. Madurez del conocimiento

| `tipo` | `estado` | Cuándo usarlo |
| --- | --- | --- |
| `teoria` | `borrador` | Entiendo el concepto, todavía no lo he aplicado |
| `experimento` | `activo` | Tengo una hipótesis y la estoy probando |
| `probado` | `validado` | Funciona, está documentado y sé en qué entorno |
| `proyecto` | `activo` | Hay una meta, un stack y un repo |

El flujo natural es `teoria → experimento → probado`, y de ahí a un `proyecto` o a un área. El `experimento` nace en `00_Inbox/`; al validarse se mueve a `03_Recursos/` con `tipo: probado` y `estado: validado`.

## 3. Uso diario en Obsidian

- **Insertar plantilla:** `Ctrl + P` → *Insert template* → elige `tpl_*`.
- **Nota diaria:** `Ctrl + P` → *Open today's daily note*. Se crea en `00_Inbox`.
- **Navegar:** `Ctrl + O` (abrir por nombre), `Ctrl + G` (saltar a enlace).
- **Ver conexiones:** Graph view desde la cinta lateral.

## 4. Automatización (PowerShell)

Abre PowerShell en la raíz de la bóveda (la carpeta que clonaste).

### Crear conocimiento

```powershell
.\99_Sistema\Scripts\nueva-nota.ps1 -Tipo Teoria -Titulo "Grafo dirigido"
.\99_Sistema\Scripts\nueva-nota.ps1 -Tipo Experimento -Titulo "Parser con BeautifulSoup" -Proyecto proyecto-ejemplo -Stack "python, requests"
.\99_Sistema\Scripts\nueva-nota.ps1 -Tipo Probado -Titulo "Sesión reutilizable de requests" -Stack "python, requests"
.\99_Sistema\Scripts\nueva-nota.ps1 -Tipo Proyecto -Titulo "Plan de pruebas" -Proyecto proyecto-ejemplo
```

Tipos válidos: `Teoria`, `Probado`, `Experimento`, `Proyecto`. Sin argumentos, el script muestra un menú.

### Actualizar índices

```powershell
.\99_Sistema\Scripts\actualizar-indices.ps1
```

Escanea la bóveda, lee el frontmatter y rellena los bloques marcados. Se ejecuta solo al crear una nota.

### Diaria y tarea programada

```powershell
.\99_Sistema\Scripts\diaria.ps1
.\99_Sistema\Scripts\instalar-tarea.ps1   # opcional: abre la diaria a las 08:00
```

> [!WARNING] Si PowerShell bloquea los scripts
> Ejecuta una vez: `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned`.

## 5. Índices automáticos

Bloques con este formato:

```html
<!-- INDICE:teoria -->
- [[Un sistema que no se usa no sirve]]
- [[Pensar es escribir]]
- [[Los enlaces importan más que las carpetas]]
<!-- /INDICE:teoria -->
```

Claves disponibles: `proyectos`, `areas`, `teoria`, `experimento`, `probado`, `archivo`, `inbox`, `recientes`, `area-estudios`, `area-dev-stack`, `area-automatizacion-ia`.

**No escribas dentro de un bloque**: se sobrescribe. Escribe fuera de él.

## 6. Revisión semanal (viernes, 20 min)

- [ ] Vaciar [[_Inbox]]
- [ ] Revisar [[_Proyectos]] y [[Inicio]]
- [ ] Pasar un `experimento` a `probado` si ya funciona
- [ ] Ejecutar `actualizar-indices.ps1`
- [ ] Archivar lo terminado en [[_Archivo]]

---

Convenciones de formato → [[Convenciones]] · Volver → [[Inicio]]
