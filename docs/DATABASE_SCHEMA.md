# Database Schema Reference

## Tables Overview

### brands
Primary storage for brand information.

**Columns:**
- `id` (SERIAL PRIMARY KEY)
- `name` (VARCHAR(255), UNIQUE)
- `handle` (VARCHAR(255))
- `notes` (TEXT)
- `created_at` (TIMESTAMP)

**Seed Data:**
- Chiltepik (@chiltepik) - Mariscos premium
- ChocoBites (@chocobites) - Galletas artesanales

---

### campaigns
Stores TikTok ad campaign configurations.

**Columns:**
- `id` (SERIAL PRIMARY KEY)
- `brand_id` (INTEGER, FOREIGN KEY)
- `name` (VARCHAR(255))
- `objective` (VARCHAR(50)) - TRAFFIC, MESSAGES, CONVERSIONS
- `daily_budget` (NUMERIC(10,2)) - In MXN
- `locations` (TEXT) - Format: "City, Country | City, Country"
- `languages` (VARCHAR(50)) - Default: 'es,*'
- `age_range` (VARCHAR(20)) - Default: '18-44'
- `gender` (VARCHAR(20)) - ALL, MALE, FEMALE
- `optimization` (VARCHAR(20)) - CPC, CPM, etc.
- `bidding` (VARCHAR(20)) - AUTO or manual
- `start_date` (DATE)
- `end_date` (DATE)
- `status` (VARCHAR(20)) - DRAFT, ACTIVE, PAUSED, ARCHIVED
- `created_at` (TIMESTAMP)

**Relationships:**
- Foreign Key: `brand_id` → brands.id

---

### ad_groups
Targeting groups within campaigns.

**Columns:**
- `id` (SERIAL PRIMARY KEY)
- `campaign_id` (INTEGER, FOREIGN KEY)
- `name` (VARCHAR(255))
- `interests` (TEXT) - Comma-separated
- `behaviors` (TEXT) - Comma-separated
- `hashtags` (TEXT) - Space-separated hashtags
- `placements` (VARCHAR(20)) - AUTO, TIKTOK_FEED, etc.
- `connection` (VARCHAR(20)) - WIFI, DATA, ANY
- `notes` (TEXT)
- `created_at` (TIMESTAMP)

**Relationships:**
- Foreign Key: `campaign_id` → campaigns.id

---

### ads
Individual ad creatives.

**Columns:**
- `id` (SERIAL PRIMARY KEY)
- `ad_group_id` (INTEGER, FOREIGN KEY)
- `name` (VARCHAR(255))
- `primary_text` (TEXT) - Main ad text
- `cta` (VARCHAR(50)) - Call-to-action button text
- `duration_sec` (INTEGER) - Video duration
- `music_hint` (TEXT) - Music recommendation
- `asset_url` (TEXT) - Video asset URL
- `status` (VARCHAR(20)) - DRAFT, ACTIVE, PAUSED
- `created_at` (TIMESTAMP)

**Relationships:**
- Foreign Key: `ad_group_id` → ad_groups.id

---

### generations
Audit log of AI generations.

**Columns:**
- `id` (SERIAL PRIMARY KEY)
- `brand_id` (INTEGER, FOREIGN KEY)
- `input_payload` (JSONB) - Input sent to AI
- `output_payload` (JSONB) - AI response
- `created_at` (TIMESTAMP)

**Relationships:**
- Foreign Key: `brand_id` → brands.id

---

## Indexes

Performance indexes on:
- `campaigns.brand_id`
- `ad_groups.campaign_id`
- `ads.ad_group_id`
- `generations.brand_id`
- `campaigns.status`
- `ads.status`

---

## Sample Queries

### Get All Campaigns for Brand
```sql
SELECT c.*, b.name as brand_name
FROM campaigns c
JOIN brands b ON c.brand_id = b.id
WHERE b.name = 'Chiltepik'
ORDER BY c.created_at DESC;
```

### Get Full Campaign Structure
```sql
SELECT 
  c.id as campaign_id,
  c.name as campaign_name,
  b.name as brand,
  COUNT(DISTINCT ag.id) as ad_groups_count,
  COUNT(DISTINCT a.id) as ads_count
FROM campaigns c
JOIN brands b ON c.brand_id = b.id
LEFT JOIN ad_groups ag ON c.id = ag.campaign_id
LEFT JOIN ads a ON ag.id = a.ad_group_id
WHERE c.id = 1
GROUP BY c.id, c.name, b.name;
```

### Get All Ads for Campaign
```sql
SELECT 
  a.name as ad_name,
  a.primary_text,
  a.cta,
  ag.name as ad_group_name,
  ag.interests,
  ag.behaviors
FROM ads a
JOIN ad_groups ag ON a.ad_group_id = ag.id
JOIN campaigns c ON ag.campaign_id = c.id
WHERE c.id = 1;
```

### Generation History
```sql
SELECT 
  g.id,
  b.name as brand,
  g.created_at,
  g.input_payload->>'brand' as input_brand,
  g.output_payload->'campaign'->>'name' as generated_campaign
FROM generations g
JOIN brands b ON g.brand_id = b.id
ORDER BY g.created_at DESC
LIMIT 10;
```

---

## Relationship Diagram

```
brands (1) ──→ campaigns (many)
campaigns (1) ──→ ad_groups (many)
ad_groups (1) ──→ ads (many)
brands (1) ──→ generations (many)
```

---

## Data Flow

1. **Generate Campaign**
   - Input: Brand name, objective, targeting
   - AI generates: Campaign structure with ad groups and ads
   - Save to: campaigns, ad_groups, ads tables

2. **Query Campaign**
   - Input: Campaign ID
   - Return: Full campaign with all ad groups and ads

3. **Track Generation**
   - Input: Brand ID
   - Save: Input/output to generations table

