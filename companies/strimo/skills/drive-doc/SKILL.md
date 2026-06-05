---
name: drive-doc
description: Crea y edita documentos (propuestas, presupuestos) en Google Docs/Drive y devuelve el enlace.
slug: drive-doc
metadata:
  paperclip:
    tags:
      - documentos
      - propuestas
---

# Skill: drive-doc

Permite a un agente crear y editar documentos en Google Docs/Drive (p. ej. propuestas).

> **Nota:** Google Drive no es una integración nativa de Paperclip. Este skill describe cómo
> operar con las herramientas disponibles (servidor MCP de Google Drive, API de Drive/Docs vía
> OAuth, o webhook propio). Requiere credenciales de Google en el entorno (`GOOGLE_REFRESH_TOKEN`).

## Cuándo usarlo
- Generar una **propuesta/presupuesto** personalizado para un lead.
- Mantener plantillas reutilizables de propuesta.

## Entradas
- Datos del lead y de la oportunidad (necesidad, alcance, plazos, precio).
- Plantilla de propuesta si existe.

## Pasos sugeridos
1. Parte de la plantilla de propuesta de Strimo (o créala si no existe).
2. Rellena: contexto → solución → alcance/entregables → plazos → inversión → siguientes pasos.
3. Guarda en la carpeta de Drive del cliente y **devuelve el enlace** en la tarea.
4. Deja la tarea en `in_review` (no se envía sin aprobación).

## Salida
- Enlace al documento de propuesta, vinculado en la tarea.
