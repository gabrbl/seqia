#!/bin/bash

# Script unificado para todas las configuraciones de Seqia
# Maneja automáticamente la clonación/actualización del repositorio

echo "🚀 Script de configuración unificado para Seqia"
echo ""

# Función para clonar o actualizar repositorio
setup_repository() {
    if [ -d "seqia" ]; then
        echo "📁 Directorio seqia ya existe, actualizando..."
        cd seqia
        git pull origin main
        echo "✅ Repositorio actualizado"
    else
        echo "📥 Clonando repositorio..."
        git clone https://github.com/gabrbl/seqia.git
        cd seqia
        echo "✅ Repositorio clonado"
    fi
}

# Función para mostrar el menú
show_menu() {
    echo ""
    echo "🔧 ¿Qué quieres hacer?"
    echo "1) Configurar permisos de Google Cloud (ejecutar una vez)"
    echo "2) Configuración post-despliegue (después de cada build)"
    echo "3) Configurar dominio personalizado (cuando esté registrado)"
    echo "4) Ver estado actual"
    echo "5) Salir"
    echo ""
    read -p "Selecciona una opción (1-5): " choice
}

# Función para configurar permisos
setup_permissions() {
    echo ""
    echo "🔐 Configurando permisos de Google Cloud..."
    chmod +x setup-gcloud.sh
    ./setup-gcloud.sh
}

# Función para post-despliegue
post_deploy() {
    echo ""
    echo "🔧 Ejecutando configuración post-despliegue..."
    chmod +x post-deploy.sh
    ./post-deploy.sh
}

# Función para configurar dominio
setup_domain() {
    echo ""
    echo "🌐 Configurando dominio personalizado..."
    chmod +x setup-domain-complete.sh
    ./setup-domain-complete.sh
}

# Función para mostrar estado
show_status() {
    echo ""
    echo "📊 Estado actual del proyecto:"
    echo ""
    
    # Verificar servicio Cloud Run
    if gcloud run services describe seqia-app --region=us-central1 &>/dev/null; then
        SERVICE_URL=$(gcloud run services describe seqia-app --region=us-central1 --format="value(status.url)")
        echo "✅ Aplicación desplegada: $SERVICE_URL"
    else
        echo "❌ Aplicación no desplegada en Cloud Run"
    fi
    
    # Verificar dominio
    if gcloud domains registrations describe seqia.dev &>/dev/null; then
        DOMAIN_STATE=$(gcloud domains registrations describe seqia.dev --format="value(state)")
        echo "📍 Dominio seqia.dev: $DOMAIN_STATE"
    else
        echo "📍 Dominio seqia.dev: No registrado"
    fi
    
    # Verificar mapeo de dominio
    if gcloud beta run domain-mappings describe seqia.dev --region=us-central1 &>/dev/null; then
        echo "🔗 Mapeo de dominio: Configurado"
    else
        echo "🔗 Mapeo de dominio: No configurado"
    fi
}

# Script principal
main() {
    # Cambiar al directorio home si no estamos en el directorio correcto
    cd ~ 2>/dev/null
    
    # Configurar repositorio
    setup_repository
    
    # Mostrar menú hasta que el usuario salga
    while true; do
        show_menu
        
        case $choice in
            1)
                setup_permissions
                ;;
            2)
                post_deploy
                ;;
            3)
                setup_domain
                ;;
            4)
                show_status
                ;;
            5)
                echo "👋 ¡Hasta luego!"
                exit 0
                ;;
            *)
                echo "❌ Opción inválida, intenta nuevamente"
                ;;
        esac
        
        echo ""
        read -p "Presiona Enter para continuar..."
    done
}

# Ejecutar script principal
main
