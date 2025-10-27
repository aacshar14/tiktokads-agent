# Step-by-Step: Create Tables NOW

## The Error:
`relation "brands" does not exist`

**Why:** Tables haven't been created yet in the database.

---

## Solution: 3 Simple Steps

### Step 1: Start Cloud SQL Proxy

Open a **new terminal** and run:

```bash
cloud-sql-proxy n8n-secstore:us-central1:n8n-hgdb --port 5432
```

**Keep this terminal running!** ✅

---

### Step 2: Connect to Database

Open **another new terminal** and run:

```bash
psql "host=127.0.0.1 port=5432 dbname=n8n user=n8n_user password=Hgn8n0814!"
```

You should see:
```
psql (XX.X)
Type "help" for help.

n8n=>
```

✅ Connected!

---

### Step 3: Create Tables

**Copy the entire content from `RUN_THIS_SQL.txt`** and paste into psql.

OR copy this one-liner and paste:

```sql
CREATE TABLE IF NOT EXISTS brands (id SERIAL PRIMARY KEY, name VARCHAR(255) NOT NULL UNIQUE, handle VARCHAR(255), notes TEXT, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP); CREATE TABLE IF NOT EXISTS campaigns (id SERIAL PRIMARY KEY, brand_id INTEGER NOT NULL, name VARCHAR(255) NOT NULL, objective VARCHAR(50) NOT NULL, daily_budget NUMERIC(10, 2), locations TEXT, languages VARCHAR(50) DEFAULT 'es,*', age_range VARCHAR(20) DEFAULT '18-44', gender VARCHAR(20) DEFAULT 'ALL', optimization VARCHAR(50), bidding VARCHAR(50), status VARCHAR(50) DEFAULT 'DRAFT', created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY (brand_id) REFERENCES brands(id)); CREATE TABLE IF NOT EXISTS ad_groups (id SERIAL PRIMARY KEY, campaign_id INTEGER NOT NULL, name VARCHAR(255), interests TEXT, behaviors TEXT, hashtags TEXT, placements VARCHAR(50) DEFAULT 'AUTO', connection VARCHAR(50) DEFAULT 'ANY', created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY (campaign_id) REFERENCES campaigns(id)); CREATE TABLE IF NOT EXISTS ads (id SERIAL PRIMARY KEY, ad_group_id INTEGER NOT NULL, name VARCHAR(255), primary_text TEXT, cta VARCHAR(100) DEFAULT 'Order Now', duration_sec INTEGER DEFAULT 15, music_hint TEXT, asset_url TEXT, status VARCHAR(50) DEFAULT 'DRAFT', created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY (ad_group_id) REFERENCES ad_groups(id)); CREATE TABLE IF NOT EXISTS generations (id SERIAL PRIMARY KEY, brand_id INTEGER NOT NULL, input_payload JSONB, output_payload JSONB, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY (brand_id) REFERENCES brands(id)); CREATE INDEX IF NOT EXISTS idx_campaigns_brand_id ON campaigns(brand_id); CREATE INDEX IF NOT EXISTS idx_ad_groups_campaign_id ON ad_groups(campaign_id); CREATE INDEX IF NOT EXISTS idx_ads_ad_group_id ON ads(ad_group_id); CREATE INDEX IF NOT EXISTS idx_generations_brand_id ON generations(brand_id); INSERT INTO brands (name, handle, notes) VALUES ('Chiltepik', '@chiltepik', 'Mariscos premium'), ('ChocoBites', '@chocobites', 'Galletas artesanales') ON CONFLICT (name) DO NOTHING;
```

Press Enter.

✅ Tables created!

---

### Step 4: Verify It Worked

Run in psql:

```sql
\dt
```

You should see:
- brands
- campaigns
- ad_groups
- ads
- generations

```sql
SELECT * FROM brands;
```

You should see:
- Chiltepik
- ChocoBites

✅ Everything is ready!

---

### Step 5: Run Your Workflow Again

Now go back to n8n and run your workflow again. It will work! 🎉

---

## Quick Visual:

```
Terminal 1: cloud-sql-proxy running ✅
            ↓
Terminal 2: psql connected ✅
            ↓
            Paste SQL from RUN_THIS_SQL.txt ✅
            ↓
            Tables created ✅
            ↓
n8n:        Run workflow ✅
            ↓
            SUCCESS! 🎉
```

---

## Summary:

1. ✅ Start proxy: `cloud-sql-proxy n8n-secstore:us-central1:n8n-hgdb --port 5432`
2. ✅ Connect: `psql "host=127.0.0.1 port=5432 dbname=n8n user=n8n_user password=Hgn8n0814!"`
3. ✅ Paste SQL from `RUN_THIS_SQL.txt`
4. ✅ Done! Run workflow again.

That's it! 🚀

