---
name: deploy-web
description: Publica o actualiza landings de captación en Vercel o Netlify y devuelve la URL.
slug: deploy-web
metadata:
  paperclip:
    tags:
      - web
      - captación
---

# Skill: deploy-web

Permite a un agente **publicar o actualizar sitios/landings** en Vercel o Netlify.

> **Nota:** el deploy no es una integración nativa de Paperclip. Este skill describe cómo operar
> con las herramientas disponibles (CLI de Vercel/Netlify, sus APIs, o un servidor MCP). Requiere
> `VERCEL_TOKEN` o `NETLIFY_AUTH_TOKEN` en el entorno del agente.

## Cuándo usarlo
- Publicar una **landing de campaña** para captar leads.
- Actualizar una página existente (copy, formulario, oferta).

## Entradas
- Contenido/copy aprobado de la landing y objetivo de la campaña.
- Repositorio o directorio del sitio, y plataforma destino (Vercel o Netlify).

## Pasos sugeridos
1. Prepara el contenido de la landing (gancho, beneficio, prueba social, formulario, CTA).
2. Despliega con la plataforma elegida (`vercel deploy` / `netlify deploy`) usando el token.
3. Verifica que la URL carga y que el formulario captura leads correctamente.
4. **Devuelve la URL** y el estado del deploy en la tarea.

## Gobernanza
- Si la landing es pública y representa a la marca Strimo, deja el deploy en **preview** y pide
  aprobación humana antes de promover a producción.

## Salida
- URL publicada (preview o producción) y registro del deploy en la tarea.
