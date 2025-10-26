# Debug Workflow - What to Check

## Error: Cannot read properties of undefined

This means the "Process Data" node isn't receiving data from all previous nodes.

## Check These:

### 1. Check Node Connections
Make sure all nodes are connected:
- ✅ Manual Trigger → Get Brand ID
- ✅ Get Brand ID → Generate with OpenAI  
- ✅ Generate with OpenAI → Process Data

### 2. Check Each Node Output
Run each node individually to see its output:

**Step 1:** Run just the trigger to see brand data
**Step 2:** Add OpenAI node and run (see if it returns data)
**Step 3:** Then add Process Data node

---

## Alternative: Simplified Workflow

Instead of fixing the complex workflow, let's test step by step:

### Test 1: Query Brands
```
Manual Trigger → PostgreSQL (SELECT * FROM brands)
```
Run this first to verify database works.

### Test 2: OpenAI Only
```
Manual Trigger → OpenAI (Generate test ad)
```
Test if OpenAI works alone.

### Test 3: Combine
Then link them together.

---

## Simplified Fix:

Use this simpler code that doesn't depend on multiple inputs:

```javascript
// Get whatever data is available
const inputs = $input.all();
const aiData = inputs.find(item => item.json.message || item.json.choices) || inputs[0];
const brandData = inputs.find(item => item.json.id || item.json.name) || {};
const inputData = inputs.find(item => item.json.brand) || {};

// Extract OpenAI response
let aiResponse = {};
try {
  if (aiData.json.message && aiData.json.message.content) {
    aiResponse = JSON.parse(aiData.json.message.content);
  } else if (aiData.json.choices) {
    aiResponse = JSON.parse(aiData.json.choices[0].message.content);
  }
} catch (e) {
  aiResponse = { campaign: {}, ad_groups: [] };
}

// Return data
return [{
  json: {
    brandId: brandData.json?.id || 1,
    brandName: inputData.json?.brand || 'Chiltepik',
    campaign: aiResponse.campaign || {},
    adGroups: aiResponse.ad_groups || [],
    inputData: inputData.json || {}
  }
}];
```

---

## Quick Test:
1. Click "Execute Node" on each previous node
2. Check what data they output
3. Then fix Process Data based on actual output format

