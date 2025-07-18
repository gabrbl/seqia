# Seqia - AI Agents Platform

Modern website for Seqia, a company specializing in custom AI agents and conversational solutions for businesses.

## 🚀 Live Demo
- **Production:** https://seqia.dev (coming soon)
- **Repository:** https://github.com/gabrbl/seqia

## 🛠 Tech Stack
- **Framework:** Next.js 14+ with TypeScript
- **Styling:** Tailwind CSS
- **Deployment:** Google Cloud Run
- **CI/CD:** Google Cloud Build
- **Container:** Docker

## 🎨 Features
- Modern animated logo with SVG graphics
- Responsive design with Tailwind CSS
- Gradient backgrounds and smooth animations
- Contact form with modern UI
- Professional branding with "Seqia"

## 🚀 Google Cloud Deployment

### Prerequisites
1. Google Cloud Project with billing enabled
2. GitHub repository connected to Cloud Build
3. Required APIs enabled and permissions configured

### Setup Google Cloud Permissions
```bash
# Run these commands in Google Cloud Shell FIRST
chmod +x setup-gcloud.sh
./setup-gcloud.sh
```

### Automatic Deployment
This project is configured for automatic deployment using Google Cloud Build:

1. **Connect Repository to Cloud Build:**
   - Go to [Cloud Build Triggers](https://console.cloud.google.com/cloud-build/triggers)
   - Click "Connect Repository"
   - Select GitHub and authorize
   - Choose this repository (`gabrbl/seqia`)

2. **Create Build Trigger:**
   - Name: `seqia-deploy`
   - Event: Push to branch `main`
   - Configuration: Cloud Build configuration file
   - Location: `/cloudbuild.yaml`

3. **Configure Permissions:**
   ```bash
   # Run these commands in Google Cloud Shell
   ./setup-gcloud.sh
   ```

4. **Post-deployment configuration:**
   ```bash
   # After first successful build, run:
   chmod +x post-deploy.sh
   ./post-deploy.sh
   ```

### Manual Deployment
```bash
# Build and deploy manually
gcloud builds submit --config cloudbuild.yaml
```

## 🔧 Local Development

```bash
# Install dependencies
npm install

# Run development server
npm run dev

# Open http://localhost:3000
```

## 🌐 Custom Domain Setup (seqia.dev)

### Quick Setup
The domain `seqia.dev` is pre-configured! Just run:
```bash
# In Google Cloud Shell
chmod +x setup-domain.sh
./setup-domain.sh
```

### Manual Setup
1. **Map domain to Cloud Run:**
   ```bash
   gcloud beta run domain-mappings create \
     --service seqia-app \
     --domain seqia.dev \
     --region us-central1
   ```

2. **Get DNS records:**
   ```bash
   gcloud beta run domain-mappings describe seqia.dev --region us-central1
   ```

3. **Configure DNS in Cloud Domains:**
   - Go to [Cloud Domains](https://console.cloud.google.com/net-services/domains)
   - Select `seqia.dev`
   - Go to "DNS" tab
   - Add the CNAME/A records provided by the previous command

4. **Wait for DNS propagation** (up to 48 hours)

### SSL Certificate
- **Automatic:** Google Cloud Run automatically provisions SSL certificates for custom domains
- **Let's Encrypt:** Certificates are renewed automatically

## 📝 Environment Variables
No environment variables required for basic deployment.

## 🏗 Build Process
1. **Build trigger** activates on push to `main`
2. **Docker image** is built using multi-stage Dockerfile
3. **Image is pushed** to Google Container Registry
4. **Cloud Run service** is updated with new image
5. **Automatic scaling** based on traffic

## 💰 Estimated Costs
- **Cloud Run:** ~$0.001 per 100 requests
- **Container Registry:** ~$0.10/GB per month
- **Cloud Build:** 120 build-minutes free per day
- **Total for small website:** < $5/month

## 📧 Contact
For questions about AI agents and custom solutions, visit the contact section on the website.

---
© 2025 Seqia. All rights reserved.
