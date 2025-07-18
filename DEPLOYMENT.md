# Seqia - Guía Completa de Despliegue en Google Cloud

Esta guía documenta el proceso completo de despliegue del sitio web de Seqia en Google Cloud Platform, desde el desarrollo local hasta la producción con dominio personalizado.

## 📋 Tabla de Contenidos

1. [Arquitectura del Proyecto](#arquitectura)
2. [Requisitos Previos](#requisitos)
3. [Configuración Inicial](#configuración-inicial)
4. [Despliegue Automático con CI/CD](#despliegue-automático)
5. [Configuración de Dominio Personalizado](#dominio-personalizado)
6. [Verificación y Troubleshooting](#verificación)
7. [Mantenimiento y Actualizaciones](#mantenimiento)

## 🏗 Arquitectura del Proyecto {#arquitectura}

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   GitHub Repo   │───▶│   Cloud Build    │───▶│   Cloud Run     │
│   (seqia)       │    │   (CI/CD)        │    │   (seqia-app)   │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                                                        │
┌─────────────────┐    ┌──────────────────┐            │
│  Cloud Domains  │───▶│   Cloud DNS      │───────────▶│
│  (seqia.dev)    │    │ (seqia-dev-zone) │            │
└─────────────────┘    └──────────────────┘            │
                                                        ▼
                                              ┌─────────────────┐
                                              │  https://       │
                                              │  seqia.dev      │
                                              └─────────────────┘
```

### Componentes:

- **Frontend**: Next.js 14+ con TypeScript y Tailwind CSS
- **Hosting**: Google Cloud Run (contenedor Docker)
- **CI/CD**: Google Cloud Build con triggers automáticos
- **DNS**: Google Cloud DNS con zona administrada
- **Dominio**: Google Cloud Domains (seqia.dev)
- **SSL**: Certificados automáticos de Google Cloud

## 🔧 Requisitos Previos {#requisitos}

### Google Cloud Platform:
- ✅ Proyecto de GCP con facturación habilitada
- ✅ APIs habilitadas:
  - Cloud Run API
  - Cloud Build API
  - Container Registry API
  - Cloud DNS API
  - Cloud Domains API

### Herramientas:
- ✅ Cuenta de GitHub
- ✅ Google Cloud CLI (`gcloud`)
- ✅ Git
- ✅ Node.js 18+ (para desarrollo local)

## 🚀 Configuración Inicial {#configuración-inicial}

### Paso 1: Preparación del Proyecto

```bash
# Clonar el repositorio
git clone https://github.com/gabrbl/seqia.git
cd seqia

# Instalar dependencias
npm install

# Desarrollo local
npm run dev
```

### Paso 2: Configuración de Google Cloud

```bash
# Ejecutar script de configuración automática
chmod +x seqia-setup.sh
./seqia-setup.sh

# Opción 1: Configurar permisos de Google Cloud
```

**El script configura automáticamente:**
- Habilitación de APIs necesarias
- Permisos para Cloud Build
- Configuración de service accounts

### Configuración Manual (alternativa):

```bash
# Habilitar APIs
gcloud services enable cloudbuild.googleapis.com
gcloud services enable run.googleapis.com
gcloud services enable containerregistry.googleapis.com
gcloud services enable dns.googleapis.com

# Configurar permisos
PROJECT_ID=$(gcloud config get-value project)
PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format="value(projectNumber)")

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$PROJECT_NUMBER@cloudbuild.gserviceaccount.com" \
    --role="roles/run.admin"

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$PROJECT_NUMBER@cloudbuild.gserviceaccount.com" \
    --role="roles/iam.serviceAccountUser"
```

## 🔄 Despliegue Automático con CI/CD {#despliegue-automático}

### Configuración de Cloud Build

1. **Conectar repositorio GitHub:**
   - Ve a [Cloud Build Triggers](https://console.cloud.google.com/cloud-build/triggers)
   - Click "Conectar repositorio"
   - Selecciona GitHub y autoriza
   - Elige el repositorio `gabrbl/seqia`

2. **Crear trigger de despliegue:**
   - Nombre: `seqia-auto-deploy`
   - Evento: Push a rama `main`
   - Configuración: Archivo de Cloud Build (`/cloudbuild.yaml`)

### Archivo de Configuración (`cloudbuild.yaml`)

```yaml
steps:
  # Construir imagen Docker
  - name: 'gcr.io/cloud-builders/docker'
    args: ['build', '-t', 'gcr.io/$PROJECT_ID/seqia:$COMMIT_SHA', '-t', 'gcr.io/$PROJECT_ID/seqia:latest', '.']
  
  # Push imagen a Container Registry
  - name: 'gcr.io/cloud-builders/docker'
    args: ['push', '--all-tags', 'gcr.io/$PROJECT_ID/seqia']
  
  # Desplegar a Cloud Run
  - name: 'gcr.io/google.com/cloudsdktool/cloud-sdk'
    entrypoint: gcloud
    args:
      - 'run'
      - 'deploy'
      - 'seqia-app'
      - '--image'
      - 'gcr.io/$PROJECT_ID/seqia:$COMMIT_SHA'
      - '--region'
      - 'us-central1'
      - '--platform'
      - 'managed'
      - '--allow-unauthenticated'
      - '--port'
      - '3000'
      - '--memory'
      - '512Mi'
      - '--cpu'
      - '1'
      - '--max-instances'
      - '10'
      - '--min-instances'
      - '0'

timeout: 1200s
options:
  logging: CLOUD_LOGGING_ONLY
  machineType: 'E2_HIGHCPU_8'

images:
  - 'gcr.io/$PROJECT_ID/seqia:$COMMIT_SHA'
  - 'gcr.io/$PROJECT_ID/seqia:latest'
```

### Docker Configuration

**Dockerfile optimizado para producción:**
```dockerfile
FROM node:18-alpine AS base
FROM base AS deps
WORKDIR /app
COPY package.json package-lock.json* ./
RUN npm ci

FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
ENV NEXT_TELEMETRY_DISABLED 1
RUN npm run build

FROM base AS runner
WORKDIR /app
ENV NODE_ENV production
ENV NEXT_TELEMETRY_DISABLED 1

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

COPY --from=builder /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

USER nextjs
EXPOSE 3000
ENV PORT 3000
ENV HOSTNAME "0.0.0.0"

CMD ["node", "server.js"]
```

## 🌐 Configuración de Dominio Personalizado {#dominio-personalizado}

### Paso 1: Registrar Dominio

1. **Ve a [Cloud Domains](https://console.cloud.google.com/net-services/domains)**
2. **Registra `seqia.dev`**
3. **Espera a que el estado sea `ACTIVE`**

### Paso 2: Configurar DNS

```bash
# Crear zona DNS
gcloud dns managed-zones create seqia-dev-zone \
    --dns-name=seqia.dev \
    --description="DNS zone for seqia.dev" \
    --dnssec-state=off
```

### Paso 3: Mapear Dominio a Cloud Run

```bash
# Usando el script automatizado
./seqia-setup.sh
# Opción 3: Configurar dominio personalizado

# O manualmente:
gcloud beta run domain-mappings create \
    --service seqia-app \
    --domain seqia.dev \
    --region us-central1
```

### Paso 4: Configurar Registros DNS

```bash
# Obtener IPs de Cloud Run
gcloud beta run domain-mappings describe seqia.dev --region=us-central1

# Agregar registros A
gcloud dns record-sets create seqia.dev \
    --zone=seqia-dev-zone \
    --type=A \
    --ttl=300 \
    --rrdatas="216.239.32.21,216.239.34.21,216.239.36.21,216.239.38.21"

# Agregar registro para www
gcloud dns record-sets create www.seqia.dev \
    --zone=seqia-dev-zone \
    --type=A \
    --ttl=300 \
    --rrdatas="216.239.32.21,216.239.34.21,216.239.36.21,216.239.38.21"
```

### Paso 5: Configurar Cloud Domains

1. **Ve a Cloud Domains → seqia.dev → DNS**
2. **Selecciona "Usar Cloud DNS (recomendado)"**
3. **Elige la zona `seqia-dev-zone`**
4. **Deshabilita DNSSEC temporalmente**
5. **Guarda cambios**

## ✅ Verificación y Troubleshooting {#verificación}

### Script de Verificación Automática

```bash
./seqia-setup.sh
# Opción 4: Ver estado actual
```

### Verificación Manual

```bash
# Verificar servicio Cloud Run
gcloud run services describe seqia-app --region=us-central1

# Verificar mapeo de dominio
gcloud beta run domain-mappings list --region=us-central1

# Verificar DNS
nslookup seqia.dev
dig seqia.dev

# Verificar zona DNS
gcloud dns record-sets list --zone=seqia-dev-zone
```

### URLs de Verificación

- **Cloud Run directo:** https://seqia-app-[hash].us-central1.run.app
- **Dominio personalizado:** https://seqia.dev

### Comandos de Troubleshooting

```bash
# Ver logs de Cloud Build
gcloud builds list --limit=5

# Ver logs de Cloud Run
gcloud run services logs read seqia-app --region=us-central1

# Verificar certificados SSL
gcloud beta run domain-mappings describe seqia.dev --region=us-central1 --format="value(status.certificateMode)"
```

## 🔄 Mantenimiento y Actualizaciones {#mantenimiento}

### Actualizaciones de Código

1. **Hacer cambios en el código**
2. **Commit y push a `main`:**
   ```bash
   git add .
   git commit -m "Descripción de cambios"
   git push origin main
   ```
3. **Cloud Build despliega automáticamente**

### Configuración Post-Despliegue

```bash
# Después de cada despliegue exitoso
./seqia-setup.sh
# Opción 2: Configuración post-despliegue
```

### Monitoreo

- **Cloud Build:** https://console.cloud.google.com/cloud-build/builds
- **Cloud Run:** https://console.cloud.google.com/run
- **Cloud DNS:** https://console.cloud.google.com/net-services/dns
- **Facturación:** https://console.cloud.google.com/billing

### Costos Estimados

- **Cloud Run:** ~$0.001 por 100 requests
- **Container Registry:** ~$0.10/GB por mes
- **Cloud DNS:** ~$0.20 por zona por mes
- **Cloud Domains:** ~$12/año para .dev
- **Total estimado:** < $20/mes para sitio pequeño

## 🛠 Script de Configuración Automatizada

El proyecto incluye `seqia-setup.sh` con menú interactivo:

1. **Configurar permisos de Google Cloud** (primera vez)
2. **Configuración post-despliegue** (después de builds)
3. **Configurar dominio personalizado** (cuando esté registrado)
4. **Ver estado actual** (verificación)
5. **Salir**

### Uso del Script

```bash
# Ejecutar script interactivo
./seqia-setup.sh

# Seguir las opciones del menú según tu fase de configuración
```

## 📚 Recursos Adicionales

- [Documentación de Cloud Run](https://cloud.google.com/run/docs)
- [Guía de Cloud Build](https://cloud.google.com/build/docs)
- [Next.js Deployment](https://nextjs.org/docs/deployment)
- [Cloud DNS Documentation](https://cloud.google.com/dns/docs)

## 🔒 Seguridad

- ✅ HTTPS automático con certificados administrados por Google
- ✅ IAM configurado con principio de menor privilegio
- ✅ Contenedor sin privilegios de root
- ✅ Acceso público controlado a través de Cloud Run

---

**Proyecto desarrollado por Gabriel Rebelles para Seqia**  
*Documentación actualizada: Enero 2025*
