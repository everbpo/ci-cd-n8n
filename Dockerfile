

# Usar Ubuntu 22.04 como base
FROM ubuntu:22.04

# Actualizar e instalar todas las dependencias necesarias
RUN apt-get update && \
    apt-get install -y \
    curl \
    gnupg \
    build-essential \
    tree \
    nano \
    apt-utils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Instalar Node.js versión 20.x
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get update && \
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Establecer el directorio de trabajo
WORKDIR /home/node

# Copiar n8n-nodes-customs-city al contenedor
COPY ./n8n-nodes-customs-city /home/node/.n8n/n8n-nodes-customs-city/

# Instalar n8n globalmente
RUN npm install -g n8n

# Copiar y ejecutar el script de enlace
COPY ./nodes-link.sh /home/node/.n8n/nodes-link.sh
RUN chmod +x /home/node/.n8n/nodes-link.sh

# Debug: Mostrar estructura antes de ejecutar
RUN tree /home/node

# Ejecutar script
RUN /home/node/.n8n/nodes-link.sh

# Establecer variable de entorno para n8n
ENV N8N_CUSTOM_EXTENSIONS="/home/node/.n8n/"

# Exponer el puerto por defecto de n8n
EXPOSE 5678

# Ejecutar n8n
CMD ["n8n"]
