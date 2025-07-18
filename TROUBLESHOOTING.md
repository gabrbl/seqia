# Troubleshooting Guide for Seqia Deployment

## Common Issues and Solutions

### 1. "bash: line 1: 404:: command not found"

**Problem:** GitHub raw file not accessible or not yet propagated.

**Solution:**
```bash
# Instead of using curl, clone the repository directly:
git clone https://github.com/gabrbl/seqia.git
cd seqia
chmod +x seqia-setup.sh
./seqia-setup.sh
```

### 2. "fatal: destination path 'seqia' already exists"

**Problem:** Directory already exists from previous clone.

**Solution:**
```bash
cd seqia
git pull origin main
# Continue with your desired script
```

### 3. "Permission denied" errors

**Problem:** Scripts don't have execute permissions.

**Solution:**
```bash
chmod +x *.sh
# Then run your desired script
```

### 4. Domain verification errors

**Problem:** Domain not registered or not active in Cloud Domains.

**Solution:**
1. Go to https://console.cloud.google.com/net-services/domains
2. Register seqia.dev
3. Wait for status to be "ACTIVE"
4. Then run domain setup scripts

### 5. Cloud Build permission errors

**Problem:** Cloud Build service account lacks permissions.

**Solution:**
```bash
# Run the permission setup script first:
chmod +x setup-gcloud.sh
./setup-gcloud.sh
```

## Step-by-Step Deployment

### Phase 1: Initial Setup (One time)
```bash
# 1. Clone repository
git clone https://github.com/gabrbl/seqia.git
cd seqia

# 2. Setup Google Cloud permissions
chmod +x setup-gcloud.sh
./setup-gcloud.sh

# 3. Setup Cloud Build trigger (in console)
# Go to: https://console.cloud.google.com/cloud-build/triggers
# Connect your GitHub repository
# Create trigger for main branch
```

### Phase 2: After Successful Build
```bash
# Configure public access and check status
cd seqia
git pull origin main
chmod +x post-deploy.sh
./post-deploy.sh
```

### Phase 3: Domain Setup (When domain is registered)
```bash
# Map custom domain
cd seqia
git pull origin main
chmod +x setup-domain-complete.sh
./setup-domain-complete.sh
```

## Quick Status Check

```bash
# Check if app is deployed
gcloud run services describe seqia-app --region=us-central1

# Check domain status
gcloud domains registrations describe seqia.dev

# Check domain mapping
gcloud beta run domain-mappings describe seqia.dev --region=us-central1
```

## URLs to Remember

- **Google Cloud Console:** https://console.cloud.google.com
- **Cloud Build Triggers:** https://console.cloud.google.com/cloud-build/triggers
- **Cloud Run Services:** https://console.cloud.google.com/run
- **Cloud Domains:** https://console.cloud.google.com/net-services/domains
- **GitHub Repository:** https://github.com/gabrbl/seqia

## Support

If you encounter any issues not covered here:
1. Check the Cloud Build logs in Google Cloud Console
2. Verify all prerequisites are met
3. Ensure your Google Cloud project has billing enabled
4. Check that all required APIs are enabled
