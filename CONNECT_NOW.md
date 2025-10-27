# Connect to Your Database NOW

## Quick Connection (2 Terminal Windows)

### Terminal 1: Start Proxy
```bash
cloud-sql-proxy n8n-secstore:us-central1:n8n-hgdb --port 5432
```
**Keep this running!**

### Terminal 2: Connect to Database
```bash
psql "host=127.0.0.1 port=5432 dbname=n8n user=n8n_user password=Hgn8n0814!"
```

---

## Once Connected, Run These Queries:

### 1. View Your Campaigns
```sql
SELECT c.id, c.name, b.name as brand, c.objective, c.status, c.created_at 
FROM campaigns c 
JOIN brands b ON c.brand_id = b.id 
ORDER BY c.created_at DESC;
```

### 2. Count Your Data
```sql
SELECT 
  (SELECT COUNT(*) FROM brands) as brands,
  (SELECT COUNT(*) FROM campaigns) as campaigns,
  (SELECT COUNT(*) FROM ad_groups) as ad_groups,
  (SELECT COUNT(*) FROM ads) as ads;
```

### 3. View All Brands
```sql
SELECT * FROM brands;
```

---

## Quick Queries File

Load all queries from file:
```bash
psql "host=127.0.0.1 port=5432 dbname=n8n user=n8n_user password=YOUR_PASSWORD" -f QUERY_SAVED_CAMPAIGNS.sql
```

Or copy queries from `QUERY_SAVED_CAMPAIGNS.sql` and paste into psql.

---

## Connection Credentials

- **Host:** 127.0.0.1
- **Port:** 5432
- **Database:** n8n
- **User:** n8n_user
- **Password:** YOUR_PASSWORD

Ready to connect! 🚀

