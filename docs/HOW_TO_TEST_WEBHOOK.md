# How to Test Your Webhook Workflow

## Quick Steps:

### 1. Import Updated Workflow

The workflow file `tiktok_ads_master_workflow.json` has been updated with:
- ✅ Webhook trigger (instead of manual)
- ✅ Fixed SQL query (uses $1 parameter)
- ✅ Ready to receive POST requests

**Import it into n8n:**
1. Go to n8n
2. Import workflow
3. Select `tiktok_ads_master_workflow.json`
4. **Activate the workflow** (toggle switch)

---

### 2. Get Your Webhook URL

After importing and activating, n8n will show you:
**Webhook URL:** `https://n8ne01.entrega.space/webhook/ads/generate`

Copy this URL!

---

### 3. Test with curl

**Windows PowerShell:**
```powershell
Invoke-RestMethod -Uri "https://n8ne01.entrega.space/webhook/ads/generate" `
  -Method Post `
  -ContentType "application/json" `
  -Body '{
    "brand": "ChocoBites",
    "objective": "MESSAGES",
    "locations": ["Piedras Negras, MX", "Eagle Pass, US"],
    "daily_budget_mxn": 200,
    "age_range": "16-35",
    "gender": "ALL",
    "language": "es,*"
  }'
```

**Git Bash or Linux:**
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

---

### 4. Alternative: Use Postman

1. Create new request
2. **Method:** POST
3. **URL:** `https://n8ne01.entrega.space/webhook/ads/generate`
4. **Headers:** `Content-Type: application/json`
5. **Body (raw JSON):**
```json
{
  "brand": "ChocoBites",
  "objective": "MESSAGES",
  "locations": ["Piedras Negras, MX", "Eagle Pass, US"],
  "daily_budget_mxn": 200,
  "age_range": "16-35",
  "gender": "ALL",
  "language": "es,*"
}
```
6. Click Send

---

## Expected Response:

You should see:
```json
{
  "success": true,
  "message": "Campaign generated and saved",
  "campaignId": 1
}
```

---

## Check in n8n:

1. Go to n8n
2. Click on "Executions" (left menu)
3. See your workflow execution
4. Click to view details
5. Check each node's output

---

## Test Different Brands:

### Chiltepik:
```json
{
  "brand": "Chiltepik",
  "objective": "TRAFFIC",
  "locations": ["Piedras Negras, MX"],
  "daily_budget_mxn": 250,
  "age_range": "18-44",
  "gender": "ALL",
  "language": "es,*"
}
```

---

## Troubleshooting:

### "404 Not Found"
- Make sure workflow is **activated**
- Check the webhook URL is correct
- Verify path: `/webhook/ads/generate`

### "No brand found"
- Make sure brand exists in database
- Check spelling: "ChocoBites" or "Chiltepik"

### Query error
- Check n8n execution details
- Verify database connection is working

---

## Quick Test Command:

Copy and run this in PowerShell:

```powershell
$body = @{
  brand = "ChocoBites"
  objective = "MESSAGES"
  locations = @("Piedras Negras, MX", "Eagle Pass, US")
  daily_budget_mxn = 200
  age_range = "16-35"
  gender = "ALL"
  language = "es,*"
} | ConvertTo-Json

Invoke-RestMethod -Uri "https://n8ne01.entrega.space/webhook/ads/generate" -Method Post -ContentType "application/json" -Body $body
```

Ready to test! 🚀

