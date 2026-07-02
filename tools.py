"""Herramientas que el agente puede usar. Añade aquí las tuyas con @beta_tool.

El SDK genera el esquema JSON automáticamente a partir de la firma y el
docstring de cada función.
"""

import subprocess
from pathlib import Path

from anthropic import beta_tool

REPORTS_DIR = Path(__file__).resolve().parent / "reports"

# Comandos permitidos para run_command. Amplía la lista según lo que tu
# agente necesite; mantenerla corta limita el daño si el agente se equivoca.
ALLOWED_COMMANDS = {"ls", "cat", "df", "du", "uptime", "free", "curl", "git", "grep", "tail", "head"}


@beta_tool
def run_command(command: str) -> str:
    """Ejecuta un comando de shell en el servidor y devuelve su salida.

    Solo se permiten los comandos de la lista blanca del agente. Úsalo para
    inspeccionar el sistema, consultar APIs con curl, leer logs, etc.

    Args:
        command: Línea de comando completa a ejecutar (ej. "df -h").
    """
    executable = command.strip().split()[0] if command.strip() else ""
    if executable not in ALLOWED_COMMANDS:
        return f"Error: el comando '{executable}' no está en la lista blanca ({sorted(ALLOWED_COMMANDS)})."
    try:
        result = subprocess.run(
            command, shell=True, capture_output=True, text=True, timeout=120
        )
    except subprocess.TimeoutExpired:
        return "Error: el comando superó el límite de 120 segundos."
    output = (result.stdout + result.stderr).strip()
    return f"exit_code={result.returncode}\n{output[:20000]}"


@beta_tool
def save_report(filename: str, content: str) -> str:
    """Guarda un informe o resultado en el directorio reports/ del agente.

    Args:
        filename: Nombre del archivo, ej. "informe-diario.md". Sin rutas.
        content: Contenido completo del archivo.
    """
    safe_name = Path(filename).name
    if not safe_name or safe_name in (".", ".."):
        return "Error: nombre de archivo inválido."
    REPORTS_DIR.mkdir(exist_ok=True)
    path = REPORTS_DIR / safe_name
    path.write_text(content, encoding="utf-8")
    return f"Guardado en {path}"


TOOLS = [run_command, save_report]
