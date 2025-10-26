# Fix Data Flow from Process Data to Save Campaign

## ✅ What Works:
- Database connection ✅
- Tables exist ✅  
- INSERT works ✅

## ❌ What Doesn't Work:
- Data from Process Data node shows as "undefined"

---

## Fix: Check Process Data Output

### Step 1: See What Data Exists

Before "Save Campaign" node, add a **Set** node:

1. **Add "Set" node** between Process Data and Save Campaign
2. In this node, create fields and map them:
   - `brandId` → {{ $json.brandId }}
   - `campaignName` → {{ $json.campaign.name }}
   - `objective` → {{ $json.campaign.objective }}
   - etc.
3. This will show you what data actually exists
4. Run it and check the output

### Step 2: Once You See the Data

Update "Save Campaign" query to use the values from Set node:

```sql
INSERT INTO campaigns (brand_id, name, objective, daily_budget, locations, languages, age_range, gender, optimization, bidding, status)
VALUES (
  {{ $json.brandId }},
  '{{ $json.campaignName }}',
  '{{ $json.objective }}',
  {{ $json.budget }},
  'Piedras Negras',
  'es,*',
  '18-44',
  'ALL',
  'CPC',
  'AUTO',
  'DRAFT'
)
RETURNING id;
```

---

## Alternative: Fix Process Data Output

In "Process Data" node, ensure it outputs this structure:

```javascript
const aiData = $input.first().json;

let campaignData;
try {
  campaignData = aiData.message?.content || aiData.choices?.[0]?.message?.content;
  campaignData = JSON.parse(campaignData);
} catch (e) {
  campaignData = { campaign: {}, ad_groups: [] };
}

return [{
  json: {
    brandId: 1,
    campaignName: campaignData.campaign?.name || 'Test Campaign',
    objective: campaignData.campaign?.objective || 'TRAFFIC',
    budget: campaignData.campaign?.daily_budget_mxn || 250,
    locations: 'Piedras Negras, MX',
    campaignData: campaignData
  }
}];
```

Then in Save Campaign, use:
```sql
INSERT INTO campaigns (brand_id, name, objective, daily_budget, locations, languages, age_range, gender, optimization, bidding, status)
VALUES (
  {{ $json.brandId }},
  '{{ $json.campaignName }}',
  '{{ $json.objective }}',
  {{ $json.budget }},
  '{{ $json.locations }}',
  'es,*', '18-44', 'ALL', 'CPC', 'AUTO', 'DRAFT'
)
RETURNING id;
```

---

## Next Step:
Add the Set node to debug what data flows to Save Campaign!

