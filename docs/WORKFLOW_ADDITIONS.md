# Add These Nodes to Complete Your Workflow

## Workflow Additions:

### After "Save Campaign" Node:

#### 1. Add "Save Ad Groups" PostgreSQL Node

**Operation:** Execute Query  
**Query:**
```sql
INSERT INTO ad_groups (
  campaign_id, name, interests, behaviors, hashtags, 
  placements, connection
)
SELECT 
  {{ $json.id }},
  'Test Ad Group',
  'Food, Seafood',
  'Mobile users',
  '#mariscos #aguachiles',
  'AUTO',
  'ANY'
RETURNING id, campaign_id;
```

**Note:** This is a test with hardcoded values. Once it works, we'll make it dynamic.

---

#### 2. Add "Save Ads" PostgreSQL Node

**Operation:** Execute Query  
**Query:**
```sql
INSERT INTO ads (
  ad_group_id, name, primary_text, cta, duration_sec, status
)
SELECT 
  {{ $json.id }},
  'Test Ad 1',
  'Deliciosos mariscos frescos en tu frontera',
  'Order Now',
  12,
  'DRAFT'
RETURNING id;
```

---

## Test Flow:

1. **Run the workflow**
2. **Check database:**
```sql
SELECT * FROM campaigns;
SELECT * FROM ad_groups;
SELECT * FROM ads;
```
3. **Verify data saved** ✅

---

## Then Make It Dynamic:

Once the hardcoded versions work, we'll replace with actual data from the OpenAI response.

---

## Content Management - Create These Workflows:

### Workflow 1: "List All Campaigns"
**Node:** PostgreSQL Query
```sql
SELECT 
  c.id,
  c.name,
  b.name as brand,
  c.objective,
  c.daily_budget,
  c.status,
  COUNT(ag.id) as ad_groups_count
FROM campaigns c
JOIN brands b ON c.brand_id = b.id
LEFT JOIN ad_groups ag ON c.id = ag.campaign_id
GROUP BY c.id, c.name, b.name, c.objective, c.daily_budget, c.status
ORDER BY c.created_at DESC;
```

### Workflow 2: "Get Campaign with Full Structure"
**Node:** PostgreSQL Query
```sql
SELECT 
  c.id as campaign_id,
  c.name as campaign_name,
  b.name as brand,
  ag.name as ad_group_name,
  ag.interests,
  ag.behaviors,
  a.name as ad_name,
  a.primary_text,
  a.cta
FROM campaigns c
JOIN brands b ON c.brand_id = b.id
JOIN ad_groups ag ON c.id = ag.campaign_id
JOIN ads a ON ag.id = a.ad_group_id
WHERE c.id = $1;
```

---

## Quick Start Guide:

### Step 1: Test Current Flow
Add the hardcoded "Save Ad Groups" and "Save Ads" nodes
- Run workflow
- Verify data saved in database

### Step 2: Make It Dynamic
- Replace hardcoded values with actual data from OpenAI response
- Use expressions like `{{ $json.campaign.id }}`

### Step 3: Add Query Workflows
- Create workflows to view and manage your campaigns
- Use the queries above

---

## You're Ready!

See `COMPLETE_WORKFLOW_NEXT.md` for the full code for each node.

