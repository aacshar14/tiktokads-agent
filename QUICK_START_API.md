# Quick Start - API Endpoint

## ✅ Your Endpoint is Ready!

**POST** `https://n8ne01.entrega.space/webhook/ads/generate`

---

## 🚀 Test Right Now

### Option 1: PowerShell (Windows)

Open PowerShell and run:

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

Invoke-RestMethod -Uri "https://n8ne01.entrega.space/webhook/ads/generate" `
  -Method Post `
  -ContentType "application/json" `
  -Body $body
```

---

### Option 2: Git Bash

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

### Option 3: Postman

1. Method: **POST**
2. URL: `https://n8ne01.entrega.space/webhook/ads/generate`
3. Headers: `Content-Type: application/json`
4. Body (raw JSON):
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

---

## ✅ What You'll Get

```json
{
  "success": true,
  "message": "Campaign generated and saved",
  "campaignId": 1
}
```

---

## 📋 Documentation

See `API_ENDPOINT_SETUP.md` for:
- Complete API specification
- All parameters explained
- Example code in multiple languages
- Error handling
- Testing strategies

---

## 🎯 Next Steps

1. Import `tiktok_ads_api_workflow.json` into n8n
2. Activate the workflow
3. Test with curl/PowerShell/Postman
4. Check results in database

Ready to test! 🚀

