#!/bin/bash

# Script para configuraciones post-despliegue
# Ejecutar después de que Cloud Build haya desplegado la aplicación

SERVICE_NAME="seqia-app"
REGION="us-central1"
DOMAIN="seqia.dev"

echo "🔧 Configuraciones post-despliegue para Seqia..."
echo ""

# 1. Configurar acceso público
echo "1. Configurando acceso público..."
gcloud run services add-iam-policy-binding $SERVICE_NAME \
  --region=$REGION \
  --member=allUsers \
  --role=roles/run.invoker

if [ $? -eq 0 ]; then
    echo "✅ Acceso público configurado"
else
    echo "❌ Error configurando acceso público"
fi

echo ""

# 2. Verificar si el dominio ya está mapeado
echo "2. Verificando mapeo de dominio..."
if gcloud beta run domain-mappings describe $DOMAIN --region=$REGION &>/dev/null; then
    echo "✅ Dominio $DOMAIN ya está mapeado"
else
    echo "📡 Mapeando dominio $DOMAIN..."
    gcloud beta run domain-mappings create \
        --service $SERVICE_NAME \
        --domain $DOMAIN \
        --region $REGION
    
    if [ $? -eq 0 ]; then
        echo "✅ Dominio mapeado exitosamente"
    else
        echo "❌ Error mapeando dominio"
    fi
fi

echo ""

# 3. Obtener información de DNS
echo "3. 📋 Información de DNS para configurar:"
echo ""
gcloud beta run domain-mappings describe $DOMAIN --region=$REGION --format="value(status.resourceRecords[].name,status.resourceRecords[].type,status.resourceRecords[].rrdata)" | while read name type data; do
    echo "  📍 Registro DNS:"
    echo "     Nombre: $name"
    echo "     Tipo: $type" 
    echo "     Valor: $data"
    echo "  ---"
done

echo ""
echo "🚀 URLs del sitio:"
SERVICE_URL=$(gcloud run services describe $SERVICE_NAME --region=$REGION --format="value(status.url)")
echo "  🔗 Cloud Run: $SERVICE_URL"
echo "  🌐 Dominio personalizado: https://$DOMAIN (después de configurar DNS)"

echo ""
echo "📝 Próximos pasos:"
echo "1. Configura los registros DNS mostrados arriba en Cloud Domains"
echo "2. Espera la propagación DNS (hasta 48 horas)"
echo "3. Tu sitio estará disponible en https://$DOMAIN"
