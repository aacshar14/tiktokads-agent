# TikTok Ads Database Integration with n8n and Cloud SQL

## Overview
This guide explains how to integrate the TikTok Ads schema into your GCP Cloud SQL PostgreSQL instance and use it with n8n workflows.

## Database Setup

### 1. Connect to Your Cloud SQL Instance

First, ensure you have:
- A GCP Cloud SQL PostgreSQL instance running
- Connection credentials (host, port, database, username, password)
- SSL certificate (usually provided by GCP)

### 2. Create the Database Schema

**Option A: Using Cloud Console**
1. Go to GCP Console > SQL
2. Select your instance
3. Click "Connect using Cloud Shell" or "Connect using psql"
4. Run the `tiktok_schema_cloudsql.sql` file

**Option B: Using psql command line**
```bash
psql -h <your-instance-connection-name> \
     -U <username> \
     -d postgres \
     -f tiktok_schema_cloudsql.sql
```

**Option C: Using Cloud SQL Proxy**
```bash
./cloud_sql_proxy -instances=<instance-connection-name>=tcp:5432
```

### 3. n8n Workflow Configuration

## n8n Setup Steps

### Step 1: Add PostgreSQL Credential in n8n

1. Open n8n
2. Go to **Credentials** > **Add Credential**
3. Select **Postgres**
4. Fill in connection details:
   - **Host**: Your Cloud SQL instance IP or connection name
   - **Port**: 5432 (or your custom port)
   - **Database**: Your database name
   - **User**: Your database username
   - **Password**: Your database password
   - **SSL**: Enabled (check box)
   - **SSL - CA Certificate**: Upload your Cloud SQL CA certificate
   - **SSL - Mode**: require (or prefer if testing)

### Step 2: Create n8n Workflow

Here's a sample workflow structure for TikTok Ad generation:

#### Workflow: Generate TikTok Ads Campaign

**Nodes needed:**

1. **Manual Trigger** or **Webhook** (to start the workflow)

2. **OpenAI Node** (to generate ad content)
   - Configure your OpenAI API key
   - Use the prompt from `OpenAI.json`
   - Input: `{{$json}}` (your generate.json payload)

3. **Postgres Node** (Select existing brand)
   ```sql
   SELECT id, name FROM brands WHERE name = '{{$json.brand}}';
   ```

4. **Function Node** (Process the OpenAI response)
   - Use code from `snippet _function.json`
   - Parse the JSON response
   - Extract campaign, ad_groups data

5. **Postgres Node** (Insert Campaign)
   ```sql
   INSERT INTO campaigns 
   (brand_id, name, objective, daily_budget, locations, languages, age_range, gender, optimization, bidding, status)
   VALUES 
   ({{$json.brand_id}}, '{{$json.campaign.name}}', '{{$json.campaign.objective}}', 
    {{$json.campaign.daily_budget_mxn}}, '{{$json.campaign.locations}}', 
    '{{$json.campaign.languages}}', '{{$json.campaign.age_range}}', 
    '{{$json.campaign.gender}}', '{{$json.campaign.optimization}}', 
    '{{$json.campaign.bidding}}', 'DRAFT')
   RETURNING id;
   ```

6. **Postgres Node** (Insert Ad Groups and Ads)
   - Loop through ad_groups
   - For each ad_group, insert into `ad_groups` table
   - Then insert all ads for that ad_group

7. **Postgres Node** (Log Generation)
   ```sql
   INSERT INTO generations (brand_id, input_payload, output_payload)
   VALUES ({{$json.brand_id}}, 
           '{{$json.original_input}}'::jsonb,
           '{{$json.full_response}}'::jsonb);
   ```

## Complete n8n Workflow Example

### Input Data Structure
```json
{
  "brand": "Chiltepik",
  "objective": "TRAFFIC",
  "locations": ["Piedras Negras, MX", "Eagle Pass, US"],
  "daily_budget_mxn": 250,
  "age_range": "18-44",
  "gender": "ALL",
  "language": "es,*"
}
```

### Workflow Flow
```
1. Manual Trigger → Receives input data
2. Postgres (Get Brand ID) → Query brand
3. OpenAI → Generate campaign content
4. Function → Parse OpenAI response
5. Postgres (Insert Campaign) → Save to DB
6. Loop: For each ad_group
   - Postgres (Insert Ad Group)
   - Loop: For each ad in the ad_group
     - Postgres (Insert Ad)
7. Postgres (Log Generation) → Save full input/output
8. Return results
```

## Using the Database

### Query all campaigns for a brand
```sql
SELECT c.*, b.name as brand_name 
FROM campaigns c 
JOIN brands b ON c.brand_id = b.id 
WHERE b.name = 'Chiltepik';
```

### Get full campaign details
```sql
SELECT 
  c.name as campaign_name,
  c.objective,
  c.daily_budget,
  ag.name as ad_group_name,
  ad.name as ad_name,
  ad.primary_text,
  ad.cta
FROM campaigns c
JOIN ad_groups ag ON c.id = ag.campaign_id
JOIN ads ad ON ag.id = ad.ad_group_id
WHERE c.id = 1
ORDER BY ag.id, ad.id;
```

### Check generation history
```sql
SELECT 
  g.id,
  b.name as brand,
  g.created_at,
  g.input_payload,
  g.output_payload
FROM generations g
JOIN brands b ON g.brand_id = b.id
ORDER BY g.created_at DESC;
```

## Testing the Connection

### Test with a simple query
Create a test workflow in n8n:

1. **Manual Trigger**
2. **Postgres Node** → Execute query
   ```sql
   SELECT * FROM brands LIMIT 5;
   ```

This will verify your connection works.

## Security Notes

1. **Use SSL**: Always enable SSL when connecting to Cloud SQL from n8n
2. **Credentials**: Store database credentials securely in n8n's credential system
3. **Access Control**: Use IAM authentication if possible
4. **Network**: Consider using Private IP for better security

## Troubleshooting

### Common Issues

1. **Connection Refused**
   - Check Cloud SQL instance is running
   - Verify firewall rules allow your IP
   - Check connection string format

2. **SSL Certificate Error**
   - Download the latest Cloud SQL CA certificate
   - Upload it to n8n credentials
   - Use SSL mode: require

3. **Authentication Failed**
   - Verify username/password in n8n credentials
   - Check database user has proper permissions

4. **Schema Not Found**
   - Ensure you ran the schema SQL file
   - Verify you're connected to the correct database

## Next Steps

1. Set up the database schema on Cloud SQL
2. Configure n8n PostgreSQL credential
3. Create workflow to generate ads
4. Test with sample data
5. Expand to full automation

