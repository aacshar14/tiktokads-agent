# Fix Workflow Inputs in n8n

## Issues to Fix:

### 1. ✅ OpenAI Node - Change Operation
**Location:** "Generate with OpenAI" node

**Fix:**
- Click on the OpenAI node
- Find **"Operation"** dropdown
- Change from: **"Complete"**
- To: **"Chat"** (or "Chat Messages")
- Save

**Why:** GPT-4 needs chat endpoint, not completions endpoint

---

### 2. ✅ Process Data Node - Fix JSON Parsing
**Location:** "Process Data" node

**Fix:**
- Click on "Process Data" node
- Replace the code with this:

```javascript
// Get OpenAI response
const aiItem = items[0].json;
const brandItem = items[1].json;
const inputItem = items[2].json;

// Extract OpenAI message content
let aiResponse;
if (aiItem.message && aiItem.message.content) {
  try {
    aiResponse = JSON.parse(aiItem.message.content);
  } catch (e) {
    aiResponse = aiItem.message.content;
  }
} else if (aiItem.choices && aiItem.choices[0]) {
  aiResponse = JSON.parse(aiItem.choices[0].message.content);
} else if (typeof aiItem === 'string') {
  aiResponse = JSON.parse(aiItem);
} else {
  aiResponse = aiItem;
}

// Get brand ID
const brandId = brandItem?.id || brandItem?.[0]?.id || 1;
const brandName = inputItem?.brand || 'Chiltepik';

// Structure the data
const result = {
  brandId: brandId,
  brandName: brandName,
  campaign: aiResponse.campaign,
  adGroups: aiResponse.ad_groups,
  inputData: inputItem
};

return [{ json: result }];
```

- Save

---

### 3. ✅ Get Brand ID Node - Fix Query
**Location:** "Get Brand ID" node

**Fix:**
- Change the SQL query to handle input properly:

```sql
SELECT id, name FROM brands WHERE name = $1 LIMIT 1;
```

Or use:
```sql
SELECT id, name FROM brands WHERE LOWER(name) = LOWER($1) LIMIT 1;
```

- **Parameters:** Add `brand` as parameter

---

## Summary:
1. OpenAI node: Change operation to "chat"
2. Process Data node: Use the new code above
3. Get Brand ID node: Fix the SQL query

Then test!

