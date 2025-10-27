# Test Your Workflow with Webhook

## Updated Workflow

I've updated the workflow to use a **Webhook** instead of manual trigger.

## How to Use:

### Step 1: Activate the Workflow

1. Go to your workflow in n8n
2. Click **"Activate"** (top right)
3. Note the webhook URL shown

### Step 2: Test with curl

```bash
curl -X POST https://n8ne01.entrega.space/webhook/ads/generate \
  -H "Content-Type: application/json" \
  -d '{
    "brand": "ChocoBites",
    "objective": "MESSAGES",
    "locations": ["Piedras Negras, MX", "Eagle Pass, US"],
    "daily_budget_mxn": 200,
    "age_range": "16-35",
    "gender": "ALL",
    "language": "es,*"
  }'
```

### Alternative: Use different brand

```bash
curl -X POST https://n8ne01.entrega.space/webhook/ads/generate \
  -H "Content-Type: application/json" \
  -d '{
    "brand": "Chiltepik",
    "objective": "TRAFFIC",
    "locations": ["Piedras Negras, MX", "Eagle Pass, US"],
    "daily_budget_mxn": 250,
    "age_range": "18-44",
    "gender": "ALL",
    "language": "es,*"
  }'
```

### Step 3: Check Response

You'll get back:
- Campaign data from AI
- Campaign saved to database
- Success message

---

## Expected Response:

```json
{
  "success": true,
  "message": "TikTok Ads campaign generated and saved successfully!",
  "brand": "ChocoBites",
  "campaign": { ... }
}
```

---

## Make Sure Workflow is Activated:

1. Open workflow in n8n
2. Click **"Active"** toggle (top right)
3. Should turn green ✅
4. Then test with curl

---

## Troubleshooting:

### "Webhook not found"
- Make sure workflow is activated
- Check the webhook URL is correct
- Verify path: `/webhook/ads/generate`

### "Connection refused"
- Check if n8n is running
- Verify the URL format

### Workflow not triggered
- Check workflow is activated
- Look at execution history in n8n

---

## Test Different Scenarios:

### Test 1: Low budget
```bash
curl -X POST https://n8ne01.entrega.space/webhook/ads/generate \
  -H "Content-Type: application/json" \
  -d '{
    "brand": "ChocoBites",
    "objective": "TRAFFIC",
    "daily_budget_mxn": 100,
    "locations": ["Piedras Negras, MX"],
    "age_range": "18-44",
    "gender": "ALL"
  }'
```

### Test 2: High budget
```bash
curl -X POST https://n8ne01.entrega.space/webhook/ads/generate \
  -H "Content-Type: application/json" \
  -d '{
    "brand": "Chiltepik",
    "objective": "CONVERSIONS",
    "daily_budget_mxn": 500,
    "locations": ["Piedras Negras, MX", "Eagle Pass, US"],
    "age_range": "25-54",
    "gender": "ALL"
  }'
```

---

## Your Webhook URL:

**URL:** `https://n8ne01.entrega.space/webhook/ads/generate`  
**Method:** POST  
**Content-Type:** application/json

Test it now!

