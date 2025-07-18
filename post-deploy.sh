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
    echo "❌ Error configurando acceso público (puede que ya esté configurado)"
fi

echo ""

# 2. Verificar si el dominio está verificado
echo "2. Verificando estado del dominio..."
VERIFIED_DOMAINS=$(gcloud domains list-user-verified --format="value(domain)")

if echo "$VERIFIED_DOMAINS" | grep -q "$DOMAIN"; then
    echo "✅ Dominio $DOMAIN está verificado"
    DOMAIN_VERIFIED=true
else
    echo "⚠️  Dominio $DOMAIN NO está verificado"
    echo ""
    echo "📋 Para verificar el dominio:"
    echo "1. Ve a: https://console.cloud.google.com/net-services/domains"
    echo "2. Selecciona tu dominio: $DOMAIN"
    echo "3. Ve a la pestaña 'Registro'"
    echo "4. Verifica que el dominio esté activo y registrado correctamente"
    echo ""
    echo "📋 O verifica manualmente con:"
    echo "gcloud domains registrations describe $DOMAIN"
    echo ""
    DOMAIN_VERIFIED=false
fi

echo ""

# 3. Mapear dominio si está verificado
if [ "$DOMAIN_VERIFIED" = true ]; then
    echo "3. Verificando mapeo de dominio..."
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
            echo "💡 Intenta manualmente:"
            echo "gcloud beta run domain-mappings create --service $SERVICE_NAME --domain $DOMAIN --region $REGION"
        fi
    fi
    
    echo ""
    
    # 4. Obtener información de DNS
    echo "4. 📋 Información de DNS para configurar:"
    echo ""
    gcloud beta run domain-mappings describe $DOMAIN --region=$REGION --format="value(status.resourceRecords[].name,status.resourceRecords[].type,status.resourceRecords[].rrdata)" | while read name type data; do
        echo "  📍 Registro DNS:"
        echo "     Nombre: $name"
        echo "     Tipo: $type" 
        echo "     Valor: $data"
        echo "  ---"
    done
else
    echo "3. ⏭️  Saltando mapeo de dominio (dominio no verificado)"
    echo ""
    echo "🔧 Pasos manuales para configurar el dominio:"
    echo ""
    echo "Paso 1: Verificar que el dominio esté registrado:"
    echo "  gcloud domains registrations describe $DOMAIN"
    echo ""
    echo "Paso 2: Si el dominio está registrado, mapear manualmente:"
    echo "  gcloud beta run domain-mappings create \\"
    echo "    --service $SERVICE_NAME \\"
    echo "    --domain $DOMAIN \\"
    echo "    --region $REGION"
    echo ""
    echo "Paso 3: Obtener registros DNS:"
    echo "  gcloud beta run domain-mappings describe $DOMAIN --region $REGION"
fi

echo ""
echo "🚀 URLs del sitio:"
SERVICE_URL=$(gcloud run services describe $SERVICE_NAME --region=$REGION --format="value(status.url)")
echo "  🔗 Cloud Run: $SERVICE_URL"

if [ "$DOMAIN_VERIFIED" = true ]; then
    echo "  🌐 Dominio personalizado: https://$DOMAIN (después de configurar DNS)"
else
    echo "  🌐 Dominio personalizado: Pendiente de verificación"
fi

echo ""
echo "📝 Estado actual:"
echo "  ✅ Aplicación desplegada en Cloud Run"
if [ "$DOMAIN_VERIFIED" = true ]; then
    echo "  ✅ Dominio verificado y mapeado"
    echo "  📋 Configura los registros DNS mostrados arriba"
else
    echo "  ⏳ Pendiente: Verificar y mapear dominio"
fi
