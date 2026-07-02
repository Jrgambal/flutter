# Agente Claude 24/7 (VPS)

Un demonio Python que corre permanentemente en tu servidor y ejecuta tareas
con Claude de forma autónoma. El **propósito del agente lo defines tú** editando
un solo archivo (`prompt/system.md`) — el resto de la infraestructura ya está lista.

## Arquitectura

```
                        VPS (siempre encendido)
┌─────────────────────────────────────────────────────────────┐
│  systemd ──reinicia si muere──▶ daemon.py (bucle infinito)  │
│                                     │                       │
│  tasks/inbox/*.md  ──se detectan──▶ │                       │
│  (tú, cron, u otro proceso          │  API de Anthropic     │
│   dejan tareas aquí)                ▼                       │
│                              bucle agéntico ◀──────────────▶│── Claude
│                              (tool runner)                  │   (claude-opus-4-8)
│                                     │                       │
│                    herramientas: run_command, save_report   │
│                                     │                       │
│  tasks/done/  ◀──resultado──────────┘                       │
└─────────────────────────────────────────────────────────────┘
```

- **`daemon.py`** — el bucle: vigila `tasks/inbox/`, procesa cada tarea y deja
  el resultado en `tasks/done/`. Errores recuperables (rate limit, caída de red,
  5xx) se reintentan en el siguiente ciclo; los no recuperables van a `tasks/failed/`.
- **`tools.py`** — las manos del agente. Trae dos de ejemplo (shell con lista
  blanca y guardado de informes); añade las tuyas con el decorador `@beta_tool`.
- **`prompt/system.md`** — el cerebro/misión. Se relee en cada ciclo: puedes
  cambiar el comportamiento del agente sin reiniciar el servicio.

## Instalación en el VPS

```bash
# 1. Usuario dedicado y código
sudo useradd -r -m -d /opt/claude-agent claude-agent
sudo -u claude-agent git clone <este-repo> /opt/claude-agent
cd /opt/claude-agent

# 2. Entorno Python
sudo -u claude-agent python3 -m venv .venv
sudo -u claude-agent .venv/bin/pip install -r requirements.txt

# 3. Credenciales
sudo -u claude-agent cp .env.example .env
sudo -u claude-agent nano .env   # pega tu ANTHROPIC_API_KEY

# 4. Servicio 24/7
sudo cp deploy/claude-agent.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now claude-agent
journalctl -u claude-agent -f    # ver logs en vivo
```

## Cómo darle trabajo

Una tarea es simplemente un archivo de texto en la bandeja de entrada:

```bash
echo "Revisa el uso de disco del servidor y genera un informe con save_report" \
  > /opt/claude-agent/tasks/inbox/revisar-disco.md
```

Para **tareas recurrentes**, usa cron para dejar la tarea en la bandeja:

```cron
# Informe diario a las 8:00
0 8 * * * echo "Genera el informe diario del sistema" > /opt/claude-agent/tasks/inbox/diario-$(date +\%F).md
```

Cualquier otro sistema (un webhook, un bot de Telegram, otro script) puede
alimentar al agente escribiendo archivos en `tasks/inbox/`.

## Elección de modelo y costes

Precios por millón de tokens (entrada / salida):

| Modelo | ID | Precio | Cuándo usarlo |
|---|---|---|---|
| Claude Opus 4.8 | `claude-opus-4-8` | $5 / $25 | Por defecto: tareas complejas y agénticas |
| Claude Sonnet 5 | `claude-sonnet-5` | $3 / $15 (intro $2 / $10 hasta 31-08-2026) | Alto volumen con gran calidad |
| Claude Haiku 4.5 | `claude-haiku-4-5` | $1 / $5 | Clasificación y tareas simples |

Cambia el modelo en `.env` (`AGENT_MODEL`). Orientación de coste: una tarea
típica de unos 5K tokens de entrada y 2K de salida con Opus 4.8 cuesta ~$0.075;
con Haiku, ~$0.015.

## Seguridad

- `run_command` usa **lista blanca de comandos** (`ALLOWED_COMMANDS` en
  `tools.py`). Amplíala solo con lo que el agente realmente necesite.
- El servicio corre con un usuario sin privilegios y endurecimiento de systemd.
- La clave API vive en `.env` (permisos 600), nunca en el código ni en el prompt.

## Cómo extenderlo

- **Nuevas herramientas**: añade funciones con `@beta_tool` en `tools.py` y
  regístralas en `TOOLS` (enviar emails, consultar tu base de datos, llamar a
  tus APIs...).
- **Búsqueda web**: añade `{"type": "web_search_20260209", "name": "web_search"}`
  a la lista de tools para que el agente pueda buscar en internet (herramienta
  de servidor, no requiere código local).
- **Alternativa sin servidor**: si algún día no quieres mantener el VPS,
  Anthropic ofrece *Managed Agents* con despliegues programados (cron gestionado)
  donde ellos hospedan el bucle y el contenedor del agente.
