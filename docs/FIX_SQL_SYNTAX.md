# Fix SQL Syntax Error

## Problem:
"Syntax error at line 1 near .."

The `{{ }}` expressions aren't working in PostgreSQL node queries.

## Solution Options:

### Option 1: Use Parameter Mapping (Recommended)

In your "Save Campaign" node:
1. Turn ON **"Query Replacement"** or **"Use Parameters"**
2. Use `$1, $2, $3` etc in SQL
3. Map parameters in fields below

**Query:**
```sql
INSERT INTO campaigns (
  brand_id, name, objective, daily_budget, locations, 
  languages, age_range, gender, optimization, bidding, status
)
VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
RETURNING id;
```

**Then add parameter mapping:**
- `$1` → `{{ $json.brandId }}`
- `$2` → `{{ $json.campaign.name }}`
- `$3` → `{{ $json.campaign.objective }}`
- etc.

---

### Option 2: Use Function Node First

**Add Function node before Save Campaign:**

**Code:**
```javascript
const data = $json;

// Build SQL values
const brandId = data.brandId || 1;
const campaign = data.campaign || {};
const campaignName = campaign.name || 'Default Campaign';
const objective = campaign.objective || 'TRAFFIC';
const budget = campaign.daily_budget_mxn || 250;
const locations = campaign.locations || 'Piedras Negras';
const languages = campaign.languages || 'es,*';
const ageRange = campaign.age_range || '18-44';
const gender = campaign.gender || 'ALL';
const optimization = campaign.optimization || 'CPC';
const bidding = campaign.bidding || 'AUTO';

return [{
  json: {
    brandId,
    campaignName,
    objective,
    budget,
    locations,
    languages,
    ageRange,
    gender,
    optimization,
    bidding,
    status: 'DRAFT'
  }
}];
```

**Then in Save Campaign, use simple query:**
```sql
INSERT INTO campaigns (brand_id, name, objective, daily_budget, locations, languages, age_range, gender, optimization, bidding, status)
VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
RETURNING id;
```

**Map parameters:** brandId, campaignName, objective, etc.

---

### Option 3: Use Hardcoded for Now, Fix Later

Keep using hardcoded values to test, then gradually make dynamic node by node.

---

## Recommended: Use Option 2

Add a Function node before "Save Campaign" to prepare all values, then use parameter mapping.

This is more reliable than trying to use expressions in SQL.

