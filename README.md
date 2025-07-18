# Seqia - AI Agents Platform

Modern website for Seqia, a company specializing in custom AI agents and conversational solutions for businesses.

## 🚀 Live Demo
- **Production:** https://seqia.dev
- **Repository:** https://github.com/gabrbl/seqia

## 🛠 Tech Stack
- **Framework:** Next.js 14+ with TypeScript
- **Styling:** Tailwind CSS
- **Deployment:** Google Cloud Run
- **CI/CD:** Google Cloud Build
- **Container:** Docker
- **Domain:** Google Cloud Domains + Cloud DNS

## 🎨 Features
- ✨ Modern animated logo with SVG graphics
- 📱 Responsive design with Tailwind CSS
- 🎨 Gradient backgrounds and smooth animations
- 📝 Contact form with modern UI
- 🔤 Professional branding with "Seqia"
- ⚡ Optimized for performance and SEO

## 🚀 Quick Start

### Local Development
```bash
git clone https://github.com/gabrbl/seqia.git
cd seqia
npm install
npm run dev
```
Open [http://localhost:3000](http://localhost:3000) to see the result.

### Google Cloud Deployment

For complete deployment instructions, see **[DEPLOYMENT.md](DEPLOYMENT.md)**

**Quick setup with automated script:**
```bash
# In Google Cloud Shell
git clone https://github.com/gabrbl/seqia.git
cd seqia
chmod +x seqia-setup.sh
./seqia-setup.sh
```

## 📁 Project Structure

```
seqia/
├── src/
│   └── app/
│       ├── page.tsx          # Main landing page
│       ├── layout.tsx        # Root layout
│       ├── globals.css       # Global styles & animations
│       └── favicon.ico       # Site icon
├── public/                   # Static assets
├── .dockerignore            # Docker ignore file
├── .gitignore              # Git ignore file
├── cloudbuild.yaml         # Cloud Build configuration
├── Dockerfile              # Multi-stage Docker build
├── next.config.ts          # Next.js configuration
├── package.json            # Dependencies and scripts
├── postcss.config.mjs      # PostCSS configuration
├── tailwind.config.js      # Tailwind CSS configuration
├── tsconfig.json           # TypeScript configuration
├── seqia-setup.sh          # Automated deployment script
├── DEPLOYMENT.md           # Complete deployment guide
├── TROUBLESHOOTING.md      # Common issues and solutions
└── README.md               # This file
```

## 🔧 Configuration Files

- **`cloudbuild.yaml`** - Automated CI/CD pipeline
- **`Dockerfile`** - Optimized multi-stage container build
- **`next.config.ts`** - Next.js production configuration
- **`seqia-setup.sh`** - Interactive deployment script

## 📋 Deployment Checklist

- [x] ✅ Modern Next.js application
- [x] ✅ Docker containerization
- [x] ✅ Google Cloud Run deployment
- [x] ✅ Automated CI/CD with Cloud Build
- [x] ✅ Custom domain (seqia.dev)
- [x] ✅ SSL certificates (automatic)
- [x] ✅ DNS configuration with Cloud DNS
- [x] ✅ Production optimizations

## 🌐 Architecture

```
GitHub → Cloud Build → Container Registry → Cloud Run → seqia.dev
```

## 📊 Performance

- ⚡ Lighthouse Score: 95+ (Performance, Accessibility, Best Practices, SEO)
- 🚀 First Contentful Paint: < 1.5s
- 📱 Mobile-first responsive design
- 🎨 Optimized animations and transitions

## 🛡 Security

- 🔒 HTTPS enforced (HSTS)
- 🛡 Security headers configured
- 🔐 No sensitive data in frontend
- ⚡ Content Security Policy
- 🚨 Automated security scanning

## 💰 Cost Optimization

- 📦 Multi-stage Docker builds (smaller images)
- ⚡ Static optimization for Next.js
- 🔄 Auto-scaling with Cloud Run
- 💾 Efficient caching strategies

## 📚 Documentation

- **[DEPLOYMENT.md](DEPLOYMENT.md)** - Complete deployment guide
- **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)** - Common issues and solutions

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📧 Contact

For questions about AI agents and custom solutions, visit [seqia.dev](https://seqia.dev)

## 📄 License

This project is proprietary software owned by Seqia.

---
© 2025 Seqia. All rights reserved.
