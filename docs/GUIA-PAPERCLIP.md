# Guía completa de Paperclip — uso correcto y prudente

> Guía optimizada para operar Paperclip como **board operator** (el dueño humano) de tus dos
> empresas de agentes: **crececonia** y **Strimo.cl**. Escrita en orden de uso real: primero
> entender, luego configurar, luego operar día a día y, sobre todo, hacerlo **con prudencia**
> (sin gastos descontrolados ni acciones a clientes reales sin tu OK).

---

## 0. Tu rol: board operator

Tú **no haces el trabajo** ni asignas cada tarea a mano. Tu trabajo es:

1. **Fijar objetivos** claros por empresa.
2. **Aprobar** decisiones clave (estrategia del CEO, contrataciones).
3. **Vigilar** coste y progreso desde el dashboard.
4. **Intervenir** solo cuando algo se atasca.

El **CEO** convierte tus objetivos en estrategia (que tú apruebas) y reparte el trabajo. Tú
mandas; los agentes ejecutan.

---

## 1. Los 6 conceptos núcleo (entiéndelos una vez)

| Concepto | Qué es | Lo que importa |
|---|---|---|
| **Company** | La organización raíz | Tiene objetivo, organigrama y presupuesto. Una instalación corre varias. |
| **Agent** | Cada "empleado" (IA) | Tiene adaptador, rol, jefe (`reportsTo`), capacidades y presupuesto. Árbol estricto: cada agente tiene **un solo jefe**; el CEO no tiene jefe (te reporta a ti). |
| **Issue / Task** | La unidad de trabajo | Tiene estado, prioridad, **un** asignado y un padre. Todo traza al objetivo. |
| **Delegation** | El CEO descompone objetivos en tareas | Tú apruebas estrategia y contrataciones; el reparto es automático. |
| **Heartbeat** | La "ventana" en que un agente despierta y trabaja | Se dispara por horario, asignación, mención `@`, clic manual o resolución de aprobación. Los agentes **no corren 24/7**. |
| **Governance** | Las puertas de control humano | Contrataciones y estrategia del CEO requieren tu aprobación. Todo queda en un registro de auditoría. |

### Ciclo de vida de una tarea
```
backlog → todo → in_progress → in_review → done
                     │
                  blocked → todo / in_progress
```
- `in_progress` requiere **checkout atómico**: solo un agente posee una tarea a la vez.
- `done` y `cancelled` son estados finales.

---

## 2. Configuración inicial (una sola vez)

### 2.1 Arrancar
```sh
npx paperclipai onboard --yes      # configura y arranca; UI en http://localhost:3100
npx paperclipai run                # re-arrancarlo otro día
```
> Mantén la ventana de la terminal **abierta** mientras lo uses; esa ventana lo mantiene encendido.

### 2.2 Conectar Claude (clave) — el adaptador `claude_local`
Tus agentes corren sobre **Claude Code**. Necesitas:
1. El **CLI `claude`** instalado y accesible.
2. Tu **`ANTHROPIC_API_KEY`** (o login por suscripción de Claude).

Dónde obtener la API key: https://console.anthropic.com → *API Keys* → *Create Key*.

Cómo cargarla de forma segura (ver §2.3) y **validarla**: en cada agente pulsa
**"Test Environment"** — comprueba que el CLI está, el directorio de trabajo es válido, el modo
de auth, y hace un "hello" en vivo. Si sale verde, el agente puede trabajar.

Campos útiles del adaptador (en *Agent → Configuration*):
- `cwd` — directorio de trabajo del agente (ruta absoluta; obligatorio).
- `model` — modelo de Claude (opcional; por defecto el del CLI).
- `maxTurnsPerRun` — turnos máx. por heartbeat (por defecto 300; **bájalo para limitar gasto**).
- `timeoutSec` — tope de tiempo del proceso.

### 2.3 Secretos (API keys) — hazlo bien desde el principio
Paperclip **cifra los secretos en reposo** con una clave maestra local que nunca sale de tu
máquina (`~/.paperclip/.../secrets/master.key`). **Respáldala junto con la base de datos** — sin
ella no se pueden descifrar los secretos.

Flujo correcto (no pongas claves en texto plano en los campos):
1. **Company Settings → Secrets** → crea el secreto (p. ej. `ANTHROPIC_API_KEY`, `CANVA_API_TOKEN`).
2. En el agente, campo **Environment variables** → añade la clave que el proceso espera.
3. Pon el origen de la fila en **Secret** y selecciona el secreto guardado (`latest` o versión fija).

> **Principio de mínimo privilegio:** vincula a cada agente **solo** los secretos que necesita.
> Una vez que el valor llega al agente, considéralo "expuesto a ese agente" (puede registrarlo).
> Limita el blast radius y **rota** las claves si sospechas filtración.

---

## 3. Modelar tus empresas (objetivos → agentes → tareas)

### 3.1 Buenos objetivos
Específico y medible delega mejor. Compara:
- 🚫 "Crecer la marca"
- ✅ "Publicar 4 piezas/semana y captar 200 suscriptores de email en 60 días" (crececonia)
- ✅ "Tener un embudo que genere 8 leads cualificados/mes con propuesta lista" (Strimo.cl)

### 3.2 Patrón de organigrama recomendado (empieza plano)
Para 3–5 agentes, el CEO delega directo:
```
CEO
├── (crececonia) Estratega · Redactor · Diseñador · Community/Email
└── (Strimo.cl)  SDR · Cualificación · Redactor propuestas · Gestor correo
```
**Empieza con el CEO solo** y deja que **contrate bajo demanda** (hire-on-demand) según el trabajo
real lo exija. No crees los 5 el día 1 si no hay trabajo para ellos (gasta tokens en vano).

### 3.3 Crear agentes
Dos vías:
- **Tú lo creas** (Agents → New): nombre, rol (`ceo`, `cmo`, `engineer`, `researcher`…), *reports
  to*, adaptador (`claude_local`), `cwd`, capacidades, presupuesto.
- **El CEO lo pide** (hire-on-demand): aparece una aprobación `hire_agent` en tu cola; revisas y
  apruebas/rechazas.

### 3.4 Atajo: importar paquetes completos (opcional)
Tu repo `paperclipagency` ya tiene las dos empresas completas en `companies/`. Para cargarlas de
golpe (en vez de a mano), con Paperclip corriendo:
```sh
npx paperclipai company import ./companies/crececonia --target new --dry-run   # previsualiza
npx paperclipai company import ./companies/crececonia --target new --new-company-name "crececonia"
npx paperclipai company import ./companies/strimo     --target new --new-company-name "Strimo.cl"
```
> Tras importar, los **heartbeats programados entran desactivados** por seguridad. Actívalos en la
> UI cuando estés conforme. (Si ya creaste Strimo.cl a mano, importarla crearía una **segunda**
> empresa duplicada: elige una sola vía.)

---

## 4. El flujo de delegación (cómo trabajas día a día)

```
Fijas un objetivo
  → el CEO despierta (heartbeat)
  → el CEO propone una ESTRATEGIA (te crea una aprobación)
  → tú APRUEBAS
  → el CEO crea tareas y las asigna a su equipo
  → los reports despiertan (heartbeat por asignación) y ejecutan
  → el CEO monitorea, desbloquea y escala
  → tú ves resultados en dashboard y activity log
```

Lo único que tienes que hacer: **fijar objetivo → aprobar estrategia → aprobar contrataciones →
vigilar**. No tienes que decirle al CEO "ahora habla con el SDR": lo hace solo según roles.

### Si "el CEO no delega", revisa en este orden:
1. **¿Hay una aprobación pendiente** en tu cola? (causa #1).
2. ¿Los reports están **pausados/terminados/en error**? (no tiene a quién delegar).
3. ¿El CEO superó el **80 % de presupuesto**? (entra en modo "solo crítico").
4. ¿Hay **objetivos** fijados?
5. ¿El **heartbeat** del CEO está activo?
6. ¿Las **instrucciones (AGENTS.md)** del CEO mencionan delegar/contratar?

---

## 5. Aprobaciones (governance) — tu palanca de control

Tipos de aprobación que llegarán a tu cola (**Approvals**):
- **CEO Strategy** — el plan inicial del CEO. Sin tu OK, el CEO no puede mover tareas a
  `in_progress`.
- **Hire Agent** — el CEO/manager quiere contratar a alguien (incluye rol, capacidades, adaptador
  y presupuesto propuestos).

Para cada una puedes: **Approve** · **Reject** · **Request revision** (pedir cambios y que la
reenvíe).

### Poderes de override del board (úsalos con criterio)
- Pausar / reanudar cualquier agente.
- **Terminar** un agente (¡irreversible! — mejor pausar primero).
- Reasignar cualquier tarea.
- Anular límites de presupuesto.
- Crear agentes directamente (saltándote el flujo de aprobación).

> 💡 **Prudencia:** activa las **hire approvals** en los ajustes de empresa para que ningún agente
> se contrate sin tu visto bueno. Es tu mejor freno contra el crecimiento (y gasto) descontrolado.

---

## 6. Costes y presupuestos — no te lleves sustos

Paperclip registra **cada token** por agente y mes (mes calendario UTC) y **frena solo**:

| Umbral | Acción |
|---|---|
| **80 %** | Aviso suave — el agente se concentra solo en lo crítico |
| **100 %** | Parada dura — el agente se **auto-pausa**, no más heartbeats |

Un agente auto-pausado se reactiva subiendo su presupuesto o esperando al mes siguiente.

Dónde ajustar:
- **Empresa:** Company Settings (o `PATCH /api/companies/{id}` con `budgetMonthlyCents`).
- **Por agente:** Agent → Configuration (`budgetMonthlyCents`, en **centavos** USD).

Dónde mirar el gasto: **Dashboard** (mes actual vs presupuesto, por empresa y por agente).

### Buenas prácticas de coste (prudencia)
- Empieza con **presupuestos conservadores** y súbelos cuando veas resultados.
- Usa **presupuestos por agente** para acotar el riesgo de cualquiera.
- Baja `maxTurnsPerRun` y alarga el intervalo de heartbeat de agentes no urgentes.
- Revisa el dashboard con regularidad para cazar picos raros.
- El CEO y agentes "pensantes" pueden necesitar más presupuesto que los ejecutores.

---

## 7. Heartbeats — controla cuándo (y cuánto) trabajan

Cada agente tiene ajustes de heartbeat (Agent → Configuration): **intervalo**, cooldown,
concurrencia máx. y **disparadores** (horario, asignación, mención, manual).

Prudencia:
- Para arrancar, prefiere disparo **por asignación y manual**; deja los **horarios (cron)
  desactivados** hasta confiar en el agente.
- Un cron muy frecuente = más gasto. Empieza espaciado (diario/semanal) y ajusta.
- Para probar un agente puntualmente, usa **"Invoke"** (heartbeat manual) en vez de dejar un cron
  encendido.

---

## 8. Tareas — cómo crearlas bien

Campos: **título** (accionable), **descripción** (markdown, con criterios de aceptación),
**prioridad** (`critical/high/medium/low`), **asignado** (un agente), **padre** (mantiene la
jerarquía hacia el objetivo) y **proyecto**.

Consejos:
- Toda tarea debe **trazar al objetivo** (ponle padre). Si no traza, no es prioritaria.
- Una tarea bloqueada debe llevar un **comentario** explicando el bloqueo.
- Sigue el progreso por **comentarios**, **cambios de estado** (activity log), **dashboard** y el
  **run history** del agente.

---

## 9. Reglas de oro de uso prudente (resumen)

1. **Nada sale a un cliente/lista real sin tu aprobación.** Configura los skills (correo,
   propuestas, publicación) para dejar el trabajo en `in_review` y enviar solo tras tu OK.
2. **Hire approvals activadas.** Que nadie se contrate sin ti.
3. **Presupuestos conservadores** por empresa y por agente; súbelos con resultados.
4. **Cron desactivado al principio**; usa "Invoke" manual para probar.
5. **Mínimo privilegio en secretos**; respalda la `master.key`.
6. **Empieza plano y pequeño** (CEO solo) y crece bajo demanda.
7. **Pausa antes de terminar** — terminar es irreversible.
8. **Objetivos específicos y medibles** → mejor delegación.
9. **Revisa el activity log y el dashboard** como rutina (es tu "panel de la empresa").
10. **Backups**: base de datos + clave maestra juntas.

---

## 10. Checklist de puesta en marcha

- [ ] Paperclip corriendo (`http://localhost:3100`).
- [ ] `ANTHROPIC_API_KEY` cargada como **secreto** y vinculada al CEO.
- [ ] **"Test Environment"** en verde para el CEO.
- [ ] Objetivo de la empresa fijado (específico y medible).
- [ ] Estrategia del CEO **aprobada** (con tus ajustes).
- [ ] **Hire approvals** activadas.
- [ ] Presupuesto de empresa y del CEO fijados (conservadores).
- [ ] Crons **desactivados** hasta confiar; pruebas con "Invoke".
- [ ] Skills sensibles (correo/propuestas/publicación) configurados para **requerir aprobación**.
- [ ] `master.key` y base de datos respaldadas.

---

## Referencias (en el repo de Paperclip)
- Conceptos: `docs/start/core-concepts.md` · `docs/start/what-is-paperclip.md`
- Delegación: `docs/guides/board-operator/delegation.md`
- Aprobaciones: `docs/guides/board-operator/approvals.md`
- Costes y presupuestos: `docs/guides/board-operator/costs-and-budgets.md`
- Agentes: `docs/guides/board-operator/managing-agents.md` · Tareas: `.../managing-tasks.md`
- Organigrama: `docs/guides/board-operator/org-structure.md`
- Adaptador Claude: `docs/adapters/claude-local.md` · Secretos: `docs/deploy/secrets.md`
- Importar/exportar: `docs/guides/board-operator/importing-and-exporting.md`
