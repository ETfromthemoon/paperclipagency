# Paperclip Agency — crececonia & Strimo.cl

Repositorio de **configuración + despliegue** para gestionar mis dos proyectos con
[**Paperclip**](https://github.com/paperclipai/paperclip), la plataforma open-source para
orquestar equipos de agentes de IA — *"si un agente es un empleado, Paperclip es la empresa"*.

> Este repo **no contiene** el código de Paperclip. Contiene: (1) la **configuración** de mis dos
> empresas de agentes en formato importable (`agentcompanies/v1`), y (2) la **infra** para
> desplegar Paperclip en un VPS y dejarlo corriendo 24/7.

## Enfoque: arranque mínimo y prudente

Cada empresa arranca con **un solo agente, el CEO**. El CEO propone la estrategia (que tú
apruebas) y **contrata al resto del equipo bajo demanda** cuando el trabajo lo exija. Sin rutinas
automáticas (cron) al principio y con aprobación humana para contratar y para contactar audiencias
o clientes reales. Esto mantiene el gasto bajo control mientras validas.

## Mis dos empresas

| Carpeta | Empresa | Objetivo #1 |
|---|---|---|
| [`companies/crececonia/`](companies/crececonia/) | **crececonia** — marca personal de IA | Crecer comunidad **y** monetizar |
| [`companies/strimo/`](companies/strimo/) | **Strimo.cl** — desarrollo web | Captar clientes nuevos |

Cada carpeta es un **paquete de empresa** importable (arranque mínimo):

```
companies/<empresa>/
├── COMPANY.md                         # Identidad + objetivos (goals)
├── .paperclip.yaml                    # Adaptador, presupuesto, env (solo CEO, sin cron)
├── agents/ceo/AGENTS.md               # El CEO: rol e instrucciones (incl. hire-on-demand)
└── tasks/estrategia-inicial/TASK.md   # Tarea semilla: el CEO propone la estrategia
```

## Despliegue en un VPS (recomendado para 24/7)

Los heartbeats programados solo sirven si el servidor está **siempre encendido**, así que el
destino es un VPS Ubuntu. Pasos:

```sh
# En un VPS Ubuntu limpio, dentro de este repo:
chmod +x scripts/setup-vps.sh
sudo ./scripts/setup-vps.sh          # instala Docker, clona Paperclip, crea .env y arranca

# Luego edita .env y añade tu ANTHROPIC_API_KEY, y reinicia:
docker compose restart paperclip
```

`scripts/setup-vps.sh` deja Paperclip respondiendo en el **puerto 3100** del servidor.
Guía completa de producción (acceso seguro, dominio/HTTPS, Postgres): [`deploy/PRODUCTION.md`](deploy/PRODUCTION.md).

### Probar en tu PC primero (opcional)
```sh
npx paperclipai onboard --yes        # UI/API en http://localhost:3100
```

## Cargar mis dos empresas

Con Paperclip corriendo, importa cada paquete:

```sh
npx paperclipai company import ./companies/crececonia --target new --dry-run   # previsualiza
npx paperclipai company import ./companies/crececonia --target new --new-company-name "crececonia"
npx paperclipai company import ./companies/strimo     --target new --new-company-name "Strimo.cl"
```

> Tras importar, revisa presupuestos y deja los heartbeats programados desactivados hasta confiar
> en el agente (usa "Invoke" para probarlo manualmente).

## Conectar Claude

El adaptador `claude_local` corre el **CLI de Claude Code** donde viva Paperclip (en el VPS): por
eso el CLI `claude` y la `ANTHROPIC_API_KEY` van en el servidor. Carga la clave como **secreto** y
valida cada agente con **"Test Environment"**. Detalles en [`docs/GUIA-PAPERCLIP.md`](docs/GUIA-PAPERCLIP.md).

## Guías

- 📘 **Guía de operación (uso correcto y prudente):** [`docs/GUIA-PAPERCLIP.md`](docs/GUIA-PAPERCLIP.md)
- 🚀 **Despliegue en producción / VPS:** [`deploy/PRODUCTION.md`](deploy/PRODUCTION.md)
- 🔧 **Script de arranque del VPS:** [`scripts/setup-vps.sh`](scripts/setup-vps.sh)

## Documentación de Paperclip
- Repo: https://github.com/paperclipai/paperclip
- Conceptos · Quickstart · Importar/exportar · Spec de paquetes: carpeta `docs/` del repo de Paperclip.
