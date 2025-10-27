# Connect to Cloud SQL Database

## Setup Cloud SQL Proxy

### Step 1: Install Cloud SQL Proxy (if not already installed)

**Windows:**
```powershell
# Download from Google Cloud
# https://cloud.google.com/sql/docs/postgres/sql-proxy#install
```

Or via Chocolatey:
```powershell
choco install google-cloud-sql-proxy
```

---

### Step 2: Start Cloud SQL Proxy

Open a **new terminal** and run:

```bash
cloud-sql-proxy n8n-secstore:us-central1:n8n-hgdb --port 5432
```

This will start a local proxy on port 5432.

**Keep this terminal running!**

---

### Step 3: Connect to Database

Open a **new terminal** (keep proxy running) and connect:

```bash
psql "host=127.0.0.1 port=5432 dbname=n8n user=n8n_user password=Hgttads0814!"
```

Or use environment variable:
```bash
export PGPASSWORD="Hgttads0814!"
psql -h 127.0.0.1 -p 5432 -U n8n_user -d n8n
```

---

## Query Your Data

Once connected, try these queries:

### View Brands
```sql
SELECT * FROM brands;
```

### View Campaigns
```sql
SELECT 
  c.id,
  c.name,
  b.name as brand_name,
  c.objective,
  c.daily_budget,
  c.status,
  c.created_at
FROM campaigns c
JOIN brands b ON c.brand_id = b.id
ORDER BY c.created_at DESC;
```

### View All Ad Groups
```sql
SELECT 
  ag.id,
  c.name as campaign_name,
  ag.name as ad_group_name,
  ag.interests,
  ag.behaviors,
  COUNT(a.id) as ads_count
FROM ad_groups ag
JOIN campaigns c ON ag.campaign_id = c.id
LEFT JOIN ads a ON ag.id = a.ad_group_id
GROUP BY ag.id, c.name, ag.name, ag.interests, ag.behaviors;
```

### View All Ads
```sql
SELECT 
  a.id,
  ag.name as ad_group,
  a.name,
  a.primary_text,
  a.cta,
  a.status
FROM ads a
JOIN ad_groups ag ON a.ad_group_id = ag.id
ORDER BY a.created_at DESC;
```

### Count Everything
```sql
SELECT 
  (SELECT COUNT(*) FROM brands) as brands,
  (SELECT COUNT(*) FROM campaigns) as campaigns,
  (SELECT COUNT(*) FROM ad_groups) as ad_groups,
  (SELECT COUNT(*) FROM ads) as ads,
  (SELECT COUNT(*) FROM generations) as generations;
```

---

## Alternative: Use pgAdmin

1. Install pgAdmin: https://www.pgadmin.org/download/
2. Add new server:
   - Host: `127.0.0.1`
   - Port: `5432`
   - Database: `n8n`
   - Username: `n8n_user`
   - Password: `Hgttads0814!`

---

## Alternative: Using Cloud Shell (Browser)

If Cloud SQL Proxy is giving issues, use Google Cloud Shell:

```bash
gcloud sql connect n8n-hgdb --user=n8n_user --database=n8n
```

---

## Quick Connection Script

Create a file `connect_db.sh`:

```bash
#!/bin/bash

# Start proxy in background
cloud-sql-proxy n8n-secstore:us-central1:n8n-hgdb --port 5432 &

# Wait a moment
sleep 2

# Connect
PGPASSWORD="Hgttads0814!" psql -h 127.0.0.1 -p 5432 -U n8n_user -d n8n
```

Make executable and run:
```bash
chmod +x connect_db.sh
./connect_db.sh
```

---

## Useful Commands

### List All Tables
```sql
\dt
```

### Describe Table Structure
```sql
\d campaigns
```

### Export Data to CSV
```sql
\copy (SELECT * FROM campaigns) TO 'campaigns.csv' CSV HEADER;
```

### Show Current User
```sql
SELECT current_user;
```

### Show Database Version
```sql
SELECT version();
```

---

## Troubleshooting

### "cloud-sql-proxy: command not found"
- Install the Cloud SQL Proxy first
- Or use gcloud command instead

### "Connection refused"
- Make sure proxy is running
- Check port 5432 is not in use: `netstat -an | findstr 5432`

### "Authentication failed"
- Double-check password
- Make sure you're using the correct user: `n8n_user`

### "Database doesn't exist"
- Make sure you're connecting to database: `n8n`
- List databases: `psql -l`

---

## Next Steps After Connecting

1. Check your data: `SELECT * FROM campaigns;`
2. View brands: `SELECT * FROM brands;`
3. Export data if needed
4. Make manual updates if needed

Happy querying! 🎉

