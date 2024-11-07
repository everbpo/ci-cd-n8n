# Usar Ubuntu 22.04 como base
FROM ubuntu:22.04

# Actualizar e instalar dependencias necesarias
RUN apt-get update && \
    apt-get install -y curl gnupg build-essential && \
    rm -rf /var/lib/apt/lists/*

# Instalar Node.js versión 20.x
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# Establecer el directorio de trabajo
WORKDIR /home/node

# Copiar n8n-nodes-customs-city al contenedor
COPY n8n-nodes-customs-city /home/node/n8n-nodes-customs-city

# Instalar n8n globalmente
RUN npm install -g n8n

# Copiar y ejecutar el script de enlace
COPY nodes-link.sh /home/node/nodes-link.sh
RUN chmod +x /home/node/nodes-link.sh
RUN /home/node/nodes-link.sh

# Exponer el puerto por defecto de n8n
EXPOSE 5678

# Ejecutar n8n
CMD ["n8n"]