# Memoria del proyecto — Paperclip Agency

Contexto y decisiones para gestionar las dos empresas de agentes con **Paperclip**.
(Idioma de trabajo con el usuario: **español**.)

## Las dos empresas
- **crececonia** (`companies/crececonia/`) — marca personal de IA para negocios y personas.
  - Objetivo #1: **ambos** — crecer comunidad **y** monetizar.
- **Strimo.cl** (`companies/strimo/`) — desarrollo de sitios web.
  - Objetivo #1: **captar clientes**.

## Decisiones clave (acordadas con el usuario)
1. **Arranque mínimo:** cada empresa empieza **solo con el CEO**; el CEO contrata al resto
   **bajo demanda** (hire-on-demand). Sin rutinas cron al principio.
2. **Prudencia/gobernanza:** aprobación humana obligatoria para contratar y antes de
   publicar/contactar audiencias o clientes reales. Presupuestos conservadores (USD 150/mes por
   empresa, USD 120 el CEO; en `budgetMonthlyCents`).
3. **Hoja en blanco:** el repo se rehízo desde cero (se eliminó la estructura previa de 5 agentes,
   skills y projects). Estructura actual por empresa: `COMPANY.md`, `.paperclip.yaml` (claude_local,
   sin cron), `agents/ceo/AGENTS.md`, `tasks/estrategia-inicial/TASK.md`.
4. **Despliegue elegido: VPS** (no PC del usuario), para correr 24/7.
   - Plan: el usuario compra el VPS Ubuntu; Claude corre `scripts/setup-vps.sh` (instala Docker +
     Paperclip + .env), carga `ANTHROPIC_API_KEY` e importa las dos empresas.
   - "Configurar todo primero en el repo, subir al VPS cuando lo compre" — hecho.
   - Pendiente: el usuario aún **no ha comprado el VPS**. Cuando diga "ya lo tengo", retomar.

## Estado del repo
- Rama de trabajo: **`claude/dreamy-dijkstra-P0W99`** (todo el desarrollo y push aquí).
- Infra: `scripts/setup-vps.sh`, `docker-compose.yml`, `.env.example`, `deploy/PRODUCTION.md`.
- Guía de operación: `docs/GUIA-PAPERCLIP.md`.
- Formato de paquetes validado contra el spec `agentcompanies/v1` de Paperclip.

## Notas técnicas
- Adaptador de los CEOs: `claude_local` (corre el CLI `claude` donde viva Paperclip → en el VPS).
- `cwd` y `model` NO se versionan en `.paperclip.yaml` (son específicos de la máquina; se
  configuran en la UI/despliegue).
- VPS recomendado: **mínimo 4 GB RAM** (Claude corre dentro y consume memoria).
- Paperclip escucha en el **puerto 3100**.
