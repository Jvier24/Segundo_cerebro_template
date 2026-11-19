# AGENTS.md — Reglas normativas para agentes en esta bóveda

> **Este archivo es de cumplimiento obligatorio.** Aplícalo antes de proponer código, arquitectura o comandos, y antes de crear o modificar cualquier nota. Si una instrucción aquí entra en conflicto con una convención externa, prevalece este archivo.

---

## 1. Jerarquía de Verdad

**Antes de proponer código, arquitectura o comandos, busca siempre en `03_Recursos/` y `01_Proyectos/`.** No respondas desde memoria ni desde suposiciones: lee primero.

Orden de precedencia, de mayor a menor autoridad:

1. **`tipo: probado` + `estado: validado`** (en `03_Recursos/`) → **fuente de verdad absoluta**. Su código, configuración y `## Condiciones y Entorno` son la referencia definitiva. Si contradicen cualquier otra nota, gana esta.
2. **`tipo: proyecto` + `estado: activo`** (en `01_Proyectos/`) → decisiones técnicas y stack vigentes para ese proyecto.
3. **Notas `area`, `moc` o `indice`** (en `02_Areas/`, `03_Recursos/`, `99_Sistema/`) → contexto y convenciones.
4. **`tipo: experimento` o `estado: borrador`** → referencia no confirmada (ver §2).

Si no existe ninguna nota `probado/validado` sobre el tema, **dilo explícitamente** antes de proponer una solución: «No hay conocimiento validado en `03_Recursos/` sobre esto; lo siguiente es una propuesta, no una verdad documentada.»

Cuando una solución funcione, propon convertirla en nota `probado` para que pase a ser verdad absoluta en futuras sesiones.

---

## 2. Manejo de Experimentos y Teoría

Trata las notas con **`tipo: experimento`** o **`estado: borrador`** únicamente como **referencia no confirmada**.

- Nunca las copies a producción, a un repo real ni a una configuración activa sin advertir al usuario primero.
- Nunca las presentes como patrón validado, aunque el código parezca correcto.
- Si el usuario pide usarlas, incluye una advertencia explícita con la nota de origen, por ejemplo:

  > ⚠️ Esta solución proviene de `[[Pensar es escribir]]` (`tipo: teoria`, `estado: borrador`). No está validada. Revísala antes de llevarla a producción.

- Para promover una idea, sigue el flujo `teoria → experimento → probado`: primero se prueba (el `experimento` vive en `00_Inbox/`), luego se documenta con `## Condiciones y Entorno` y se marca `estado: validado`.

---

## 3. Regla de Ignorar

**Ignora por completo la carpeta `04_Archivo/`**, incluido `04_Archivo/Plantillas legacy/`, salvo que el usuario te pida explícitamente buscar allí.

- No la incluyas en búsquedas por defecto.
- No la cites como fuente.
- No uses su contenido para responder, aunque parezca relevante.
- No la tengas en cuenta al proponer arquitectura ni al generar índices o consultas.

Si el usuario dice «busca también en el archivo» o nombra `04_Archivo/`, entonces —y solo entonces— accede a ella, indicando que se trata de material histórico y no de verdad vigente.

---

## 4. Creación de Notas

Cada vez que se te pida documentar un hallazgo, una solución o un apunte en esta bóveda:

1. **Usa estrictamente el esquema YAML de la plantilla correspondiente** en `99_Sistema/Templates/`. Leela antes de escribir. No inventes campos ni omitas los obligatorios.

   | Situación | Plantilla | `tipo` | `estado` | Campos obligatorios |
   | --- | --- | --- | --- | --- |
   | Concepto entendido, sin aplicar | `tpl_teoria.md` | `teoria` | `borrador` | `area`, `stack`, `actualizado` |
   | Hipótesis en prueba | `tpl_experimento.md` | `experimento` | `activo` | `stack`, `proyecto`, `actualizado` |
   | Solución que funciona | `tpl_probado.md` | `probado` | `validado` | `stack`, `proyecto`, `actualizado` |
   | Trabajo con meta y repo | `tpl_proyecto.md` | `proyecto` | `activo` | `stack`, `repo`, `actualizado` |

2. **Actualiza `actualizado` a la fecha actual del sistema** en formato `YYYY-MM-DD` al momento de escribir. Nunca copies la fecha de una nota anterior ni la dejes como `{{date:YYYY-MM-DD}}`. Obtén la fecha real con `Get-Date -Format yyyy-MM-dd` (o equivalente).

3. **Guarda en la carpeta correcta** sin excepciones:
   - `teoria`, `probado` → `03_Recursos/`
   - `experimento` → `00_Inbox/` (todavía no validado)
   - `proyecto` → `01_Proyectos/<slug>/`
   - Capturas sin clasificar y `diaria` → `00_Inbox/`

4. **Prefiere el script** para crearlas (rellena plantilla y actualiza índices):

   ```powershell
   .\99_Sistema\Scripts\nueva-nota.ps1 -Tipo Probado -Titulo "Sesion reutilizable" -Proyecto proyecto-ejemplo -Stack "python, requests"
   ```

   Tipos válidos: `Teoria`, `Probado`, `Experimento`, `Proyecto`.

5. **Usa wikilinks de Obsidian** (por ejemplo `[[Inicio]]`) para enlazar con otras notas, y añade un alias (`[[Inicio|texto visible]]`) cuando el nombre sea largo.

6. **Nunca escribas dentro de bloques `<!-- INDICE:... -->`**: se regeneran con `actualizar-indices.ps1`. Escribes fuera de ellos.

7. **Nombres de carpetas y archivos sin acentos** (kebab-case). Los acentos en el contenido son normales.

8. **Promoción de experimentos**: cuando un `experimento` en `00_Inbox/` se valide, muévelo a `03_Recursos/` (o a `01_Proyectos/<slug>/` si pasa a ser trabajo con meta) y cambia su frontmatter a `tipo: probado` y `estado: validado`. Completa `## Condiciones y Entorno` antes de promoverlo. Nunca dejes un experimento validado en `00_Inbox/`.

---

## 5. Checklist rápido antes de responder

- [ ] ¿Busqué en `03_Recursos/` y `01_Proyectos/`?
- [ ] ¿Estoy citando una nota `probado/validado` o lo estoy marcando como propuesta?
- [ ] ¿Evité `04_Archivo/` salvo petición explícita?
- [ ] ¿Advertí si usé un `experimento` o un `borrador`?
- [ ] Si escribí una nota: ¿usé la plantilla exacta, la fecha actual y la carpeta correcta?
- [ ] Si validé un experimento: ¿lo promoví a `03_Recursos/` con `tipo: probado` y `estado: validado`?

Índice central → [[00_Dashboard]] · Guía → [[99_Sistema/Guía del sistema|Guía del sistema]] · Convenciones → [[99_Sistema/Convenciones|Convenciones]]
