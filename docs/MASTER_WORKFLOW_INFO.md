# TikTok Ads Master Workflow

## File: `tiktok_ads_master_workflow.json`

This is your **working master workflow** - save this for future reference!

## Workflow Nodes:

1. **Manual Trigger** - Start workflow
2. **Get Brand ID** - Query database for brand
3. **Generate with OpenAI** - Generate TikTok ads with AI
4. **Process Data** - Structure the AI response
5. **Save Campaign** - Insert campaign to database
6. **Save Ads** - Insert ad groups to database
7. **Save Ad Groups** - Additional ad group processing
8. **Prepare Log** - Format generation log data
9. **Log Generation** - Save to generations table
10. **Return Result** - Final success message

## Current Status:
- ✅ Successfully executing
- ✅ Saving to database
- ✅ Using hardcoded test values

## Next Steps:

### Make it Dynamic:
1. Replace hardcoded values in "Save Campaign" with actual data
2. Make "Save Ads" loop through ad groups from AI response
3. Add loop for individual ads
4. Update queries to use expressions like `{{ $json.campaign.name }}`

See `COMPLETE_WORKFLOW_NEXT.md` for detailed next steps.

## Import Instructions:

To re-import this workflow:
1. Go to https://n8ne01.entrega.space
2. Click "Import from File"
3. Upload `tiktok_ads_master_workflow.json`
4. Configure credentials:
   - Postgres account (id: DgapWprXhXGmXRc1)
   - OpenAi account (id: rEeljXZUbLsUttr6)
5. Test!

