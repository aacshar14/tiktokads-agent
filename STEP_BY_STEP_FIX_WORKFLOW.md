# Step-by-Step: Fix Your Workflow (No More Errors!)

## What You Need to Do:

Find **EVERY** PostgreSQL node in your workflow and replace the query.

---

## Step 1: Find All PostgreSQL Nodes

In your n8n workflow canvas, look for nodes with "Postgres" in the name:
- "Get Brand ID" ✅ (Usually already working)
- "Save Campaign" ⚠️ (Needs fix)
- "Log Generation" ⚠️ (Needs fix)
- Any other PostgreSQL nodes

---

## Step 2: Fix "Save Campaign" Node

### How to Find It:
- Look for a PostgreSQL node that comes AFTER "Process Data" node
- It probably says "Save Campaign" or similar

### Click on it, then replace the SQL with:

```sql
INSERT INTO campaigns (
  brand_id, name, objective, daily_budget, locations, 
  languages, age_range, gender, optimization, bidding, status
)
SELECT 
  1::integer,
  'Test Campaign'::text,
  'TRAFFIC'::text,
  250::numeric,
  'Piedras Negras, MX'::text,
  'es,*'::text,
  '18-44'::text,
  'ALL'::text,
  'CPC'::text,
  'AUTO'::text,
  'DRAFT'::text
RETURNING id;
```

**Important:** Make sure there are NO `$1`, `$2`, etc. in the query!

---

## Step 3: Fix "Log Generation" Node

### How to Find It:
- Look for a PostgreSQL node AFTER "Save Campaign"
- It probably says "Log Generation" or "Save Generation" or similar

### Click on it, then replace the SQL with:

```sql
INSERT INTO generations (brand_id, input_payload, output_payload)
SELECT 
  1::integer,
  '{"test": "data"}'::jsonb,
  '{"result": "ok"}'::jsonb
RETURNING id;
```

**Important:** Make sure there are NO `$1`, `$2`, etc. in the query!

---

## Step 4: Leave "Get Brand ID" Alone

The "Get Brand ID" node should have:
```sql
SELECT id, name FROM brands WHERE name = 'Chiltepik' LIMIT 1;
```

If it's working, **don't change it**!

---

## Step 5: Save and Test

1. Click "Save" in n8n
2. Run the workflow
3. It should work! 🎉

---

## How to Know Which Node Is Failing:

Look at the error stack trace in n8n - it will tell you which node failed:

- If it says "Get Brand ID" → Check that node
- If it says "Save Campaign" → Check that node  
- If it says "Log Generation" → Check that node

---

## Common Issues:

### ❌ "Replace Empty Values" is ON
- Turn it OFF in PostgreSQL node settings

### ❌ Query has `$1`, `$2`, etc.
- Replace with direct values or expressions

### ❌ Query has n8n expressions that evaluate to undefined
- Use hardcoded values for now

---

## Quick Checklist:

- [ ] Found "Save Campaign" node
- [ ] Replaced its SQL query
- [ ] Found "Log Generation" node
- [ ] Replaced its SQL query
- [ ] No `$1`, `$2` parameters in queries
- [ ] Saved workflow
- [ ] Tested workflow
- [ ] No errors! ✅

---

## Still Getting Errors?

Tell me which **exact node name** is failing and I'll give you the exact query for that node!

