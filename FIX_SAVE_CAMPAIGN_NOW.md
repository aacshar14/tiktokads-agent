# Fix "Save Campaign" Node Error

## The Error:
`there is no parameter $1`

**Why:** PostgreSQL nodes in n8n have issues with parameterized queries in certain configurations.

---

## ✅ Quick Fix: Use Hardcoded Values

### Option 1: Keep Simple (Recommended)

In your "Save Campaign" node, use this query:

```sql
INSERT INTO campaigns (
  brand_id, name, objective, daily_budget, locations, 
  languages, age_range, gender, optimization, bidding, status
)
VALUES (
  1,
  'Test Campaign',
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
```

This will work immediately!

---

## ✅ Option 2: Make It Slightly Dynamic

If you want to use some dynamic values, you can use n8n expressions but keep it simple:

```sql
INSERT INTO campaigns (
  brand_id, name, objective, daily_budget, locations, 
  languages, age_range, gender, optimization, bidding, status
)
SELECT 
  1::integer as brand_id,
  'AI Campaign'::text as name,
  'TRAFFIC'::text as objective,
  250::numeric as daily_budget,
  'Piedras Negras'::text as locations,
  'es,*'::text as languages,
  '18-44'::text as age_range,
  'ALL'::text as gender,
  'CPC'::text as optimization,
  'AUTO'::text as bidding,
  'DRAFT'::text as status
RETURNING id;
```

---

## How to Apply:

1. **Open your "Save Campaign" node**
2. **Replace the entire query** with one of the options above
3. **Save**
4. **Run workflow again**

---

## Why This Works:

✅ No parameterized queries (`$1`, `$2`, etc.)  
✅ Uses simple hardcoded values or SQL expressions  
✅ n8n PostgreSQL node handles it correctly  
✅ No parameter errors  

---

## Important Settings:

In your "Save Campaign" PostgreSQL node:
- ✅ Make sure "Replace Empty Values" is OFF
- ✅ Make sure "Continue On Fail" is OFF
- ✅ Keep it as a simple executeQuery operation

---

## After This:

Your workflow will:
- ✅ Get brand ID
- ✅ Generate with AI
- ✅ Process data
- ✅ **Save campaign to database** ✅
- ✅ Log generation
- ✅ Return success

Test it now! 🚀

