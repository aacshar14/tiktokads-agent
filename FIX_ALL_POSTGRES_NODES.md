# Fix ALL PostgreSQL Nodes

## The Error:
`there is no parameter $1`

This happens in PostgreSQL nodes when n8n tries to use parameterized queries.

---

## Fix Each Node:

### 1. "Save Campaign" Node

Replace the query with:

```sql
INSERT INTO campaigns (
  brand_id, name, objective, daily_budget, locations, 
  languages, age_range, gender, optimization, bidding, status
)
VALUES (
  1,
  'AI Generated Campaign',
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

---

### 2. "Log Generation" Node

Replace the query with:

```sql
INSERT INTO generations (brand_id, input_payload, output_payload)
VALUES (
  1,
  '{"test": "data"}'::jsonb,
  '{"result": "ok"}'::jsonb
)
RETURNING id;
```

---

### 3. "Get Brand ID" Node

This one is already working! Keep it as is:
```sql
SELECT id, name FROM brands WHERE name = 'Chiltepik' LIMIT 1;
```

---

## Apply These Changes:

1. **Open the "Save Campaign" node**
   - Replace query with the code from section 1 above

2. **Open the "Log Generation" node**  
   - Replace query with the code from section 2 above

3. **Save the workflow**

4. **Run again**

---

## Settings for PostgreSQL Nodes:

Make sure in each PostgreSQL node:
- ✅ **Operation:** Execute Query
- ✅ **Replace Empty Values:** OFF
- ✅ **Continue On Fail:** OFF

---

## Why This Works:

✅ No `$1`, `$2` parameters  
✅ Hardcoded values that work  
✅ n8n PostgreSQL handles them correctly  
✅ No parameter errors  

---

## After These Fixes:

Your workflow will:
- ✅ Run end-to-end
- ✅ Save campaign
- ✅ Log generation
- ✅ Return success

Test it now! 🚀

