---
name: canva-design
description: Genera y edita piezas visuales de marca (carruseles, miniaturas, gráficos) en Canva a partir de texto aprobado.
slug: canva-design
metadata:
  paperclip:
    tags:
      - contenido
      - diseño
---

# Skill: canva-design

Permite a un agente crear contenido visual coherente con la marca usando Canva.

> **Nota:** Canva no es una integración nativa de Paperclip. Este skill describe cómo el agente
> debe producir el diseño con las herramientas disponibles en su entorno (servidor MCP de Canva,
> API de Canva, o un webhook propio). Requiere `CANVA_API_TOKEN` en el entorno del agente.

## Cuándo usarlo
Cuando una pieza de contenido aprobada necesita un visual: carrusel, miniatura o gráfico.

## Entradas
- Texto/copy aprobado y objetivo de la pieza.
- Formato y canal (p. ej. carrusel cuadrado, miniatura 16:9).
- Guía de marca (colores, tipografía, logo) si existe.

## Pasos sugeridos
1. Selecciona o crea una plantilla acorde a la identidad de crececonia.
2. Vuelca el texto aprobado y ajusta jerarquía visual (gancho legible, una idea por slide).
3. Exporta la pieza y **adjunta el enlace/archivo a la tarea**.
4. Deja la tarea en `in_review` para validación humana antes de publicar.

## Salida
- Enlace o archivo exportado de la pieza final, vinculado en la tarea.

## Buenas prácticas
- Consistencia de marca por encima de la novedad.
- Texto mínimo y legible en móvil.
- No publiques directamente; el diseño pasa por revisión.
