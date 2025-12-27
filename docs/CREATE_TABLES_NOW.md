# Create Tables in Your Database

## The Problem:
Error: "relation 'brands' does not exist"
**Tables haven't been created yet!**

## Solution: Run the Schema Script

### Step 1: Connect to Database

**Terminal 1: Start Proxy**
```bash
cloud-sql-proxy n8n-secstore:us-central1:n8n-hgdb --port 5432
```

**Terminal 2: Connect**
```bash
psql "host=127.0.0.1 port=5432 dbname=n8n user=n8n_user password=YOUR_PASSWORD"
```

### Step 2: Run the Schema

Once connected, run:

```sql
-- This is from tiktok_schema_cloudsql.sql
-- Copy and paste this entire block:

CREATE TABLE IF NOT EXISTS brands (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  handle VARCHAR(255),
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS campaigns (
  id SERIAL PRIMARY KEY,
  brand_id INTEGER REFERENCES brands(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  objective VARCHAR(50) NOT NULL,
  daily_budget NUMERIC(10, 2),
  locations TEXT,
  languages VARCHAR(50),
  age_range VARCHAR(20),
  gender VARCHAR(20),
  optimization VARCHAR(50),
  bidding VARCHAR(50),
  status VARCHAR(50) DEFAULT 'DRAFT',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS ad_groups (
  id SERIAL PRIMARY KEY,
  campaign_id INTEGER REFERENCES campaigns(id) ON DELETE CASCADE,
  name VARCHAR(255),
  interests TEXT,
  behaviors TEXT,
  hashtags TEXT,
  placements VARCHAR(50),
  connection VARCHAR(50),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS ads (
  id SERIAL PRIMARY KEY,
  ad_group_id INTEGER REFERENCES ad_groups(id) ON DELETE CASCADE,
  name VARCHAR(255),
  primary_text TEXT,
  cta VARCHAR(100),
  duration_sec INTEGER DEFAULT 15,
  music_hint TEXT,
  asset_url TEXT,
  status VARCHAR(50) DEFAULT 'DRAFT',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS generations (
  id SERIAL PRIMARY KEY,
  brand_id INTEGER REFERENCES brands(id),
  input_payload JSONB,
  output_payload JSONB,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_campaigns_brand_id ON campaigns(brand_id);
CREATE INDEX IF NOT EXISTS idx_ad_groups_campaign_id ON ad_groups(campaign_id);
CREATE INDEX IF NOT EXISTS idx_ads_ad_group_id ON ads(ad_group_id);
CREATE INDEX IF NOT EXISTS idx_generations_brand_id ON generations(brand_id);

-- Insert seed data
INSERT INTO brands (name, handle, notes)
VALUES
  ('Chiltepik', '@chiltepik', 'Mariscos premium, aguachiles, ceviches'),
  ('ChocoBites', '@chocobites', 'Galletas artesanales, dulces, chewy')
ON CONFLICT (name) DO NOTHING;
```

### Step 3: Verify Tables

```sql
-- Check tables exist
\dt

-- Should show: brands, campaigns, ad_groups, ads, generations

-- Check data
SELECT * FROM brands;
```

---

## Alternative: Load from File

If the schema is in a file:

```bash
# In psql
\i tiktok_schema_cloudsql.sql

# Or from command line
psql "host=127.0.0.1 port=5432 dbname=n8n user=n8n_user password=YOUR_PASSWORD" -f tiktok_schema_cloudsql.sql
```

---

## After Tables Are Created

✅ Run your workflow again  
✅ Tables will exist  
✅ Data will save properly  

---

## Quick Copy-Paste

Copy this and run in psql:

```sql
CREATE TABLE IF NOT EXISTS brands (id SERIAL PRIMARY KEY, name VARCHAR(255) NOT NULL UNIQUE, handle VARCHAR(255), notes TEXT, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
CREATE TABLE IF NOT EXISTS campaigns (id SERIAL PRIMARY KEY, brand_id INTEGER REFERENCES brands(id) ON DELETE CASCADE, name VARCHAR(255) NOT NULL, objective VARCHAR(50) NOT NULL, daily_budget NUMERIC(10, 2), locations TEXT, languages VARCHAR(50), age_range VARCHAR(20), gender VARCHAR(20), optimization VARCHAR(50), bidding VARCHAR(50), status VARCHAR(50) DEFAULT 'DRAFT', created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
CREATE TABLE IF NOT EXISTS ad_groups (id SERIAL PRIMARY KEY, campaign_id INTEGER REFERENCES campaigns(id) ON DELETE CASCADE, name VARCHAR(255), interests TEXT, behaviors TEXT, hashtags TEXT, placements VARCHAR(50), connection VARCHAR(50), created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
CREATE TABLE IF NOT EXISTS ads (id SERIAL PRIMARY KEY, ad_group_id INTEGER REFERENCES ad_groups(id) ON DELETE CASCADE, name VARCHAR(255), primary_text TEXT, cta VARCHAR(100), duration_sec INTEGER DEFAULT 15, music_hint TEXT, asset_url TEXT, status VARCHAR(50) DEFAULT 'DRAFT', created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
CREATE TABLE IF NOT EXISTS generations (id SERIAL PRIMARY KEY, brand_id INTEGER REFERENCES brands(id), input_payload JSONB, output_payload JSONB, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
CREATE INDEX IF NOT EXISTS idx_campaigns_brand_id ON campaigns(brand_id);
CREATE INDEX IF NOT EXISTS idx_ad_groups_campaign_id ON ad_groups(campaign_id);
CREATE INDEX IF NOT EXISTS idx_ads_ad_group_id ON ads(ad_group_id);
CREATE INDEX IF NOT EXISTS idx_generations_brand_id ON generations(brand_id);
INSERT INTO brands (name, handle, notes) VALUES ('Chiltepik', '@chiltepik', 'Mariscos premium'), ('ChocoBites', '@chocobites', 'Galletas artesanales') ON CONFLICT (name) DO NOTHING;
```

Done! Now your workflow will work! 🎉

