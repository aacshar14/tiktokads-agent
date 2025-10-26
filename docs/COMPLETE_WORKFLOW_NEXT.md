# Complete the Ads Creation Workflow

## Current Flow:
1. Get Brand ID ✅
2. Generate with OpenAI ✅
3. Process Data ✅
4. Save Campaign ✅
5. ❌ **Missing:** Save Ad Groups
6. ❌ **Missing:** Save Individual Ads
7. ❌ **Missing:** Return complete results

---

## Add These Nodes:

### After "Save Campaign":

#### Node 1: "Format Ad Groups Data"
**Type:** Code
**Code:**
```javascript
// Get campaign ID from previous node
const campaignId = $json.id; // from Save Campaign
const adGroupsData = $('Process Data').first().json.adGroups || [];

// Format each ad group for saving
const formattedAdGroups = adGroupsData.map(ag => ({
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

return formattedAdGroups;
```

#### Node 2: "Save Ad Groups" (Loop)
**Type:** PostgreSQL (Loop through items)
**Query:**
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
RETURNING id, campaign_id;
```

#### Node 3: "Format Ads Data"
**Type:** Code
**Code:**
```javascript
// Get all previous data
const adGroupId = $json.id;
const adsData = $json.ads;

if (!adsData || adsData.length === 0) {
  return []; // No ads to save
}

// Format each ad
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

#### Node 4: "Save Ads"
**Type:** PostgreSQL (Loop through items)
**Query:**
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

## Complete Flow:

```
1. Trigger
   ↓
2. Get Brand ID
   ↓
3. Generate with OpenAI
   ↓
4. Process Data
   ↓
5. Save Campaign
   ↓
6. Format Ad Groups
   ↓
7. Save Ad Groups (loop)
   ↓
8. Format Ads
   ↓
9. Save Ads (loop)
   ↓
10. Return Results
```

---

## Final Return Node:

**Code:**
```javascript
const campaignData = $('Save Campaign').first().json;
const adGroupsCount = $('Save Ad Groups').all().length;
const adsCount = $('Save Ads').all().length;

return [{
  json: {
    success: true,
    campaignId: campaignData.id,
    campaignName: campaignData.name,
    adGroupsCreated: adGroupsCount,
    adsCreated: adsCount,
    message: 'TikTok campaign created successfully with all ads!'
  }
}];
```

---

## After This Works:

1. Create query workflows to view campaigns
2. Add status management (activate/archive)
3. Add content variations
4. Build content library views

