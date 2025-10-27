// Process Data Node - Fixed Code
// Paste this into the "Process Data" node in n8n

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

