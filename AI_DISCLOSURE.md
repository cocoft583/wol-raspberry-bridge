# Declaración de uso de IA

Este documento explica qué partes del proyecto se hicieron con ayuda de inteligencia artificial y cuáles no.

## Resumen

| | |
|---|---|
| Nivel de uso de IA | Asistencia en el saneamiento y la publicación. La idea y la versión original son obra humana |
| Herramienta | Claude Code (Anthropic), modelo Claude Opus 5.5 |
| Fechas del saneamiento | Del 27 al 30 de octubre de 2026 |
| Revisión humana | El autor revisó y aprobó cada cambio y el commit antes de publicarlo |

## Proyecto original (sin IA)

El proyecto lo diseñé y escribí yo, sin asistencia de IA, entre el **4 y el 15 de marzo de 2025**, en un repositorio privado con **22 commits**. Esa versión ya incluía:

- La idea: usar una Raspberry Pi siempre encendida como puente SSH para enviar paquetes Wake-on-LAN a una torre.
- El script principal con `paramiko` (conexión SSH y ejecución de `wakeonlan` en la Raspberry).
- La separación de datos personales en `config.py` con la plantilla `config_example.py`.
- Los scripts `setup.sh` (entorno virtual, dependencias y alias) y `run_script.sh`.
- El manejo de `Ctrl+C` y el README inicial.

## Por qué el repositorio empieza con un único commit

Al revisar el historial antes de hacerlo público, se encontraron datos de configuración personales en commits antiguos (entre ellos, un archivo `.pyc` compilado que se subió por error). Para no publicarlos, el historial original **no se ha migrado**: este repositorio empieza con un único commit que contiene el estado final del proyecto ya saneado. Los 22 commits originales se conservan solo en privado.

Por eso el historial público no refleja la evolución real del proyecto, que es la descrita en la sección anterior.

## Qué se hizo con ayuda de IA (saneamiento, octubre de 2026)

**Seguridad**

- Auditoría de todo el historial en busca de credenciales, IPs y direcciones MAC.
- Verificación de la clave del host SSH contra `~/.ssh/known_hosts` (`RejectPolicy` en lugar de `AutoAddPolicy`).
- Soporte de autenticación con clave SSH además de contraseña.
- `.gitignore` ampliado (`.venv/`, `__pycache__/`, `*.pyc`) y eliminación del `.pyc` rastreado.

**Código**

- `ScriptMac.py` renombrado a `ScriptPC.py` y preparado para macOS, Linux y Windows (expansión de `~` en la ruta de la clave).
- Corrección del cierre de la conexión en el bloque `finally` y códigos de salida correctos (`0` si el paquete se envía, `1` si falla).
- `run_script.sh` y `setup.sh` usan la ruta del propio script en lugar del directorio actual. `run_script.sh` devuelve el código de salida del script.
- Nuevo `run_script.bat` para Windows y `.gitattributes` para los finales de línea.
- Eliminación de `ScriptRasp.py`, que ya no se usaba.

**Dependencias**

- `requirements.txt` actualizado a las últimas versiones (paramiko 5.1.0, cryptography 50.0.2, etc.) y revisado con `pip-audit`, sin vulnerabilidades conocidas.

**Documentación**

- README ampliado: diagrama de funcionamiento, requisitos, preparación de la Raspberry y la torre, instalación por plataforma, configuración, solución de problemas y seguridad.
- Licencia MIT y este documento.

## Verificación

- Compilación de los scripts de Python y comprobación de sintaxis de los scripts de shell.
- Pruebas contra un servidor SSH falso en local: host desconocido rechazado, envío correcto con clave SSH y error cuando `wakeonlan` falla.
- **No probado** tras el saneamiento: la ejecución contra la Raspberry Pi real y el lanzador `run_script.bat` en Windows.

## Convención

No existe todavía un estándar único para declarar el uso de IA en proyectos de software. Este repositorio sigue dos convenciones habituales:

- Este archivo de declaración en la raíz del proyecto.
- El trailer `Assisted-by:` en los mensajes de los commits hechos con ayuda de IA, como recomienda la guía del kernel de Linux.
