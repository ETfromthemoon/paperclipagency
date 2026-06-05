# Despliegue en producción

Guía para dejar Paperclip funcionando de forma estable (no solo en tu portátil) y conectar
los servicios de **crececonia** y **Strimo.cl**.

## 1. Dónde alojarlo

Paperclip es un servidor Node.js + Postgres. Opciones, de más simple a más control:

| Opción | Cuándo | Notas |
|---|---|---|
| **VPS** (Hetzner, DigitalOcean, Contabo…) + Docker | Recomendado | Control total, siempre encendido. Usa `docker-compose.yml`. |
| Tu máquina con `npx paperclipai run` | Pruebas | Se apaga al cerrar el equipo. |
| AWS ECS | Escala/empresa | Ver `docs/deploy/aws-ecs.md` en el repo de Paperclip. |

> **Importante:** las plataformas serverless (Vercel/Netlify) **no** son adecuadas para el
> *servidor* de Paperclip, porque los agentes necesitan procesos de larga duración y estado.
> Vercel/Netlify aquí se usan para **publicar los sitios web de Strimo**, no para alojar Paperclip.

## 2. Base de datos

- **Dev / arranque:** PostgreSQL embebido (PGlite). No configures nada; deja `DATABASE_URL` vacío.
- **Producción:** apunta a un Postgres gestionado (Neon, Supabase, RDS) con `DATABASE_URL`.
  Descomenta el servicio `db` del `docker-compose.yml` o usa uno externo.

## 3. Modo de despliegue y acceso seguro

Para acceder de forma autenticada (no exponer la UI a internet sin protección), usa los
presets de "bind" del onboarding:

```sh
npx paperclipai onboard --yes --bind lan       # accesible en tu red local
npx paperclipai onboard --yes --bind tailnet   # accesible solo por tu Tailscale (recomendado)
```

Con Docker, las variables ya van en modo `authenticated` + `private`. Pon un
`BETTER_AUTH_SECRET` largo y aleatorio (`openssl rand -hex 32`). Detrás de un dominio, usa
HTTPS con un reverse proxy (Caddy/Nginx/Traefik) y fija `PAPERCLIP_PUBLIC_URL`.

## 4. Secretos y claves

- Rellena `.env` (a partir de `.env.example`). **Nunca** se commitea.
- `ANTHROPIC_API_KEY` para el adaptador Claude (o login por suscripción en el CLI `claude`).
- Tokens de Canva / Google / Vercel / Netlify solo si usas esos skills.
- Paperclip cifra los secretos en reposo; introdúcelos por la UI/onboarding cuando sea posible
  en lugar de dejarlos en texto plano.

## 5. Conectar el adaptador Claude

El adaptador `claude_local` ejecuta el **CLI de Claude Code** dentro del entorno de Paperclip:

1. Asegúrate de que `claude` esté instalado (la imagen Docker ya lo incluye).
2. Define `ANTHROPIC_API_KEY` o haz login por suscripción.
3. En la UI, abre cada agente → **Test Environment** para validar (comprueba CLI, cwd y un
   "hello" en vivo).

## 6. Cargar las empresas

```sh
npx paperclipai company import ./companies/crececonia --target new --new-company-name "crececonia" --dry-run
npx paperclipai company import ./companies/crececonia --target new --new-company-name "crececonia"
npx paperclipai company import ./companies/strimo     --target new --new-company-name "Strimo.cl"
```

Tras importar, **reactiva los heartbeats programados** desde la UI (entran desactivados por
seguridad) y revisa los presupuestos.

## 7. Checklist de puesta en marcha
- [ ] `BETTER_AUTH_SECRET` aleatorio y `DATABASE_URL` (si Postgres externo).
- [ ] `ANTHROPIC_API_KEY` válida y `Test Environment` en verde para los agentes Claude.
- [ ] Empresas importadas y visibles en `GET /api/companies`.
- [ ] Presupuestos mensuales revisados (en `.paperclip.yaml` o en la UI).
- [ ] Puertas de aprobación activas para acciones sensibles (correo a clientes, contrataciones).
- [ ] Heartbeats reactivados solo cuando estés conforme con cada agente.
