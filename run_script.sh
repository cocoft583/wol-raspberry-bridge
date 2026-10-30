#!/bin/bash

# Carpeta donde vive este script, para que funcione lanzado desde cualquier sitio
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Función para manejar la interrupción por teclado
function handle_interrupt {
    echo "Interrupción por teclado detectada. Desactivando el entorno virtual..."
    deactivate
    exit 1
}

# Capturar la señal SIGINT (Ctrl+C)
trap handle_interrupt SIGINT

# Activar el entorno virtual
source "$SCRIPT_DIR/.venv/bin/activate"
echo "Entorno virtual activado..."

# Ejecutar ScriptPC.py y guardar su código de salida
python "$SCRIPT_DIR/src/ScriptPC.py"
STATUS=$?

# Desactivar el entorno virtual
deactivate
echo "Entorno virtual desactivado..."
exit $STATUS
