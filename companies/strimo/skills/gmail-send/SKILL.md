---
name: gmail-send
description: Prepara y envía correos de contacto y seguimiento vía Gmail, con aprobación humana para envíos a clientes reales.
slug: gmail-send
metadata:
  paperclip:
    tags:
      - email
      - ventas
---

# Skill: gmail-send

Permite a un agente redactar y enviar correos a leads/clientes a través de Gmail.

> **Nota:** Gmail no es una integración nativa de Paperclip. Este skill describe cómo operar con
> las herramientas disponibles (servidor MCP de Gmail, API de Gmail vía OAuth, o webhook propio).
> Requiere `GOOGLE_CLIENT_ID`, `GOOGLE_CLIENT_SECRET` y `GOOGLE_REFRESH_TOKEN` en el entorno.

## Cuándo usarlo
- Correo de presentación a un lead.
- Envío de propuesta.
- Recordatorios de seguimiento.

## Gobernanza (obligatorio)
**Ningún correo a un cliente real se envía sin aprobación humana.** Prepara el correo y deja la
tarea en `in_review`; envía solo tras el visto bueno.

## Entradas
- Asunto y cuerpo (texto aprobado).
- Destinatario(s) y, si aplica, enlace a la propuesta.

## Pasos sugeridos
1. Personaliza el correo con el nombre y contexto del lead. Un único CTA claro.
2. Verifica destinatario y enlaces.
3. Solicita aprobación.
4. Tras aprobación, envía y **registra el resultado** (enviado, respondido) en la tarea.

## Salida
- Confirmación de envío y registro en la tarea.
