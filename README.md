# TikTok Ads Agent

AI-powered TikTok Ads campaign generator built with n8n, OpenAI, and Cloud SQL.

## 🚀 Quick Start

### 1. Deployment
**[👉 Follow the DEPLOYMENT GUIDE here](docs/DEPLOYMENT_GUIDE.md)** to set up on DigitalOcean + Coolify.

### 2. Local Testing
You can also run the entire stack locally with Docker:
```bash
docker-compose -f config/docker-compose.yml up -d
```
Access n8n at `http://localhost:5678`.

### 3. Generate a Campaign

```bash
curl -X POST https://n8n.yourdomain.com/webhook/ads/generate \
  -H "Content-Type: application/json" \
  -d '{
    "brand": "ChocoBites",
    "objective": "MESSAGES",
    "locations": ["Piedras Negras, MX", "Eagle Pass, US"],
    "daily_budget_mxn": 200,
    "age_range": "16-35",
    "gender": "ALL",
    "language": "es,*"
  }'
```

## 📂 Project Structure

```
tiktokads-agent/
├── workflows/                  # n8n Workflow JSON files
│   ├── tiktok_ads_production_workflow.json  # MAIN PRODUCTION WORKFLOW
│   ├── init_db_workflow.json                # Database initialization
│   ├── view_campaigns_workflow.json         # Helper to view data
│   └── archive/                             # Old versions
├── database/                   # SQL Scripts
│   ├── tiktok_schema_cloudsql.sql           # Main schema
│   └── tiktok_agent_schema.sql              # Alternative schema
├── docs/                       # Documentation
│   ├── DEPLOYMENT_GUIDE.md                  # MAIN SETUP GUIDE
│   ├── API_ENDPOINT_SETUP.md                # API details
│   └── ...
├── config/                     # Configuration files
│   ├── docker-compose.yml
│   └── env.example
├── scripts/                    # Helper scripts
│   └── connect_db.ps1
└── README.md                   # This file
```

## 🏗️ Architecture

- **n8n** - Workflow automation on Cloud Run/DigitalOcean
- **OpenAI GPT-4** - Campaign generation
- **PostgreSQL** - Data storage
- **Coolify** - Deployment management

## 📊 Database Schema

- `brands` - Brand information
- `campaigns` - Campaign details
- `ad_groups` - Ad group targeting
- `ads` - Individual ad content
- `generations` - Generation history

## 🔐 Security

- Use `.env` file for credentials (see `config/env.example`)
- Never commit passwords to Git
- See `docs/SECURITY_NOTES.md` for best practices

## 📚 Documentation

- [Deployment Guide](docs/DEPLOYMENT_GUIDE.md)
- [API Documentation](docs/API_ENDPOINT_SETUP.md)
- [Database Setup](docs/DATABASE_CONNECTION_GUIDE.md)
- [Success Summary](docs/WORKFLOW_SUCCESS_SUMMARY.md)

## ✨ Features

- ✅ AI-powered campaign generation
- ✅ Multi-brand support
- ✅ Database tracking
- ✅ Webhook API
- ✅ Cloud-based infrastructure

## 🎯 Usage

1. Import `workflows/tiktok_ads_production_workflow.json` into n8n
2. Activate the workflow
3. Call via webhook or manual trigger
4. Query database for results

## 📝 License

MIT
