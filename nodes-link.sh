#!/bin/bash

# Colores para los mensajes
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para imprimir mensajes con formato
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Función para verificar si un comando fue exitoso
check_command() {
    if [ $? -eq 0 ]; then
        print_message "$GREEN" "✓ $1"
    else
        print_message "$RED" "✗ $1"
        exit 1
    fi
}

# Directorios principales
N8N_DATA_DIR="./n8n-data"
CUSTOM_NODES_DIR="./n8n-nodes-customs-city"
NODES_DIR="${CUSTOM_NODES_DIR}/nodes"

# Crear directorios si no existen
print_message "$BLUE" "📁 Creando directorios necesarios..."
mkdir -p "${N8N_DATA_DIR}/custom_nodes"
mkdir -p "${CUSTOM_NODES_DIR}/nodes"

# Establecer permisos correctos
print_message "$BLUE" "🔒 Configurando permisos..."
chmod -R 755 "$N8N_DATA_DIR"
chmod -R 755 "$CUSTOM_NODES_DIR"
check_command "Permisos configurados"

# Verificar si hay subdirectorios en /nodes
if [ -z "$(ls -A $NODES_DIR)" ]; then
    print_message "$RED" "⚠️  No se encontraron nodos en $NODES_DIR"
    exit 1
fi

# Procesar cada nodo
print_message "$BLUE" "🔨 Iniciando construcción de nodos..."
for node_dir in "$NODES_DIR"/*; do
    if [ -d "$node_dir" ]; then
        node_name=$(basename "$node_dir")
        print_message "$BLUE" "\n📦 Procesando nodo: $node_name"
        
        # Entrar al directorio del nodo
        cd "$node_dir"
        
        # Instalar dependencias
        print_message "$BLUE" "📥 Instalando dependencias para $node_name..."
        npm install
        check_command "Instalación de dependencias para $node_name"
        
        # Construir el nodo
        print_message "$BLUE" "🛠️  Construyendo $node_name..."
        npm run build
        check_command "Construcción de $node_name"
        
        # Crear enlace simbólico
        print_message "$BLUE" "🔗 Vinculando $node_name..."
        npm link
        check_command "Vinculación de $node_name"
        
        # Enlazar el nodo con n8n
        npm link "$node_name"
        check_command "Enlazando $node_name con n8n"
        
        # Volver al directorio raíz
        cd - > /dev/null
    fi
done

# Crear enlace simbólico en n8n-data
print_message "$BLUE" "🔗 Vinculando nodos con n8n..."
ln -sf "$(pwd)/$CUSTOM_NODES_DIR" "${N8N_DATA_DIR}/custom_nodes/"
check_command "Vinculación con n8n"

print_message "$GREEN" "\n✨ Proceso completado exitosamente!\n"

# Mostrar resumen de nodos procesados
print_message "$BLUE" "📋 Resumen de nodos procesados:"
ls -l "$NODES_DIR" | grep "^d" | awk '{print "   - "$9}'