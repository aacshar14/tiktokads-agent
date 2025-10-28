# Platform Integration Guide

## Overview

This guide covers integrating generated campaigns with major advertising platforms.

## Platforms Supported

### 1. TikTok Ads
- API: TikTok Marketing API
- Status: Primary platform (structure already built)

### 2. Meta Ads (Facebook + Instagram)
- API: Meta Marketing API
- Features: Unified campaigns for both platforms

### 3. Google Ads (YouTube)
- API: Google Ads API
- Features: YouTube video campaigns

## Integration Architecture

### Option 1: Separate Workflows (Recommended)
Each platform has its own workflow file for easier management.

### Option 2: Unified Workflow
Single workflow with multiple branches for each platform.

## Prerequisites

### TikTok Ads
- TikTok Ads Manager account
- Access Token
- Business Center (if using)

### Meta Ads
- Facebook Business Manager
- App ID and App Secret
- Page Admin Access
- Ad Account ID

### Google Ads
- Google Ads Manager account
- Developer Token
- OAuth 2.0 credentials
- MCC (Manager) account recommended

## Next Steps

See `MULTI_PLATFORM_INTEGRATION.md` for detailed implementation plan.

