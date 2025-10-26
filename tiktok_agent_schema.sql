
-- === TikTok Ads Content Agent DB (SQLite/Postgres) ===
-- Core entities
CREATE TABLE IF NOT EXISTS brands (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL UNIQUE,
  handle TEXT,
  notes TEXT
);

CREATE TABLE IF NOT EXISTS campaigns (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  brand_id INTEGER NOT NULL,
  name TEXT NOT NULL,
  objective TEXT NOT NULL,          -- e.g., TRAFFIC, MESSAGES, CONVERSIONS
  daily_budget NUMERIC NOT NULL,    -- MXN
  locations TEXT NOT NULL,          -- "Piedras Negras, MX | Eagle Pass, US"
  languages TEXT DEFAULT 'es,*',
  age_range TEXT DEFAULT '18-44',
  gender TEXT DEFAULT 'ALL',
  optimization TEXT DEFAULT 'CPC',
  bidding TEXT DEFAULT 'AUTO',
  start_date TEXT DEFAULT CURRENT_DATE,
  end_date TEXT,
  status TEXT DEFAULT 'DRAFT',
  FOREIGN KEY (brand_id) REFERENCES brands(id)
);

CREATE TABLE IF NOT EXISTS ad_groups (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  campaign_id INTEGER NOT NULL,
  name TEXT NOT NULL,
  interests TEXT,
  behaviors TEXT,
  hashtags TEXT,
  placements TEXT DEFAULT 'AUTO',
  connection TEXT DEFAULT 'ANY',    -- WIFI, DATA, ANY
  notes TEXT,
  FOREIGN KEY (campaign_id) REFERENCES campaigns(id)
);

CREATE TABLE IF NOT EXISTS ads (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  ad_group_id INTEGER NOT NULL,
  name TEXT NOT NULL,
  primary_text TEXT NOT NULL,
  cta TEXT DEFAULT 'Order Now',
  duration_sec INTEGER DEFAULT 12,
  music_hint TEXT,
  asset_url TEXT,                   -- optional link to video file
  status TEXT DEFAULT 'DRAFT',
  FOREIGN KEY (ad_group_id) REFERENCES ad_groups(id)
);

-- Optional: metrics/log of generations
CREATE TABLE IF NOT EXISTS generations (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  brand_id INTEGER NOT NULL,
  input_payload TEXT NOT NULL,
  output_payload TEXT NOT NULL,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (brand_id) REFERENCES brands(id)
);

-- Seed brands
INSERT OR IGNORE INTO brands (name, handle, notes) VALUES
('Chiltepik', '@chiltepik', 'Mariscos premium, aguachiles, ceviches'),
('ChocoBites', '@chocobites', 'Galletas artesanales, dulces, chewy');
