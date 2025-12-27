# How to Restore Your Working Workflow

## 🚨 If n8n Breaks or Loses Your Workflow:

### Quick Restore:

1. **Go to n8n**
2. **Click "Import from File"**
3. **Select `master_workflow.json`**
4. **Done!** ✅

Your workflow is restored and working!

---

## 📋 What This Workflow Does:

1. **Manual Trigger** - Start the workflow
2. **Get Brand ID** - Query database for brand
3. **Generate with OpenAI** - Create campaign with AI
4. **Process Data** - Format the response
5. **Save Campaign** - Store in database
6. **Save Ad Groups** - Store ad groups (placeholder)
7. **Prepare Log** - Format for logging
8. **Log Generation** - Record the generation
9. **Return Result** - Send success response

---

## ✅ This is Your Backup!

Keep `master_workflow.json` safe. It's your working backup that:
- ✅ Connects to PostgreSQL
- ✅ Calls OpenAI successfully
- ✅ Processes AI responses
- ✅ Saves to database
- ✅ Returns success

---

## 🔧 To Use:

Just import `master_workflow.json` into n8n whenever needed!

