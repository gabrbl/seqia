#!/bin/bash

# Script para verificar y configurar el dominio seqia.dev
# Ejecutar cuando el dominio esté completamente registrado en Cloud Domains

DOMAIN="seqia.dev"
SERVICE_NAME="seqia-app"
REGION="us-central1"

echo "🌐 Configuración de dominio personalizado para Seqia"
echo "Dominio: $DOMAIN"
echo ""

# 1. Verificar que el dominio esté registrado
echo "1. 🔍 Verificando registro del dominio..."
if gcloud domains registrations describe $DOMAIN &>/dev/null; then
    echo "✅ Dominio $DOMAIN encontrado en Cloud Domains"
    
    # Obtener estado del dominio
    DOMAIN_STATE=$(gcloud domains registrations describe $DOMAIN --format="value(state)")
    echo "   Estado: $DOMAIN_STATE"
    
    if [ "$DOMAIN_STATE" = "ACTIVE" ]; then
        echo "✅ Dominio está activo y listo para usar"
        DOMAIN_READY=true
    else
        echo "⚠️  Dominio no está en estado ACTIVE. Estado actual: $DOMAIN_STATE"
        echo "   Espera a que el dominio esté completamente registrado"
        DOMAIN_READY=false
    fi
else
    echo "❌ Dominio $DOMAIN no encontrado en Cloud Domains"
    echo ""
    echo "📋 Pasos para registrar el dominio:"
    echo "1. Ve a: https://console.cloud.google.com/net-services/domains"
    echo "2. Registra el dominio $DOMAIN"
    echo "3. Espera a que el estado sea 'ACTIVE'"
    echo "4. Ejecuta este script nuevamente"
    exit 1
fi

echo ""

# 2. Verificar que el servicio Cloud Run existe
echo "2. 🔍 Verificando servicio Cloud Run..."
if gcloud run services describe $SERVICE_NAME --region=$REGION &>/dev/null; then
    echo "✅ Servicio $SERVICE_NAME encontrado"
    SERVICE_URL=$(gcloud run services describe $SERVICE_NAME --region=$REGION --format="value(status.url)")
    echo "   URL: $SERVICE_URL"
else
    echo "❌ Servicio $SERVICE_NAME no encontrado"
    echo "   Primero despliega tu aplicación"
    exit 1
fi

echo ""

# 3. Mapear dominio si está listo
if [ "$DOMAIN_READY" = true ]; then
    echo "3. 🔗 Mapeando dominio a Cloud Run..."
    
    # Verificar si ya está mapeado
    if gcloud beta run domain-mappings describe $DOMAIN --region=$REGION &>/dev/null; then
        echo "✅ Dominio ya está mapeado"
    else
        echo "📡 Creando mapeo de dominio..."
        gcloud beta run domain-mappings create \
            --service $SERVICE_NAME \
            --domain $DOMAIN \
            --region $REGION
        
        if [ $? -eq 0 ]; then
            echo "✅ Dominio mapeado exitosamente"
        else
            echo "❌ Error mapeando dominio"
            echo "💡 Verifica los permisos y el estado del dominio"
            exit 1
        fi
    fi
    
    echo ""
    
    # 4. Obtener registros DNS
    echo "4. 📋 Registros DNS para configurar en Cloud Domains:"
    echo ""
    
    # Esperar un momento para que se generen los registros
    sleep 5
    
    gcloud beta run domain-mappings describe $DOMAIN --region=$REGION --format="table(status.resourceRecords[].name,status.resourceRecords[].type,status.resourceRecords[].rrdata)" --flatten="status.resourceRecords[]"
    
    echo ""
    echo "📝 Configuración de DNS en Cloud Domains:"
    echo "1. Ve a: https://console.cloud.google.com/net-services/domains"
    echo "2. Selecciona: $DOMAIN"
    echo "3. Ve a la pestaña 'DNS'"
    echo "4. Agrega los registros mostrados arriba"
    echo "5. Espera la propagación (hasta 48 horas)"
    
    echo ""
    echo "🎉 ¡Configuración completada!"
    echo ""
    echo "🔗 URLs finales:"
    echo "   Cloud Run: $SERVICE_URL"
    echo "   Dominio personalizado: https://$DOMAIN (después de la propagación DNS)"
    
else
    echo "3. ⏭️  Dominio no está listo para mapear"
    echo "   Espera a que el estado sea 'ACTIVE' y ejecuta este script nuevamente"
fi
