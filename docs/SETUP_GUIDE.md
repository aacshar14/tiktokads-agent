# Setup Guide - TikTok Ads Agent

## Prerequisites

- GCP Cloud SQL PostgreSQL instance
- n8n instance (Cloud Run or self-hosted)
- OpenAI API key
- Cloud Run service configured

## Step 1: Database Setup

### Create Database Tables

Execute the schema file in your Cloud SQL instance:

```bash
# Option A: Direct SQL
psql -h your-cloud-sql-host -U ttuserdb -d n8n -f tiktok_schema_cloudsql.sql

# Option B: Via n8n
# Import tiktok_schema_cloudsql.sql and execute via n8n PostgreSQL node
```

This creates:
- 5 tables (brands, campaigns, ad_groups, ads, generations)
- Indexes for performance
- 2 seed brands (Chiltepik, ChocoBites)

## Step 2: n8n Configuration

### 1. Configure PostgreSQL Credential

In n8n (https://n8ne01.entrega.space):

**Add Credential → PostgreSQL:**

```
Host: /cloudsql/n8n-secstore:us-central1:n8n-hgdb
Port: 5432
Database: n8n
User: ttuserdb
Password: [your-password]
SSL: Disabled
```

### 2. Configure OpenAI Credential

**Add Credential → OpenAI:**

```
API Key: [your-openai-api-key]
Model: gpt-4
```

### 3. Link Cloud SQL to Cloud Run

```bash
gcloud run services update n8ne01 \
  --add-cloudsql-instances=n8n-secstore:us-central1:n8n-hgdb \
  --region=us-central1 \
  --project=n8n-secstore
```

## Step 3: Import Workflow

1. Go to: https://n8ne01.entrega.space
2. Click "Import from File"
3. Upload: `tiktok_ads_master_workflow.json`
4. Configure credentials in each node
5. Test the workflow

## Step 4: Test

### Input Structure:

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

### Expected Output:

```json
{
  "success": true,
  "message": "TikTok Ads campaign generated and saved successfully!",
  "brand": "Chiltepik",
  "campaign": { ... }
}
```

## Step 5: Verify Database

Query your database to verify:

```sql
SELECT * FROM campaigns;
SELECT * FROM ad_groups;
SELECT * FROM ads;
SELECT * FROM generations;
```

## Troubleshooting

### Connection Issues
- Verify Cloud SQL to Cloud Run link
- Check credential configuration
- Test connection separately

### OpenAI Errors
- Verify API key is valid
- Check model availability
- Review API usage limits

### Database Errors
- Confirm tables exist
- Check foreign key constraints
- Verify permissions

## Next Steps

See `COMPLETE_WORKFLOW_NEXT.md` for extending the workflow.

