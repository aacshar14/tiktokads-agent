# Simple Fix for SQL Syntax Error

## The Issue:
`{{ }}` expressions cause syntax errors in PostgreSQL node.

## ✅ Quick Fix:

### Add "Format Campaign Data" Node

**Insert before "Save Campaign" node**

**Type:** Code  
**Code:**
```javascript
const data = $json;

return [{
  json: {
    brandId: data.brandId || 1,
    campaignName: data.campaign?.name || 'Campaign',
    objective: data.campaign?.objective || 'TRAFFIC',
    budget: data.campaign?.daily_budget_mxn || 250,
    locations: data.campaign?.locations || '',
    languages: data.campaign?.languages || 'es,*',
    ageRange: data.campaign?.age_range || '18-44',
    gender: data.campaign?.gender || 'ALL',
    optimization: data.campaign?.optimization || 'CPC',
    bidding: data.campaign?.bidding || 'AUTO'
  }
}];
```

### Then Update "Save Campaign" Query

**Change to use parameter mapping if available, OR use this simpler approach:**

**Option A: Parameter Mapping (if available):**
```sql
INSERT INTO campaigns (brand_id, name, objective, daily_budget, locations, languages, age_range, gender, optimization, bidding, status)
VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
RETURNING id;
```

**Map parameters:** brandId, campaignName, objective, budget, locations, languages, ageRange, gender, optimization, bidding, 'DRAFT'

---

**Option B: Keep Hardcoded for Now:**

Since it's working, keep the hardcoded values. The workflow runs successfully!

You can make it dynamic later by:
1. Adding format nodes
2. Using parameter mapping
3. Gradually replacing hardcoded values

---

## Immediate Action:

**The syntax error is happening because you're trying to use expressions in SQL.**

**Quick fix:** Revert to the hardcoded query that was working:

```sql
INSERT INTO campaigns (brand_id, name, objective, daily_budget, locations, languages, age_range, gender, optimization, bidding, status)
VALUES (1, 'Test Campaign', 'TRAFFIC', 250, 'Piedras Negras', 'es,*', '18-44', 'ALL', 'CPC', 'AUTO', 'DRAFT')
RETURNING id;
```

This was working before! Use this to continue testing.

We'll make it dynamic later after it's stable.

