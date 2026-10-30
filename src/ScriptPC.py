import logging
import os
import signal
import sys
from socket import gaierror

import paramiko

import config

logging.basicConfig(level=logging.INFO, format="%(levelname)s: %(message)s")


def signal_handler(sig, frame):
    print("\nInterrupción por teclado detectada. Saliendo...")
    sys.exit(0)


signal.signal(signal.SIGINT, signal_handler)

# Ajustes opcionales: si no existen en config.py se usan los valores por defecto,
# de modo que un config.py antiguo sigue funcionando.
key_path = getattr(config, "raspberry_key_path", None)
if key_path:
    # Admite "~/.ssh/id_ed25519" en macOS, Linux y Windows
    key_path = os.path.expanduser(key_path)
password = getattr(config, "raspberry_password", None)

ssh = None
exit_code = 0

try:
    logging.info("Conectando por ssh...")
    ssh = paramiko.SSHClient()

    # Verifica la clave del host contra ~/.ssh/known_hosts (evita ataques
    # de intermediario). La primera vez hay que conectar a mano:
    #   ssh -p <puerto> <usuario>@<ip>
    ssh.load_system_host_keys()
    ssh.set_missing_host_key_policy(paramiko.RejectPolicy())

    ssh.connect(
        config.raspberry_ip,
        port=config.ssh_port,
        username=config.raspberry_user,
        key_filename=key_path,  # clave SSH (recomendado); None = no usar
        password=password,      # alternativa si no hay clave
        timeout=10,
    )
    logging.info("Conexion establecida!")

    stdin, stdout, stderr = ssh.exec_command(f"wakeonlan {config.mac_address}")
    status = stdout.channel.recv_exit_status()
    logging.info(stdout.read().decode().strip())

    if status == 0:
        logging.info("Paquete enviado correctamente!")
    else:
        logging.error(f"wakeonlan terminó con código {status}: {stderr.read().decode().strip()}")
        exit_code = 1

except paramiko.SSHException as e:
    logging.error(f"Error de SSH: {e}")
    logging.error(f"Tipo de error: {type(e).__name__}")
    exit_code = 1

except gaierror as e:
    logging.error(f"Error de conexión: {e}")
    logging.error(f"Tipo de error: {type(e).__name__}")
    exit_code = 1

except Exception as e:
    logging.error(f"Error desconocido: {e}")
    logging.error(f"Tipo de error: {type(e).__name__}")
    exit_code = 1

finally:
    if ssh is not None:
        ssh.close()

sys.exit(exit_code)
