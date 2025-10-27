#!/bin/bash

# Test your TikTok Ads Workflow

# Update this URL with your n8n webhook URL
WEBHOOK_URL="https://n8ne01.entrega.space/webhook/ads/generate"

echo "Testing TikTok Ads Generation..."
echo ""

# Test 1: ChocoBites Campaign
echo "Test 1: ChocoBites - MESSAGES"
curl -X POST "$WEBHOOK_URL" \
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

echo ""
echo ""
echo "Test 2: Chiltepik - TRAFFIC"
curl -X POST "$WEBHOOK_URL" \
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

echo ""
echo "Done!"

