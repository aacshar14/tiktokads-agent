# TikTok Ads Agent - AI-Powered Campaign Generator

Automated system for generating TikTok ad campaigns using OpenAI and managing them in PostgreSQL.

## 🎯 Overview

This project provides a complete automation system for:
- Generating TikTok ad campaigns using AI
- Managing campaigns, ad groups, and ads in PostgreSQL
- Tracking AI generation history
- Content management for multiple brands

## 🏗️ System Architecture

- **Automation Platform:** n8n (Cloud Run on GCP)
- **Database:** Cloud SQL PostgreSQL
- **AI Provider:** OpenAI (GPT-4)
- **Connection:** Private Cloud Run ↔ Cloud SQL link

## 📂 Project Structure

```
tiktokads/
├── tiktok_ads_master_workflow.json  # Main working workflow
├── tiktok_schema_cloudsql.sql      # PostgreSQL database schema
├── tiktok_agent_schema.sql         # Original SQLite schema
├── generate.json                   # Campaign input structure
├── OpenAI.json                     # AI prompt template
├── snippet _function.json          # Data processing logic
└── docs/                           # Documentation
```

## 🚀 Quick Start

### 1. Database Setup

Run the schema in your PostgreSQL database:

```sql
-- Execute tiktok_schema_cloudsql.sql
```

This creates 5 tables:
- `brands` - Brand management
- `campaigns` - Campaign data
- `ad_groups` - Targeting groups
- `ads` - Individual ad creatives
- `generations` - AI generation logs

### 2. n8n Workflow Setup

1. Import `tiktok_ads_master_workflow.json` into n8n
2. Configure credentials:
   - PostgreSQL connection to Cloud SQL
   - OpenAI API key
3. Test the workflow

### 3. Generate Your First Campaign

Use the input structure from `generate.json`:
```json
{
  "brand": "Chiltepik",
  "objective": "TRAFFIC",
  "locations": "Piedras Negras, MX | Eagle Pass, US",
  "daily_budget_mxn": 250,
  "age_range": "18-44",
  "gender": "ALL",
  "language": "es,*"
}
```

## 📊 Database Schema

### Brands Table
Stores brand information and settings.

### Campaigns Table
Manages campaign details:
- Objectives (TRAFFIC, CONVERSIONS, etc.)
- Targeting parameters
- Budget and scheduling
- Status tracking

### Ad Groups Table
Stores targeting groups:
- Interests and behaviors
- Hashtags
- Placements
- Connection types

### Ads Table
Individual ad creatives:
- Primary text
- CTA buttons
- Video duration
- Asset URLs

### Generations Table
AI generation audit trail:
- Input payloads
- Output payloads
- Timestamps

## 🔧 Configuration

### n8n Credentials

**PostgreSQL:**
- Host: `/cloudsql/n8n-secstore:us-central1:n8n-hgdb`
- Database: `n8n`
- User: `ttuserdb`

**OpenAI:**
- Model: `gpt-4`
- Operation: `chat`
- Temperature: `0.7`

## 📝 Usage

### Generate Campaign

Run the workflow with brand input data to:
1. Query brand from database
2. Generate campaign with OpenAI
3. Save campaign to database
4. Save ad groups
5. Save individual ads
6. Log generation

### Query Campaigns

```sql
SELECT * FROM campaigns 
WHERE brand_id = 1 
ORDER BY created_at DESC;
```

### View Full Campaign

```sql
SELECT c.*, b.name as brand_name
FROM campaigns c
JOIN brands b ON c.brand_id = b.id
WHERE c.id = $1;
```

## 🎨 Features

- ✅ AI-powered campaign generation
- ✅ Multi-brand support
- ✅ Complete database management
- ✅ Generation history tracking
- ✅ Spanish language support
- ✅ Custom targeting parameters

## 🔄 Workflow Nodes

1. **Manual Trigger** - Start workflow
2. **Get Brand ID** - Query database
3. **Generate with OpenAI** - AI campaign generation
4. **Process Data** - Structure AI response
5. **Save Campaign** - Database insert
6. **Save Ad Groups** - Save targeting groups
7. **Save Ads** - Save individual ads
8. **Log Generation** - Audit trail
9. **Return Result** - Success output

## 📚 Documentation

- `COMPLETE_WORKFLOW_NEXT.md` - How to extend the workflow
- `WORKFLOW_ADDITIONS.md` - Adding features
- `NEXT_STEPS_COMPLETE_SYSTEM.md` - Content management
- `FINAL_CONFIG_SUMMARY.md` - System configuration

## 🔐 Security

- Private Cloud SQL connection
- SSL/TLS encryption
- Secure credential management in n8n

## 📈 Status

✅ Database schema created
✅ Workflow executing successfully
✅ OpenAI integration working
✅ Database writes confirmed

## 🚧 Next Steps

- [ ] Make data flow fully dynamic
- [ ] Add content management workflows
- [ ] Implement campaign status management
- [ ] Add A/B test variation support
- [ ] Build content library queries

## 👥 Contributing

This is a custom automation project. For improvements:
1. Update workflow JSON
2. Test in n8n
3. Document changes

## 📄 License

Internal project for TikTok ad campaign automation.

## 🔗 Links

- n8n: https://n8ne01.entrega.space
- Database: Cloud SQL PostgreSQL
- Project: TikTok Ads Agent

---

**Last Updated:** October 26, 2025  
**Version:** 1.0.0  
**Status:** Production Ready
