# Blueprint — Strimo.cl

Mapa de cómo el objetivo (**automatizar la captación de clientes**) se convierte en **agentes**,
**proyecto** y **rutinas**.

## Objetivo → Proyecto
- **Automatizar captación** → proyecto `captacion`

## Organigrama (agentes) y pipeline
```
Director comercial (ceo)
├── SDR / Prospección         → skill: deploy-web (landings de campaña)
├── Cualificación de leads
├── Redactor de propuestas    → skill: drive-doc
└── Gestor de correo          → skill: gmail-send
```

| Etapa | Agente | Rol | Qué hace | Skills |
|---|---|---|---|---|
| Prospección | `sdr-prospeccion` | general | Encuentra/recoge leads y publica landings de captación | deploy-web |
| Cualificación | `cualificacion-leads` | researcher | Puntúa y prioriza leads (fit, intención, presupuesto) | — |
| Propuesta | `redactor-propuestas` | general | Redacta propuestas/presupuestos en Google Docs | drive-doc |
| Seguimiento | `gestor-correo` | general | Envía correos de contacto y seguimiento (con aprobación) | gmail-send |
| Cierre | board (humano) | — | Conversación final y firma | — |

## Rutinas (cron → tarea recurrente)
Definidas en `.paperclip.yaml`. Zona horaria: `America/Santiago`.

| Rutina / tarea | Cuándo | Qué hace |
|---|---|---|
| `prospeccion-diaria` | L–V 09:00 | Reúne nuevos leads y prepara material de captación |
| `generar-propuestas` | L–V 11:00 | Crea propuestas para los leads cualificados pendientes |
| `seguimiento-leads` | L–V 14:00 | Prepara correos de seguimiento de leads activos |

## Gobernanza (clave en ventas)
- **Todo contacto a un cliente real (correo, propuesta enviada) requiere aprobación humana.**
  Los agentes preparan; tú apruebas antes de enviar.
- Presupuesto mensual de empresa y por agente en `.paperclip.yaml` (`budgetMonthlyCents`, centavos USD).

## Cómo evolucionar
- Empieza en modo "preparar y revisar"; automatiza el envío solo cuando confíes en la calidad.
- Conecta tu fuente real de leads (formulario, CRM) al agente de prospección.
- Mide tasa de respuesta y conversión por etapa y ajusta los briefs.
