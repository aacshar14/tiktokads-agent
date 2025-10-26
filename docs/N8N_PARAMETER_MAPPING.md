# n8n PostgreSQL Parameter Mapping Guide

## How to Map Parameters in n8n PostgreSQL Node

### Step-by-Step:

1. **Open your "Save Campaign" node**
2. **Turn ON:** "Query Replacement" or "Replace Values" option
3. **Use `$1, $2, $3` in SQL** instead of expressions
4. **Add Parameters section** - you'll see fields for each parameter

### Example:

**SQL Query:**
```sql
INSERT INTO campaigns (
  brand_id, name, objective, daily_budget, 
  locations, languages, age_range, gender, 
  optimization, bidding, status
)
VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
RETURNING id;
```

**Parameter Mapping (if available in your n8n version):**
- Parameter 1: `{{ $json.brandId }}`
- Parameter 2: `{{ $json.campaign.name }}`
- Parameter 3: `{{ $json.campaign.objective }}`
- Parameter 4: `{{ $json.campaign.daily_budget_mxn }}`
- Parameter 5: `{{ $json.campaign.locations }}`
- Parameter 6: `{{ $json.campaign.languages }}`
- Parameter 7: `{{ $json.campaign.age_range }}`
- Parameter 8: `{{ $json.campaign.gender }}`
- Parameter 9: `{{ $json.campaign.optimization }}`
- Parameter 10: `{{ $json.campaign.bidding }}`
- Parameter 11: `'DRAFT'`

---

## Alternative: Code Node to Format Data

**Add "Format Campaign Data" node before Save Campaign:**

```javascript
const data = $json;

return [{
  json: {
    brandId: data.brandId,
    campaignName: data.campaign.name || 'Campaign',
    objective: data.campaign.objective || 'TRAFFIC',
    budget: data.campaign.daily_budget_mxn || 250,
    locations: data.campaign.locations || '',
    languages: data.campaign.languages || 'es,*',
    ageRange: data.campaign.age_range || '18-44',
    gender: data.campaign.gender || 'ALL',
    optimization: data.campaign.optimization || 'CPC',
    bidding: data.campaign.bidding || 'AUTO'
  }
}];
```

**Then Save Campaign query:**
```sql
INSERT INTO campaigns (brand_id, name, objective, daily_budget, locations, languages, age_range, gender, optimization, bidding, status)
VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
RETURNING id;
```

This way each field comes from previous node!

