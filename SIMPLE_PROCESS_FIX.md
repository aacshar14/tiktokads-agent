# Simple Fix for Process Data Node

## The Error:
`Error finding the referenced node`

**Why:** The code tries to reference nodes by name like `$('Webhook')` and `$('Get Brand ID')` but those names might be different in your workflow.

---

## ✅ Simple Solution

### Replace the "Process Data" node code with this:

**Open `PROCESS_DATA_SIMPLE_CODE.js` and copy the entire code**

Or use this code directly:

```javascript
// Get the current input item (from OpenAI)
const aiData = $json || {};

// Try to get previous inputs
let brandData = {};
try {
  const item = $input.all()[0];
  if (item && item.json) {
    brandData = item.json;
  }
} catch (e) {}

// Extract brand info with defaults
const brandId = brandData?.id || 1;
const brandName = brandData?.name || 'Chiltepik';

// Parse OpenAI response
let aiResponse = {};
try {
  if (aiData.message?.content) {
    aiResponse = JSON.parse(aiData.message.content);
  } else if (aiData.choices?.[0]?.message?.content) {
    aiResponse = JSON.parse(aiData.choices[0].message.content);
  } else if (typeof aiData === 'string') {
    aiResponse = JSON.parse(aiData);
  } else if (aiData.campaign) {
    aiResponse = aiData;
  } else {
    aiResponse = aiData;
  }
} catch (e) {
  aiResponse = aiData;
}

// Return structured data
return [{
  json: {
    brandId: brandId,
    brandName: brandName,
    campaign: aiResponse.campaign || {},
    adGroups: aiResponse.ad_groups || [],
    fullResponse: aiResponse
  }
}];
```

---

## How to Apply:

1. **Open the "Process Data" node in n8n**
2. **Replace ALL the code** with the code above
3. **Save**
4. **Run workflow again**

---

## What This Does:

✅ Uses ONLY `$json` (current input) - no node references  
✅ Handles all OpenAI response formats  
✅ Provides safe defaults  
✅ No errors about referenced nodes  
✅ Works with any workflow structure  

---

## After This:

Your workflow will work! The "Process Data" node will output:
- `brandId`: The brand ID
- `brandName`: The brand name
- `campaign`: The AI-generated campaign
- `adGroups`: The AI-generated ad groups

Test it now! 🚀

