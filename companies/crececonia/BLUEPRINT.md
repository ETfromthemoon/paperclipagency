# Blueprint — crececonia

Mapa de cómo los **objetivos** se convierten en **agentes**, **proyectos** y **rutinas**.

## Objetivos → Proyectos
- **Aumentar comunidad** → proyecto `comunidad`
- **Monetizar** → proyecto `monetizacion`

## Organigrama (agentes)
```
Director/a crececonia (ceo)
├── Estratega de contenido (cmo)
│   ├── Redactor / Guionista
│   └── Diseñador visual        → skill: canva-design
└── Community & Email           → skill: gmail-send
```

| Agente | Rol | Para qué | Skills |
|---|---|---|---|
| `ceo` | ceo | Estrategia, prioriza objetivos, aprueba el plan, delega | — |
| `estratega-contenido` | cmo | Líneas editoriales, temas, calendario, ofertas | — |
| `redactor` | general | Posts, guiones, newsletter, copys | — |
| `disenador-visual` | designer | Carruseles, miniaturas, gráficos de marca | canva-design |
| `community-email` | general | Programar, responder comunidad, newsletter por email | gmail-send |

## Rutinas (cron → tarea recurrente)
Definidas en `.paperclip.yaml`. Zona horaria: `America/Santiago`.

| Rutina / tarea | Cuándo | Qué hace |
|---|---|---|
| `calendario-editorial` | Lunes 09:00 | Planifica los temas y formatos de la semana |
| `borradores-diarios` | L–V 08:00 | Genera borradores de contenido del día |
| `informe-metricas` | Viernes 18:00 | Resume métricas de la semana y propone mejoras |

## Presupuesto y gobernanza
- Límite mensual de la empresa y por agente en `.paperclip.yaml` (`budgetMonthlyCents`, en centavos USD).
- **Aprobación humana** recomendada antes de **publicar** o **enviar la newsletter** a la lista real.

## Cómo evolucionar
- Empieza con los borradores en modo "para revisión" hasta que confíes en el tono.
- Cuando una oferta funcione, crea un proyecto/tarea específico para escalarla.
- Sube el presupuesto del agente que más valor aporte.
