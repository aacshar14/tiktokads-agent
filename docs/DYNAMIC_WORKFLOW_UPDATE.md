# Make Your Workflow Fully Dynamic

## Current Issue
Your workflow is using **hardcoded test values** instead of real data from OpenAI.

## The Fix

### Step 1: Update "Save Campaign" Node

**Replace the query** from:
```sql
INSERT INTO campaigns (...) VALUES (1, 'Test Campaign', 'TRAFFIC', ...)
```

**To:**
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
  COALESCE('{{ $json.campaign.languages }}', 'es,*'),
  COALESCE('{{ $json.campaign.age_range }}', '18-44'),
  COALESCE('{{ $json.campaign.gender }}', 'ALL'),
  COALESCE('{{ $json.campaign.optimization }}', 'CPC'),
  COALESCE('{{ $json.campaign.bidding }}', 'AUTO'),
  'DRAFT'
RETURNING id;
```

This uses **actual data** from the OpenAI response!

---

### Step 2: Add Node to Split Ad Groups

**Add:** "Split Ad Groups" node (Code)
**After:** Save Campaign
**Code:**
```javascript
const campaignId = $json.id;
const adGroupsData = $('Process Data').first().json.adGroups || [];

return adGroupsData.map((ag, index) => ({
  json: {
    campaignId: campaignId,
    name: ag.name || `Ad Group ${index + 1}`,
    interests: Array.isArray(ag.interests) ? ag.interests.join(', ') : ag.interests || '',
    behaviors: Array.isArray(ag.behaviors) ? ag.behaviors.join(', ') : ag.behaviors || '',
    hashtags: Array.isArray(ag.hashtags) ? ag.hashtags.join(' ') : ag.hashtags || '',
    placements: ag.placements || 'AUTO',
    connection: ag.connection || 'ANY',
    ads: ag.ads || []
  }
}));
```

---

### Step 3: Update "Save Ad Groups" Node

**Change the query to:**
```sql
INSERT INTO ad_groups (
  campaign_id, name, interests, behaviors, hashtags, 
  placements, connection
)
SELECT 
  {{ $json.campaignId }},
  '{{ $json.name }}',
  '{{ $json.interests }}',
  '{{ $json.behaviors }}',
  '{{ $json.hashtags }}',
  '{{ $json.placements }}',
  '{{ $json.connection }}'
RETURNING id, campaign_id;
```

And make sure it **loops through all items**

---

### Step 4: Add Split Individual Ads Node

**Add:** "Split Ads" node (Code)
**After:** Save Ad Groups
**Code:**
```javascript
const adGroupId = $json.id;
const adsData = $json.ads || [];

return adsData.map((ad, index) => ({
  json: {
    adGroupId: adGroupId,
    name: ad.name || `Ad ${index + 1}`,
    primaryText: ad.primary_text || '',
    cta: ad.cta || 'Order Now',
    durationSec: ad.duration_sec || 12,
    musicHint: ad.music_hint || '',
    assetUrl: ad.asset_url || '',
    status: 'DRAFT'
  }
}));
```

---

### Step 5: Update "Save Ads" Node

**Change the query to:**
```sql
INSERT INTO ads (
  ad_group_id, name, primary_text, cta, duration_sec, 
  music_hint, asset_url, status
)
SELECT 
  {{ $json.adGroupId }},
  '{{ $json.name }}',
  '{{ $json.primaryText }}',
  '{{ $json.cta }}',
  {{ $json.durationSec }},
  '{{ $json.musicHint }}',
  '{{ $json.assetUrl }}',
  '{{ $json.status }}'
RETURNING id;
```

And make sure it **loops through all items**

---

## Complete Flow After Updates:

```
1. Trigger
   ↓
2. Get Brand ID
   ↓
3. Generate with OpenAI
   ↓
4. Process Data
   ↓
5. Save Campaign ← Uses $json.campaign.*
   ↓
6. Split Ad Groups ← New node added
   ↓
7. Save Ad Groups ← Loops through items
   ↓
8. Split Ads ← New node added  
   ↓
9. Save Ads ← Loops through items
   ↓
10. Log Generation
   ↓
11. Return Result
```

---

## Quick Summary:

**Replace 3 queries:**
1. Save Campaign - Use actual campaign data
2. Save Ad Groups - Loop through items
3. Save Ads - Loop through items

**Add 2 code nodes:**
1. Split Ad Groups - Array to items
2. Split Ads - Array to items

**Result:** Fully dynamic workflow that saves real AI data!

---

## Test After Changes:

Run workflow → Check database:
```sql
SELECT * FROM campaigns;
SELECT * FROM ad_groups;  
SELECT * FROM ads;
```

All should have **real data** from AI! ✅

