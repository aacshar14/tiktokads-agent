-- Simple Save Campaign Query
-- Copy this into your "Save Campaign" PostgreSQL node in n8n

INSERT INTO campaigns (
  brand_id, name, objective, daily_budget, locations, 
  languages, age_range, gender, optimization, bidding, status
)
VALUES (
  1,
  'AI Generated Campaign',
  'TRAFFIC',
  250,
  'Piedras Negras, MX',
  'es,*',
  '18-44',
  'ALL',
  'CPC',
  'AUTO',
  'DRAFT'
)
RETURNING id;

-- This creates a test campaign
-- Later you can make it dynamic

