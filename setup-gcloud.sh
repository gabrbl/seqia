# Comandos para habilitar las APIs necesarias
# Ejecuta estos comandos en Google Cloud Shell o en tu terminal local con gcloud CLI

# Habilitar APIs
gcloud services enable cloudbuild.googleapis.com
gcloud services enable run.googleapis.com
gcloud services enable containerregistry.googleapis.com
gcloud services enable sourcerepo.googleapis.com

# Configurar permisos para Cloud Build
PROJECT_ID=$(gcloud config get-value project)
PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format="value(projectNumber)")

echo "📋 Configurando permisos para Cloud Build..."
echo "Project ID: $PROJECT_ID"
echo "Project Number: $PROJECT_NUMBER"

# Dar permisos a Cloud Build para desplegar en Cloud Run
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$PROJECT_NUMBER@cloudbuild.gserviceaccount.com" \
    --role="roles/run.admin"

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$PROJECT_NUMBER@cloudbuild.gserviceaccount.com" \
    --role="roles/iam.serviceAccountUser"

# Dar permisos para configurar políticas IAM en Cloud Run
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$PROJECT_NUMBER@cloudbuild.gserviceaccount.com" \
    --role="roles/run.invoker"

# Permitir que Cloud Build configure acceso público
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$PROJECT_NUMBER@cloudbuild.gserviceaccount.com" \
    --role="roles/resourcemanager.projectIamAdmin"

echo ""
echo "✅ Permisos configurados correctamente"
echo ""
echo "🔧 Configurar acceso público manualmente:"
echo "gcloud run services add-iam-policy-binding seqia-app \\"
echo "  --region=us-central1 \\"
echo "  --member=allUsers \\"
echo "  --role=roles/run.invoker"
