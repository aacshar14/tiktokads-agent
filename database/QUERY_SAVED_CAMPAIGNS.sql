-- Query to view all saved campaigns

-- 1. View All Campaigns with Brand Names
SELECT 
  c.id,
  c.name as campaign_name,
  b.name as brand_name,
  c.objective,
  c.daily_budget,
  c.status,
  c.created_at
FROM campaigns c
JOIN brands b ON c.brand_id = b.id
ORDER BY c.created_at DESC;

-- 2. View Campaign with Ad Groups Count
SELECT 
  c.id,
  c.name as campaign_name,
  b.name as brand_name,
  c.objective,
  c.daily_budget,
  c.status,
  COUNT(DISTINCT ag.id) as ad_groups_count,
  COUNT(DISTINCT a.id) as ads_count
FROM campaigns c
JOIN brands b ON c.brand_id = b.id
LEFT JOIN ad_groups ag ON c.id = ag.campaign_id
LEFT JOIN ads a ON ag.id = a.ad_group_id
GROUP BY c.id, c.name, b.name, c.objective, c.daily_budget, c.status, c.created_at
ORDER BY c.created_at DESC;

-- 3. View Full Campaign Details
SELECT 
  c.name as campaign_name,
  b.name as brand,
  c.objective,
  c.daily_budget,
  c.locations,
  ag.name as ad_group_name,
  ag.interests,
  ag.behaviors,
  ag.hashtags,
  a.name as ad_name,
  a.primary_text,
  a.cta
FROM campaigns c
JOIN brands b ON c.brand_id = b.id
LEFT JOIN ad_groups ag ON c.id = ag.campaign_id
LEFT JOIN ads a ON ag.id = a.ad_group_id
ORDER BY c.id, ag.id, a.id;

-- 4. View Brands
SELECT * FROM brands;

-- 5. View Generations Log
SELECT 
  g.id,
  b.name as brand_name,
  g.created_at,
  jsonb_pretty(g.input_payload) as input,
  jsonb_pretty(g.output_payload) as output
FROM generations g
JOIN brands b ON g.brand_id = b.id
ORDER BY g.created_at DESC
LIMIT 5;

-- 6. Statistics
SELECT 
  'Brands' as table_name,
  COUNT(*) as count
FROM brands
UNION ALL
SELECT 
  'Campaigns' as table_name,
  COUNT(*)
FROM campaigns
UNION ALL
SELECT 
  'Ad Groups' as table_name,
  COUNT(*)
FROM ad_groups
UNION ALL
SELECT 
  'Ads' as table_name,
  COUNT(*)
FROM ads
UNION ALL
SELECT 
  'Generations' as table_name,
  COUNT(*)
FROM generations;

