# config_example.py
raspberry_ip = "your_raspberry_ip"  # Dirección IP de la Raspberry
raspberry_user = "your_username"  # Usuario de la Raspberry
mac_address = "your_mac_address"  # Dirección MAC de la torre
ssh_port = 22  # Puerto de SSH de la Raspberry

# Autenticación: usa clave SSH (recomendado) o contraseña. Con una basta.
raspberry_key_path = None  # Ruta a tu clave privada, p. ej. "~/.ssh/id_ed25519"
raspberry_password = None  # Solo si no usas clave SSH
