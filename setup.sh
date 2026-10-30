#!/bin/bash

# Carpeta donde vive este script, para que funcione lanzado desde cualquier sitio
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Nombre del entorno virtual
VENV_NAME="$SCRIPT_DIR/.venv"

echo "Creando el entorno virtual..."
python3 -m venv "$VENV_NAME"

echo "Activando el entorno virtual..."
source "$VENV_NAME/bin/activate"

echo "Instalando dependencias..."
pip install -r "$SCRIPT_DIR/requirements.txt"

deactivate # Desactivar el entorno virtual

# -n no sobreescribe el archivo si ya existe, 2>/dev/null redirige los errores a /dev/null, || ejecuta el comando si el anterior falla
echo "Configurando el archivo de configuración..."
cp -n "$SCRIPT_DIR/src/config_example.py" "$SCRIPT_DIR/src/config.py" 2>/dev/null || echo "config.py ya existe, omitiendo copia."

echo "Añadiendo alias al shell..."
if [[ $SHELL == *"zsh"* ]]; then
    SHELL_RC="$HOME/.zshrc"
elif [[ $SHELL == *"bash"* ]]; then
    SHELL_RC="$HOME/.bashrc"
else
    echo "Shell no reconocido. Añade el alias manualmente."
    exit 1
fi

# grep -Fxq busca la línea exacta en el archivo, si no la encuentra, la añade
# -F cadena literal, -x línea completa, -q no imprime nada
ALIAS_CMD="alias wake_rasp='$SCRIPT_DIR/run_script.sh'"
if ! grep -Fxq "$ALIAS_CMD" "$SHELL_RC" 2>/dev/null; then
    echo "$ALIAS_CMD" >> "$SHELL_RC"
    echo "Alias añadido en $SHELL_RC (abre una terminal nueva o ejecuta: source $SHELL_RC)"
else
    echo "Alias ya existente, omitiendo..."
fi

echo "Setup completo. Edita src/config.py con tus datos y usa 'wake_rasp' para ejecutar el script."
