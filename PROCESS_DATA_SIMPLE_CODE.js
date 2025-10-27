// Process Data Node - Simple Version
// This works without referencing specific node names

// Get the current input item (from OpenAI)
const aiData = $json || {};

// Try to get previous inputs from execution context
let brandData = {};
let webhookData = {};

// Try to get data from previous nodes safely
try {
  // Check if we have execution context
  const item = $input.all()[0];
  
  // Get brand data if available
  if (item && item.json) {
    brandData = item.json;
  }
} catch (e) {
  // Ignore if not available
}

// Extract brand info with defaults
const brandId = brandData?.id || 1;
const brandName = brandData?.name || 'Chiltepik';

// Parse OpenAI response
let aiResponse = {};
try {
  // Try different OpenAI response formats
  if (aiData.message?.content) {
    aiResponse = JSON.parse(aiData.message.content);
  } else if (aiData.choices?.[0]?.message?.content) {
    aiResponse = JSON.parse(aiData.choices[0].message.content);
  } else if (typeof aiData === 'string') {
    aiResponse = JSON.parse(aiData);
  } else if (aiData.campaign) {
    // Already parsed JSON
    aiResponse = aiData;
  } else {
    aiResponse = aiData;
  }
} catch (e) {
  console.error('Error parsing AI response:', e);
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

