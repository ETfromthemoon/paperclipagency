# Paperclip Agency — crececonia & Strimo.cl

Este repositorio es el **paquete de arranque** ("agencia") para gestionar mis dos proyectos
con [**Paperclip**](https://github.com/paperclipai/paperclip), la plataforma open-source para
orquestar equipos de agentes de IA — *"si un agente es un empleado, Paperclip es la empresa"*.

> Este repo **no contiene** el código de Paperclip. Contiene la **configuración** de mis dos
> "empresas" de agentes en formato de paquete importable (markdown + `.paperclip.yaml`), más
> la infra y la guía para desplegar Paperclip y cargarlas.

## ¿Qué hace Paperclip?

Paperclip es el "panel de control" (control plane) de una empresa de agentes de IA. En vez de
usar un agente suelto, modelas una organización completa:

- **Empresa (Company)** — unidad raíz con un **objetivo** ("goal"), organigrama y presupuesto.
- **Agentes** — cada "empleado" es un agente de IA con rol, jefe, capacidades y presupuesto.
  Corren sobre **adaptadores**: Claude Code (`claude_local`), Codex, proceso shell o webhook HTTP.
- **Issues / tareas** — la unidad de trabajo; toda tarea traza de vuelta al objetivo de la empresa.
- **Delegación** — el CEO convierte objetivos en estrategia (que tú apruebas) y reparte tareas.
- **Heartbeats** — los agentes "despiertan" por horario, asignación, mención o manualmente.
- **Gobernanza y presupuestos** — puertas de aprobación, límite de gasto mensual con freno
  automático, y registro de auditoría de cada acción.
- **Multi-empresa** — una sola instalación corre varias empresas con datos aislados.

Stack: Node.js 20+ · React 19 · TypeScript · PostgreSQL (o PGlite embebido) · pnpm 9.

## Mis dos empresas en este repo

| Carpeta | Empresa | Objetivo |
|---|---|---|
| [`companies/crececonia/`](companies/crececonia/) | **crececonia** — marca personal de IA para negocios y personas | Aumentar comunidad y monetizar |
| [`companies/strimo/`](companies/strimo/) | **Strimo.cl** — desarrollo de sitios web | Automatizar la captación de clientes |

Cada carpeta es un **paquete de empresa** auto-contenido e importable:

```
companies/<empresa>/
├── COMPANY.md            # Identidad + objetivos de la empresa
├── BLUEPRINT.md          # Mapa objetivos → agentes → rutinas (lectura humana)
├── .paperclip.yaml       # Config Paperclip: adaptador, presupuestos, rutinas/cron, env
├── agents/<slug>/AGENTS.md   # Cada agente: identidad, rol, jefe, instrucciones
├── projects/<slug>/PROJECT.md
├── tasks/<slug>/TASK.md      # Tareas semilla (recurring: true para rutinas)
└── skills/<slug>/SKILL.md    # Habilidades reutilizables (Canva, Gmail, Drive, deploy)
```

## Cómo desplegar Paperclip

Necesitas **Node.js 20+** y **pnpm 9.15+**. Tres caminos:

### A) Rápido (recomendado para empezar)
```sh
npx paperclipai onboard --yes      # configura y arranca; UI/API en http://localhost:3100
npx paperclipai run                # arrancarlo de nuevo más tarde
```

### B) Docker (para un VPS o dejarlo siempre encendido)
```sh
cp .env.example .env               # rellena tus claves (sobre todo BETTER_AUTH_SECRET)
docker compose up -d               # ver docker-compose.yml
```

### C) Desde el código (para desarrollo)
```sh
git clone https://github.com/paperclipai/paperclip.git
cd paperclip && pnpm install && pnpm dev
```

## Cómo cargar mis dos empresas

Con Paperclip corriendo, importa cada paquete (crea una empresa nueva a partir del paquete):

```sh
# Desde una copia local de este repo:
npx paperclipai company import ./companies/crececonia --target new --new-company-name "crececonia"
npx paperclipai company import ./companies/strimo     --target new --new-company-name "Strimo.cl"

# O directamente desde GitHub (cuando esté publicado):
npx paperclipai company import etfromthemoon/paperclipagency/companies/crececonia --target new
```

Consejos:
- Añade `--dry-run` para previsualizar qué se va a crear antes de aplicar.
- Tras importar, los **heartbeats programados quedan desactivados** por seguridad; revísalos y
  actívalos desde la UI cuando estés conforme.

## Conectar a Claude y a los servicios

- **Claude** es un adaptador de primera clase (`claude_local`): necesita el **CLI de Claude Code**
  instalado (`claude`) y `ANTHROPIC_API_KEY` (o login por suscripción). Configurado en cada
  `.paperclip.yaml`.
- **Canva, Gmail, Google Drive y Vercel/Netlify** no son integraciones nativas de Paperclip, así
  que se conectan como **skills** que el agente invoca (vía MCP, CLI o webhook). Las plantillas
  están en `companies/<empresa>/skills/`. Rellena los tokens correspondientes en tu `.env`.

## Presupuestos y gobernanza

- Los límites de gasto mensual se definen en cada `.paperclip.yaml`
  (`budgetMonthlyCents`, en **centavos** USD) a nivel empresa y por agente. Al alcanzarse, el
  agente se **auto-pausa**.
- Acciones sensibles (p. ej. enviar correos a clientes reales, contratar agentes, la estrategia
  inicial del CEO) pasan por **aprobación humana**. Revisa y aprueba desde la UI.

## Verificación rápida
```sh
curl http://localhost:3100/api/health
curl http://localhost:3100/api/companies
```

## Documentación de Paperclip
- Repo: https://github.com/paperclipai/paperclip
- Conceptos: `docs/start/core-concepts.md` · Quickstart: `docs/start/quickstart.md`
- Importar/exportar: `docs/guides/board-operator/importing-and-exporting.md`
- Spec de paquetes de empresa: `docs/companies/companies-spec.md`
