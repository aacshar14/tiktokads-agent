# Endpoint API: POST /ads/generate

## Endpoint Details

**URL:** `POST https://n8ne01.entrega.space/webhook/ads/generate`

**Purpose:** Generate TikTok ad campaigns using AI

---

## Request Format

### Headers:
```
Content-Type: application/json
```

### Body Parameters:
```json
{
  "brand": "ChocoBites",          // Required: Brand name
  "objective": "MESSAGES",         // Required: Campaign objective
  "daily_budget_mxn": 200,         // Required: Daily budget in MXN
  "locations": ["Piedras Negras, MX", "Eagle Pass, US"],  // Required
  "age_range": "16-35",            // Optional: Default "18-44"
  "gender": "ALL",                 // Optional: Default "ALL"
  "language": "es,*"               // Optional: Default "es,*"
}
```

---

## Response Format

### Success (200):
```json
{
  "success": true,
  "message": "Campaign generated and saved",
  "campaignId": 123,
  "campaign": {
    "name": "ChocoBites Summer Campaign",
    "objective": "MESSAGES",
    "daily_budget_mxn": 200,
    "locations": "Piedras Negras, MX | Eagle Pass, US",
    ...
  }
}
```

### Error (400 - Bad Request):
```json
{
  "success": false,
  "error": "Invalid input: brand is required"
}
```

### Error (404 - Brand Not Found):
```json
{
  "success": false,
  "error": "Brand not found: InvalidBrand"
}
```

---

## Available Campaign Objectives

- `TRAFFIC` - Drive website traffic
- `CONVERSIONS` - Generate conversions
- `MESSAGES` - Get messages/leads
- `APP_PROMOTION` - Promote app downloads
- `VIDEO_VIEWS` - Maximize video views

---

## Example Requests

### Example 1: ChocoBites - Messages Campaign

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

### Example 2: Chiltepik - Traffic Campaign

```bash
curl -X POST https://n8ne01.entrega.space/webhook/ads/generate \
  -H "Content-Type: application/json" \
  -d '{
    "brand": "Chiltepik",
    "objective": "TRAFFIC",
    "locations": ["Piedras Negras, MX"],
    "daily_budget_mxn": 250,
    "age_range": "18-44",
    "gender": "ALL",
    "language": "es,*"
  }'
```

### Example 3: Minimal Request (with defaults)

```bash
curl -X POST https://n8ne01.entrega.space/webhook/ads/generate \
  -H "Content-Type: application/json" \
  -d '{
    "brand": "ChocoBites",
    "objective": "CONVERSIONS",
    "daily_budget_mxn": 300,
    "locations": ["Piedras Negras, MX"]
  }'
```

---

## Integration Code Examples

### JavaScript/Node.js
```javascript
const response = await fetch('https://n8ne01.entrega.space/webhook/ads/generate', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    brand: 'ChocoBites',
    objective: 'MESSAGES',
    daily_budget_mxn: 200,
    locations: ['Piedras Negras, MX', 'Eagle Pass, US'],
    age_range: '16-35',
    gender: 'ALL',
    language: 'es,*'
  })
});

const result = await response.json();
console.log(result);
```

### Python
```python
import requests

url = "https://n8ne01.entrega.space/webhook/ads/generate"
payload = {
    "brand": "ChocoBites",
    "objective": "MESSAGES",
    "daily_budget_mxn": 200,
    "locations": ["Piedras Negras, MX", "Eagle Pass, US"],
    "age_range": "16-35",
    "gender": "ALL",
    "language": "es,*"
}

response = requests.post(url, json=payload)
print(response.json())
```

### PHP
```php
<?php
$url = "https://n8ne01.entrega.space/webhook/ads/generate";
$data = [
    "brand" => "ChocoBites",
    "objective" => "MESSAGES",
    "daily_budget_mxn" => 200,
    "locations" => ["Piedras Negras, MX", "Eagle Pass, US"],
    "age_range" => "16-35",
    "gender" => "ALL",
    "language" => "es,*"
];

$ch = curl_init($url);
curl_setopt($ch, CURLOPT_POST, 1);
curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
curl_setopt($ch, CURLOPT_HTTPHEADER, ["Content-Type: application/json"]);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

$response = curl_exec($ch);
curl_close($ch);

echo $response;
?>
```

---

## Testing

### Test in Browser (disabled for webhooks, use curl)

### Test with Postman

1. Create new POST request
2. URL: `https://n8ne01.entrega.space/webhook/ads/generate`
3. Headers: `Content-Type: application/json`
4. Body (raw JSON): Use example above
5. Click Send

### Test with curl

```bash
curl -X POST https://n8ne01.entrega.space/webhook/ads/generate \
  -H "Content-Type: application/json" \
  -d @test-payload.json
```

---

## Workflow Setup

Import `tiktok_ads_api_workflow.json` into n8n and activate it.

The endpoint is now ready to receive POST requests!

