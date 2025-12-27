-- === TikTok Ads Content Agent DB (PostgreSQL for GCP Cloud SQL) ===
-- Compatible with PostgreSQL/Cloud SQL

-- Core entities
CREATE TABLE IF NOT EXISTS brands (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  handle VARCHAR(255),
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS campaigns (
  id SERIAL PRIMARY KEY,
  brand_id INTEGER NOT NULL,
  name VARCHAR(255) NOT NULL,
  objective VARCHAR(50) NOT NULL,          -- e.g., TRAFFIC, MESSAGES, CONVERSIONS
  daily_budget NUMERIC(10, 2) NOT NULL,    -- MXN
  locations TEXT NOT NULL,          -- "Piedras Negras, MX | Eagle Pass, US"
  languages VARCHAR(50) DEFAULT 'es,*',
  age_range VARCHAR(20) DEFAULT '18-44',
  gender VARCHAR(20) DEFAULT 'ALL',
  optimization VARCHAR(20) DEFAULT 'CPC',
  bidding VARCHAR(20) DEFAULT 'AUTO',
  start_date DATE DEFAULT CURRENT_DATE,
  end_date DATE,
  status VARCHAR(20) DEFAULT 'DRAFT',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (brand_id) REFERENCES brands(id)
);

CREATE TABLE IF NOT EXISTS ad_groups (
  id SERIAL PRIMARY KEY,
  campaign_id INTEGER NOT NULL,
  name VARCHAR(255) NOT NULL,
  interests TEXT,
  behaviors TEXT,
  hashtags TEXT,
  placements VARCHAR(20) DEFAULT 'AUTO',
  connection VARCHAR(20) DEFAULT 'ANY',    -- WIFI, DATA, ANY
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (campaign_id) REFERENCES campaigns(id)
);

CREATE TABLE IF NOT EXISTS ads (
  id SERIAL PRIMARY KEY,
  ad_group_id INTEGER NOT NULL,
  name VARCHAR(255) NOT NULL,
  primary_text TEXT NOT NULL,
  cta VARCHAR(50) DEFAULT 'Order Now',
  duration_sec INTEGER DEFAULT 12,
  music_hint TEXT,
  asset_url TEXT,                   -- optional link to video file
  status VARCHAR(20) DEFAULT 'DRAFT',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (ad_group_id) REFERENCES ad_groups(id)
);

-- Optional: metrics/log of generations
CREATE TABLE IF NOT EXISTS generations (
  id SERIAL PRIMARY KEY,
  brand_id INTEGER NOT NULL,
  input_payload JSONB NOT NULL,  -- Using JSONB for better PostgreSQL support
  output_payload JSONB NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (brand_id) REFERENCES brands(id)
);

-- Seed brands (using PostgreSQL syntax)
INSERT INTO brands (name, handle, notes) 
VALUES 
  ('Chiltepik', '@chiltepik', 'Mariscos premium, aguachiles, ceviches'),
  ('ChocoBites', '@chocobites', 'Galletas artesanales, dulces, chewy')
ON CONFLICT (name) DO NOTHING;

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_campaigns_brand_id ON campaigns(brand_id);
CREATE INDEX IF NOT EXISTS idx_ad_groups_campaign_id ON ad_groups(campaign_id);
CREATE INDEX IF NOT EXISTS idx_ads_ad_group_id ON ads(ad_group_id);
CREATE INDEX IF NOT EXISTS idx_generations_brand_id ON generations(brand_id);
CREATE INDEX IF NOT EXISTS idx_campaigns_status ON campaigns(status);
CREATE INDEX IF NOT EXISTS idx_ads_status ON ads(status);

