# Implementation Plan - Next Steps

## Current State
✅ Basic workflow executing  
✅ Saving campaign to database  
✅ Using hardcoded test values  

## Phase 1: Make It Dynamic (HIGH PRIORITY)

### 1.1 Fix "Save Campaign" Node
**Current:** Hardcoded values  
**Fix:** Use actual data from OpenAI

**Update SQL query:**
```sql
INSERT INTO campaigns (
  brand_id, name, objective, daily_budget, locations, 
  languages, age_range, gender, optimization, bidding, status
)
SELECT 
  {{ $json.brandId }},
  '{{ $json.campaign.name }}',
  '{{ $json.campaign.objective }}',
  {{ $json.campaign.daily_budget_mxn }},
  '{{ $json.campaign.locations }}',
  '{{ $json.campaign.languages }}',
  '{{ $json.campaign.age_range }}',
  '{{ $json.campaign.gender }}',
  '{{ $json.campaign.optimization }}',
  '{{ $json.campaign.bidding }}',
  'DRAFT'
RETURNING id;
```

### 1.2 Add Ad Groups Loop
**Add new node:** "Process Ad Groups"
**Type:** Code
**Function:** Loop through ad_groups array from OpenAI

**Code:**
```javascript
const campaignId = $json.id; // from Save Campaign
const adGroupsData = $('Process Data').first().json.adGroups || [];

return adGroupsData.map(ag => ({
  json: {
    campaignId: campaignId,
    name: ag.name,
    interests: ag.interests?.join(', ') || '',
    behaviors: ag.behaviors?.join(', ') || '',
    hashtags: ag.hashtags?.join(' ') || '',
    placements: ag.placements || 'AUTO',
    connection: ag.connection || 'ANY',
    ads: ag.ads || []
  }
}));
```

### 1.3 Update "Save Ad Groups" Query
```sql
INSERT INTO ad_groups (
  campaign_id, name, interests, behaviors, hashtags, 
  placements, connection
)
VALUES (
  {{ $json.campaignId }},
  '{{ $json.name }}',
  '{{ $json.interests }}',
  '{{ $json.behaviors }}',
  '{{ $json.hashtags }}',
  '{{ $json.placements }}',
  '{{ $json.connection }}'
)
RETURNING id;
```

### 1.4 Add Ads Loop
**Add new node:** "Process Individual Ads"
**Type:** Code
**Function:** Loop through ads in each ad group

**Code:**
```javascript
const adGroupId = $json.id;
const adsData = $json.ads || [];

return adsData.map(ad => ({
  json: {
    adGroupId: adGroupId,
    name: ad.name,
    primaryText: ad.primary_text,
    cta: ad.cta || 'Order Now',
    durationSec: ad.duration_sec || 12,
    musicHint: ad.music_hint || '',
    assetUrl: ad.asset_url || '',
    status: 'DRAFT'
  }
}));
```

### 1.5 Update "Save Ads" Query
```sql
INSERT INTO ads (
  ad_group_id, name, primary_text, cta, duration_sec, 
  music_hint, asset_url, status
)
VALUES (
  {{ $json.adGroupId }},
  '{{ $json.name }}',
  '{{ $json.primaryText }}',
  '{{ $json.cta }}',
  {{ $json.durationSec }},
  '{{ $json.musicHint }}',
  '{{ $json.assetUrl }}',
  '{{ $json.status }}'
)
RETURNING id;
```

---

## Phase 2: Create Query Workflows

### 2.1 "List All Campaigns" Workflow
**Purpose:** View all campaigns with summary

**Query:**
```sql
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
GROUP BY c.id, c.name, b.name, c.objective, c.daily_budget, c.status
ORDER BY c.created_at DESC;
```

### 2.2 "Get Campaign Details" Workflow  
**Purpose:** Get full campaign structure

**Query:**
```sql
SELECT 
  c.id as campaign_id,
  c.name as campaign_name,
  b.name as brand,
  ag.name as ad_group_name,
  ag.interests,
  ag.behaviors,
  ag.hashtags,
  a.name as ad_name,
  a.primary_text,
  a.cta,
  a.status as ad_status
FROM campaigns c
JOIN brands b ON c.brand_id = b.id
JOIN ad_groups ag ON c.id = ag.campaign_id
JOIN ads a ON ag.id = a.ad_group_id
WHERE c.id = $1
ORDER BY ag.id, a.id;
```

### 2.3 "Update Campaign Status" Workflow
**Purpose:** Activate, pause, or archive campaigns

**Query:**
```sql
UPDATE campaigns 
SET status = $1 
WHERE id = $2
RETURNING id, status;
```

---

## Phase 3: Content Management

### 3.1 Add Brand Management
- Create brand workflow
- Update brand information
- List all brands

### 3.2 Add A/B Testing
- Generate variations
- Track performance
- Compare results

### 3.3 Add Scheduling
- Schedule campaign start dates
- Set end dates
- Auto-activate campaigns

---

## Implementation Order

### Week 1:
1. Make Save Campaign dynamic ✅
2. Add ad groups loop ✅
3. Add ads loop ✅
4. Test complete flow ✅

### Week 2:
1. Create query workflows
2. Test data retrieval
3. Verify all relationships

### Week 3:
1. Add status management
2. Add content variations
3. Build content library

---

## Testing Strategy

1. **Unit Test:** Each node individually
2. **Integration Test:** Full workflow end-to-end
3. **Data Test:** Verify all data saved correctly
4. **Query Test:** Verify all queries return correct data

---

## Success Criteria

✅ Campaign saves with AI-generated data  
✅ All ad groups saved to database  
✅ All ads saved to database  
✅ Can query and view campaigns  
✅ Can manage campaign status  
✅ Complete audit trail in generations table  

---

## Next Action:
Start with Phase 1.1 - Make Save Campaign dynamic

