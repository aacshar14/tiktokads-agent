# Fix: Save Campaign Node

## Problem:
"there is no parameter $1"

The PostgreSQL node is using parameters but they aren't mapped.

## Solution Options:

### Option 1: Use Actual Values (Easier)

**In the "Save Campaign" node:**

Change the query to use actual values instead of parameters:

```sql
INSERT INTO campaigns (brand_id, name, objective, daily_budget, locations, languages, age_range, gender, optimization, bidding, status)
VALUES (
  $('Get Brand ID').first().json.id,
  $('Process Data').first().json.campaign.name,
  $('Process Data').first().json.campaign.objective,
  $('Process Data').first().json.campaign.daily_budget_mxn,
  $('Process Data').first().json.campaign.locations,
  $('Process Data').first().json.campaign.languages,
  $('Process Data').first().json.campaign.age_range,
  $('Process Data').first().json.campaign.gender,
  $('Process Data').first().json.campaign.optimization,
  $('Process Data').first().json.campaign.bidding,
  'DRAFT'
)
RETURNING id;
```

### Option 2: Fix Parameter Mapping

**If using $1, $2, etc., you need to add them:**

In the "Save Campaign" node:
1. Turn OFF "Replace Query" or "Use Parameters"
2. Use the query from Option 1 above

### Option 3: Simplify the Query

**Use this simpler version:**

```sql
INSERT INTO campaigns (
  brand_id, name, objective, daily_budget, locations, languages, age_range, gender, optimization, bidding, status
)
VALUES (
  {{ $json.brandId }},
  {{ $json.campaign.name }},
  {{ $json.campaign.objective }},
  {{ $json.campaign.daily_budget_mxn }},
  '{{ $json.campaign.locations }}',
  '{{ $json.campaign.languages }}',
  '{{ $json.campaign.age_range }}',
  '{{ $json.campaign.gender }}',
  '{{ $json.campaign.optimization }}',
  '{{ $json.campaign.bidding }}',
  'DRAFT'
)
RETURNING id;
```

---

## Recommended: Use Option 3 (Simplest)

Copy the query from Option 3 into your "Save Campaign" node.

It uses simple expressions instead of parameters.

