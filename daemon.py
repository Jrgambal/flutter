"""Agente 24/7 — demonio que ejecuta tareas con Claude en un VPS.

Funcionamiento:
  1. Vigila el directorio tasks/inbox/ en busca de archivos .md o .txt.
  2. Cada archivo es una tarea: se la pasa a Claude junto con el prompt de
     sistema (prompt/system.md), que define la misión del agente.
  3. Claude puede usar las herramientas definidas en tools.py (shell,
     guardar informes, etc.) hasta completar la tarea.
  4. El resultado se escribe en tasks/done/<nombre>.result.md y la tarea
     original se archiva. Si falla de forma no recuperable, va a tasks/failed/.

El proceso corre para siempre; systemd lo reinicia si muere (ver
deploy/claude-agent.service).
"""

import logging
import os
import shutil
import time
from pathlib import Path

import anthropic

from tools import TOOLS

BASE_DIR = Path(__file__).resolve().parent
INBOX = BASE_DIR / "tasks" / "inbox"
DONE = BASE_DIR / "tasks" / "done"
FAILED = BASE_DIR / "tasks" / "failed"
SYSTEM_PROMPT_FILE = BASE_DIR / "prompt" / "system.md"

MODEL = os.environ.get("AGENT_MODEL", "claude-opus-4-8")
POLL_SECONDS = int(os.environ.get("AGENT_POLL_SECONDS", "30"))
MAX_TOKENS = int(os.environ.get("AGENT_MAX_TOKENS", "16000"))

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(message)s",
)
log = logging.getLogger("agente-24-7")


def run_task(client: anthropic.Anthropic, system_prompt: str, task_text: str) -> str:
    """Ejecuta una tarea con el bucle agéntico (tool runner) y devuelve el texto final."""
    runner = client.beta.messages.tool_runner(
        model=MODEL,
        max_tokens=MAX_TOKENS,
        system=system_prompt,
        thinking={"type": "adaptive"},
        tools=TOOLS,
        messages=[{"role": "user", "content": task_text}],
    )
    parts = []
    for message in runner:
        for block in message.content:
            if block.type == "text" and block.text.strip():
                parts.append(block.text)
    return "\n\n".join(parts)


def process_file(client: anthropic.Anthropic, system_prompt: str, task_file: Path) -> None:
    log.info("Procesando tarea: %s", task_file.name)
    task_text = task_file.read_text(encoding="utf-8")
    try:
        result = run_task(client, system_prompt, task_text)
    except anthropic.RateLimitError:
        log.warning("Rate limit; la tarea %s se reintentará en el próximo ciclo", task_file.name)
        return
    except anthropic.APIStatusError as e:
        if e.status_code >= 500:
            log.warning("Error %s del servidor; se reintentará: %s", e.status_code, task_file.name)
            return
        log.error("Error no recuperable (%s) en %s: %s", e.status_code, task_file.name, e.message)
        shutil.move(str(task_file), FAILED / task_file.name)
        (FAILED / f"{task_file.stem}.error.txt").write_text(str(e), encoding="utf-8")
        return
    except anthropic.APIConnectionError:
        log.warning("Sin conexión; la tarea %s se reintentará", task_file.name)
        return

    (DONE / f"{task_file.stem}.result.md").write_text(result, encoding="utf-8")
    shutil.move(str(task_file), DONE / task_file.name)
    log.info("Tarea completada: %s", task_file.name)


def main() -> None:
    for d in (INBOX, DONE, FAILED):
        d.mkdir(parents=True, exist_ok=True)

    client = anthropic.Anthropic()  # lee ANTHROPIC_API_KEY del entorno
    log.info("Agente iniciado. Modelo: %s. Vigilando %s cada %ss", MODEL, INBOX, POLL_SECONDS)

    while True:
        system_prompt = SYSTEM_PROMPT_FILE.read_text(encoding="utf-8")
        pending = sorted(
            (f for f in INBOX.iterdir() if f.is_file() and f.suffix in (".md", ".txt")),
            key=lambda f: f.stat().st_mtime,
        )
        for task_file in pending:
            process_file(client, system_prompt, task_file)
        time.sleep(POLL_SECONDS)


if __name__ == "__main__":
    main()
