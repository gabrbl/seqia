#!/bin/bash

# Script para configurar dominio personalizado en Cloud Run
# Reemplaza TU_DOMINIO.com con tu dominio real

# Variables - CONFIGURACIÓN PARA SEQIA.DEV
DOMAIN="seqia.dev"
SERVICE_NAME="seqia-app"
REGION="us-central1"

echo "🌐 Configurando dominio personalizado para Seqia..."
echo "Dominio: $DOMAIN"
echo "Servicio: $SERVICE_NAME"
echo "Región: $REGION"
echo ""

# Verificar que el servicio existe
echo "1. Verificando que el servicio Cloud Run existe..."
if gcloud run services describe $SERVICE_NAME --region=$REGION &>/dev/null; then
    echo "✅ Servicio $SERVICE_NAME encontrado"
else
    echo "❌ Error: Servicio $SERVICE_NAME no encontrado en región $REGION"
    echo "   Primero despliega tu aplicación con: gcloud builds submit"
    exit 1
fi

# Verificar dominio
echo ""
echo "2. Verificando dominio $DOMAIN..."
if gcloud domains registrations describe $DOMAIN &>/dev/null; then
    echo "✅ Dominio $DOMAIN encontrado en Cloud Domains"
else
    echo "⚠️  Dominio no encontrado en Cloud Domains, pero continuando..."
    echo "   Asegúrate de que tienes control sobre el dominio"
fi

# Mapear dominio a Cloud Run
echo ""
echo "3. Mapeando dominio a Cloud Run..."
gcloud beta run domain-mappings create \
    --service $SERVICE_NAME \
    --domain $DOMAIN \
    --region $REGION

if [ $? -eq 0 ]; then
    echo "✅ Mapeo de dominio creado exitosamente"
else
    echo "❌ Error al crear mapeo de dominio"
    exit 1
fi

# Obtener registros DNS necesarios
echo ""
echo "4. Obteniendo registros DNS necesarios..."
echo "Ejecuta este comando para ver los registros DNS que necesitas configurar:"
echo ""
echo "gcloud beta run domain-mappings describe $DOMAIN --region=$REGION"
echo ""

# Mostrar registros DNS
echo "📋 Registros DNS necesarios:"
gcloud beta run domain-mappings describe $DOMAIN --region=$REGION --format="value(status.resourceRecords[].name,status.resourceRecords[].type,status.resourceRecords[].rrdata)" | while read name type data; do
    echo "  Nombre: $name"
    echo "  Tipo: $type" 
    echo "  Valor: $data"
    echo "  ---"
done

echo ""
echo "🎉 ¡Configuración completada!"
echo ""
echo "📝 Próximos pasos:"
echo "1. Configura los registros DNS mostrados arriba en tu dominio"
echo "2. Espera a que se propague el DNS (puede tomar hasta 48 horas)"
echo "3. Tu sitio estará disponible en: https://$DOMAIN"
echo ""
echo "💡 Para verificar el estado:"
echo "   gcloud beta run domain-mappings describe $DOMAIN --region=$REGION"
