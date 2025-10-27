-- ULTRA SIMPLE QUERIES - Copy these EXACTLY
-- Use these if nothing else works

-- ============================================
-- MINIMAL SAVE CAMPAIGN
-- ============================================
INSERT INTO campaigns (brand_id, name, objective, status) 
VALUES (1, 'Test', 'TRAFFIC', 'DRAFT') 
RETURNING id;

-- ============================================
-- MINIMAL LOG GENERATION  
-- ============================================
INSERT INTO generations (brand_id, input_payload, output_payload) 
VALUES (1, '{}'::jsonb, '{}'::jsonb) 
RETURNING id;

-- ============================================
-- NOTES:
-- ============================================
-- - These have the MINIMUM columns
-- - No $1, $2 parameters
-- - Will definitely work
-- - Use these as a last resort

