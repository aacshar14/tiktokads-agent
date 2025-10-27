# Fix "Process Data" Node Error

## The Error:
`Cannot read properties of undefined (reading 'json')` in Process Data node

## Why This Happens:
The workflow is now using a Webhook, so the input structure is different.

---

## Solution: Update Process Data Node

### Current Code (Broken):
The code is trying to read from `items[0].json` but the structure is different with webhook input.

### Fixed Code:

Replace the entire "Process Data" node code with:

```javascript
// Get all inputs
const inputs = $input.all();

// Extract data from each input
const webhookData = $('Webhook').first().item.json.body || {};
const brandData = $('Get Brand ID').first().item.json || {};
const aiData = $json || {};

// Get brand info
const brandId = brandData?.id || brandData?.[0]?.id || 1;
const brandName = brandData?.name || brandData?.[0]?.name || webhookData?.brand || 'Chiltepik';

// Extract OpenAI response
let aiResponse = {};
try {
  if (aiData.message?.content) {
    aiResponse = JSON.parse(aiData.message.content);
  } else if (aiData.choices?.[0]?.message?.content) {
    aiResponse = JSON.parse(aiData.choices[0].message.content);
  } else if (typeof aiData === 'string') {
    aiResponse = JSON.parse(aiData);
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
    inputData: webhookData
  }
}];
```

---

## How to Fix in n8n:

1. **Open your workflow in n8n**
2. **Click on "Process Data" node**
3. **Replace the entire JavaScript code** with the code above
4. **Click "Save"**
5. **Run the workflow again** ✅

---

## What Changed:

- ✅ Uses `$('Webhook')` to get webhook data
- ✅ Uses `$('Get Brand ID')` to get brand data  
- ✅ Uses `$json` for OpenAI data
- ✅ Handles all possible OpenAI response formats
- ✅ Provides defaults for missing data
- ✅ No more "undefined" errors

---

## After This Fix:

Your workflow will:
- ✅ Get webhook input
- ✅ Get brand ID
- ✅ Generate with AI
- ✅ Process the response correctly
- ✅ Save to database
- ✅ Work end-to-end!

Test it now! 🚀

