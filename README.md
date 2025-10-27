# TikTok Ads Agent

AI-powered TikTok Ads campaign generator built with n8n, OpenAI, and Cloud SQL.

## 🚀 Quick Start

### Generate a Campaign

```bash
curl -X POST https://n8ne01.entrega.space/webhook/ads/generate \
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

## 📁 Project Structure

- **Core Files:**
  - `tiktok_ads_master_workflow.json` - Main n8n workflow
  - `tiktok_schema_cloudsql.sql` - Database schema
  - `generate.json` - Input structure
  - `OpenAI.json` - AI prompts

- **Documentation:**
  - `API_ENDPOINT_SETUP.md` - API reference
  - `DATABASE_CONNECTION_GUIDE.md` - Database setup
  - `SECURITY_NOTES.md` - Security best practices
  - `docs/` - Additional guides

- **Database:**
  - `RUN_THIS_SQL.txt` - Quick schema setup
  - `QUERY_SAVED_CAMPAIGNS.sql` - Sample queries

## 🏗️ Architecture

- **n8n** - Workflow automation on Cloud Run
- **OpenAI GPT-4** - Campaign generation
- **Cloud SQL PostgreSQL** - Data storage
- **GCP** - Cloud infrastructure

## 📊 Database Schema

- `brands` - Brand information
- `campaigns` - Campaign details
- `ad_groups` - Ad group targeting
- `ads` - Individual ad content
- `generations` - Generation history

## 🔐 Security

- Use `.env` file for credentials (see `env.example`)
- Never commit passwords to Git
- See `SECURITY_NOTES.md` for best practices

## 📚 Documentation

- [API Documentation](API_ENDPOINT_SETUP.md)
- [Database Setup](DATABASE_CONNECTION_GUIDE.md)
- [Setup Guide](docs/SETUP_GUIDE.md)
- [Success Summary](WORKFLOW_SUCCESS_SUMMARY.md)

## ✨ Features

- ✅ AI-powered campaign generation
- ✅ Multi-brand support
- ✅ Database tracking
- ✅ Webhook API
- ✅ Cloud-based infrastructure

## 🎯 Usage

1. Import `tiktok_ads_master_workflow.json` into n8n
2. Activate the workflow
3. Call via webhook or manual trigger
4. Query database for results

## 📝 License

MIT
