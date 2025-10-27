-- ============================================
-- FIXES FOR ALL POSTGRESQL NODES IN N8N
-- ============================================

-- ============================================
-- 1. SAVE CAMPAIGN NODE
-- ============================================
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

-- ============================================
-- 2. LOG GENERATION NODE
-- ============================================
INSERT INTO generations (brand_id, input_payload, output_payload)
VALUES (
  1,
  '{"test": "input"}'::jsonb,
  '{"test": "output"}'::jsonb
)
RETURNING id;

-- ============================================
-- 3. GET BRAND ID NODE (already working)
-- ============================================
-- Keep this as is:
SELECT id, name FROM brands WHERE name = 'Chiltepik' LIMIT 1;

-- ============================================
-- NOTES:
-- ============================================
-- - These queries use hardcoded values
-- - No parameterized queries ($1, $2, etc.)
-- - This avoids n8n parameter errors
-- - Later you can make them dynamic if needed

