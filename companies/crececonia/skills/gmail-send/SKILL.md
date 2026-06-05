---
name: gmail-send
description: Prepara y envía correos (newsletter, respuestas) vía Gmail, con aprobación humana para envíos a listas reales.
slug: gmail-send
metadata:
  paperclip:
    tags:
      - email
      - comunidad
---

# Skill: gmail-send

Permite a un agente redactar y enviar correos a través de Gmail.

> **Nota:** Gmail no es una integración nativa de Paperclip. Este skill describe cómo el agente
> debe operar con las herramientas disponibles (servidor MCP de Gmail, API de Gmail vía OAuth, o
> un webhook propio). Requiere credenciales de Google en el entorno
> (`GOOGLE_CLIENT_ID`, `GOOGLE_CLIENT_SECRET`, `GOOGLE_REFRESH_TOKEN`).

## Cuándo usarlo
- Enviar la **newsletter** semanal.
- Responder mensajes de la comunidad.

## Gobernanza (obligatorio)
**Cualquier envío a la lista real o a un cliente requiere aprobación humana.** Prepara el correo
(asunto, cuerpo, destinatarios) y deja la tarea en `in_review`; envía solo tras el visto bueno.

## Entradas
- Asunto y cuerpo (texto aprobado).
- Destinatario(s) o segmento de la lista.

## Pasos sugeridos
1. Redacta asunto + cuerpo con la voz de la marca y un único CTA.
2. Verifica destinatarios y enlaces.
3. Solicita aprobación si es un envío masivo o a clientes.
4. Tras aprobación, envía y **registra el resultado** (enviados, errores) en la tarea.

## Salida
- Confirmación de envío y registro adjunto a la tarea.
